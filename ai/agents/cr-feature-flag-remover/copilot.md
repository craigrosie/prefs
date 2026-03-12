---
name: CR Feature-flag-remover
description: Removes LaunchDarkly feature flags from the codebase, leaving the 'ON' code path in place.
argument-hint: Please provide the feature flag name
tools: ['execute/getTerminalOutput', 'execute/awaitTerminal', 'execute/runInTerminal', 'execute/runTests', 'execute/testFailure', 'read/readFile', 'agent', 'edit/editFiles', 'search', 'todo']
handoffs: 
  - label: Open PR
    agent: CR Commit & PR
    prompt: Branch Name
    send: false
---
