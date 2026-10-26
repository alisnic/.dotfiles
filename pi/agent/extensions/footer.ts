import { homedir } from 'node:os';
import type { ExtensionAPI, ExtensionContext, SessionEntry } from '@earendil-works/pi-coding-agent';
import { truncateToWidth, visibleWidth } from '@earendil-works/pi-tui';

type CodexUsage = {
  provider?: string;
  fiveHour?: { usedPercent?: number };
  weekly?: { usedPercent?: number };
};

export default function (pi: ExtensionAPI) {
  pi.on('session_start', (_event, ctx) => {
    if (ctx.mode !== 'tui') return;

    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsubscribe = footerData.onBranchChange(() => tui.requestRender());
      let leafId: string | null | undefined;
      let stats = summarizeUsage([], ctx);

      return {
        dispose: unsubscribe,
        invalidate() {
          leafId = undefined;
        },
        render(width: number): string[] {
          const currentLeafId = ctx.sessionManager.getLeafId();
          if (currentLeafId !== leafId) {
            stats = summarizeUsage(ctx.sessionManager.getEntries(), ctx);
            leafId = currentLeafId;
          }

          const model = ctx.model;
          const subscription = model && isSubscription(ctx, model.provider, model.id);
          const parts: string[] = [];

          if (stats.input) parts.push(`↑${formatTokens(stats.input)}`);
          if (stats.output) parts.push(`↓${formatTokens(stats.output)}`);
          if (stats.cacheRead) parts.push(`R${formatTokens(stats.cacheRead)}`);
          if (stats.cacheWrite) parts.push(`W${formatTokens(stats.cacheWrite)}`);
          if ((stats.cacheRead || stats.cacheWrite) && stats.cacheHitRate !== undefined) {
            parts.push(`CH${stats.cacheHitRate.toFixed(1)}%`);
          }

          if (subscription) {
            const usage = (globalThis as typeof globalThis & { piCodexLimit?: CodexUsage }).piCodexLimit;
            if (/^openai-codex(-\d+)?$/.test(model.provider)) {
              const snapshot = usage?.provider === model.provider ? usage : undefined;
              parts.push(
                `Codex: 5h ${formatPercent(snapshot?.fiveHour?.usedPercent)}, 1w ${formatPercent(snapshot?.weekly?.usedPercent)}`
              );
            } else {
              parts.push('subscription');
            }
          } else if (model) {
            parts.push(`$${stats.cost.toFixed(3)}`);
          }

          const context = ctx.getContextUsage();
          if (context) {
            const color = (context.percent ?? 0) > 90 ? 'error' : (context.percent ?? 0) > 70 ? 'warning' : 'dim';
            parts.push(
              theme.fg(color, `Ctx ${formatTokens(context.tokens || 0)}/${formatTokens(context.contextWindow)}`)
            );
          }

          let cwd = ctx.sessionManager.getCwd();
          const home = homedir();
          if (cwd === home || cwd.startsWith(`${home}/`)) cwd = `~${cwd.slice(home.length)}`;
          const branch = footerData.getGitBranch();
          const name = ctx.sessionManager.getSessionName();
          const location = `${cwd}${branch ? ` (${branch})` : ''}${name ? ` • ${name}` : ''}`;
          const left = parts.join(' ∙ ');
          const right = model ? `${model.id}${model.reasoning ? ` • ${pi.getThinkingLevel()}` : ''}` : 'no-model';
          const padding = ' '.repeat(Math.max(2, width - visibleWidth(left) - visibleWidth(right)));
          const lines = [location, `${left}${padding}${right}`].map(line =>
            theme.fg('dim', truncateToWidth(line, width))
          );

          // pi-codex-limit still fetches limits and handles /codex-limit, but its separate status is redundant.
          const statuses = [...footerData.getExtensionStatuses()]
            .filter(([key]) => key !== 'codex-limit-usage')
            .map(([, text]) => text.replace(/[\r\n\t]/g, ' '));
          if (statuses.length) lines.push(truncateToWidth(statuses.join(' '), width));

          return lines;
        }
      };
    });
  });
}

function summarizeUsage(entries: readonly SessionEntry[], ctx: ExtensionContext) {
  const totals = {
    input: 0,
    output: 0,
    cacheRead: 0,
    cacheWrite: 0,
    cost: 0,
    cacheHitRate: undefined as number | undefined
  };
  let provider = ctx.model?.provider ?? '';
  let modelId = ctx.model?.id ?? '';

  for (const entry of entries) {
    if (entry.type === 'model_change') {
      provider = entry.provider;
      modelId = entry.modelId;
    }

    const message = entry.type === 'message' ? entry.message : undefined;
    if (message?.role === 'assistant') {
      provider = message.provider;
      modelId = message.model;
    }

    const usage =
      message?.role === 'assistant' || message?.role === 'toolResult'
        ? message.usage
        : entry.type === 'usage' || entry.type === 'compaction' || entry.type === 'branch_summary'
          ? entry.usage
          : undefined;
    if (!usage) continue;

    totals.input += usage.input;
    totals.output += usage.output;
    totals.cacheRead += usage.cacheRead;
    totals.cacheWrite += usage.cacheWrite;
    const usageProvider = entry.type === 'usage' ? entry.provider : provider;
    const usageModel = entry.type === 'usage' ? entry.model : modelId;
    if (!isSubscription(ctx, usageProvider, usageModel)) totals.cost += usage.cost.total;

    if (message?.role === 'assistant') {
      const prompt = usage.input + usage.cacheRead + usage.cacheWrite;
      totals.cacheHitRate = prompt > 0 ? (usage.cacheRead / prompt) * 100 : undefined;
    }
  }

  return totals;
}

function isSubscription(ctx: ExtensionContext, provider: string, modelId: string): boolean {
  if (provider === 'kimi-coding') return true;

  const model = ctx.modelRegistry.find(provider, modelId);
  return Boolean(
    model &&
    ctx.modelRegistry.isUsingOAuth(model) &&
    ctx.modelRegistry.getProvider(provider)?.auth.oauth?.isSubscription
  );
}

function formatTokens(count: number): string {
  if (count < 1000) return String(count);
  if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
  if (count < 1000000) return `${Math.round(count / 1000)}k`;
  return `${(count / 1000000).toFixed(1)}M`;
}

function formatPercent(percent: number | undefined): string {
  return percent === undefined ? '?%' : `${Math.max(0, Math.min(100, percent)).toFixed(1)}%`;
}
