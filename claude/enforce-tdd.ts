#!/usr/bin/env bun


const actionVerbs = [
  "add",
  "build",
  "change",
  "configure",
  "convert",
  "create",
  "delete",
  "disable",
  "enable",
  "enhance",
  "extend",
  "extract",
  "fix",
  "hook up",
  "implement",
  "integrate",
  "migrate",
  "modify",
  "move",
  "port",
  "redo",
  "refactor",
  "remove",
  "rename",
  "replace",
  "rework",
  "rewrite",
  "set up",
  "support",
  "toggle",
  "update",
  "wire up",
];

const conversationalPrefixes = [
  /^are there\b/i,
  /^can you\b/i,
  /^could you\b/i,
  /^describe\b/i,
  /^do\b/i,
  /^does\b/i,
  /^explain\b/i,
  /^how can\b/i,
  /^how does\b/i,
  /^how do\b/i,
  /^how should\b/i,
  /^how to\b/i,
  /^is there\b/i,
  /^list\b/i,
  /^should\b/i,
  /^show me\b/i,
  /^tell me\b/i,
  /^what\b/i,
  /^when\b/i,
  /^where\b/i,
  /^why\b/i,
];

const actionPattern = new RegExp(
  `\\b(${actionVerbs.map((v) => v.replace(/ /g, "\\s+")).join("|")})\\b`,
  "i"
);

function isImplementationPrompt(text: string): boolean {
  if (conversationalPrefixes.some((pattern) => pattern.test(text))) {
    return false;
  }
  return actionPattern.test(text);
}

try {
  const input = await Bun.stdin.text();
  const { prompt } = JSON.parse(input);

  if (typeof prompt === "string" && isImplementationPrompt(prompt.trim())) {
    process.stdout.write(
      JSON.stringify({
        additionalContext:
          "MANDATORY: Load and follow hyperpowers:test-driven-development before writing any code. Use the Skill tool to load it now. This is not optional.",
      })
    );
  } else {
    process.stdout.write("{}");
  }
} catch {
  process.stdout.write("{}");
}

export { };
