#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANUSCRIPT_DIR="${ROOT_DIR}/manuscript"
METADATA_FILE="${MANUSCRIPT_DIR}/metadata.yaml"
CHAPTER_DIR="${MANUSCRIPT_DIR}/chapters"

error_count=0
search_cmd=""
search_args=()

if command -v rg >/dev/null 2>&1; then
  search_cmd="rg"
  search_args=(-q)
else
  search_cmd="grep"
  search_args=(-Eq)
fi

fail() {
  echo "Error: $1" >&2
  error_count=$((error_count + 1))
}

warn() {
  echo "Warning: $1" >&2
}

if [[ ! -f "${METADATA_FILE}" ]]; then
  fail "metadata file not found at ${METADATA_FILE}."
else
  for key in title creator language publisher rights description subjects; do
    if ! "${search_cmd}" "${search_args[@]}" "^${key}:" "${METADATA_FILE}"; then
      fail "missing required metadata key: ${key}"
    fi
  done
  if ! "${search_cmd}" "${search_args[@]}" "role:\\s*author" "${METADATA_FILE}"; then
    warn "metadata creator role 'author' not found."
  fi
  if ! "${search_cmd}" "${search_args[@]}" "text:\\s*\"?.+\"?" "${METADATA_FILE}"; then
    warn "metadata creator text field looks empty."
  fi
fi

if [[ ! -d "${CHAPTER_DIR}" ]]; then
  fail "chapters directory not found at ${CHAPTER_DIR}."
else
  mapfile -t chapters < <(find "${CHAPTER_DIR}" -maxdepth 1 -type f -name '*.md' | sort)
  if [[ ${#chapters[@]} -eq 0 ]]; then
    fail "no chapter files found in ${CHAPTER_DIR}."
  fi
  for chapter in "${chapters[@]}"; do
    base="$(basename "${chapter}")"
    if [[ ! "${base}" =~ ^[0-9]{2}-.*\.md$ ]]; then
      warn "chapter file should use numeric prefix: ${base}"
    fi
  done
fi

if [[ ${error_count} -gt 0 ]]; then
  echo "Validation failed with ${error_count} error(s)." >&2
  exit 1
fi

echo "Manuscript validation passed."
