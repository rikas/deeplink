# Changelog

## 3.0.0 (2026-10-20)

### Breaking changes

- `query` returns decoded values (`a b` instead of `a+b`). Values are encoded only by `to_s`, and
  query keys are now encoded too.
- `add_query` with a `nil` value adds a parameter without a value (`?flag`) instead of `flag=`.

### Fixes

- Keep URL fragments (`deep://page#section`), available through `fragment`.
- Keep query parameters without a value (`?flag`), stored with a `nil` value.
- Encode query values that are not strings, such as symbols.
- Parse links without a double slash (`deep:foo`, `deep:/foo`) instead of returning `''`.
- Parse query values containing `{` or `}` in full.

### Development

- Add `changelog_uri` to the gem metadata and ship `CHANGELOG.md` with the gem.

## 2.0.0 (2026-10-20)

### Breaking changes

- Require Ruby >= 3.2 (was >= 2.5).

### Fixes

- Support Ruby 4.0, which removed the CGI library. Query values are encoded exactly as before.
- Already encoded query values are no longer double encoded (`?q=hello%20world` used to become
  `q=hello%2520world`).
- `remove_query` without keys returns `nil` instead of raising `NoMethodError`.

### Development

- CI tests Ruby 3.2, 3.3, 3.4 and 4.0, and runs RuboCop in a separate job.
- Add Dependabot for GitHub Actions and Bundler.
- Update development dependencies (RuboCop 1.92, RSpec 3.13, `debug` and `irb` instead of
  `pry-byebug`).
- `rake` runs the specs and RuboCop.

## 1.1.0 (2020-05-01)

- Drop support for Ruby 2.1.

## 1.0.1 (2018-02-13)

- Code style fixes.

## 1.0.0 (2016-05-06)

- First stable release.

## 0.1.4 (2016-04-06)

- Fix `NoMethodError` when parsing query parameters on Ruby < 2.1.

## 0.1.3 (2015-12-11)

- Fix parsing `nil` links.
- Parse query parameters with unusual characters.
- Allow removing a list of query parameters.
