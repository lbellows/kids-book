# Development and Publishing Plan

This plan focuses on workflow readiness, automation hooks, and decision points
for producing and publishing a children's book through KDP.

## 1. Scope and format decisions

- Choose format workflow via `config/book_format.env`:
  - `BOOK_FORMAT=reflowable` for text-forward books (EPUB + DOCX).
  - `BOOK_FORMAT=fixed` for illustrated books (KPF + print-ready PDF).
- Lock target trim size, bleed, and color settings early for print layout.
- Establish minimum illustration and asset requirements (count, size, DPI).

## 2. Manuscript production workflow

- Maintain chapter/section order in `manuscript/chapters/` using numeric prefixes.
- Keep metadata current in `manuscript/metadata.yaml`.
- Track illustration notes inline or in a dedicated `assets/` folder.

## 3. Build and validation

- Reflowable:
  - Run `scripts/build_ebook.sh` and `scripts/build_docx.sh`.
  - Review EPUB in Kindle Previewer and DOCX in Word/LibreOffice.
- Fixed layout:
  - Use `scripts/build_fixed_layout.sh` as the checklist.
  - Build KPF (Kindle Create/Kids' Book Creator) and print-ready PDF.
  - Validate layout, bleed, and image quality in Previewer.

## 4. Pre-publish checklist

- Verify metadata consistency between `metadata.yaml` and KDP dashboard.
- Confirm front/back matter order and content.
- Ensure all images have alt text and 300 DPI for print.
- Finalize cover assets (front for ebook; wraparound PDF for print).

## 5. Publishing steps

- Manual KDP dashboard upload is the default path for both formats.
- Optional: use `scripts/publish_cli.sh` for reflowable artifacts and a CLI/API
  handoff if you have KDP API access.
- Record submission IDs, pricing, and categories used for future updates.

## 6. Launch and maintenance

- Collect early reviews and update marketing copy as needed.
- Tag manuscript versions in git for each KDP submission.
- For revisions, rebuild assets and resubmit through KDP.

## 7. Future automation (prompt-to-book)

- Define a prompt template that maps story structure, character list, and
  illustration slots to Markdown outputs.
- Use `prompts/book_prompt_template.md` as the starting prompt for generation.
- Use `scripts/scaffold_book.sh` to create chapter stubs and metadata.
- Run `scripts/validate_manuscript.sh` to validate structure before builds.
- Maintain a metadata checklist to keep book info in sync with KDP.
