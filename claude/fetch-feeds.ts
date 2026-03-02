#!/usr/bin/env bun
/**
 * Fetch RSS/Atom feeds and print recent items as JSON.
 *
 * Usage: bun fetch-feeds.ts <feeds.md> [--hours N]
 *
 * Reads feed URLs from a feeds.md file (lines starting with "- http"),
 * fetches all feeds in parallel, filters to items published within the
 * last N hours (default 48), and writes a JSON array to stdout.
 *
 * Output schema: [{title, url, feed, category, published, summary}]
 */

import { readFileSync } from "fs";
import { XMLParser } from "fast-xml-parser";

interface FeedSource {
  url: string;
  category: string;
  name: string;
}

interface FeedItem {
  title: string;
  url: string;
  feed: string;
  category: string;
  published: string;
  summary: string;
}

function parseFeedsMd(path: string): FeedSource[] {
  let category = "";
  return readFileSync(path, "utf-8")
    .split("\n")
    .flatMap((line): FeedSource[] => {
      if (line.startsWith("## ")) {
        category = line.slice(3).trim();
        return [];
      }
      if (line.startsWith("- http")) {
        const url = line.slice(2).split(/\s/)[0].trim();
        const name = line.includes(" — ") ? line.split(" — ")[1].trim() : url;
        return [{ url, category, name }];
      }
      return [];
    });
}

function text(val: unknown): string {
  if (typeof val === "string") return val;
  if (typeof val !== "object" || val == null) return String(val ?? "");
  return String((val as Record<string, unknown>)["#text"] ?? "");
}

function decodeEntities(s: string): string {
  return s
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#(\d+);/g, (_, n) => String.fromCharCode(Number(n)))
    .replace(/&#x([0-9a-f]+);/gi, (_, h) => String.fromCharCode(parseInt(h, 16)));
}

function stripHtml(html: string): string {
  return decodeEntities(html.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim());
}

function parseDate(entry: Record<string, unknown>): Date | null {
  const raw = entry["pubDate"] ?? entry["published"] ?? entry["updated"] ?? entry["dc:date"];
  if (!raw) return null;
  const d = new Date(text(raw));
  return isNaN(d.getTime()) ? null : d;
}

function extractLinkedUrl(html: string): string | null {
  const match = html.match(/href="([^"]+)">\[link\]/i);
  return match ? match[1] : null;
}

function isBare(summary: string): boolean {
  return summary.length < 80 || /^\s*submitted by/i.test(summary);
}

async function fetchMetaDescription(url: string): Promise<string> {
  try {
    const res = await fetch(url, {
      signal: AbortSignal.timeout(8_000),
      headers: { "User-Agent": "Mozilla/5.0 (compatible; personal-feed-reader/1.0)" },
    });
    if (!res.ok) return "";
    const html = await res.text();
    const match =
      html.match(/<meta[^>]+name=["']description["'][^>]+content=["']([^"']+)["']/i) ??
      html.match(/<meta[^>]+content=["']([^"']+)["'][^>]+name=["']description["']/i);
    return match ? decodeEntities(match[1].trim()) : "";
  } catch {
    return "";
  }
}

async function fetchFeed(source: FeedSource, cutoff: Date): Promise<FeedItem[]> {
  const res = await fetch(source.url, {
    signal: AbortSignal.timeout(10_000),
    headers: { "User-Agent": "Mozilla/5.0 (compatible; personal-feed-reader/1.0)" },
  });
  if (!res.ok) return [];

  const parser = new XMLParser({ ignoreAttributes: false, textNodeName: "#text" });
  const doc = parser.parse(await res.text());

  const feedTitle = text(doc?.rss?.channel?.title ?? doc?.feed?.title ?? source.url);
  const rssItems: Record<string, unknown>[] = [doc?.rss?.channel?.item ?? []].flat();
  const atomEntries: Record<string, unknown>[] = [doc?.feed?.entry ?? []].flat();

  const items = await Promise.all(
    [...rssItems, ...atomEntries].map(async (entry) => {
      const published = parseDate(entry);
      if (!published || published < cutoff) return null;

      const linkVal = entry["link"];
      const itemUrl =
        typeof linkVal === "object" && linkVal != null
          ? String((linkVal as Record<string, unknown>)["@_href"] ?? "")
          : String(linkVal ?? "");

      const rawSummary = text(entry["description"] ?? entry["summary"] ?? entry["content"] ?? "");
      let summary = stripHtml(rawSummary).slice(0, 300);

      if (isBare(summary)) {
        const linkedUrl = extractLinkedUrl(rawSummary);
        if (linkedUrl) {
          const metaDesc = await fetchMetaDescription(linkedUrl);
          if (metaDesc) summary = metaDesc.slice(0, 300);
        }
      }

      return {
        title: decodeEntities(text(entry["title"]).trim()),
        url: itemUrl,
        feed: feedTitle,
        category: source.category,
        published: published.toISOString(),
        summary,
      };
    }),
  );

  return items.filter((item): item is FeedItem => item != null);
}

const args = process.argv.slice(2);
const feedsPath = args[0];
const hoursFlag = args.indexOf("--hours");
const hours = hoursFlag !== -1 ? parseInt(args[hoursFlag + 1], 10) : 48;
const perCatFlag = args.indexOf("--per-category");
const perCategory = perCatFlag !== -1 ? parseInt(args[perCatFlag + 1], 10) : null;

if (!feedsPath) {
  console.error("Usage: fetch-feeds.ts <feeds.md> [--hours N] [--per-category N]");
  process.exit(1);
}

const cutoff = new Date(Date.now() - hours * 60 * 60 * 1000);
const sources = parseFeedsMd(feedsPath);
const results = await Promise.allSettled(sources.map((source) => fetchFeed(source, cutoff)));
const allItems = results
  .flatMap((r) => (r.status === "fulfilled" ? r.value : []))
  .sort((a, b) => b.published.localeCompare(a.published));

const substantive = allItems.filter((item) => !isBare(item.summary));
let items = substantive;
if (perCategory != null) {
  const countByCategory = new Map<string, number>();
  items = substantive.filter((item) => {
    const count = countByCategory.get(item.category) ?? 0;
    if (count >= perCategory) return false;
    countByCategory.set(item.category, count + 1);
    return true;
  });
}

console.log(JSON.stringify(items, null, 2));
