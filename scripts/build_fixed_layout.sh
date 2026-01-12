#!/usr/bin/env bash
set -euo pipefail

# Guide for fixed-layout (illustrated) book exports.
# Usage: scripts/build_fixed_layout.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMAT_CONFIG="${ROOT_DIR}/config/book_format.env"
BOOK_FORMAT="reflowable"

if [[ -f "${FORMAT_CONFIG}" ]]; then
  # shellcheck disable=SC1090
  source "${FORMAT_CONFIG}"
fi

if [[ "${BOOK_FORMAT}" != "fixed" ]]; then
  cat <<'EOF' >&2
Warning: BOOK_FORMAT is not set to "fixed".
Set BOOK_FORMAT=fixed in config/book_format.env for fixed-layout workflows.
EOF
fi

cat <<'EOF'
Fixed-layout export checklist:
1. Assemble page spreads or single pages in your layout tool (InDesign, Affinity,
   Canva, etc.). Use 300 DPI assets and confirm trim size + bleed.
2. Export a print-ready PDF for paperback/hardcover uploads.
3. Build a KPF using Kindle Create or Kindle Kids' Book Creator for Kindle.
4. Validate in Kindle Previewer and adjust any page order, bleed, or image issues.
EOF
