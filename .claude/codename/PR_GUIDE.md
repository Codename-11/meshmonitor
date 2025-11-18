# Pull Request Guide

This workflow keeps your fork clean, makes it easy to test features locally, and ensures upstream history stays tidy.

## 1. Keep `main` in Sync with Upstream

> Note: `main` is automatically synced daily by `.github/workflows/sync-fork.yml`, but you can run these commands anytime manually. Just remember to push your changes back to your fork after syncing.
> You can also run the sync workflow manually by clicking the "Run workflow" button in the Actions tab

```bash
git checkout main
git fetch upstream
git rebase upstream/main      # or merge if you prefer
git push origin main
```

Your fork’s `main` now mirrors `Yeraze/main`.

## 2. Maintain a Personal `dev` Branch

```bash
git checkout main
git checkout -b dev
git push -u origin dev
```

- `dev` is your integration branch where you combine features for local testing.
- You normally do **not** open PRs from `dev`.

## 3. Create Feature Branches from `dev`

**Best Practice: Create feature branch from upstream/main:**
```bash
git fetch upstream
git checkout -b feat/my-feature upstream/main
# Copy .claude/ from main for reference (optional, for PR_TODO.md access)
git checkout main -- .claude/ 2>/dev/null || echo ".claude/ not needed"
```

**Alternative: Create from dev:**
```bash
git checkout dev
git checkout -b feat/my-feature
# .claude/ will be present but should NOT be committed
```

1. **Using PR_TODO.md during development:**
   - `.claude/codename/PR_TODO.md` can be present in your working directory for reference
   - You can update it during development to track progress
   - **⚠️ CRITICAL: Never commit `.claude/` files in feature branches!**
   - Before committing, ensure `.claude/` is not staged: `git status` should show it as untracked or modified but not staged

2. Implement the feature, add tests, update docs.
3. Run checks:
   ```bash
   npm run lint
   npm run typecheck
   npm run test:run
   ```
4. Commit with conventional message(s).

## 4. Push Feature Branch & Open PR

**Before pushing, verify your branch:**
```bash
# Check what files are staged/committed (should NOT include .claude/)
git diff --cached --name-only  # Check staged files
git diff upstream/main --name-only  # Check all changes

# If .claude/ appears in staged files, unstage it:
git restore --staged .claude/

# If .claude/ was accidentally committed, remove it:
git rm -r --cached .claude/
git commit -m "chore: Remove .claude/ from feature branch"

# Verify .claude/ is NOT in the commit:
git show HEAD --name-only
```

```bash
git push -u origin feat/my-feature
```

- Open PR: `Codename-11/feat/my-feature` → `Yeraze/main`.
- Paste `.claude/codename/PR_DESCRIPTION.md` content into the PR body.
- **Verify the PR diff does NOT include `.claude/` files** - PRs compare to `upstream/main` which doesn't have these files

## 5. Keep Feature Branch Updated (Optional Rebase)

```bash
git checkout feat/my-feature
git fetch upstream
git rebase upstream/main      # keeps history linear
git push --force-with-lease
```

## 6. Use the Feature Locally While PR is Pending

```bash
git checkout dev
git merge feat/my-feature
git push origin dev
```

- `dev` now contains the feature for your own use.
- Continue stacking additional feature branches onto `dev` as needed.

## 7. After PR is Merged Upstream

```bash
git checkout main
git fetch upstream
git rebase upstream/main
git push origin main

git checkout dev
git rebase main
git push origin dev --force-with-lease
```

Finally, clean up:

```bash
git branch -d feat/my-feature
git push origin --delete feat/my-feature
```

## 8. Tips & Troubleshooting

- **Need to switch branches with uncommitted work?**
  ```bash
  git stash push -m "WIP feature"
  # switch branches...
  git stash pop
  ```

- **Upstream merged other PRs before yours?**
  ```bash
  git checkout feat/my-feature
  git fetch upstream
  git rebase upstream/main   # or merge
  git push --force-with-lease
  ```

- **When to wait vs merge into dev?**
  - Merge feature into `dev` immediately after you open the PR if you need it locally.
  - Rebase `dev` onto `main` only *after* upstream has merged all required PRs (to avoid churn).
  - If you have conflicts during rebase, resolve them once on the branch closest to the conflict (usually the feature) before touching `dev`.

- **Manual vs workflow sync**
  - Workflow runs daily; if you need `main` synced right now, run the commands in Section 1 and push manually.
  - You can trigger the workflow from GitHub → Actions → “Sync Fork and Reapply Custom README” → “Run workflow”.

## Quick Reference

| Action                              | Command(s) |
|------------------------------------|------------|
| Sync fork main                     | `git checkout main && git fetch upstream && git rebase upstream/main && git push origin main` |
| Start feature branch               | `git checkout dev && git checkout -b feat/foo` |
| Run checks                         | `npm run lint && npm run typecheck && npm run test:run` |
| Push feature / open PR             | `git push -u origin feat/foo` |
| Use feature locally (merge to dev) | `git checkout dev && git merge feat/foo && git push origin dev` |
| After PR merge                     | Sync `main`, rebase `dev`, delete feature branch |

This structure keeps `main` clean, `dev` ready for personal deployments, and each feature isolated for review. Use rebase for linear history; use merge if you prefer to preserve branch topology.

