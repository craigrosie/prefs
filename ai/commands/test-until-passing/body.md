Run all the tests in this repo. If there are any failures, investigate and fix them. Do not stop until all the tests pass.

1. Analyse each failure carefully — read the relevant handler, model, or helper code before making changes.
2. Fix the root cause in the production code (not by weakening assertions or skipping tests).
3. Re-run the tests to verify the fix.
4. Repeat until the test command exits with no failures.

## Rules

- Do **not** delete, skip, or comment-out failing tests.
- Do **not** change test assertions to match broken behaviour — fix the behaviour instead.
- Prefer minimal, targeted fixes; avoid unrelated refactors.
- If a test failure reveals a genuine design conflict (e.g. an intentional behaviour change), **stop and report** to the user before proceeding.
