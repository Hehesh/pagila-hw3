#!/usr/bin/env bash
# Run from the root of a pagila-hw3 worktree.
set -euo pipefail

MAX_ROUNDS="${MAX_ROUNDS:-25}"
DIFF_LINES="${DIFF_LINES:-35}"
MODEL_ARGS=("$@")

command -v dic >/dev/null || { echo 'dic is required' >&2; exit 1; }
command -v files-to-prompt >/dev/null || { echo 'files-to-prompt is required' >&2; exit 1; }
command -v docker >/dev/null || { echo 'docker is required' >&2; exit 1; }
[[ -d sql && -d expected && -x ./run_tests.sh ]] || {
  echo 'Run from pagila-hw3 root with sql/, expected/, and run_tests.sh.' >&2; exit 1;
}
[[ $(git -C pagila rev-parse --short=8 HEAD) == e1e5a855 ]] || {
  echo 'Wrong Pagila dataset: pin submodule to e1e5a855 before running.' >&2; exit 1;
}
[[ -z $(git status --porcelain) ]] || {
  echo 'Start from a clean git worktree. Check results/ and any untracked files.' >&2; exit 1;
}

# The schema is the ONLY database information used in prompts initially.
# This file is outside the project tree, so it is not accidentally committed.
SCHEMA_FILE="$(mktemp)"
TEST_LOG="$(mktemp)"
trap 'rm -f "$SCHEMA_FILE" "$TEST_LOG"' EXIT

docker compose exec -T pg psql -X -P pager=off -c '\d+ *' > "$SCHEMA_FILE"
[[ -s "$SCHEMA_FILE" ]] || { echo 'Empty database schema' >&2; exit 1; }

# Initialize dic functions in this script's shell.
eval "$(dic --init)" 2>/dev/null
command -v committe >/dev/null || { echo 'committe is unavailable after dic init' >&2; exit 1; }

base_instructions='Complete the Pagila SQL problems using only the database schema and question text provided. Edit only sql/*.sql. Never edit expected/, results/, run_tests.sh, pagila/, or the database schema. Do not inspect expected files, raw database rows, or other repository files. Maintain valid PostgreSQL SQL. The local harness will run tests and provide bounded feedback later.'

# Intentionally NO tests or expected outputs are supplied on this initial call.
committe "${MODEL_ARGS[@]}" <<PROMPT
$base_instructions

DATABASE SCHEMA:
$(cat "$SCHEMA_FILE")

SQL QUESTIONS:
$(files-to-prompt sql/)

Implement an initial solution for each question. Do not run tests yourself.
PROMPT

# One pass of tests per iteration; only a single failure becomes prompt context.
# Requires the repository's existing psql connection to be configured.
for ((round=1; round<=MAX_ROUNDS; round++)); do
  echo "=== Ralph test round $round/$MAX_ROUNDS ==="
  if ./run_tests.sh > "$TEST_LOG" 2>&1; then
    echo 'All tests pass. Review the SQL and git history before submitting.'
    exit 0
  fi

  failure=''
  for problem in sql/*.sql; do
    id="$(basename "${problem%.sql}")"
    expected="expected/$id.out"
    actual="results/$id.out"
    if [[ ! -f "$expected" || ! -f "$actual" ]]; then
      failure="$id"
      break
    fi
    if ! diff -B -q "$expected" "$actual" >/dev/null; then
      failure="$id"
      break
    fi
  done

  if [[ -z "$failure" ]]; then
    echo 'Tests failed but no mismatching output was found. Check psql configuration and run_tests.sh.' >&2
    sed -n '1,12p' "$TEST_LOG" >&2
    exit 2
  fi

  expected="expected/$failure.out"
  actual="results/$failure.out"
  if [[ -f "$expected" && -f "$actual" ]]; then
    feedback="$(diff -B -U 1 "$expected" "$actual" | head -n "$DIFF_LINES" | cut -c 1-180 || true)"
  else
    feedback='The expected or actual output file is missing; inspect the SQL syntax and local test setup.'
  fi

  echo "First failing problem: $failure"
  committe "${MODEL_ARGS[@]}" <<PROMPT
$base_instructions

DATABASE SCHEMA:
$(cat "$SCHEMA_FILE")

ONE FAILING PROBLEM: $failure
$(files-to-prompt "sql/$failure.sql")

BOUNDED TEST FEEDBACK (unified diff: - means expected, + means actual):
$feedback

Fix this problem using schema reasoning, without inspecting expected/ or results/ directly. Only edit sql/$failure.sql. Do not run tests yourself.
PROMPT
done

echo "Stopped at MAX_ROUNDS=$MAX_ROUNDS without all tests passing." >&2
exit 1
