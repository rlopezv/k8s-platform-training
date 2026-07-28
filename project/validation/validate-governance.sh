#!/usr/bin/env bash
set -u

STATE_FILE="${STATE_FILE:-project/project-state.md}"
README_FILE="${README_FILE:-README.md}"
PLANNING_FILE="${PLANNING_FILE:-project/project-planning.md}"
AGENTS_FILE="${AGENTS_FILE:-AGENTS.md}"
UNIT08_PLAYBOOK="${UNIT08_PLAYBOOK:-playbooks/units/08-tekton-continuous-integration.md}"
ADVANCED_LABS_REGISTER="${ADVANCED_LABS_REGISTER:-project/advanced-labs-register.md}"
TUTORIAL08_DIR="${TUTORIAL08_DIR:-tutorial/08-tekton-continuous-integration}"
LAB08_DIR="${LAB08_DIR:-labs/08-tekton-continuous-integration}"

failures=0
warnings=0

check() {
  local status="$1"
  local name="$2"
  local detail="$3"

  printf '[%s] %s - %s\n' "$status" "$name" "$detail"
  case "$status" in
    FAIL) failures=$((failures + 1)) ;;
    WARN) warnings=$((warnings + 1)) ;;
  esac
}

file_exists() {
  local file="$1"

  if [ -f "$file" ]; then
    check PASS "file exists" "$file"
  else
    check FAIL "file exists" "$file missing"
  fi
}

contains() {
  local file="$1"
  local pattern="$2"

  grep -Fq "$pattern" "$file" 2>/dev/null
}

not_contains_any() {
  local file="$1"
  shift

  local pattern
  for pattern in "$@"; do
    if grep -Fq "$pattern" "$file" 2>/dev/null; then
      check FAIL "obsolete text" "$file contains '$pattern'"
    else
      check PASS "obsolete text" "$file does not contain '$pattern'"
    fi
  done
}

tracked_by_git() {
  local file="$1"

  git ls-files --error-unmatch "$file" >/dev/null 2>&1
}

playbook_state() {
  local file="$1"

  awk '
    /^## Estado del playbook$|^### Estado del playbook$/ { in_section = 1; next }
    in_section && /^```text$/ { in_block = 1; next }
    in_section && in_block && /^```$/ { exit }
    in_section && in_block { print; exit }
  ' "$file"
}

validate_playbook_state() {
  local file="$1"
  local state

  state="$(playbook_state "$file")"
  case "$state" in
    "Borrador"|"En revisión"|"Aprobado"|"Obsoleto")
      check PASS "playbook state enum" "$file declares '$state'"
      ;;
    "")
      check FAIL "playbook state enum" "$file does not declare Estado del playbook"
      ;;
    *)
      check FAIL "playbook state enum" "$file declares '$state'; expected Borrador, En revisión, Aprobado or Obsoleto"
      ;;
  esac
}

echo "Project governance validation"
echo "This validation checks repository governance documents only."
echo "It does not contact the cluster, install tools, fetch releases or modify state."
echo

for file in "$STATE_FILE" "$README_FILE" "$PLANNING_FILE" "$AGENTS_FILE" "$UNIT08_PLAYBOOK" "$ADVANCED_LABS_REGISTER"; do
  file_exists "$file"
done

echo

