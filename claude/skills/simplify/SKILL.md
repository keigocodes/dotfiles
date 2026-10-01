---
name: simplify
description: Simplify and refine code for clarity, consistency, and maintainability while preserving all functionality. Use when the user asks to simplify, clean up, or refine code, or mentions "/simplify".
---

Simplify the recently modified code (or code the user points at) for clarity, consistency, and maintainability while preserving all functionality.

Delegate to the `code-simplifier` subagent via the Agent tool. Brief it with:
- which files or changes to focus on (default: recently modified code in this session)
- any constraints the user has mentioned (style, framework, things to leave alone)

Do not refactor beyond simplification, do not add features, and do not change behavior.
