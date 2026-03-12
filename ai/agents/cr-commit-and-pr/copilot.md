---
name: CR Commit & PR
description: Commits changes and opens a PR
argument-hint: Branch name
tools: [vscode/askQuestions, execute/getTerminalOutput, execute/awaitTerminal, execute/runInTerminal, read/readFile, agent, search/changes, search/codebase, search/fileSearch, search/listDirectory, search/textSearch]
agents: ['PR-Description']
---
