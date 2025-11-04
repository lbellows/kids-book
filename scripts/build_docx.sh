#!/usr/bin/env bash
set -euo pipefail

# Build a print-ready DOCX file from the manuscript using Pandoc.
# Usage: scripts/build_docx.sh [--output <filename>]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANUSCRIPT_DIR="${ROOT_DIR}/manuscript"
OUTPUT_DIR="${ROOT_DIR}/output"
METADATA_FILE="${MANUSCRIPT_DIR}/metadata.yaml"
CHAPTER_DIR="${MANUSCRIPT_DIR}/chapters"
DEFAULT_OUTPUT="kids-book-sample.docx"

output_name="${DEFAULT_OUTPUT}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      shift
      output_name="${1:-}"
      if [[ -z "${output_name}" ]]; then
        echo "Error: --output requires a filename." >&2
        exit 1
      fi
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
  shift || true
done

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is not installed or not on PATH." >&2
  echo "Install pandoc (https://pandoc.org/installing.html) and try again." >&2
  exit 1
fi

if [[ ! -f "${METADATA_FILE}" ]]; then
  echo "Error: metadata file not found at ${METADATA_FILE}." >&2
  exit 1
fi

mapfile -t chapters < <(find "${CHAPTER_DIR}" -maxdepth 1 -type f -name '*.md' | sort)
if [[ ${#chapters[@]} -eq 0 ]]; then
  echo "Error: no chapter files found in ${CHAPTER_DIR}." >&2
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"

pandoc \
  --from=markdown+smart \
  --metadata-file="${METADATA_FILE}" \
  --output="${OUTPUT_DIR}/${output_name}" \
  "${chapters[@]}"

echo "DOCX created at ${OUTPUT_DIR}/${output_name}"
