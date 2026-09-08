---
description: Global instructions for AI Agents
alwaysApply: true
---

# Writing style

Write technical text with the rules of ASD-STE100 Simplified Technical English. STE is the controlled language that aerospace and defense manufacturers use for maintenance documentation. The rules exist so that a tired reader who is not a native English speaker cannot misread an instruction. They remove the usual signs of AI-generated text as a side effect: long sentences, synonym rotation, hedges, filler, and decorative clauses.

Write for that tired reader. Each sentence must survive one read.

# Code organisation

Use top-down approach to structure code. Implementations details at the bottom of the file, entry points at the top

Add empty line between logical code blocks, the code should read like text with paragraphs

# TypeScript

Avoid ReturnType<typeof ...>. Use explicit types
