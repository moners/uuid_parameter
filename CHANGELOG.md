# ChangeLog

Here's an overview of notable changes to this program.  
For more technical details, try [`tig`](https://jonas.github.io/tig/).

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

<!-- Nothing yet. Maybe open an issue? -->

- Make Gitlab/Github links **not** relative since Gitlab is smarter about them,
  but Github plagues users with broken links

## [0.2.1] - 2018-10-12

- Fix locale files
- Fix link in [README.md]

## [0.2.0] - 2018-10-12

- Fix bug when existing records had NULL values
- Refactor out the validator class to simplify code
- Make specifications clearer
- Prepare for I18n (now working but rightly put in code, see #2)
- Released an alpha version 2 days ago to test I18n...

## 0.1.0 - 2018-09-19

Initial release.

[CHANGELOG.md]: ./CHANGELOG.md
[LICENSE]: ./LICENSE
[README.md]: ./README.md
[Unreleased]: ../compare/v0.2.1...HEAD
[0.2.1]: /../../compare/v0.2.0...v0.2.1
[0.2.0]: https://gitlab.com/incommon.cc/uuid_parameter/compare/v0.1.0...v0.2.0
