# Codename-11 Fork Setup

## Project Overview
**MeshMonitor** - Web app for monitoring Meshtastic mesh networks over IP
- **Stack:** React 19 + TypeScript + Node.js/Express + SQLite
- **Theme:** Catppuccin Mocha dark theme
- **Port:** 8080 (Docker), 5173 (React dev), 3001 (API dev)

## Fork Structure
```
upstream: Yeraze/meshmonitor (main project)
origin:   Codename-11/meshmonitor (your fork)
```

**Branches:**
- `main` - Mirrors Yeraze/main (auto-synced daily via GitHub Actions)
- `dev` - Personal integration branch for testing features locally
- `feat/*` - Individual feature branches for PRs to upstream

## Development Workflow

### Starting a New Feature
```bash
# Create feature branch from dev
git checkout dev
git checkout -b feat/my-feature

# Make changes, test locally
docker-compose -f docker-compose.dev.yml up --build

# Run checks before PR
npm run lint
npm run typecheck
npm run test:run
tests/system-tests.sh  # Required for PRs

# Push and open PR to Yeraze/main
git push -u origin feat/my-feature
```

### Using Feature Locally (While PR is Pending)
```bash
git checkout dev
git merge feat/my-feature
git push origin dev
```

### After PR Merges
```bash
# Sync main with upstream
git checkout main
git fetch upstream
git rebase upstream/main
git push origin main

# Rebase dev on updated main
git checkout dev
git rebase main
git push origin dev --force-with-lease

# Delete feature branch
git branch -d feat/my-feature
git push origin --delete feat/my-feature
```

## Important Rules (from CLAUDE.md)
- **Always use Context7 MCP** for code generation, setup, library docs
- **Review docs/ARCHITECTURE_LESSONS.md** before implementing node communication, state management, backup/restore
- **Backend talks to Node** - Frontend never talks directly to node
- **Test on "gauntlet" channel** - Never send test messages on Primary!
- **Docker dev environment** - Build first, then start
- **Never push to main** - Always use feature branches
- **Update versions** in package.json AND Helm chart, regenerate package-lock
- **Run system-tests.sh** before creating PR, post output report after user manually tests with npm run dev

## Quick Commands
```bash
# Start dev environment
docker-compose -f docker-compose.dev.yml up --build

# Run all checks
npm run lint && npm run typecheck && npm run test:run

# System tests (required before PR)
tests/system-tests.sh

# Manual sync fork (if needed)
git checkout main && git fetch upstream && git rebase upstream/main && git push origin main
```

## Resources
- **Main Docs:** https://meshmonitor.org/
- **PR Guide:** `.claude/codename/PR_GUIDE.md`
- **Meshtastic Protobufs:** https://github.com/meshtastic/protobufs/
- **Upstream Repo:** https://github.com/Yeraze/meshmonitor

## Personal Files Location

All personal fork management files are in `.claude/codename/`:
- This directory is **tracked in fork's main** (needed for GitHub Actions workflow)
- These files will **never** be pushed to upstream or included in PRs
- **⚠️ CRITICAL: Never commit `.claude/` changes in feature branches!**
  - Feature branches should only contain main codebase changes
  - If you modify `.claude/` files, stash or discard those changes before committing
  - PRs compare to `upstream/main` which doesn't have `.claude/`, so they won't appear in PR diffs
- Use these files for your own fork management only
