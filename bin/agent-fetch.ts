#!/usr/bin/env -S node --experimental-strip-types
/// <reference types="node" />

import { execFile, spawn } from 'node:child_process';
import { parseArgs as parseCliArgs, promisify } from 'node:util';
const execFileAsync = promisify(execFile);

const CHROME_PATH = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';

type OutputFormat = 'html' | 'markdown';

const { url, format } = parseArgs(process.argv.slice(2));

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
      Accept: 'text/markdown',
    },
  });

  const contentType = response.headers.get('Content-Type')?.split(';')[0];

  if (contentType !== 'text/markdown') {
    const html = await renderWithChrome(url);
    const markdown = await htmlToMarkdown(html);

    process.stdout.write(markdown);
    return;
  }

  const body = await response.text();
  console.log(body);
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
      targetUrl,
    ],
    { maxBuffer: 100 * 1024 * 1024 }
  );
  return stdout;
}

function htmlToMarkdown(html: string): Promise<string> {
  return new Promise((resolve, reject) => {
    const child = spawn('uvx', ['trafilatura', '--markdown', '--formatting']);

    let stdout = '';
    child.stdout.setEncoding('utf8');
    child.stdout.on('data', (chunk) => {
      stdout += chunk;
    });

    child.on('error', reject);
    child.on('close', (code) => {
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

function parseArgs(args: string[]): { url: string; format: OutputFormat } {
  let values: { format?: string };
  let positionals: string[];

  try {
    ({ values, positionals } = parseCliArgs({
      args,
      allowPositionals: true,
      strict: true,
      options: {
        format: {
          type: 'string',
        },
      },
    }));
  } catch (error) {
    failUsage(getMessage(error));
  }

  if (positionals.length === 0) {
    failUsage('Missing URL');
  }

  if (positionals.length > 1) {
    failUsage('Only one URL may be provided');
  }

  const format = values.format ?? 'markdown';

  if (format !== 'html' && format !== 'markdown') {
    failUsage('`--format` must be one of: html, markdown');
  }

  return { url: positionals[0], format };
}

function failUsage(message: string): never {
  console.error(message);
  console.error('Usage: agent-fetch <url> [--format html|markdown]');
  process.exit(1);
}
