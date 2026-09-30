#!/usr/bin/env node
// Claude Code status line: git branch/worktree, context window usage, and rate limit usage.

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

let raw = "";
process.stdin.on("data", (c) => (raw += c));
process.stdin.on("end", () => {
  const data = JSON.parse(raw);
  const limits = data.rate_limits;

  const parts = [
    gitField(data),
    contextField(data),
    field("5h", limits && limits.five_hour),
    field("7d", limits && limits.seven_day),
    field("spend", limits && limits.spend_limit),
  ].filter(Boolean);

  process.stdout.write(parts.join(dim(" · ")));
});

function gitField(data) {
  const dir = (data.workspace && data.workspace.current_dir) || data.cwd;
  if (!dir) return null;

  try {
    const [branch, toplevel, gitDir, commonDir] = execSync(
      `git -C ${JSON.stringify(dir)} rev-parse --abbrev-ref HEAD --show-toplevel --git-dir --git-common-dir`,
      { stdio: ["ignore", "pipe", "ignore"] },
    )
      .toString()
      .trim()
      .split("\n");

    const worktree = path.basename(toplevel);
    const linked = path.resolve(dir, gitDir) !== path.resolve(dir, commonDir);

    return `${dim("⎇")} ${branch} ${dim(`(${worktree}${linked ? "+" : ""})`)}`;
  } catch {
    return null;
  }
}

function contextField(data) {
  const usage = contextUsage(data);
  if (!usage) return null;

  const { percent, used, size } = usage;
  return `${dim("ctx")} ${color(percent)}${dim(` (${fmtTokens(used)}/${fmtTokens(size)})`)}`;
}

function contextUsage(data) {
  const cw = data.context_window;
  if (cw && cw.used_percentage != null && cw.context_window_size) {
    const used = cw.total_input_tokens ?? tokensFromUsage(cw.current_usage);
    if (used == null) return null;
    return { percent: Math.round(cw.used_percentage), used, size: cw.context_window_size };
  }

  const usage = lastAssistantUsage(data.transcript_path);
  if (!usage) return null;

  const tokens = tokensFromUsage(usage);
  if (tokens == null) return null;

  const size = data.model && /\[1m\]/.test(data.model.id) ? 1_000_000 : 200_000;
  return { percent: Math.round((tokens / size) * 100), used: tokens, size };
}

function tokensFromUsage(usage) {
  if (!usage) return null;
  return (
    (usage.input_tokens || 0) +
    (usage.cache_read_input_tokens || 0) +
    (usage.cache_creation_input_tokens || 0)
  );
}

function lastAssistantUsage(transcriptPath) {
  if (!transcriptPath) return null;

  try {
    const lines = fs.readFileSync(transcriptPath, "utf8").split("\n");
    for (let i = lines.length - 1; i >= 0; i--) {
      if (!lines[i].trim()) continue;
      const entry = JSON.parse(lines[i]);
      if (entry.message && entry.message.usage) return entry.message.usage;
    }
  } catch {
    return null;
  }

  return null;
}

function fmtTokens(n) {
  if (n >= 1_000_000) return `${Math.round((n / 1_000_000) * 10) / 10}M`;
  if (n >= 1_000) return `${Math.round(n / 1_000)}k`;
  return `${n}`;
}

function field(label, window) {
  if (!window) return null;

  const percent = Math.round(window.used_percentage);
  const resets = new Date(window.resets_at * 1000).toLocaleTimeString([], {
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  });

  return `${dim(label)} ${color(percent)}${dim(` ↻${resets}`)}`;
}

function color(percent) {
  const code = percent >= 90 ? 31 : percent >= 70 ? 33 : 32;
  return `\x1b[${code}m${percent}%\x1b[0m`;
}

function dim(text) {
  return `\x1b[2m${text}\x1b[0m`;
}
