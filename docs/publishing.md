# Amazon KDP Publishing Guide

Use this checklist after you finish writing and editing the manuscript. It
covers technical exports, quality checks, and the KDP submission flow.

## 1. Prepare your manuscript

- **Finalize content**: Proofread the Markdown chapters in `manuscript/chapters`
  and ensure headings follow a logical hierarchy (`#` for title page, `##`
  for chapters, etc.).
- **Update metadata**: Edit `manuscript/metadata.yaml` so it reflects your
  final title, subtitle, author name(s), description, and rights statement.
- **Front/back matter**: Add dedication, copyright, acknowledgements, and
  About the Author sections as separate Markdown files if desired. Place them
  in `manuscript/chapters/` with numeric prefixes so they render in the correct
  order (for example, `00-dedication.md`, `99-about-the-author.md`).
- **Illustrations**: If you have artwork, embed references (for print) or add
  `<img>` tags with alt text in the Markdown for the EPUB build. Store assets
  under a new folder (e.g., `assets/illustrations/`) and update paths.

## 2. Build deliverables

1. **eBook**: Run `scripts/build_ebook.sh --output <your-title>.epub`.
   - Confirm the console reports `EPUB created at ...`.
   - Open the file in Kindle Previewer (free from Amazon) to review layout,
     table of contents, and navigation.
2. **Paperback (optional)**: Run `scripts/build_docx.sh --output <your-title>.docx`.
   - Review the DOCX in Microsoft Word or LibreOffice Writer.
   - Set page size, margins, and fonts according to KDP paperback guidelines.

## 3. Validate files

- **Spell check & grammar**: Use your editor or tools such as Grammarly or
  ProWritingAid on the DOCX export.
- **Accessibility**: Ensure images have descriptive alt text. Confirm headings
  are sequential (no jumping from `##` to `####`).
- **Metadata audit**: In Kindle Previewer, check the title/author data matches
  your KDP dashboard entries.
- **Cover**: Provide a high-resolution cover image.
  - For eBooks, export a single front cover (`manuscript/cover.png`).
  - For paperbacks, use Amazon's [Cover Creator](https://kdp.amazon.com/en_US/cover-templates)
    or upload a PDF wraparound file matching trim size + bleed.

## 4. KDP upload options

### Manual dashboard flow

1. Sign in to [kdp.amazon.com](https://kdp.amazon.com/).
2. Click **Create** → **Kindle eBook** (and/or **Paperback**).
3. **Kindle eBook Details**:
   - Language, book title, subtitle, and series info.
   - Enter contributors, description, publishing rights, and keywords.
   - Choose categories and age/grade range for children's books.
4. **Kindle eBook Content**:
   - Enable DRM if desired.
   - Upload the EPUB created by `build_ebook.sh`.
   - Upload your cover (PNG/JPG). Use the previewer to review every page.
5. **Kindle eBook Pricing**:
   - Select territories.
  - Set pricing and royalty option (35% or 70%).
6. For **Paperback**:
   - Repeat the details tab.
   - Upload the DOCX (or a print-ready PDF) and your paperback cover PDF.
   - Approve the digital preview.
   - Order a proof copy if you want a physical check.
7. Submit your book for publication. Amazon will review and usually respond
   within 72 hours.

### CLI/API automation (optional)

If you have access to the KDP Publishing API (currently invite-only) or a
third-party CLI that wraps it, use the scaffolded script in this repository:

1. Populate `config/publishing.env` with your credentials:
   - `AMAZON_KDP_ACCESS_KEY`, `AMAZON_KDP_SECRET_KEY`
   - `KDP_PROFILE_NAME`, `KDP_REGION`
2. Run the automated build and validation pipeline:

   ```bash
   scripts/publish_cli.sh --title-slug my-book-title
   ```

   - The script sources your secrets, rebuilds the EPUB and DOCX, and prints the
     file paths that need to be uploaded.
   - Use `--skip-ebook` or `--skip-docx` to limit the build.
3. Integrate with your chosen HTTP client or SDK to call the KDP Publishing API:
   - Upload ebook and paperback assets (`UploadAsset`).
   - Create/update a book resource and submit for publishing (`SubmitPublish`).
   - The script prints a `curl` skeleton demonstrating AWS SigV4 signing; update
     the `{api-gateway-id}` placeholder with your API endpoint.
4. Record the submission ID returned by the API so you can track status or
   rerun the workflow.

> Tip: Keep `config/publishing.env` out of source control (already gitignored)
> and use a secrets manager (AWS Secrets Manager, 1Password, etc.) for shared
> environments.

## 5. Launch preparation

- Prepare marketing copy and a launch date.
- Set up your Author Central profile.
- Collect early readers for reviews.
- Share progress updates on social media or a mailing list.

## 6. Maintenance and versioning

- Use git tags or branches to mark major manuscript versions.
- Keep a changelog (e.g., `docs/changelog.md`) tracking edits post-release.
- If you update the book, rebuild the EPUB/DOCX and re-upload to KDP; Amazon
  will prompt you to republish the new version.

With this workflow you can focus on writing while the scripts handle the
export formatting Amazon expects. Customize the repository to match your
creative process, and happy publishing!
