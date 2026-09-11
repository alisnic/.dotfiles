---
description: Global instructions for AI Agents
alwaysApply: true
---

# Writing style

Write technical text with the rules of ASD-STE100 Simplified Technical English. STE is the controlled language that aerospace and defense manufacturers use for maintenance documentation. The rules exist so that a tired reader who is not a native English speaker cannot misread an instruction. They remove the usual signs of AI-generated text as a side effect: long sentences, synonym rotation, hedges, filler, and decorative clauses.

Write for that tired reader. Each sentence must survive one read.

# Simplicity first

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

# Reconsider existing approaches

Before copying a nearby approach on how to structure your solution, evaluate it against instructions in
this file. If you see a contraction in this process, ask the user how to proceed.

# Code organisation

Use top-down approach to structure code. Implementations details at the bottom of the file, entry points at the top

Add empty line between logical code blocks, the code should read like text with paragraphs

Do not extract a helper whose name restates its body. Inline a trivial expression that has one caller. A helper earns its place when the name tells the reader something the code does not, or when more than one caller uses the logic.

```ts
// bad — name restates the body
function fullName(user: User): string {
  return `${user.first} ${user.last}`;
}

greet(fullName(user));

// good — keep the expression at the call site
greet(`${user.first} ${user.last}`);
```

# TypeScript

Avoid `ReturnType<typeof ...>` for type declarations, prefer explicit types in this case. Do not declare
the type if it can be inferred.
