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

```bash
git checkout dev
git checkout -b feat/my-feature
```

1. Implement the feature, add tests, update docs.
2. Run checks:
   ```bash
   npm run lint
   npm run typecheck
   npm run test:run
   ```
3. Commit with conventional message(s).

## 4. Push Feature Branch & Open PR

```bash
git push -u origin feat/my-feature
```

- Open PR: `Codename-11/feat/my-feature` → `Yeraze/main`.
- Paste `temp/PR_DESCRIPTION.md` content into the PR body.

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

