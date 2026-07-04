#!/usr/bin/env bash
# Cross-Vendor Review — call one non-Claude reviewer model via OpenRouter.
# See references/cross-vendor-panel.md for when/why to use this overlay.
#
# Usage:
#   OPENROUTER_API_KEY=... cross-vendor-review.sh <model> <prompt-file> [output-file]
#   cross-vendor-review.sh <model> <prompt-file> [output-file]   # falls back to 1Password
#
# <model> is an OpenRouter model id, e.g.:
#   x-ai/grok-4
#   google/gemini-2.5-pro
#   deepseek/deepseek-chat
#   z-ai/glm-4.6
#   moonshotai/kimi-k2
# Prefer the direct-output sibling over the "-thinking"/extended-reasoning
# variant — reasoning-heavy variants can burn their whole token budget on
# hidden reasoning and return empty content (see cross-vendor-panel.md).
#
# Writes the raw model response text to stdout (or output-file if given).
# Exits non-zero on any HTTP/API error — caller must not silently continue
# past a failed vendor call (Error Handling — Never Silently Swallow).

set -euo pipefail

MODEL="${1:?usage: cross-vendor-review.sh <model> <prompt-file> [output-file]}"
PROMPT_FILE="${2:?usage: cross-vendor-review.sh <model> <prompt-file> [output-file]}"
OUT_FILE="${3:-}"

if [ ! -f "$PROMPT_FILE" ]; then
  echo "ERROR: prompt file not found: $PROMPT_FILE" >&2
  exit 1
fi

if [ -z "${OPENROUTER_API_KEY:-}" ]; then
  OPENROUTER_API_KEY="$(op item get "openrouter-api-key-main" --vault "Shared with Watson" --fields credential --reveal 2>/dev/null || true)"
fi

if [ -z "${OPENROUTER_API_KEY:-}" ]; then
  echo "ERROR: OPENROUTER_API_KEY not set and 1Password lookup failed (openrouter-api-key-main / Shared with Watson vault)." >&2
  exit 1
fi

PROMPT_JSON=$(python3 -c "import json,sys; print(json.dumps(open(sys.argv[1]).read()))" "$PROMPT_FILE")

RESPONSE=$(curl -s -w '\n%{http_code}' https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$MODEL\",\"messages\":[{\"role\":\"user\",\"content\":$PROMPT_JSON}]}")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" != "200" ]; then
  echo "ERROR: OpenRouter call failed for model $MODEL (HTTP $HTTP_CODE): $BODY" >&2
  exit 1
fi

CONTENT=$(echo "$BODY" | python3 -c "
import json,sys
d=json.load(sys.stdin)
choices=d.get('choices') or []
content=(choices[0].get('message',{}).get('content') if choices else None) or ''
print(content)
")

if [ -z "$CONTENT" ]; then
  echo "ERROR: empty content from $MODEL — likely a reasoning-heavy variant burning its budget on hidden reasoning. Try the direct-output sibling model." >&2
  exit 1
fi

if [ -n "$OUT_FILE" ]; then
  echo "$CONTENT" > "$OUT_FILE"
else
  echo "$CONTENT"
fi
