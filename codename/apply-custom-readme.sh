#!/usr/bin/env bash
set -euo pipefail

README_FILE="README.md"

if [[ ! -f "$README_FILE" ]]; then
  echo "README.md not found. Skipping custom block reapply."
  exit 0
fi

python - <<'PY'
import pathlib, re
readme = pathlib.Path("README.md")
text = readme.read_text(encoding="utf-8")
pattern = r"\n?<!-- CODENAME-11 CUSTOM -->.*?<!-- END CODENAME-11 CUSTOM -->\n?"
text = re.sub(pattern, "\n", text, flags=re.S)
readme.write_text(text.rstrip() + "\n", encoding="utf-8")
PY

python - <<'PY'
import pathlib, re

readme = pathlib.Path("README.md")
text = readme.read_text(encoding="utf-8").rstrip() + "\n"

custom_block = """
<!-- CODENAME-11 CUSTOM -->
## Codename-11 Enhancements (Local Fork Only)

> These additions exist only in Codename-11's fork. They are re-applied automatically after every upstream sync.

| Branch | Purpose |
|--------|---------|
| `main` | Mirrors `Yeraze/main` via GitHub Actions |
| `dev`  | Personal integration branch for staging features |
| `feat/*` | Individual feature branches used for PRs |

### Tooling
- Automated upstream sync: `.github/workflows/sync-fork.yml`
- README customization script: `codename/apply-custom-readme.sh`
- PR scaffolding: `codename/PR_GUIDE.md`

<!-- END CODENAME-11 CUSTOM -->
""".strip()

pattern = r"\n?<!-- CODENAME-11 CUSTOM -->.*?<!-- END CODENAME-11 CUSTOM -->\n?"
text = re.sub(pattern, "\n", text, flags=re.S)
marker = "\n## Documentation"

if marker in text:
    head, tail = text.split(marker, 1)
    new_text = head.rstrip() + "\n\n" + custom_block + "\n\n## Documentation" + tail
else:
    new_text = text.rstrip() + "\n\n" + custom_block + "\n"

readme.write_text(new_text.rstrip() + "\n", encoding="utf-8")
PY

echo "✅ Custom README block re-applied near top."

