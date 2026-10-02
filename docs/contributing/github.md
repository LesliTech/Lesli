# Contribution Workflow

Lesli is developed as a Ruby on Rails engine in the wider LesliBuilder workspace. The `master` branch is the repository's integration branch; make each change on a short-lived branch and send a pull request back to `master`.

Stable releases are identified by versioned gems, Git tags, and GitHub Releases. The repository does not use separate `test` and `production` branches as part of its current contribution workflow.

---

## Choose the Correct Repository

Start by locating the package that owns the behavior:

| Change | Repository |
| --- | --- |
| Framework controllers, models, layouts, generators, or database conventions | Lesli Core |
| Reusable Rails interface component or form builder | LesliView |
| Shared styles, icons, JavaScript dependencies, or compiled frontend assets | LesliAssets |
| Testing configuration, reporting, or coverage behavior | LesliTesting |
| A business capability owned by an engine | That engine's repository |
| Website presentation or generated documentation output | `lesli.dev` |

Documentation source belongs beside the package it describes. The website copies those source files during its documentation build, so change the package documentation rather than editing generated website pages.

---

## Set Up Lesli Core

Clone the repository and install its development dependencies:

```shell
git clone https://github.com/LesliTech/Lesli.git
cd Lesli
bundle install
```

Lesli's tests boot the Rails application under `test/dummy`. Run the suite before making changes to confirm the local environment works:

```shell
bundle exec rake
```

For cross-package development, use the complete LesliBuilder layout and local `path` dependencies. See [Installing Lesli for Development](/engines/lesli/start/development) for the recommended workspace structure.

---

## Create a Branch

Update the integration branch, then create a focused branch:

```shell
git switch master
git pull --ff-only
git switch -c fix/navigation-active-state
```

Useful branch prefixes include:

```text
feature/account-invitations
fix/navigation-active-state
docs/database-migrations
refactor/response-interface
```

The exact prefix is not enforced. Prefer a short name that explains the result of the work. Include an issue identifier when one exists, but do not make an internal project-management ID a requirement for outside contributors.

Keep unrelated work on separate branches. A focused branch is easier to test, review, revert, and release.

---

## Make the Change

Before editing, identify the existing convention and its tests. Lesli is modular, so a small-looking core change may affect several engines or the host application.

While working:

* Keep domain behavior in the engine that owns it.
* Preserve public APIs unless the change intentionally introduces a documented breaking release.
* Add or update tests with behavioral changes.
* Update package documentation when behavior, configuration, or public APIs change.
* Edit source assets, not generated output, unless the package intentionally tracks both.
* Follow `.editorconfig`: UTF-8, LF line endings, final newlines, and four-space indentation for project source files.
* Do not include local databases, logs, coverage reports, credentials, or temporary files.

For database changes, follow [Migration Versioning](/engines/lesli/database/versioning). For frontend changes, follow the [Frontend Development](/engines/lesli/frontend/) conventions.

---

## Run Local Checks

Run the complete engine test suite:

```shell
bundle exec rake
```

Run one test file while iterating:

```shell
bundle exec ruby -Itest test/app/models/lesli_account_test.rb
```

Enable LesliTesting coverage explicitly:

```shell
COVERAGE=true bundle exec rake
```

Run the repository's Brakeman configuration for security-sensitive changes:

```shell
bundle exec brakeman --config-file config/brakeman.yml
```

Verify that the gem can be packaged when dependencies or packaged files change:

```shell
bundle exec rake build
```

The pull-request workflow runs Brakeman, Minitest, and a LesliBuilder integration job in sequence. Local checks shorten feedback, but GitHub Actions remains the final verification for the submitted branch.

---

## Keep the Branch Current

Refresh a long-running branch before requesting final review:

```shell
git fetch origin
git rebase origin/master
```

Resolve conflicts deliberately and rerun affected checks. Do not rewrite a branch another contributor is using without coordinating with them.

After the branch is ready, push it and open a pull request targeting `master`:

```shell
git push --set-upstream origin fix/navigation-active-state
```

See [Pull Requests](/engines/lesli/contributing/pull-requests) for the submission and review checklist.