if [ "$failures" -eq 0 ]; then
  for playbook in playbooks/units/*.md; do
    validate_playbook_state "$playbook"
  done

  if contains "$STATE_FILE" "playbook aprobado" || contains "$STATE_FILE" "playbook de Unidad 08 generado y aprobado"; then
    if awk '
      /^### Estado del playbook$/ { in_section = 1; next }
      in_section && /^```text$/ { in_block = 1; next }
      in_section && in_block && /^```$/ { exit }
      in_section && in_block && $0 == "Aprobado" { found = 1 }
      END { exit(found ? 0 : 1) }
    ' "$UNIT08_PLAYBOOK"; then
      check PASS "unit 08 playbook state" "$UNIT08_PLAYBOOK declares Aprobado"
    else
      check FAIL "unit 08 playbook state" "$STATE_FILE says playbook approved but $UNIT08_PLAYBOOK does not declare Aprobado"
    fi
  else
    check WARN "unit 08 playbook state" "$STATE_FILE does not explicitly declare the Unit 08 playbook as approved"
  fi

  if contains "$STATE_FILE" "Siguiente incremento permitido | Generar la Unidad 08"; then
    check PASS "next increment" "$STATE_FILE authorizes generating Unit 08"
    not_contains_any "$README_FILE" "generar el playbook de la **Unidad 08"
    not_contains_any "$PLANNING_FILE" "generar el playbook de la **Unidad 08"
    not_contains_any "$AGENTS_FILE" "Generar el playbook de la Unidad 08"
  elif contains "$STATE_FILE" "Siguiente incremento permitido | Revisar y validar funcionalmente la Unidad 08"; then
    check PASS "next increment" "$STATE_FILE authorizes reviewing and validating generated Unit 08"
    if [ -f "$TUTORIAL08_DIR/summary.md" ] && [ -f "$LAB08_DIR/README.md" ]; then
      check PASS "unit 08 generated artifacts" "$TUTORIAL08_DIR and $LAB08_DIR exist"
    else
      check FAIL "unit 08 generated artifacts" "Unit 08 state is generated but tutorial or lab artifacts are missing"
    fi
  elif contains "$STATE_FILE" "Siguiente incremento permitido | Revisar pedagógicamente la Unidad 08"; then
    check PASS "next increment" "$STATE_FILE authorizes pedagogical review of validated Unit 08"
    if [ -f "$TUTORIAL08_DIR/summary.md" ] && [ -f "$LAB08_DIR/README.md" ]; then
      check PASS "unit 08 generated artifacts" "$TUTORIAL08_DIR and $LAB08_DIR exist"
    else
      check FAIL "unit 08 generated artifacts" "Unit 08 state is generated but tutorial or lab artifacts are missing"
    fi
  else
    check WARN "next increment" "$STATE_FILE does not declare a recognized Unit 08 next increment"
  fi

  not_contains_any "$STATE_FILE" \
    "la aprobación del playbook queda pendiente" \
    "la aprobacion del playbook queda pendiente" \
    "pendiente de versionar"

  not_contains_any "$UNIT08_PLAYBOOK" \
    "Borrador generado; pendiente de revision y aprobacion del usuario" \
    "antes de aprobar este playbook" \
    "No instalado antes de aprobar el playbook"

  if contains "$STATE_FILE" "unidad pendiente de generar"; then
    if [ -e "$TUTORIAL08_DIR" ]; then
      check FAIL "unit 08 tutorial absence" "$STATE_FILE says Unit 08 is pending generation but $TUTORIAL08_DIR exists"
    else
      check PASS "unit 08 tutorial absence" "$TUTORIAL08_DIR is absent while Unit 08 is pending generation"
    fi

    if [ -e "$LAB08_DIR" ]; then
      check FAIL "unit 08 lab absence" "$STATE_FILE says Unit 08 is pending generation but $LAB08_DIR exists"
    else
      check PASS "unit 08 lab absence" "$LAB08_DIR is absent while Unit 08 is pending generation"
    fi
  fi

  if contains "$STATE_FILE" "| \`project/advanced-labs-register.md\` | Versionado"; then
    if tracked_by_git "$ADVANCED_LABS_REGISTER"; then
      check PASS "advanced labs register" "$ADVANCED_LABS_REGISTER is tracked by Git"
    else
      check FAIL "advanced labs register" "$STATE_FILE says $ADVANCED_LABS_REGISTER is versioned but Git is not tracking it"
    fi
  fi
fi

echo
echo "Governance validation summary: $failures failure(s), $warnings warning(s)."

if [ "$failures" -gt 0 ]; then
  exit 1
fi
