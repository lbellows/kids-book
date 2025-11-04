#!/usr/bin/env bash
set -euo pipefail

# Build an EPUB file from the manuscript using Pandoc.
# Usage: scripts/build_ebook.sh [--output <filename>] [--no-cover]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANUSCRIPT_DIR="${ROOT_DIR}/manuscript"
OUTPUT_DIR="${ROOT_DIR}/output"
METADATA_FILE="${MANUSCRIPT_DIR}/metadata.yaml"
CHAPTER_DIR="${MANUSCRIPT_DIR}/chapters"
DEFAULT_OUTPUT="kids-book-sample.epub"
COVER_IMAGE="${MANUSCRIPT_DIR}/cover.png"

output_name="${DEFAULT_OUTPUT}"
use_cover=true

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
    --no-cover)
      use_cover=false
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

pandoc_args=(
  --from=markdown+smart
  --toc
  --css="${ROOT_DIR}/styles/ebook.css"
  --metadata-file="${METADATA_FILE}"
  --output="${OUTPUT_DIR}/${output_name}"
)

if [[ -d "${ROOT_DIR}/styles" && -f "${ROOT_DIR}/styles/ebook.css" ]]; then
  :
else
  pandoc_args=("${pandoc_args[@]/--css=*}")
fi

if [[ "${use_cover}" == true ]]; then
  if [[ -f "${COVER_IMAGE}" ]]; then
    pandoc_args+=("--epub-cover-image=${COVER_IMAGE}")
  else
    echo "Warning: cover image not found at ${COVER_IMAGE}. Use --no-cover to skip." >&2
  fi
fi

pandoc "${pandoc_args[@]}" "${chapters[@]}"

echo "EPUB created at ${OUTPUT_DIR}/${output_name}"
