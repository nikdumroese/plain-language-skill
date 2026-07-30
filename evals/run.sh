#!/usr/bin/env bash
# Generate before/after samples for the README.
#
# Runs two invocations of the same LLM against the same prompt.
# The only difference: whether the plain-language skill is loaded.
#
# Supported runners (auto-detected in order):
#   1. pi     — https://github.com/earendil-works/pi
#   2. claude — Claude Code CLI
#   3. codex  — OpenAI Codex CLI
#
# Override the runner:  RUNNER=claude ./evals/run.sh
# Override the model:   MODEL=claude-opus-5 ./evals/run.sh
#
# All runners are invoked with:
#   - no CLAUDE.md / AGENTS.md discovery
#   - no auto-discovered skills
#   - no tools (pure text generation)
#
# Output: examples/generated-before-after.md

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_DIR="$REPO_ROOT/skills/plain-language-iso-24495"
OUT="$REPO_ROOT/examples/generated-before-after.md"

RUNNER="${RUNNER:-auto}"

detect_runner() {
  if command -v pi >/dev/null 2>&1; then echo pi
  elif command -v claude >/dev/null 2>&1; then echo claude
  elif command -v codex >/dev/null 2>&1; then echo codex
  else echo none
  fi
}

if [ "$RUNNER" = "auto" ]; then
  RUNNER=$(detect_runner)
fi

case "$RUNNER" in
  pi)
    MODEL="${MODEL:-claude-sonnet-5}"
    PROVIDER="${PROVIDER:-github-copilot}"
    RUNNER_VERSION="pi $(pi --version 2>&1 | head -1)"
    ;;
  claude)
    MODEL="${MODEL:-default}"
    PROVIDER=""
    RUNNER_VERSION="claude $(claude --version 2>&1 | head -1)"
    ;;
  codex)
    MODEL="${MODEL:-gpt-5}"
    PROVIDER=""
    RUNNER_VERSION="codex $(codex --version 2>&1 | head -1)"
    ;;
  none)
    echo "ERROR: no supported runner found. Install one of: pi, claude, codex." >&2
    exit 1
    ;;
  *)
    echo "ERROR: unknown runner '$RUNNER'. Use pi, claude, or codex." >&2
    exit 1
    ;;
esac

run_baseline() {
  local prompt="$1"
  case "$RUNNER" in
    pi)     pi -p -nc -ns -nt --provider "$PROVIDER" --model "$MODEL" "$prompt" ;;
    claude) claude --bare -p "$prompt" ;;
    codex)  codex exec -m "$MODEL" --no-project-doc "$prompt" ;;
  esac
}

run_with_skill() {
  local prompt="$1"
  local skill_content="$2"
  case "$RUNNER" in
    pi)
      pi -p -nc -ns -nt \
        --append-system-prompt "$skill_content" \
        --provider "$PROVIDER" --model "$MODEL" "$prompt"
      ;;
    claude)
      claude --bare -p --append-system-prompt "$skill_content" "$prompt"
      ;;
    codex)
      codex exec -m "$MODEL" --no-project-doc \
        --system-prompt "$skill_content" "$prompt"
      ;;
  esac
}

mkdir -p "$REPO_ROOT/examples"

# Concatenate skill content into a single system-prompt payload.
# In interactive use the agent reads these files via the read tool. With no
# tools available we inline them so the same rules are in scope.
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
SKILL_CONTENT="$(cat "$SKILL_BLOB")"

PROMPTS=(
  "Write a memo asking leadership to approve migrating payment processing from Stripe to Adyen. It saves cost, improves European latency, takes six weeks. Legal, Security, and Finance need to sign off."
  "Write a short RFC proposing that we adopt Temporal for background job orchestration, replacing the current mix of Sidekiq and cron. The reader is the engineering leadership team."
  "Write a postmortem for a 45-minute payment outage on 2026-07-30. Cause: a deploy removed a required environment variable. Detection was via customer reports; alerts did not fire."
)

{
  echo "# Before / after — real samples"
  echo ""
  echo "**Generated:** $(date '+%Y-%m-%d %H:%M %Z')"
  echo "**Runner:** $RUNNER_VERSION"
  if [ -n "$PROVIDER" ]; then
    echo "**Provider / model:** \`$PROVIDER / $MODEL\`"
  else
    echo "**Model:** \`$MODEL\`"
  fi
  echo ""
  echo "Both runs use the same runner, the same model, and the same prompt. Neither has access to CLAUDE.md, auto-discovered skills, or project context. The only difference is whether the plain-language skill is in the system prompt."
  echo ""
  echo "Regenerate with \`./evals/run.sh\`. Override the runner with \`RUNNER=claude ./evals/run.sh\` or the model with \`MODEL=... ./evals/run.sh\`."
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

  echo "[$(date +%H:%M:%S)] Sample $N baseline via $RUNNER..." >&2
  {
    echo "### Baseline (no skill)"
    echo ""
    echo '````markdown'
    run_baseline "$PROMPT"
    echo ''
    echo '````'
    echo ""
  } >> "$OUT"

  echo "[$(date +%H:%M:%S)] Sample $N with-skill via $RUNNER..." >&2
  {
    echo "### With plain-language skill"
    echo ""
    echo '````markdown'
    run_with_skill "$PROMPT" "$SKILL_CONTENT"
    echo ''
    echo '````'
    echo ""
    echo "---"
  } >> "$OUT"
done

echo "Done. Output: $OUT" >&2
