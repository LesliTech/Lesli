# Pull Requests

A pull request should make one change easy to understand, verify, and maintain. Open it against `master`, keep its scope focused, and explain the result rather than listing filenames.

Use a draft pull request when the direction would benefit from early feedback but the branch is not ready to merge.

---

## Before Opening a Pull Request

* Review the complete diff and remove unrelated changes.
* Rebase or otherwise update the branch against `origin/master`.
* Run the relevant tests locally and record the exact commands.
* Add regression coverage for a bug fix and behavioral coverage for a feature.
* Run Brakeman when the change touches requests, parameters, authentication, authorization, rendering, files, or SQL.
* Update public documentation, examples, and configuration references when behavior changes.
* Verify migrations from the previous schema and from a clean database.
* Rebuild generated assets when their source changes and the package tracks the output.
* Confirm the branch contains no credentials, local databases, logs, or reports.

The full test suite is the default expectation for core changes:

```shell
bundle exec rake
```

If a check cannot be run locally, say why in the pull request instead of omitting it silently.

---

## Title and Description

Write a concise, outcome-focused title. Conventional Commit style works well:

```text
fix(navigation): preserve active state after Turbo visits
```

The description should answer:

1. What problem or opportunity does this address?
2. What changed and why was this approach selected?
3. How was it verified?
4. Does it affect compatibility, configuration, migrations, or deployment?

A useful template is:

```markdown
## Summary

- Explain the user-visible or developer-visible result.
- Mention the important implementation decision.

## Verification

- `bundle exec rake`
- `bundle exec brakeman --config-file config/brakeman.yml`
- Manual scenario tested, when relevant

## Compatibility

- No breaking changes
- Migration, configuration, or upgrade notes when applicable

## Visual changes

- Screenshot or recording for affected interfaces

Closes #123
```

Omit empty sections, but never hide a known limitation or upgrade requirement.

---

## Continuous Integration

Every pull request triggers the Lesli test workflow. Its jobs currently run in this order:

1. Brakeman security analysis
2. Minitest engine suite
3. LesliBuilder integration verification

All required jobs should pass before merge. A failing check must be fixed or explicitly identified as an unrelated infrastructure failure; rerunning a job without understanding the failure is not a resolution.

Changes that affect another engine or shared gem should also be tested in that package or in a representative host application.

---

## What Reviewers Check

Review is not limited to syntax. Consider:

* Correctness for normal, empty, invalid, and unauthorized states
* Tests that prove behavior rather than mirror implementation
* Authentication, authorization, data exposure, and injection risks
* Backward compatibility of Ruby APIs, routes, configuration, views, and database schema
* Clear ownership between Lesli Core, shared gems, engines, and the host application
* Query behavior, indexes, account scoping, and migration safety
* Accessible, responsive, and Turbo-safe frontend behavior
* Documentation and upgrade guidance for public changes
* Whether generated files correspond to reviewed source changes

Not every pull request needs every category. Review the risks introduced by the actual change.

---

## Write Actionable Feedback

Assume good intent and discuss the code, not the author. Keep comments specific and explain the consequence of a requested change.

Label the intent when it might be ambiguous:

* **Blocking:** must be resolved before merge
* **Suggestion:** a recommended improvement that is not required
* **Question:** asks for context or confirms an assumption
* **Nit:** optional polish with no behavior impact

Attach comments to the smallest useful line range. When possible, suggest a concrete direction without requiring the author to copy one exact implementation.

Authors should resolve comments only after addressing them or recording the agreed outcome. Reviewers should re-check changed code rather than assuming the first revision still represents the branch.

---

## Merge Expectations

A pull request is ready to merge when:

* Its scope and behavior are understood.
* Required CI checks pass.
* Blocking review feedback is resolved.
* Tests and documentation are proportionate to the change.
* Migration and release implications are documented.

Compiled assets are not exempt from review. When generated output is tracked, review it together with the source and build command that produced it.

Maintainers choose the merge strategy and release timing. Contributors should not bump `Lesli::VERSION` unless the pull request is specifically preparing a release.
