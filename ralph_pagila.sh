#!/usr/bin/env bash
# Run from the pagila-hw3 repository root. Requires dic, files-to-prompt, Docker.
set -euo pipefail
MAX_ROUNDS="${MAX_ROUNDS:-25}"
MAX_STUCK="${MAX_STUCK:-3}"
DIFF_LINES="${DIFF_LINES:-18}"
QUESTIONS_REF="${QUESTIONS_REF:-origin/master}"  # unchanged assignment templates
MODEL_ARGS=("$@")

for tool in git docker dic; do command -v "$tool" >/dev/null || { echo "Missing: $tool" >&2; exit 1; }; done
[[ -d sql && -d expected && -x ./run_tests.sh ]] || { echo 'Run from pagila-hw3 root.' >&2; exit 1; }
[[ $(git -C pagila rev-parse --short=8 HEAD) == e1e5a855 ]] || { echo 'Pin pagila submodule to e1e5a855.' >&2; exit 1; }
[[ -z $(git status --porcelain) ]] || { echo 'Commit or stash changes before starting.' >&2; exit 1; }

# Verify original assignment descriptions are available before doing any work.
for file in sql/*.sql; do
  if ! git cat-file -e "$QUESTIONS_REF:$file" 2>/dev/null; then
    echo "Cannot find $file in $QUESTIONS_REF; set QUESTIONS_REF to a pre-Ralph commit containing the questions." >&2
    exit 1
  fi
done

schema=$(mktemp)
log=$(mktemp)
trap 'rm -f "$schema" "$log"' EXIT
docker compose exec -T pg psql -X -P pager=off -c '\d+ *' > "$schema"
[[ -s $schema ]] || { echo 'No schema returned.' >&2; exit 1; }

eval "$(dic --init)" 2>/dev/null
command -v committe >/dev/null || { echo 'Cannot initialize committe.' >&2; exit 1; }

# Pull ONLY initial SQL comment blocks from original, pinned Git objects.
question() {
  git show "$QUESTIONS_REF:sql/$1.sql" | sed -n '1,/\*\//p'
}

instructions='Solve the Pagila homework using the provided schema and original problem descriptions. Only edit SQL solution code under sql/*.sql. Keep the existing problem-description comment blocks intact. Never inspect expected/, results/, raw database rows, or the database contents. Do not hardcode output values. Do not run tests yourself. The harness runs tests and supplies limited diagnostic feedback.'

# Initial generation gets schema + original problem statements, but no expected outputs.
questions=''
for file in sql/*.sql; do
  id=${file#sql/}; id=${id%.sql}
  questions+=$'\n\n'"PROBLEM $id:"$'\n'"$(question "$id")"
done

committe "${MODEL_ARGS[@]}" <<PROMPT
$instructions

DATABASE SCHEMA:
$(cat "$schema")

ORIGINAL QUESTIONS (from $QUESTIONS_REF, not edited working files):
$questions

Implement solutions. Do not remove or alter question comments.
PROMPT

last_failure=''
stuck=0
for ((round=1; round<=MAX_ROUNDS; round++)); do
  echo "=== Ralph test round $round/$MAX_ROUNDS ==="
  if ./run_tests.sh > "$log" 2>&1; then
    echo 'All tests pass. Review SQL and Git history before submission.'
    exit 0
  fi
  failure=''
  for file in sql/*.sql; do
    id=${file#sql/}; id=${id%.sql}
    if [[ ! -f "expected/$id.out" || ! -f "results/$id.out" ]] || ! diff -B -q "expected/$id.out" "results/$id.out" >/dev/null; then
      failure=$id; break
    fi
  done
  if [[ -z $failure ]]; then
    echo 'Test runner failed without an identified SQL mismatch:' >&2
    head -n 12 "$log" >&2
    exit 2
  fi
  if [[ $failure == "$last_failure" ]]; then ((stuck+=1)); else stuck=1; last_failure=$failure; fi
  echo "First failing problem: $failure (consecutive failures: $stuck)"
  if ((stuck >= MAX_STUCK)); then
    echo "Stopped: problem $failure has failed $stuck consecutive rounds. Review schema, original question, SQL, and local test diagnostics manually." >&2
    exit 3
  fi
  expected="expected/$failure.out"
  actual="results/$failure.out"
  if [[ -f $expected && -f $actual ]]; then
    feedback=$(diff -B -U 1 "$expected" "$actual" | head -n "$DIFF_LINES" | cut -c 1-160 || true)
  else
    feedback='Missing expected or actual file; inspect test setup.'
  fi
  committe "${MODEL_ARGS[@]}" <<PROMPT
$instructions

DATABASE SCHEMA:
$(cat "$schema")

ORIGINAL PROBLEM $failure:
$(question "$failure")

CURRENT SQL:
$(cat "sql/$failure.sql")

BOUNDED TEST DIFF (- expected, + actual; $DIFF_LINES lines maximum):
$feedback

Fix only sql/$failure.sql, preserving the original problem-description comment block.
PROMPT
done
echo "Stopped: MAX_ROUNDS=$MAX_ROUNDS." >&2
exit 1
