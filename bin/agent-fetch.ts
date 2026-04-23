#!/usr/bin/env -S node --experimental-strip-types
/// <reference types="node" />

import { execFile, spawn } from 'node:child_process';
import { parseArgs as parseCliArgs, promisify } from 'node:util';
const execFileAsync = promisify(execFile);
import * as cheerio from 'cheerio';

const CHROME_PATH = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';

type OutputFormat = 'html' | 'markdown';

const { url, format, withLinks } = parseArgs(process.argv.slice(2));

try {
  new URL(url);
} catch (error) {
  console.error('Invalid URL: ' + url);
  process.exit(1);
}

async function main() {
  if (format === 'html') {
    process.stdout.write(await renderWithChrome(url));
    return;
  }

  const response = await fetch(url, {
    method: 'GET',
    headers: {
      Accept: 'text/markdown'
    }
  });

  const contentType = response.headers.get('Content-Type')?.split(';')[0];

  if (contentType === 'text/markdown' || contentType === 'application/json') {
    console.log(await response.text());
    return;
  }

  const html = await renderWithChrome(url);
  const markdown = await htmlToMarkdown(html);

  if (withLinks) {
    const links = extractLinks(html, url);

    if (links.length > 0) {
      const linkSection =
        '\n\n---\n\n## Links\n\n' +
        links.map(l => (l.title ? `- [${l.title}](${l.url})` : `- ${l.url}`)).join('\n') +
        '\n';
      process.stdout.write(markdown + linkSection);
    } else {
      process.stdout.write(markdown);
    }
  } else {
    process.stdout.write(markdown);
  }
  return;
}

async function renderWithChrome(targetUrl: string): Promise<string> {
  const { stdout } = await execFileAsync(
    CHROME_PATH,
    [
      '--headless=new',
      '--disable-gpu',
      '--no-sandbox',
      '--hide-scrollbars',
      '--virtual-time-budget=10000',
      '--run-all-compositor-stages-before-draw',
      '--dump-dom',
      targetUrl
    ],
    { maxBuffer: 100 * 1024 * 1024 }
  );
  return stdout;
}

function extractLinks(html: string, baseUrl: string): { url: string; title: string | undefined }[] {
  const $ = cheerio.load(html);
  const seen = new Set<string>();
  const links: { url: string; title: string | undefined }[] = [];

  $('a[href]').each((_, el) => {
    const $el = $(el);
    const href = $el.attr('href');
    if (!href || href.startsWith('#') || href.startsWith('javascript:')) return;
    // skip links that are just images
    if ($el.find('img').length > 0) return;
    let absolute: string;

    try {
      absolute = new URL(href, baseUrl).toString();
    } catch {
      absolute = href;
    }

    if (seen.has(absolute)) return;

    seen.add(absolute);
    const title = $el.text().trim();
    links.push({ url: absolute, title: title || undefined });
  });
  return links;
}

function htmlToMarkdown(html: string): Promise<string> {
  return new Promise((resolve, reject) => {
    const child = spawn('uvx', ['trafilatura']);

    let stdout = '';
    child.stdout.setEncoding('utf8');
    child.stdout.on('data', chunk => {
      stdout += chunk;
    });

    child.on('error', reject);
    child.on('close', code => {
      if (code !== 0) {
        reject(new Error('trafilatura exited with code ' + code));
        return;
      }
      resolve(stdout);
    });

    child.stdin.end(html);
  });
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error: unknown) => {
    console.error(getMessage(error));
    process.exit(1);
  });

function getMessage(error: unknown): string {
  if (error instanceof Error) {
    let message = `${error.constructor.name}: ${error.message}`;

    if (error.cause) {
      message += `\n\tCaused by: ${getMessage(error.cause)}`;
    }

    return message;
  } else {
    return String(error);
  }
}

function parseArgs(args: string[]): { url: string; format: OutputFormat; withLinks: boolean } {
  let values: { format?: string; 'with-links'?: boolean };
  let positionals: string[];

  try {
    ({ values, positionals } = parseCliArgs({
      args,
      allowPositionals: true,
      strict: true,
      options: {
        format: {
          type: 'string'
        },
        'with-links': {
          type: 'boolean',
          default: false
        }
      }
    }));
  } catch (error) {
    failUsage(getMessage(error));
  }

  if (positionals.length > 1) {
    failUsage('Only one URL may be provided');
  }

  const [url] = positionals;

  if (!url) {
    failUsage('Missing URL');
  }

  const format = values.format ?? 'markdown';

  if (format !== 'html' && format !== 'markdown') {
    failUsage('`--format` must be one of: html, markdown');
  }

  return { url, format, withLinks: values['with-links'] as boolean };
}

function failUsage(message: string): never {
  console.error(message);
  console.error('Usage: agent-fetch.ts <url> [--format html|markdown] [--with-links]');
  process.exit(1);
}
