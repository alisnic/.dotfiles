import type { ExtensionAPI } from '@mariozechner/pi-coding-agent';
import { Type } from '@sinclair/typebox';
import { Text } from '@mariozechner/pi-tui';
import {
  DEFAULT_MAX_BYTES,
  DEFAULT_MAX_LINES,
  formatSize,
  type TruncationResult,
  truncateHead
} from '@mariozechner/pi-coding-agent';
import { loadEnvFile } from 'node:process';

// Ollama Web Tools for pi
// Provides web_search and web_fetch tools using local Ollama instance

interface SearchResponse {
  results: Array<{
    title: string;
    url: string;
    content: string;
  }>;
}

interface SearchDetails {
  results: Array<{ title: string; url: string; content: string }>;
  truncation?: TruncationResult;
}

interface FetchResponse {
  title: string;
  content: string;
  links: string[];
}

function getOllamaHost(): string {
  return 'https://ollama.com';
}

export default function (pi: ExtensionAPI) {
  // web_search tool
  pi.registerTool({
    name: 'web_search',
    label: 'Web Search',
    description:
      "Search the web for real-time information using your local Ollama instance's web_search API. Output is truncated to " +
      DEFAULT_MAX_LINES +
      ' lines or ' +
      formatSize(DEFAULT_MAX_BYTES) +
      ' (whichever is hit first). Requires Ollama running locally with web search enabled.',
    parameters: Type.Object({
      query: Type.String({ description: 'The search query to execute' }),
      max_results: Type.Optional(
        Type.Number({ description: 'Maximum number of search results to return (default: 5)', default: 5 })
      )
    }),
    async execute(_toolCallId, params, signal, _onUpdate, _ctx) {
      const maxResults = params.max_results ?? 5;
      const host = getOllamaHost();

      try {
        const response = await fetch(`${host}/api/web_search`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${process.env.OLLAMA_API_KEY}`
          },
          body: JSON.stringify({
            query: params.query,
            max_results: maxResults
          }),
          signal
        });

        if (!response.ok) {
          if (response.status === 401) {
            throw new Error('Unauthorized. Run `ollama signin` to authenticate.');
          }
          const errorText = await response.text().catch(() => '');
          throw new Error(`Search API error (status ${response.status}): ${errorText || response.statusText}`);
        }

        const data = (await response.json()) as SearchResponse;

        // Format results for LLM
        const formatted = data.results
          .map((r, i) => `${i + 1}. ${r.title}\n   URL: ${r.url}\n   ${r.content}`)
          .join('\n\n');

        // Apply truncation to avoid overwhelming the LLM context
        const truncation = truncateHead(formatted || '', {
          maxLines: DEFAULT_MAX_LINES,
          maxBytes: DEFAULT_MAX_BYTES
        });

        const details: SearchDetails = {
          results: data.results
        };

        let resultText = truncation.content;

        if (truncation.truncated) {
          details.truncation = truncation;
          const truncatedLines = truncation.totalLines - truncation.outputLines;
          const truncatedBytes = truncation.totalBytes - truncation.outputBytes;
          resultText +=
            '\n\n[Output truncated: showing ' +
            truncation.outputLines +
            ' of ' +
            truncation.totalLines +
            ' lines (' +
            formatSize(truncation.outputBytes) +
            ' of ' +
            formatSize(truncation.totalBytes) +
            '). ' +
            truncatedLines +
            ' lines (' +
            formatSize(truncatedBytes) +
            ') omitted.]';
        }

        return {
          content: [{ type: 'text', text: resultText }],
          details
        };
      } catch (error) {
        if (error instanceof Error && error.message.includes('ECONNREFUSED')) {
          throw new Error(
            `Could not connect to Ollama at ${host}. Make sure Ollama is running and web_search is enabled.`
          );
        }
        throw error;
      }
    },
    renderCall(args, _theme, context) {
      const text = (context.lastComponent as Text | undefined) ?? new Text('', 0, 0);
      const query = args.query ? `"${args.query}"` : '';
      text.setText(`web_search ${query}`);
      return text;
    },
    renderResult(result, { expanded, isPartial }, theme, _context) {
      const details = result.details as SearchDetails | undefined;

      if (isPartial) {
        return new Text(theme.fg('warning', 'Searching...'), 0, 0);
      }

      if (!details || details.results.length === 0) {
        return new Text(theme.fg('dim', 'No results found'), 0, 0);
      }

      let text = '';

      if (expanded) {
        // Expanded view: show all results
        text = theme.fg('success', `${details.results.length} result${details.results.length !== 1 ? 's' : ''}`);
        if (details.truncation?.truncated) {
          text += theme.fg('warning', ' (truncated)');
        }
        const content = result.content[0];
        if (content?.type === 'text') {
          text += '\n' + theme.fg('dim', content.text);
        }
      } else {
        // Compact view: show first result truncated
        const first = details.results[0];
        text = theme.fg('success', `✓ ${details.results.length} result${details.results.length !== 1 ? 's' : ''}`);

        for (const first of details.results) {
          const title = theme.fg('accent', first.title);
          const url = theme.fg('dim', first.url);

          text += '\n' + theme.fg('toolTitle', '  ' + title);
          text += '\n' + '  ' + url + '\n';
        }
        if (details.truncation?.truncated) {
          text += theme.fg('warning', '  (output truncated)');
        }
      }

      return new Text(text, 0, 0);
    }
  });
}
