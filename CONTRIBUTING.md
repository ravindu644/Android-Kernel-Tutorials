# Writing docs for this repo

The voice here is casual and beginner-first, and it stays that way. This page is
about the shape of a document, not the words in it.

Before you open a PR, run this:

```bash
npx markdownlint-cli2 --fix "**/*.md"
```

It fixes most of the mechanical stuff on its own. The rules below are the ones it
cannot check for you.

## Headings

- One `#` per file, and it is the first heading in the file.
- Never skip a level. `#`, then `##`, then `###`.
- Emoji go first, before the number: `## ✅ 01. Downloading the kernel source`
- No `<h2 id="...">` and no `## <span id="...">`. GitHub builds the anchor from
  the heading text on its own. Hover a rendered heading and click the link icon
  to copy the real one.
- A heading is a title, not a sentence. If it needs a comma, or it trails off
  into the next line, it is a paragraph, not a heading.

## Lists

- `-` for bullets. Two spaces per nesting level.
- `1.` `2.` `3.` for numbered lists, one space after the dot.
  - The zero padded `01.` style is used only for the numbered sections of the
    main README, because links point at them.
- Text, images and code that belong to a list item are indented to line up with
  that item's text.

## Callouts and bold

- A real callout is a GitHub alert:

  ```markdown
  > [!NOTE]
  > Useful to know, but you can keep going without it.
  ```

  The five types are `NOTE`, `TIP`, `IMPORTANT`, `WARNING` and `CAUTION`.
- Two alerts in a row cancel each other out. If everything is important, nothing
  is.
- Starting a paragraph with `**Note:**` or `**In my case,**` is fine, that is
  just how this repo talks. Do not fake an alert with a whole line of bold text.

## Code

- Always fenced, always backticks, always a language tag.
- Use `bash` for commands, `c` for kernel source, `kconfig` for defconfig
  fragments, `diff` for patches, and `text` for terminal output and logs.

## Images

- Markdown syntax, not `<img>`:

  ```markdown
  ![Extracted clang folder showing the bin directory](./screenshots/32.png)
  ```

- The alt text describes that one image in a few words. Do not paste the same
  alt text onto ten screenshots. Someone on a slow connection or a screen reader
  gets the alt text and nothing else.
- Raw `<img>` only when you actually need `width=`.
- A caption goes on the line below, in *italics*.

## Everything else

- `---` for a separator. Never `<hr>`, never `<br>`, and never two trailing
  spaces to force a line break. A blank line is a paragraph break.
- Links are relative and start with `./` or `../`. Not `/LICENSE`, and not a full
  `github.com` URL to a file that lives in this repo.
- Every doc outside the root starts with a link back to the main guide.
- LF line endings, one newline at the end of the file, no trailing spaces.
  `.gitattributes` handles the first one for you.

---

[← Back to the main guide](./README.md)
