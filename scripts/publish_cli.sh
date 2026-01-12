#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${ROOT_DIR}/config/publishing.env"
FORMAT_CONFIG="${ROOT_DIR}/config/book_format.env"
OUTPUT_DIR="${ROOT_DIR}/output"
DEFAULT_TITLE_SLUG="kids-book-sample"
EPUB_NAME="${DEFAULT_TITLE_SLUG}.epub"
DOCX_NAME="${DEFAULT_TITLE_SLUG}.docx"
BUILD_EBOOK_SCRIPT="${ROOT_DIR}/scripts/build_ebook.sh"
BUILD_DOCX_SCRIPT="${ROOT_DIR}/scripts/build_docx.sh"
BOOK_FORMAT="reflowable"

if [[ -f "${FORMAT_CONFIG}" ]]; then
  # shellcheck disable=SC1090
  source "${FORMAT_CONFIG}"
fi

usage() {
  cat <<'USAGE'
Usage: scripts/publish_cli.sh [--title-slug <slug>] [--skip-docx] [--skip-ebook]

Options:
  --title-slug  Base filename (no extension) used for export artifacts.
  --skip-docx   Do not rebuild the DOCX deliverable.
  --skip-ebook  Do not rebuild the EPUB deliverable.
USAGE
}

title_slug="${DEFAULT_TITLE_SLUG}"
run_docx=true
run_epub=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title-slug)
      shift
      title_slug="${1:-}"
      if [[ -z "${title_slug}" ]]; then
        echo "Error: --title-slug requires a non-empty value." >&2
        exit 1
      fi
      ;;
    --skip-docx)
      run_docx=false
      ;;
    --skip-ebook)
      run_epub=false
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift || true
done

if [[ ! -f "${CONFIG_FILE}" ]]; then
  cat <<EOF >&2
Error: publishing config not found at ${CONFIG_FILE}.
Create this file by copying ${ROOT_DIR}/config/publishing.env.example and add your KDP API credentials.
EOF
  exit 1
fi

# shellcheck disable=SC1090
source "${CONFIG_FILE}"

missing_vars=()
for required_var in AMAZON_KDP_ACCESS_KEY AMAZON_KDP_SECRET_KEY KDP_PROFILE_NAME KDP_REGION; do
  if [[ -z "${!required_var:-}" ]]; then
    missing_vars+=("$required_var")
  fi
done

if [[ ${#missing_vars[@]} -gt 0 ]]; then
  printf 'Error: missing required variables in %s: %s\n' "${CONFIG_FILE}" "${missing_vars[*]}" >&2
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"

if [[ "${run_epub}" == true ]]; then
  "${BUILD_EBOOK_SCRIPT}" --output "${title_slug}.epub"
  EPUB_NAME="${title_slug}.epub"
fi

if [[ "${run_docx}" == true ]]; then
  "${BUILD_DOCX_SCRIPT}" --output "${title_slug}.docx"
  DOCX_NAME="${title_slug}.docx"
fi

if [[ "${BOOK_FORMAT}" == "fixed" ]]; then
  cat <<'EOF' >&2
Note: BOOK_FORMAT=fixed is set. The CLI helper only builds reflowable outputs.
For fixed layout, export a KPF (Kindle Create/Kids' Book Creator) and a
print-ready PDF, then upload those assets in KDP.
EOF
fi

cat <<EOF
Artifacts ready under ${OUTPUT_DIR}:
  - ${OUTPUT_DIR}/${EPUB_NAME}
  - ${OUTPUT_DIR}/${DOCX_NAME}

Next steps for CLI/API publishing:
  1. Export your credentials as environment variables (already sourced).
  2. Use your preferred HTTP client or SDK to call the KDP Publishing API's
     UploadAsset and SubmitPublish operations. Placeholder command:
        curl -X POST \\
          --aws-sigv4 "aws:amz:${KDP_REGION}:execute-api" \\
          --user "${AMAZON_KDP_ACCESS_KEY}:${AMAZON_KDP_SECRET_KEY}" \\
          --data-binary @${OUTPUT_DIR}/${EPUB_NAME} \\
          https://{api-gateway-id}.execute-api.${KDP_REGION}.amazonaws.com/production/assets
  3. Repeat for the paperback asset if applicable.

Refer to docs/old-but-valid-publishing.md for full instructions and API references.
EOF
