# Gem Documentation Standard

Every Lesli gem owns the documentation for its installation and public API. Keep that source in the gem repository under `docs`; the Lesli website copies it into the generated documentation site.

This standard applies to Ruby gems such as LesliAssets, LesliDate, LesliSystem, LesliTesting, LesliView, and Termline. Repositories that only provide development tooling or GitHub Actions should document their own workflow instead of imitating a Ruby gem.

---

## Documentation Structure

Use the README as the public landing page. It should explain the gem's purpose, requirements, quick start, primary capabilities, development setup, and support links without reproducing every API option.

Organize detailed documentation by responsibility:

```text
docs/
├── navigation
├── about/
│   ├── installation.md
│   ├── configuration.md
│   ├── compatibility.md
│   ├── development.md
│   └── upgrading.md
├── api-or-domain/
│   ├── index
│   ├── overview.md
│   └── feature.md
└── images/
```

Only `about/installation.md` is required. Add optional pages only when they describe real behavior:

| Page | Include when |
| --- | --- |
| `configuration.md` | The gem exposes settings, environment variables, or an initializer |
| `compatibility.md` | Adapter, platform, Rails, or browser behavior needs a support matrix |
| `development.md` | Contributors need build tools or a workflow beyond `bundle install` and tests |
| `upgrading.md` | A release requires a migration or behavior change |

Use one domain folder for a small API and focused folders for a component library. Every folder shown as a navigation section must include an `index` landing file. Do not publish empty pages, speculative APIs, or generated work-in-progress placeholders.

---

## Navigation

The `docs/navigation` file controls the sidebar. Put setup first, followed by the public API or domain sections:

```erb
<%= navigation_for_folder(
  "gems",
  "my-gem",
  "about",
  order: ["installation", "configuration", "compatibility", "development", "upgrading"]
) %>
<%= navigation_for_folder("gems", "my-gem", "api", order: ["overview", "client", "errors"]) %>
```

The generator ignores missing files, so the common order can be shared by gems with fewer setup pages.

Keep published URLs stable. If a page must move, add a website redirect before removing its old route. A stable existing structure is preferable to a cosmetic reorganization.

---

## Installation Page

An installation guide must let a developer reach one working example without reading the source. Include:

1. Supported Ruby, Rails, and framework requirements
2. The `bundle add` command
3. Any required `require`, initializer, asset, or host-application setup
4. A minimal example that verifies the installation
5. Links to configuration and compatibility details when applicable

Separate consumer setup from contributor tooling. A released gem's installation page should not ask application developers to install Node.js or run repository build tasks unless those steps are truly required at runtime.

---

## Public API Pages

Document supported entry points rather than private implementation details. Each class, component, or feature guide should include:

* Its purpose and fully qualified Ruby constant
* A minimal working example
* Constructor or method options, including defaults
* Accepted input shapes and returned value or rendered behavior
* Important errors, side effects, and compatibility limits
* Related APIs and required integrations

Use option tables when a method has several arguments:

| Option | Default | Purpose |
| --- | --- | --- |
| `timeout:` | `5` | Maximum number of seconds to wait |

Examples must use names and signatures that exist in the current release. Prefer the public shortcut over an internal builder and identify compatibility aliases as such.

---

## Component Libraries

For a ViewComponent or UI library, group pages by the concepts developers browse: components, elements, forms, layouts, charts, and widgets. A component page should include:

* A render example
* Required host assets or JavaScript behavior
* Constructor options and slots
* Block usage when supported
* Accessibility behavior developers must preserve
* The empty, loading, disabled, or error state when relevant

Do not describe a visual component only with an image. The documented ERB example is the contract developers need to reuse it.

Mark domain-coupled components clearly. If a component expects associations, routes, record attributes, or another Lesli engine, list those requirements before the example.

---

## Asset Libraries

Asset documentation must distinguish among:

| Kind | Meaning |
| --- | --- |
| Source | Files contributors edit |
| Generated | Files produced by a repository build task |
| Distributed | Files packaged in the released gem |
| Consumed | Logical paths, partials, or helpers used by host applications |

Document the consumer path first. Put compilation commands and generated-file warnings in `about/development.md`, not in the installation flow.

---

## README Links

README links to detailed guides should use canonical website URLs because the README is also published as the gem landing page:

```markdown
- [Installation](https://www.lesli.dev/gems/my-gem/about/installation)
- [API overview](https://www.lesli.dev/gems/my-gem/api/overview)
```

Repository-relative links are appropriate only for files that are not copied into the website, such as the license.

---

## Review Checklist

Before publishing gem documentation:

* Verify every constant, method, option, default, and example against the current implementation.
* Verify installation commands against the gemspec and runtime dependencies.
* Remove empty pages and descriptions of retired implementations.
* Give every navigation folder a working landing route.
* Keep contributor build steps separate from consumer installation.
* Check canonical README and edit-page links on the generated website.
* Run the gem test suite and the documentation website build.
* Review the generated pages on desktop and mobile widths.
