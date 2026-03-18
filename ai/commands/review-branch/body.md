Review the changes on a branch against `main` using the `github-pr-reviewer` agent instructions.

## Step 1: Determine the branch to review

If an argument was provided (`$1`), check out that branch:
```
git checkout $1
```

If no argument was provided, use the current branch as-is. Confirm which branch is being reviewed.

## Step 2: Update main and get the diff

Pull the latest changes on `main` without switching to it:
```
git fetch origin main:main
```

If `origin` is not the correct remote, identify the right one first with `git remote -v` and adjust accordingly.

Then get the diff against `main`:
```
git diff main
```

And the commit log for this branch:
```
git log main.. --oneline
```

## Step 3: Review the branch

Using the diff and commit log above, plus the code in the current working tree, produce a full review report.
