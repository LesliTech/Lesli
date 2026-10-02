# Releases and Versioning

Lesli follows [Semantic Versioning 2.0.0](https://semver.org/). The public gem version communicates compatibility to applications and engines that depend on Lesli.

```text
MAJOR.MINOR.PATCH
  5  .  1  . 10
```

| Release | Use | Example |
| --- | --- | --- |
| Patch | Backward-compatible bug fix or internal correction | `5.1.10` → `5.1.11` |
| Minor | Backward-compatible capability or meaningful public enhancement | `5.1.10` → `5.2.0` |
| Major | Intentional backward-incompatible change | `5.1.10` → `6.0.0` |

Database changes do not automatically require a particular segment. An additive, backward-compatible migration can ship in a minor or patch release depending on the behavior it supports; a destructive or incompatible schema contract requires a major release or a staged compatibility plan.

---

## Version Sources

The gem version and build identifier live in:

```ruby
# lib/lesli/version.rb
module Lesli
  VERSION = "5.1.10"
  BUILD = "1790534691"
end
```

`lesli.gemspec` reads `Lesli::VERSION` as the package version. `BUILD` is a separate internal build identifier and is not a fourth Semantic Versioning segment.

Applications declare compatible ranges in Bundler, for example:

```ruby
gem "lesli", "~> 5.1"
```

Do not edit `VERSION` in an ordinary feature or bug-fix pull request unless a maintainer has asked that branch to prepare a release. Centralizing the bump avoids conflicts between concurrent contributions.

---

## Identify Compatibility Impact

A change may be breaking when it removes or changes an established contract, including:

* Ruby classes, methods, arguments, or return shapes
* Routes, controller responses, or status codes
* Configuration keys or defaults
* Database columns, constraints, or migration assumptions
* View partial paths, helper names, CSS hooks, or JavaScript globals
* Supported Rails, Ruby, or dependency versions

Deprecate before removing when practical. Document the replacement, emit a useful warning, and keep both paths available for an appropriate transition period.

A large internal refactor is not a major release when public behavior remains compatible. Conversely, a one-line removal can require a major release when consumers depend on it.

---

## Prepare a Release

Releases are maintainer-owned. The repository's GitHub Actions workflow verifies changes but does not currently publish the gem or infer a release from `#minor` or `#major` commit text.

A release branch or pull request should:

1. Select the next version from the compatibility impact.
2. Update `Lesli::VERSION` and the build identifier using the current release tooling.
3. Confirm dependency constraints and packaged files.
4. Run tests, security analysis, and integration checks.
5. Build the gem locally.
6. Prepare human-readable release notes and upgrade instructions.

```shell
bundle exec rake
bundle exec brakeman --config-file config/brakeman.yml
bundle exec rake build
```

Inspect the built package under `pkg/` before publishing. It should include the intended `app`, `config`, `db`, and `lib` files plus the license, Rakefile, and README selected by the gemspec.

Bundler exposes a maintainer release task:

```shell
bundle exec rake release
```

That task creates the `vVERSION` Git tag, pushes the tag, builds the gem, and publishes it to RubyGems. It requires release credentials and push access; do not run it for verification or from an unapproved branch.

---

## Release Notes

The gemspec points consumers to GitHub Releases as the changelog. Release notes should be written for people upgrading an application, not as a raw commit list.

Include:

* Important features and fixes
* Security changes and their impact
* Breaking changes and replacements
* Required migrations or deployment ordering
* New or renamed configuration
* Dependency and platform requirement changes
* Known limitations or follow-up work

Link the pull requests or issues that provide useful detail. Omit maintenance noise that does not affect consumers.

---

## Release Checklist

* The version matches the documented compatibility impact.
* `lib/lesli/version.rb` and the built gem report the same version.
* Tests, Brakeman, and LesliBuilder integration pass.
* The gem builds and contains the intended files.
* Database changes include safe migration and rollback guidance.
* Public changes have documentation and upgrade notes.
* The Git tag uses `vMAJOR.MINOR.PATCH` and points to the reviewed release commit.
* GitHub Release notes are published with the gem release.
