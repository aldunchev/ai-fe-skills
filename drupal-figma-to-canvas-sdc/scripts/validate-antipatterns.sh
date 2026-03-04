#!/usr/bin/env bash
# validate-antipatterns.sh — Run 16 automatable anti-pattern checks on a Drupal SDC component.
#
# Usage:
#   bash validate-antipatterns.sh <component-dir> <component-name>
#
# Example:
#   bash .claude/skills/figma-to-sdc-portable/scripts/validate-antipatterns.sh \
#     web/themes/custom/acme/components/02-molecules/content-card content-card
#
# Exit code: 0 if all checks pass, 1 if any fail.
#
# --- Project-Specific Patterns (edit for your project) ---
# These variables define patterns that are project-specific.
# Edit them to match your theme's token naming conventions.
WRONG_TYPO_PATTERNS="text-heading-"
WRONG_EYEBROW_PATTERNS="text-eyebrow-lg\|text-eyebrow-md\|text-eyebrow-sm"
INVENTED_UTIL_PATTERNS="spacing-[0-9]\|p-spacing-\|gap-spacing-\|m-spacing-"
ARBITRARY_COLOR_PATTERNS="bg-\[var(--\|text-\[var(--\|border-\[var(--"
# --- End Project-Specific Patterns ---

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <component-dir> <component-name>"
  exit 2
fi

DIR="$1"
NAME="$2"
TWIG="$DIR/$NAME.twig"
PCSS="$DIR/$NAME.pcss"
SCHEMA="$DIR/$NAME.component.yml"

PASS=0
FAIL=0
SKIP=0

check() {
  local num="$1" label="$2" result="$3"
  if [[ "$result" == "PASS" ]]; then
    echo "  OK Check $num: $label"
    PASS=$((PASS + 1))
  elif [[ "$result" == "SKIP" ]]; then
    echo "  -- Check $num: $label (skipped — file not found)"
    SKIP=$((SKIP + 1))
  else
    echo "  FAIL Check $num: $label"
    FAIL=$((FAIL + 1))
  fi
}

echo "Anti-Pattern Validation: $NAME"
echo "Directory: $DIR"
echo ""

# ---------- Check 1: Recreating Atoms ----------
if [[ -f "$TWIG" ]]; then
  hits=$(grep -n '<h[1-6]\|<button\|<a \|<img\|<svg' "$TWIG" | grep -v '{#\|#}\|<!--' || true)
  [[ -z "$hits" ]] && check 1 "No hardcoded atoms" PASS || check 1 "No hardcoded atoms" FAIL
else
  check 1 "No hardcoded atoms" SKIP
fi

# ---------- Check 2: Missing 'only' keyword ----------
if [[ -f "$TWIG" ]]; then
  hits=$(grep -n '{% include.*%}' "$TWIG" | grep -v 'only %}' || true)
  [[ -z "$hits" ]] && check 2 "All includes use 'only'" PASS || check 2 "All includes use 'only'" FAIL
else
  check 2 "All includes use 'only'" SKIP
fi

# ---------- Check 3: Inline styles ----------
if [[ -f "$TWIG" ]]; then
  hits=$(grep -n 'style="' "$TWIG" || true)
  [[ -z "$hits" ]] && check 3 "No inline styles" PASS || check 3 "No inline styles" FAIL
else
  check 3 "No inline styles" SKIP
fi

# ---------- Check 4: Hardcoded colors in CSS ----------
if [[ -f "$PCSS" ]]; then
  hits=$(grep -n '#[0-9a-fA-F]\{3,6\}\|rgb\|hsl' "$PCSS" || true)
  [[ -z "$hits" ]] && check 4 "No hardcoded colors in CSS" PASS || check 4 "No hardcoded colors in CSS" FAIL
else
  check 4 "No hardcoded colors in CSS" SKIP
fi

# ---------- Check 5: Wrong typography tokens ----------
if [[ -f "$TWIG" ]]; then
  hits=$(grep -n "$WRONG_TYPO_PATTERNS\|$WRONG_EYEBROW_PATTERNS" "$TWIG" || true)
  [[ -z "$hits" ]] && check 5 "No wrong typography tokens" PASS || check 5 "No wrong typography tokens" FAIL
else
  check 5 "No wrong typography tokens" SKIP
fi

# ---------- Check 5b: Custom font-size in CSS ----------
if [[ -f "$PCSS" ]]; then
  hits=$(grep -n 'font-size:' "$PCSS" || true)
  [[ -z "$hits" ]] && check "5b" "No custom font-size in CSS" PASS || check "5b" "No custom font-size in CSS" FAIL
else
  check "5b" "No custom font-size in CSS" SKIP
fi

# ---------- Check 6: Non-existent / invented utilities ----------
if [[ -f "$TWIG" ]]; then
  hits=$(grep -n "$INVENTED_UTIL_PATTERNS\|$WRONG_TYPO_PATTERNS" "$TWIG" || true)
  [[ -z "$hits" ]] && check 6 "No invented utilities" PASS || check 6 "No invented utilities" FAIL
else
  check 6 "No invented utilities" SKIP
fi

# ---------- Check 7: Type string overuse ----------
if [[ -f "$SCHEMA" ]]; then
  total=$(grep -c '      type:' "$SCHEMA" 2>/dev/null) || total=0
  strings=$(grep -c "      type: string" "$SCHEMA" 2>/dev/null) || strings=0
  if [[ "$total" -gt 0 && "$strings" -eq "$total" && "$total" -gt 2 ]]; then
    check 7 "Props properly typed (not all strings)" FAIL
  else
    check 7 "Props properly typed (not all strings)" PASS
  fi
