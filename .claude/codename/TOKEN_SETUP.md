# Token Setup for Feature Branch Automation

## Required Tokens

### 1. Claude Code OAuth Token (`CLAUDE_CODE_OAUTH_TOKEN`)

**What it is:** OAuth token for Claude Code GitHub app to review your code

**Do you need it if GitHub app is installed?**

**Yes, you still need the OAuth token.** The GitHub app installation handles permissions, but the OAuth token is required for Claude's API authentication. They work together:
- **GitHub App**: Handles repository permissions and access
- **OAuth Token**: Authenticates with Claude's API to actually run reviews

**Where to get it:**

The OAuth token is separate from the GitHub app installation. You need to generate it from Claude's side.

**Method 1: Via Claude Code Website (Primary Method)**
1. Go to: https://claude.ai/code
2. Sign in with your Claude subscription (must have Claude Code access)
3. Look for one of these:
   - Settings icon/gear → "GitHub" or "Integrations"
   - "API" or "Tokens" section
   - "Generate Token" or "OAuth Token" option
4. Generate the OAuth token
5. Copy the token immediately (you may not see it again)

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

**Method 4: Check Anthropic Documentation**
1. Visit the action's repository: https://github.com/anthropics/claude-code-action
2. Check the README for OAuth token setup instructions
3. Look for "Getting Started" or "Setup" section

**Testing if you need the token:**
1. Push a feature branch without the token set
2. Check the workflow run - if it fails with authentication error, you need the token
3. The error message will indicate if `CLAUDE_CODE_OAUTH_TOKEN` is missing

**If you can't find the token generation option:**
- The feature might be in beta/limited access
- Check if you have Claude Code subscription access
- Try contacting Anthropic support or check their documentation
- Alternative: The token might be auto-generated during GitHub app installation - check your fork's Settings → Secrets → Actions for any auto-created secrets

**Important:** The OAuth token is different from:
- GitHub Personal Access Token (PAT)
- Claude API key
- It's specifically for the Claude Code GitHub app integration

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

