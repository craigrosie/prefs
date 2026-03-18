Finish reviewing PR #$1 and return to the previous branch.

## Step 1: Switch back to the previous branch

Ask the user which branch they were on before running `/review-pr $1`, then check it out:

```
git checkout <previous-branch>
```

## Step 2: Restore stashed changes

If a stash was created by `/review-pr $1` (labelled `pre-pr-review-$1 stash`), pop it:

```
git stash pop
```

If no such stash exists, skip this step.

## Step 3: Confirm

Report to the user:
- The branch you are now on
- Whether a stash was restored
