# Commits

A useful commit records one coherent change and explains why it exists. Keep the history easy to review and safe to revert; do not combine unrelated cleanup, generated files, dependency updates, and behavior changes without a clear reason.

Before committing:

1. Review `git diff` and remove accidental changes.
2. Run the checks relevant to the files you changed.
3. Confirm tests and documentation describe the resulting behavior.
4. Ensure no credentials, local databases, logs, or generated reports are staged.

---

## Commit Message Format

Prefer the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) structure for new work:

```text
type(optional-scope): concise description

Optional body explaining context and tradeoffs.

Optional footer.
```

Examples:

```text
fix(navigation): preserve active state after Turbo visits
```

```text
docs(database): document ten-digit migration versions
```

```text
feat(accounts): add account suspension workflow

Keep suspended accounts available to audit queries while preventing
new authenticated sessions.

Closes #123
```

Use an imperative, lowercase description without repeating the package name. The subject should complete the sentence, "This commit will ..."

An issue number is useful when one exists, but a Trello or internal work-item identifier is not required.

---

## Common Types

| Type | Use |
| --- | --- |
| `feat` | Backward-compatible user or developer-facing capability |
| `fix` | Defect correction |
| `docs` | Documentation-only change |
| `refactor` | Internal restructuring without intended behavior change |
| `test` | Test additions or corrections |
| `perf` | Performance improvement |
| `build` | Build system, package, or dependency behavior |
| `ci` | Continuous-integration configuration |
| `style` | Formatting-only change with no behavior impact |
| `chore` | Maintenance that does not fit another type |

Use a scope only when it adds useful context, such as `navigation`, `database`, `generator`, or `deps`. Avoid vague scopes such as `misc`.

Dependency updates normally use `build(deps)` or `chore(deps)`. Generated asset changes should describe the source change that produced them rather than using `assets` as the only explanation.

---

## Breaking Changes

Mark an intentional incompatible change with `!` and explain it in the body or a `BREAKING CHANGE:` footer:

```text
feat(router)!: remove legacy authentication paths

BREAKING CHANGE: Applications must mount authentication through
Lesli::Router.login before upgrading.
```

A breaking marker does not replace migration guidance. Explain the affected API, route, configuration, database, or behavior and provide an upgrade path in the pull request and documentation.

Do not mark a change as breaking merely because its implementation is large.

---

## Commit Boundaries

A commit should leave the repository in a meaningful state whenever practical. Good boundaries include:

* A failing regression test followed by its focused fix, when that history helps review
* A migration and the model behavior that depends on it
* A source asset change and its required compiled output
* A documentation correction independent of application code

Before requesting review, clean up temporary debugging commits. Preserve commits that explain distinct decisions; squash noise such as `fix typo`, `try again`, or merge-conflict-only commits.

Never rewrite commits already shared on a branch without coordinating with its other contributors.
