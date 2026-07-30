#!/usr/bin/env bash
# Generate before/after samples for the README.
#
# Uses pi with GitHub Copilot. Both runs use the same model and the same prompt.
# The only difference is whether the plain-language skill is loaded.
#
# Requires: pi, github-copilot provider authenticated.
# Output: examples/generated-before-after.md
#
# Flags used:
#   -p    print mode (headless)
#   -nc   no CLAUDE.md / AGENTS.md
#   -ns   no auto-discovered skills
#   -nt   no tools (text generation only)
#
# The with-skill run appends the concatenated SKILL.md + references directly to
# the system prompt. In interactive use the agent would read those files via the
# read tool, but with -nt that path is not available, so we inline them.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_DIR="$REPO_ROOT/skills/plain-language-iso-24495"
OUT="$REPO_ROOT/examples/generated-before-after.md"

PROVIDER="${PROVIDER:-github-copilot}"
MODEL="${MODEL:-claude-sonnet-5}"

mkdir -p "$REPO_ROOT/examples"

# Concatenate skill content into a single system-prompt payload
SKILL_BLOB=$(mktemp)
trap 'rm -f "$SKILL_BLOB"' EXIT
{
  cat "$SKILL_DIR/SKILL.md"
  echo ""
  echo "# ---- REFERENCE: PRINCIPLES ----"
  cat "$SKILL_DIR/references/principles.md"
  echo ""
  echo "# ---- REFERENCE: CHECKLIST ----"
  cat "$SKILL_DIR/references/checklist.md"
  echo ""
  echo "# ---- TEMPLATE ----"
  cat "$SKILL_DIR/assets/template.md"
} > "$SKILL_BLOB"

PROMPTS=(
  "Write a memo asking leadership to approve migrating payment processing from Stripe to Adyen. It saves cost, improves European latency, takes six weeks. Legal, Security, and Finance need to sign off."
  "Write a short RFC proposing that we adopt Temporal for background job orchestration, replacing the current mix of Sidekiq and cron. The reader is the engineering leadership team."
  "Write a postmortem for a 45-minute payment outage on 2026-07-30. Cause: a deploy removed a required environment variable. Detection was via customer reports; alerts did not fire."
)

{
  echo "# Before / after — real samples"
  echo ""
  echo "**Generated:** $(date '+%Y-%m-%d %H:%M %Z')"
  echo "**Runner:** pi $(pi --version 2>&1 | head -1)"
  echo "**Provider / model:** \`$PROVIDER / $MODEL\`"
  echo ""
  echo "Both runs use the same model and the same prompt. Neither has access to CLAUDE.md, auto-discovered skills, or project context. The only difference is whether the plain-language skill is loaded."
  echo ""
  echo "Baseline command:"
  echo '```'
  echo "pi -p -nc -ns -nt --provider $PROVIDER --model $MODEL '<prompt>'"
  echo '```'
  echo ""
  echo "With-skill command (skill content concatenated into system prompt):"
  echo '```'
  echo "pi -p -nc -ns -nt --append-system-prompt \"\$(cat <skill-files>)\" --provider $PROVIDER --model $MODEL '<prompt>'"
  echo '```'
  echo ""
  echo "---"
} > "$OUT"

for i in "${!PROMPTS[@]}"; do
  PROMPT="${PROMPTS[$i]}"
  N=$((i + 1))

  {
    echo ""
    echo "## Sample $N"
    echo ""
    echo "**Prompt:** $PROMPT"
    echo ""
  } >> "$OUT"

  echo "[$(date +%H:%M:%S)] Sample $N baseline..." >&2
  {
    echo "### Baseline (no skill)"
    echo ""
    echo '````markdown'
    pi -p -nc -ns -nt --provider "$PROVIDER" --model "$MODEL" "$PROMPT"
    echo ''
    echo '````'
    echo ""
  } >> "$OUT"

  echo "[$(date +%H:%M:%S)] Sample $N with-skill..." >&2
  {
    echo "### With plain-language skill"
    echo ""
    echo '````markdown'
    pi -p -nc -ns -nt \
      --append-system-prompt "$(cat "$SKILL_BLOB")" \
      --provider "$PROVIDER" --model "$MODEL" "$PROMPT"
    echo ''
    echo '````'
    echo ""
    echo "---"
  } >> "$OUT"
done

echo "Done. Output: $OUT" >&2
