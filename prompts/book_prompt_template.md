# Prompt-to-Book Template

Use this prompt to generate a full manuscript with metadata and chapter files
that match this repository's structure.

## Project summary
- Working title:
- Audience age range:
- Reading level:
- Approximate word count:
- Tone (e.g., playful, gentle, adventurous):
- Series info (if any):

## Story constraints
- Setting and time period:
- Main characters (name, role, short description):
- Core theme or lesson:
- Must-include scenes or beats:
- Avoided topics or sensitive areas:

## Visual/illustration notes (optional)
- Number of illustrations:
- Full-bleed vs spot art:
- Key illustration moments:

## Output requirements
- Output a `manuscript/metadata.yaml` block using:
  - title, creator (author), language, publisher, rights, description, subjects
- Output chapters as Markdown with numeric prefixes:
  - `manuscript/chapters/00-front-matter.md`
  - `manuscript/chapters/01-...`
  - `manuscript/chapters/99-back-matter.md`
- Keep headings consistent (`#` for title page, `##` for chapter titles).
- Use short paragraphs and line breaks suitable for read-aloud pacing.
- Include inline illustration callouts in brackets, e.g. `[Illustration: ...]`.

## Compliance notes
- Avoid trademarks, brand names, or copyrighted character references.
- Use original character names and settings.
- Keep language appropriate for the target age range.