else
  check 7 "Props properly typed (not all strings)" SKIP
fi

# ---------- Check 8: Component name mismatch ----------
if [[ -f "$SCHEMA" ]]; then
  schema_name=$(grep '^name:' "$SCHEMA" | head -1 | sed 's/^name:\s*//')
  # name should be human-readable (contain spaces or capitals), not kebab-case
  if echo "$schema_name" | grep -q '-'; then
    check 8 "Schema name is human-readable" FAIL
  else
    check 8 "Schema name is human-readable" PASS
  fi
else
  check 8 "Schema name is human-readable" SKIP
fi

# ---------- Check 9: Arbitrary color values in Twig ----------
if [[ -f "$TWIG" ]]; then
  hits=$(grep -n "$ARBITRARY_COLOR_PATTERNS" "$TWIG" || true)
  [[ -z "$hits" ]] && check 9 "No arbitrary color values" PASS || check 9 "No arbitrary color values" FAIL
else
  check 9 "No arbitrary color values" SKIP
fi

# ---------- Check 10: Fixed width/height ----------
if [[ -f "$TWIG" ]]; then
  twig_hits=$(grep -n 'w-\[.*px\]\|h-\[.*px\]' "$TWIG" || true)
else
  twig_hits=""
fi
if [[ -f "$PCSS" ]]; then
  pcss_hits=$(grep -n 'width:\|height:' "$PCSS" || true)
else
  pcss_hits=""
fi
hits="$twig_hits$pcss_hits"
[[ -z "$hits" ]] && check 10 "No fixed width/height" PASS || check 10 "No fixed width/height" FAIL

# ---------- Check 11: Schema has status and group ----------
if [[ -f "$SCHEMA" ]]; then
  has_status=$(grep -c '^status:' "$SCHEMA" 2>/dev/null) || has_status=0
  has_group=$(grep -c '^group:' "$SCHEMA" 2>/dev/null) || has_group=0
  if [[ "$has_status" -gt 0 && "$has_group" -gt 0 ]]; then
    check 11 "Schema has status and group" PASS
  else
    check 11 "Schema has status and group" FAIL
  fi
else
  check 11 "Schema has status and group" SKIP
fi

# ---------- Check 12: Per-prop examples ----------
if [[ -f "$SCHEMA" ]]; then
  has_examples=$(grep -c '      examples:' "$SCHEMA" 2>/dev/null) || has_examples=0
  has_top_level=$(grep -c '^examples:' "$SCHEMA" 2>/dev/null) || has_top_level=0
  if [[ "$has_examples" -gt 0 && "$has_top_level" -eq 0 ]]; then
    check 12 "Schema has per-prop examples" PASS
  else
    check 12 "Schema has per-prop examples" FAIL
  fi
else
  check 12 "Schema has per-prop examples" SKIP
fi

# ---------- Check 13: Non-BEM CSS classes ----------
if [[ -f "$PCSS" ]]; then
  hits=$(grep -n '^\.[^_-]*[A-Z]' "$PCSS" || true)
  [[ -z "$hits" ]] && check 13 "CSS uses BEM naming" PASS || check 13 "CSS uses BEM naming" FAIL
else
  check 13 "CSS uses BEM naming" SKIP
fi

# ---------- Check 14: JS uses .src.js extension ----------
if [[ -f "$DIR/$NAME.js" && ! -f "$DIR/$NAME.src.js" ]]; then
  check 14 "JavaScript uses .src.js extension" FAIL
else
  check 14 "JavaScript uses .src.js extension" PASS
fi

# ---------- Check 15: Canvas-incompatible prop types ----------
if [[ -f "$SCHEMA" ]]; then
  # Check for array of objects (always bad for Canvas)
  array_of_objects=$(grep -A 3 'type: array' "$SCHEMA" | grep 'type: object' || true)
  # Count type: object entries, subtract root props declaration and canvas $ref entries
  obj_total=$(grep -c 'type: object' "$SCHEMA" 2>/dev/null) || obj_total=0
  canvas_refs=$(grep -c 'canvas\.module' "$SCHEMA" 2>/dev/null) || canvas_refs=0
  root_props=$(grep -c '^  type: object' "$SCHEMA" 2>/dev/null) || root_props=0
  generic_count=$((obj_total - canvas_refs - root_props))
  if [[ -n "$array_of_objects" ]] || [[ "$generic_count" -gt 0 ]]; then
    check 15 "No Canvas-incompatible prop types" FAIL
  else
    check 15 "No Canvas-incompatible prop types" PASS
  fi
else
  check 15 "No Canvas-incompatible prop types" SKIP
fi

# ---------- Check 16: Redundant image slots ----------
if [[ -f "$SCHEMA" ]]; then
  has_image_ref=$(grep -q 'canvas.module/image' "$SCHEMA" && echo 1 || echo 0)
  has_image_slot=$(grep -q 'image_slot' "$SCHEMA" && echo 1 || echo 0)
  if [[ "$has_image_ref" -eq 1 && "$has_image_slot" -eq 1 ]]; then
    check 16 "No redundant image slots" FAIL
  else
    check 16 "No redundant image slots" PASS
  fi
else
  check 16 "No redundant image slots" SKIP
fi

# ---------- Summary ----------
echo ""
echo "=============================="
echo "Results: $PASS PASS, $FAIL FAIL, $SKIP SKIP"
echo "=============================="

if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
