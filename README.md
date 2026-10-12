# OrgTeX

OrgTeX is a modular, extensible and cross-platform document system built around
Org Mode and LaTeX.

The goal of OrgTeX is to make professional document creation easier by allowing
users to focus on content instead of dealing directly with complex LaTeX
configuration.

## Project goals

OrgTeX aims to provide:

- Org Mode based document authoring.
- Automatic LaTeX generation and PDF compilation.
- Modular document families and variants.
- Reusable themes and cover designs.
- Fine-grained control over document structure and layout.
- Spanish and English user interfaces.
- Native and Docker-based compilation backends.
- Support for Linux, Windows and macOS.
- Clear validation and human-friendly error messages.
- An extensible architecture where new modules can be added without modifying
  existing ones whenever possible.

## Planned document families

- Article-style documents.
- Report-style documents.
- Books.
- Correspondence.
- Business documents.
- Presentations.
- Posters.
- Visual documents.

## Status

OrgTeX is currently in early development.

The project architecture is being defined before implementation begins.

## Development

OrgTeX is developed as a free and open-source project.

AI-assisted development tools may be used during development. All contributions
must still be reviewed, understood and tested by human contributors.

See:

- `docs/architecture.md`
- `docs/licensing.md`
- `docs/ai-assisted-development.md`
- `docs/third-party-licenses.md`

### Testing

The current testing procedure is documented in
[`docs/testing.md`](docs/testing.md).

It includes the minimal end-to-end Org Mode → OrgTeX → LuaLaTeX → PDF pipeline test.

## License

OrgTeX is licensed under the Mozilla Public License 2.0 (MPL-2.0).
