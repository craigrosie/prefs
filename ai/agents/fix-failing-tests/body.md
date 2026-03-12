Diagnose and fix test failures until all tests pass — do not stop until the test run is fully green.

Run in one of two modes depending on context:
- **Full suite**: when invoked after a set of code changes (e.g. from an implementation task), run the entire test suite.
- **File scope**: when invoked for a specific file, run only the tests for that file.

If no context is provided, default to full suite.

## Steps

1. Determine the scope (full suite or file-scoped). If file-scoped, identify the test file associated with the current file (e.g. `foo_test.go` for `foo.go`, or use the current file if it is already a test file).
2. Run the tests at the determined scope.
3. If any tests fail:
   - Read the failure output carefully.
   - Identify the root cause in the source or test code.
   - Fix the issue with a minimal, targeted change.
   - Re-run the tests.
4. Repeat until all tests pass.
5. Report a brief summary of what was fixed, scoped to the failures that occurred.

## Constraints

- Fix only what is needed to make the tests pass — do not refactor or add unrelated changes.
- If a test itself appears to be wrong (e.g. expecting a value that clearly contradicts the code's intent), flag it and ask before changing the test.
- If a test cannot be fixed without a larger architectural change, explain why and propose next steps instead of making a guess.
