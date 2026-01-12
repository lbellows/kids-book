#!/usr/bin/env bash
set -euo pipefail

# Scaffold manuscript structure and a prompt file for generation.
# Usage: scripts/scaffold_book.sh [--chapters <count>] [--force]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANUSCRIPT_DIR="${ROOT_DIR}/manuscript"
CHAPTER_DIR="${MANUSCRIPT_DIR}/chapters"
METADATA_FILE="${MANUSCRIPT_DIR}/metadata.yaml"
PROMPT_TEMPLATE="${ROOT_DIR}/prompts/book_prompt_template.md"
PROMPT_FILLED="${ROOT_DIR}/prompts/book_prompt_filled.md"
MANIFEST_FILE="${ROOT_DIR}/.scaffold_manifest"
SCAFFOLD_MARKER="scaffolded: scripts/scaffold_book.sh"

chapter_count=3
force=false
clean=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --chapters)
      shift
      chapter_count="${1:-}"
      if [[ -z "${chapter_count}" || ! "${chapter_count}" =~ ^[0-9]+$ ]]; then
        echo "Error: --chapters requires a numeric count." >&2
        exit 1
      fi
      ;;
    --force)
      force=true
      ;;
    --clean)
      clean=true
      ;;
    -h|--help)
      echo "Usage: scripts/scaffold_book.sh [--chapters <count>] [--force] [--clean]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
  shift || true
done

mkdir -p "${CHAPTER_DIR}" "${ROOT_DIR}/prompts"

if [[ "${clean}" == true ]]; then
  if [[ ! -f "${MANIFEST_FILE}" ]]; then
    echo "No scaffold manifest found at ${MANIFEST_FILE}." >&2
    exit 0
  fi
  while IFS= read -r entry; do
    if [[ -z "${entry}" ]]; then
      continue
    fi
    if [[ -f "${entry}" ]]; then
      if grep -q "${SCAFFOLD_MARKER}" "${entry}"; then
        rm -f "${entry}"
        echo "Removed ${entry}"
      else
        echo "Skipped (marker missing): ${entry}" >&2
      fi
    fi
  done < "${MANIFEST_FILE}"
  rm -f "${MANIFEST_FILE}"
  echo "Scaffold cleanup complete."
  exit 0
fi

manifest_entries=()

if [[ -f "${PROMPT_TEMPLATE}" ]]; then
  if [[ ! -f "${PROMPT_FILLED}" || "${force}" == true ]]; then
    {
      echo "<!-- ${SCAFFOLD_MARKER} -->"
      cat "${PROMPT_TEMPLATE}"
    } > "${PROMPT_FILLED}"
  fi
  if grep -q "${SCAFFOLD_MARKER}" "${PROMPT_FILLED}"; then
    manifest_entries+=("${PROMPT_FILLED}")
  fi
fi

if [[ ! -f "${METADATA_FILE}" || "${force}" == true ]]; then
  cat <<'EOF' > "${METADATA_FILE}"
---
# scaffolded: scripts/scaffold_book.sh
title: "Working Title"
creator:
  - role: author
    text: "Author Name"
language: en-US
publisher: "Self-Published"
rights: "Copyright © 2024 Author Name"
description: |
  Short description of the book.
subjects:
  - "Children's Fiction"
  - "Adventure"
---
EOF
fi
if grep -q "${SCAFFOLD_MARKER}" "${METADATA_FILE}"; then
  manifest_entries+=("${METADATA_FILE}")
fi

front_matter="${CHAPTER_DIR}/00-front-matter.md"
if [[ ! -f "${front_matter}" || "${force}" == true ]]; then
  cat <<'EOF' > "${front_matter}"
<!-- scaffolded: scripts/scaffold_book.sh -->
# Title Page

Working Title

Author Name
EOF
fi
if grep -q "${SCAFFOLD_MARKER}" "${front_matter}"; then
  manifest_entries+=("${front_matter}")
fi

for ((i=1; i<=chapter_count; i++)); do
  chapter_num="$(printf "%02d" "${i}")"
  chapter_file="${CHAPTER_DIR}/${chapter_num}-chapter-${i}.md"
  if [[ ! -f "${chapter_file}" || "${force}" == true ]]; then
    cat <<EOF > "${chapter_file}"
<!-- ${SCAFFOLD_MARKER} -->
## Chapter ${i}

<Chapter ${i} opening paragraph.>

[Illustration: ...]
EOF
  fi
  if grep -q "${SCAFFOLD_MARKER}" "${chapter_file}"; then
    manifest_entries+=("${chapter_file}")
  fi
done

back_matter="${CHAPTER_DIR}/99-back-matter.md"
if [[ ! -f "${back_matter}" || "${force}" == true ]]; then
  cat <<'EOF' > "${back_matter}"
<!-- scaffolded: scripts/scaffold_book.sh -->
# About the Author

Short author bio.
EOF
fi
if grep -q "${SCAFFOLD_MARKER}" "${back_matter}"; then
  manifest_entries+=("${back_matter}")
fi

if [[ ${#manifest_entries[@]} -gt 0 ]]; then
  printf "%s\n" "${manifest_entries[@]}" > "${MANIFEST_FILE}"
fi

echo "Scaffold complete."
