#!/usr/bin/env -S node --experimental-strip-types
/// <reference types="node" />

import path from 'node:path';
import { loadEnvFile } from 'node:process';
import { parseArgs } from 'node:util';
import assert from 'assert/strict';

loadEnvFile(path.resolve(import.meta.dirname, '.env'));

interface SearchResponse {
  results: Array<{
    title: string;
    url: string;
    content: string;
  }>;
}

const argsConfig = {
  query: { type: 'string' },
  'max-results': { type: 'string', default: '5' }
};

async function main() {
  const { positionals, values } = parseArgs({
    args: process.argv.slice(2),
    options: argsConfig,
    allowPositionals: true
  });

  const [query] = positionals;

  const maxResults = values['max-results'];

  if (!query) {
    console.error('Usage: agent-search.ts "query" [--max-results N]');
    process.exit(1);
  }

  assert(typeof maxResults === 'string');

  const response = await fetch(`https://ollama.com/api/web_search`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${process.env.OLLAMA_API_KEY}`
    },
    body: JSON.stringify({
      query: query,
      max_results: parseInt(maxResults)
    })
  });

  if (!response.ok) {
    console.log(await response.text());
    process.exit(1);
  }

  const data = (await response.json()) as SearchResponse;

  console.log(data.results.map(e => ({ title: e.title, url: e.url })));
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
