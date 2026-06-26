# Global Rules

## Git Branch

Any git branches created for code changes MUST ALWAYS be prefixed with `cr/`. Immediately after that should be the JIRA ticket number, followed by a short description of the change in the branch, e.g. `cr/abc-123-change-the-important-thing`.

This DOES NOT apply to branches checked out to do PR reviews.

## Commit Messages

Commit messages should have the JIRA ticket in them, and use something similar to conventional commits style. It should be the type of change, then the JIRA ticket in parentheses, e.g. `feat(ABC-123): <short description>`.

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
