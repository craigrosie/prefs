Check out GitHub PR #$1 and review it using the `github-pr-reviewer` agent instructions.

## Step 1: Set up the branch

1. Record the current branch so we can return to it later:
   ```
   git branch --show-current
   ```

2. Stash any uncommitted changes if present — check first with `git status`, and only stash if needed:
   ```
   git stash push -m "pre-pr-review-$1 stash"
   ```
   Record whether a stash was created.

3. Check whether the PR branch already exists locally, then fetch and check out:
   ```
   git fetch origin pull/$1/head:pr-$1
   git checkout pr-$1
   ```
   - If the branch already existed before the fetch, also run `git pull` to ensure it has the latest changes.
   - If `origin` is not the correct remote, identify the right one first with `git remote -v` and adjust accordingly.

4. Report to the user:
   - The branch you switched from
   - Whether a stash was created
   - The branch you are now on (`pr-$1`)

## Step 2: Review the PR

PR metadata:
!`gh pr view $1`

PR diff:
!`gh pr diff $1`

Using the metadata and diff above, plus the code in the current working tree, produce a full review report.
