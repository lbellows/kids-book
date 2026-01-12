# Kids Book Publishing Starter

This repository gives you a lightweight workflow for drafting a children's
book, exporting it to Kindle Direct Publishing (KDP) formats, and preparing
for final upload to Amazon. It includes:

- A manuscript workspace organized for long-form writing.
- Pandoc-based build scripts that create EPUB (ebook) and DOCX (print)
  deliverables Amazon KDP accepts.
- Example content to demonstrate structure and formatting.
- Documentation that walks through final publishing checks and the KDP
  submission process.

## Repository layout

```
manuscript/
  metadata.yaml   # Book-level metadata consumed by the build scripts
  chapters/       # Markdown chapters/sections in reading order
  cover.png       # (Optional) KDP-compliant cover image placed here
config/
  book_format.env # Select reflowable vs fixed-layout workflows
  publishing.env.example # Template for CLI/API publishing credentials
scripts/
  build_ebook.sh  # Generates an EPUB suitable for Kindle upload
  build_docx.sh   # Generates a DOCX manuscript for print/paperback
  build_fixed_layout.sh # Guidance for fixed-layout (illustrated) exports
  validate_manuscript.sh # Validates metadata + chapter structure
  scaffold_book.sh # Scaffolds prompt + manuscript stubs
  publish_cli.sh  # Orchestrates scripted exports + API hand-off
styles/
  ebook.css       # Minimal typography overrides for the EPUB build
output/           # Build artifacts are written here
prompts/
  book_prompt_template.md # Prompt scaffold for book generation
```

## Prerequisites

- [Pandoc](https://pandoc.org/) 2.10 or newer must be installed and on your PATH.
- (Optional) A KDP-ready cover image saved as `manuscript/cover.png`.
  - Recommended size: 2560 x 1600px for eBooks (or follow Amazon's latest
    specs).

## Writing workflow

1. Duplicate `manuscript/chapters/01-starbright.md` and use it as a template
   for additional chapters or sections.
2. Update `manuscript/metadata.yaml` with your author name, title, and other
   metadata KDP expects.
3. Save illustration notes or asset references inline in Markdown or in a
   dedicated folder (for example, `assets/`).

## Building formats

Generate an EPUB (recommended for Kindle eBooks):

```bash
scripts/build_ebook.sh
```

- Outputs `output/kids-book-sample.epub`.
- Use `--output my-title.epub` to customize the file name.
- Add `--no-cover` if you have not prepared a cover yet.

Generate a DOCX (accepted for paperback manuscript uploads):

```bash
scripts/build_docx.sh
```

- Outputs `output/kids-book-sample.docx`.
- Use `--output my-title.docx` to customize the file name.

Both scripts will surface actionable errors if something is missing (Pandoc
not installed, chapters absent, metadata incomplete, etc.).

Note: Set `BOOK_FORMAT` in `config/book_format.env` to choose between a
reflowable workflow (EPUB/DOCX) and fixed-layout guidance (KPF + PDF). See
`docs/publishing.md` for details.

## Next steps

Head to `docs/publishing.md` for detailed guidance on polishing your files,
packaging front/back matter, checking accessibility, and completing the KDP
upload and launch steps. That guide covers both manual dashboard publishing
and how to integrate `scripts/publish_cli.sh` with the KDP Publishing API (if
you have access).

For prompt-driven generation, start with `prompts/book_prompt_template.md`
and scaffold via `scripts/scaffold_book.sh`, then validate the output via
`scripts/validate_manuscript.sh`.

Use `scripts/scaffold_book.sh --clean` to remove scaffolded placeholder files
that still contain the scaffold marker.

1. Install Pandoc locally, run scripts/build_ebook.sh and scripts/build_docx.sh, then preview the files in Kindle Previewer/Word.
2. Replace manuscript/cover.png with your final cover art and rerun the EPUB build.
3. Follow docs/publishing.md to complete metadata checks and upload the files to KDP.
