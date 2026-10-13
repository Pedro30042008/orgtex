# Changelog

All notable changes to OrgTeX will be documented in this file.

## Unreleased

### Added

- Configuration keyword validation for unknown or misspelled `ORGTEX_`
  directives.
- Dedicated language registry with initial support for `es` and `en`.
- Language validation tests, including direct registry validation and
  validation through the OrgTeX export pipeline.
- Simple document cover support through `#+ORGTEX_COVER: simple`, including
  cover validation, LaTeX package selection, title-page generation, and
  end-to-end pipeline verification.
- Aggregate test runner through `scripts/test-all.sh` for executing all current
  OrgTeX test suites with a final pass/fail summary.
- Minimal document theme support through `#+ORGTEX_THEME: minimal`, including
  theme validation, LaTeX package selection, and end-to-end pipeline
  verification.
- ADR 0003 defining Org keywords as the primary per-document configuration
  format.
- Automated end-to-end test runner for the initial OrgTeX pipeline.
- Minimal end-to-end Org Mode to PDF pipeline test.
- Document variant validation for supported family and variant combinations.
- Document family selection through public OrgTeX family names.
- Initial Org Mode export integration.
- Minimal LaTeX core package and article backend.
- Initial project structure for OrgTeX.
- MPL-2.0 project license.
- ADR 0001 documenting the project licensing decision.
- ADR 0002 documenting AI-assisted development.

### Changed

- Configuration parsing is now separated from semantic value validation.
  `orgtex-config.el` validates configuration keyword names and preserves raw
  values, while specialized registries validate family, variant, theme, cover,
  and language semantics.
- Language resolution during export now uses the dedicated OrgTeX language
  registry instead of hardcoded export logic.
- The aggregate test runner now executes seven test suites.
- The export pipeline preserves package order so themes are loaded before
  covers.
- The pipeline warning check detects persistent LaTeX warnings without matching
  unrelated package metadata.
