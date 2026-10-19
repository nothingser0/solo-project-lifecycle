#!/usr/bin/env node
/**
 * Fail if any tracked path looks like an absolute path that leaked into the
 * repository — the signature of a shell that ate backslashes.
 *
 * History: a scaffold test created a literal drive-letter directory at the repo
 * root holding a copy of the Windows user temp path. It was committed and pushed
 * in 85154b4 and stayed tracked for 13 commits, because index-manifest.js only
 * walks a fixed set of directories and never saw the repo root.
 *
 * This is a negative check on tracked paths only: it cannot churn with content,
 * and it would have failed on the commit that introduced those files.
 *
 * Usage: node scripts/verify/verify-no-absolute-paths.js [--json]
 * Exit: 0 clean, 1 leaked paths found, 2 could not run.
 */
"use strict";

const { execFileSync } = require("child_process");
const path = require("path");

// Each pattern targets a fragment with no legitimate reason to exist inside a
// tracked relative path. git emits forward slashes only, so there is no
// backslash branch.
const RULES = [
  { name: "drive letter + fullwidth colon", re: /^[A-Za-z]\uF03A\// },
  { name: "drive letter + slash", re: /^[A-Za-z]:\// },
  { name: "temp under a user profile", re: /(^|\/)(Users|home)\/[^/]+\/(AppData\/)?/i },
  { name: "temp directory in path", re: /AppData\/Local\/Temp/i },
];

// Resolve the repo root from this file, so the scan is cwd-independent and the
// portability regression cannot make it scan a temp directory.
const REPO_ROOT = path.resolve(__dirname, "..", "..");

function trackedFiles() {
  // quotepath=false keeps non-ASCII (the fullwidth colon) readable, so the
  // patterns above match real bytes instead of octal escapes.
  const out = execFileSync(
    "git",
    ["-c", "core.quotepath=false", "ls-files", "-z"],
    { cwd: REPO_ROOT, encoding: "utf8", maxBuffer: 64 * 1024 * 1024 },
  );
  return out.split("\0").filter(Boolean);
}

function main() {
  const json = process.argv.includes("--json");

  let files;
  try {
    files = trackedFiles();
  } catch (err) {
    console.error(`error: could not list tracked files (${err.message})`);
    return 2;
  }

  const hits = [];
  for (const file of files) {
    for (const rule of RULES) {
      if (rule.re.test(file)) {
        hits.push({ file, rule: rule.name });
        break;
      }
    }
  }

  if (json) {
    console.log(JSON.stringify({ checked: files.length, leaked: hits }, null, 2));
  } else if (hits.length === 0) {
    console.log(`\u2705 No absolute paths among ${files.length} tracked files.`);
  } else {
    console.error(`\u274c ${hits.length} tracked path(s) look like absolute paths:`);
    for (const hit of hits.slice(0, 20)) {
      console.error(`   [${hit.rule}] ${hit.file}`);
    }
    if (hits.length > 20) console.error(`   ... and ${hits.length - 20} more`);
    console.error("");
    console.error("   These are almost always a mangled shell path, not a real file.");
    console.error("   Remove with: git rm -r --cached -- '<top-level dir>'");
  }

  return hits.length === 0 ? 0 : 1;
}

process.exit(main());
