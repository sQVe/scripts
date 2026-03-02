#!/usr/bin/env bun
/**
 * Notebox date and path resolution.
 *
 * Usage:
 *   notebox.ts weekly-path          Current week's file path
 *   notebox.ts today                Today's day name and date
 *   notebox.ts prev-weekly-path     Previous week's file path
 *   notebox.ts week-context         Prev/curr paths and labels (4 lines)
 *   notebox.ts week-monday          Monday date of current week
 *   notebox.ts project-path         Current year's project log path
 */

const DAY_NAMES = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

function requireNotebox(): string {
  const notebox = Bun.env.NOTEBOX;
  if (!notebox) {
    console.error("NOTEBOX environment variable is not set");
    process.exit(1);
  }
  return notebox;
}

function isoWeek(d: Date): { year: number; week: number } {
  const thursday = new Date(d);
  thursday.setDate(d.getDate() + 3 - ((d.getDay() + 6) % 7));
  const year = thursday.getFullYear();
  const week1 = new Date(year, 0, 4);
  const week = 1 + Math.round(((thursday.getTime() - week1.getTime()) / 864e5 - 3 + ((week1.getDay() + 6) % 7)) / 7);
  return { year, week };
}

function weeklyFilePath(d: Date, notebox: string): string {
  const { year, week } = isoWeek(d);
  return `${notebox}/weekly/${year}-W${String(week).padStart(2, "0")}.md`;
}

function formatDate(d: Date): string {
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${DAY_NAMES[d.getDay()]} ${year}-${month}-${day}`;
}

function prevWeek(d: Date): Date {
  const p = new Date(d);
  p.setDate(d.getDate() - 7);
  return p;
}

function monday(d: Date): Date {
  const m = new Date(d);
  m.setDate(d.getDate() - ((d.getDay() + 6) % 7));
  return m;
}

const [, , cmd] = process.argv;

switch (cmd) {
  case "weekly-path": {
    console.log(weeklyFilePath(new Date(), requireNotebox()));
    break;
  }
  case "today": {
    console.log(formatDate(new Date()));
    break;
  }
  case "prev-weekly-path": {
    const notebox = requireNotebox();
    console.log(weeklyFilePath(prevWeek(new Date()), notebox));
    break;
  }
  case "week-context": {
    const notebox = requireNotebox();
    const today = new Date();
    const prev = prevWeek(today);
    const { year: py, week: pw } = isoWeek(prev);
    const { year: cy, week: cw } = isoWeek(today);
    console.log(weeklyFilePath(prev, notebox));
    console.log(weeklyFilePath(today, notebox));
    console.log(`${py}-W${String(pw).padStart(2, "0")}`);
    console.log(`${cy}-W${String(cw).padStart(2, "0")}`);
    break;
  }
  case "week-monday": {
    console.log(formatDate(monday(new Date())));
    break;
  }
  case "project-path": {
    const notebox = requireNotebox();
    const year = new Date().getFullYear();
    console.log(`${notebox}/projects/${year}.md`);
    break;
  }
  default: {
    console.error(`Unknown command: ${cmd ?? "(none)"}`);
    console.error("Commands: weekly-path, today, prev-weekly-path, week-context, week-monday, project-path");
    process.exit(1);
  }
}
