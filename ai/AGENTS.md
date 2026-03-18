## AI Agent, Command, and Skill Definitions

Agent source files live under `ai/agents/<name>/`, command source files under `ai/commands/<name>/`, and skills under `ai/skills/<name>/`. The `ai/dist/` directory contains generated output — do not edit files there directly.

### Editing agents

Each agent directory contains up to three files:

- `body.md` — the agent instructions. This is the file to edit when changing what an agent does.
- `copilot.md` — GitHub Copilot frontmatter. **Do not edit unless explicitly instructed by the user.**
- `opencode.md` — OpenCode frontmatter. **Do not edit unless explicitly instructed by the user.**

### Editing commands

Each command directory under `ai/commands/<name>/` follows the same structure as agents:

- `body.md` — the command instructions. This is the file to edit when changing what a command does.
- `copilot.md` — GitHub Copilot frontmatter. **Do not edit unless explicitly instructed by the user.**
- `opencode.md` — OpenCode frontmatter. **Do not edit unless explicitly instructed by the user.**

### Syncing changes

After modifying any agent, command, or skill (`body.md`), or this `AGENTS.md` file, run:

```
agentsync
```

This regenerates the files in `ai/dist/` that AI tools read. Run `agentsync --help` to see all available options.

### Troubleshooting agentsync

If `agentsync` is not found, install it first:

```
cd agentsync && go install . && cd -
```

If `go install` fails or the binary is still not on `$PATH`, run the tool directly as a fallback:

```
cd agentsync && go run . [flags]
```


