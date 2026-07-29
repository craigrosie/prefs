# Global Rules

## Git

NEVER, EVER commit directly to `main` or `master` branches.

### Git Branch

Any git branches created for code changes MUST ALWAYS be prefixed with `cr/`. Immediately after that should be the JIRA ticket number, followed by a short description of the change in the branch, e.g. `cr/abc-123-change-the-important-thing`.

This DOES NOT apply to branches checked out to do PR reviews.

### Worktrees

Do not use git worktrees unless explicitly instructed to do so.

### Commit Messages

Commit messages should have the JIRA ticket in them, and use something similar to conventional commits style. It should be the type of change, then the JIRA ticket in parentheses, e.g. `feat(ABC-123): <short description>`.

### PR Descriptions

Never put this emoji '' in PR descriptions.

## Testing

- If tests fail due to the docker issues, skip these and let the user know

## Feature Flags

ALL changes should be gated behind feature flags.

The exceptions are:
- changes to CDK code

Feature flags should never be used in `main.go` files. If you think you need to apply a feature flag in a `main.go` file, find somewhere 'downstream' to apply it instead.

If you are unsure where to apply a feature flag, then ask the user.

## Superpowers

When Superpowers creates a spec or plan document, the JIRA ticket should always be included in the file name. The format should be `<date>-<jira ticket>-<short description>`.

<!-- CODEGRAPH_START -->
## CodeGraph

This project has a CodeGraph MCP server (`codegraph_*` tools) configured. CodeGraph is a tree-sitter-parsed knowledge graph of every symbol, edge, and file. Reads are sub-millisecond and return structural information grep cannot.

### When to prefer codegraph over native search

Use codegraph for **structural** questions — what calls what, what would break, where is X defined, what is X's signature. Use native grep/read only for **literal text** queries (string contents, comments, log messages) or after you already have a specific file open.

| Question | Tool |
|---|---|
| "Where is X defined?" / "Find symbol named X" | `codegraph_search` |
| "What calls function Y?" | `codegraph_callers` |
| "What does Y call?" | `codegraph_callees` |
| "What would break if I changed Z?" | `codegraph_impact` |
| "Show me Y's signature / source / docstring" | `codegraph_node` |
| "Give me focused context for a task/area" | `codegraph_context` |
| "See several related symbols' source at once" | `codegraph_explore` |
| "What files exist under path/" | `codegraph_files` |
| "Is the index healthy?" | `codegraph_status` |

### Rules of thumb

- **Answer directly — don't delegate exploration.** For "how does X work" / architecture / trace questions, answer with 2-3 codegraph calls: `codegraph_context` first, then ONE `codegraph_explore` for the source of the symbols it surfaces. Codegraph IS the pre-built index, so spawning a separate file-reading sub-task/agent — or running a grep + read loop — repeats work codegraph already did and costs more for the same answer.
- **Trust codegraph results.** They come from a full AST parse. Do NOT re-verify them with grep — that's slower, less accurate, and wastes context.
- **Don't grep first** when looking up a symbol by name. `codegraph_search` is faster and returns kind + location + signature in one call.
- **Don't chain `codegraph_search` + `codegraph_node`** when you just want context — `codegraph_context` is one call.
- **Don't loop `codegraph_node` over many symbols** — one `codegraph_explore` call returns several symbols' source grouped in a single capped call, while each separate node/Read call re-reads the whole context and costs far more.
- **Index lag**: the file watcher debounces ~500ms behind writes; don't re-query immediately after editing a file in the same turn.

### If `.codegraph/` doesn't exist

The MCP server returns "not initialized." Ask the user: *"I notice this project doesn't have CodeGraph initialized. Want me to run `codegraph init -i` to build the index?"*
<!-- CODEGRAPH_END -->

