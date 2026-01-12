# AGENTS.md

Repository intent: draft and publish a children's book for Amazon KDP.

Key paths:
- `config/book_format.env` to select reflowable vs fixed-layout workflow.
- `config/publishing.env.example` as the template for KDP API credentials.
- `manuscript/metadata.yaml` for book metadata.
- `manuscript/chapters/` for chapter/section Markdown files (numeric prefixes).
- `docs/old-but-valid-publishing.md` for the publishing checklist and format guidance.
- `prompts/book_prompt_template.md` for prompt-driven generation.
- `scripts/build_ebook.sh` and `scripts/build_docx.sh` for Pandoc exports.
- `scripts/build_fixed_layout.sh` for fixed-layout export guidance.
- `scripts/validate_manuscript.sh` to validate metadata + chapter structure.
- `scripts/scaffold_book.sh` to scaffold prompt + manuscript stubs.
- `scripts/publish_cli.sh` for optional KDP API handoff (invite-only).
- `output/` for build artifacts (generated).

Build commands:
- `scripts/build_ebook.sh --output <title>.epub`
- `scripts/build_docx.sh --output <title>.docx`

Notes:
- This repo uses a lightweight Markdown + Pandoc flow; image-heavy picture
  books may require a fixed-layout KPF and print-ready PDF workflow (see
  `docs/old-but-valid-publishing.md`).
- Avoid editing `output/` directly; regenerate via scripts instead.
- Content details are intentionally light right now; expect future prompts to
  generate a full manuscript and illustrations.
