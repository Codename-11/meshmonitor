# Token Setup for Feature Branch Automation

## Required Tokens

### 1. Claude Code OAuth Token (`CLAUDE_CODE_OAUTH_TOKEN`)

**What it is:** OAuth token for Claude Code GitHub app to review your code

**Where to get it:**

The OAuth token is generated when you install/connect the Claude Code GitHub app to your repository.

**Method 1: Via Claude Code Website (if available)**
1. Go to: https://claude.ai/code
2. Sign in with your Claude subscription
3. Look for "GitHub Integration" or "Settings" section
4. If there's a "Generate OAuth Token" option, use that
5. Copy the token

**Method 2: Via GitHub App Installation (Recommended)**
1. Go to: https://github.com/apps/claude-code (or search for "Claude Code" in GitHub Apps)
2. Click "Install" or "Configure"
3. Select your fork repository (Codename-11/meshmonitor)
4. During installation, you may be prompted to authorize and generate an OAuth token
5. Copy the token when shown

**Method 3: Check GitHub App Settings**
1. Go to your fork: https://github.com/Codename-11/meshmonitor
2. Settings → Integrations → Installed GitHub Apps
3. Find "Claude Code" app
4. Click "Configure" → Look for OAuth token or "Generate token" option

**Note:** If you've already installed the Claude Code app but don't see the token, you may need to:
- Re-authorize the app
- Check if the token is shown in the app's configuration page
- The token might be auto-generated and stored - check GitHub's secret management

**Where to set it:**
- GitHub → Your Fork → Settings → Secrets and variables → Actions
- Click "New repository secret"
- Name: `CLAUDE_CODE_OAUTH_TOKEN`
- Value: Paste the token
- Click "Add secret"

---

### 2. Upstream Personal Access Token (`UPSTREAM_PAT`) - Optional

**What it is:** Token to create PRs in upstream repository (Yeraze/meshmonitor)

**When needed:** Only if you want automatic upstream PR creation

**Where to get it:**
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Name: `MeshMonitor Upstream PR`
4. Expiration: Choose your preference (90 days recommended)
5. Scopes: Check `repo` (Full control of private repositories)
   - This includes: `public_repo` (Access public repositories)
6. Click "Generate token"
7. **Copy immediately** (you won't see it again!)

**Where to set it:**
- GitHub → Your Fork → Settings → Secrets and variables → Actions
- Click "New repository secret"
- Name: `UPSTREAM_PAT`
- Value: Paste the token
- Click "Add secret"

**Security Note:** This token has access to create PRs. Keep it secure.

---

## Quick Setup Checklist

- [ ] Get Claude Code OAuth token from https://claude.ai/code
- [ ] Add `CLAUDE_CODE_OAUTH_TOKEN` secret to your fork
- [ ] (Optional) Create GitHub PAT with `repo` scope
- [ ] (Optional) Add `UPSTREAM_PAT` secret to your fork
- [ ] Push a feature branch to test the workflow

## Testing

1. Create a feature branch: `git checkout -b feat/test-automation`
2. Make a small change
3. Push: `git push -u origin feat/test-automation`
4. Check Actions tab - workflow should run automatically
5. Review the created PR in your fork

## Troubleshooting

**Workflow not triggering?**
- Check branch name matches `feat/**` pattern
- Verify workflow file is in `.github/workflows/`

**Claude review not running?**
- Verify `CLAUDE_CODE_OAUTH_TOKEN` secret is set correctly
- Check token hasn't expired
- Ensure Claude Code app is installed on your fork

**Can't create upstream PR?**
- Verify `UPSTREAM_PAT` has `repo` scope
- Check token hasn't expired
- Ensure you have permission to create PRs in upstream repo

