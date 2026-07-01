#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const os = require("os");

const args = process.argv.slice(2);
const isGlobal = args.includes("--global");
const isProject = args.includes("--project");

// Default: both
const doGlobal = isGlobal || (!isGlobal && !isProject);
const doProject = isProject || (!isGlobal && !isProject);

const rulesDir = path.join(__dirname, "..", "rules");

const RULE_FILES = [
  "engineering.md",
  "code-style.md",
  "commit-style.md",
  "review.md",
  "figma.md",
  "i18n.md",
];

function mergeRules() {
  let content = "# Claude Code 工程级长期记忆\n\n";
  for (const f of RULE_FILES) {
    const p = path.join(rulesDir, f);
    if (fs.existsSync(p)) {
      content += fs.readFileSync(p, "utf-8") + "\n";
    }
  }
  return content;
}

function log(msg) {
  console.log(`[+] ${msg}`);
}

function warn(msg) {
  console.log(`[!] ${msg}`);
}

function installClaudeCode() {
  const dir = path.join(os.homedir(), ".claude");
  const target = path.join(dir, "CLAUDE.md");
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(target, mergeRules(), "utf-8");
  log(`Claude Code: ${target}`);
}

function installCursor() {
  fs.writeFileSync(".cursorrules", mergeRules(), "utf-8");
  log("Cursor: .cursorrules");
}

function installCopilot() {
  fs.mkdirSync(".github", { recursive: true });
  fs.writeFileSync(".github/copilot-instructions.md", mergeRules(), "utf-8");
  log("Copilot: .github/copilot-instructions.md");
}

function installWindsurf() {
  fs.writeFileSync(".windsurfrules", mergeRules(), "utf-8");
  log("Windsurf: .windsurfrules");
}

// Main
if (doGlobal) {
  console.log("\n=== Global Install ===");
  installClaudeCode();
}

if (doProject) {
  console.log("\n=== Project Install ===");
  if (!fs.existsSync(".git")) {
    warn("Not a git repo. Run this in your project root.");
    process.exit(1);
  }
  installCursor();
  installCopilot();
  installWindsurf();
}

console.log("\nDone.");
