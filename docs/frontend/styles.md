# Styles with Tailwind CSS

Lesli uses Tailwind CSS for framework and engine interfaces. LesliAssets owns the shared theme, design tokens, fonts, and icon fonts; each engine can compile a small stylesheet for the utility classes and custom rules used by that engine.

The source files and generated Rails assets are intentionally separate:

```text
source/tailwind/application.tailwind.css
        ↓ build
app/assets/stylesheets/<package_name>/application.tailwind.css
```

Edit files under `source/tailwind`. Files under `app/assets/stylesheets` are generated output and will be replaced by the next build.

---

## Stylesheet Order

The authenticated Lesli layout loads three stylesheets in order:

| Stylesheet | Responsibility |
| --- | --- |
| `lesli_assets/application.tailwind` | Base theme, design tokens, fonts, icons, and application-shell utilities |
| `lesli_assets/view.tailwind` | Utilities and component styles required by LesliView |
| `<current_engine>/application.tailwind` | Utilities and rules used by the current engine |

Because the engine stylesheet loads last, use it for feature-specific presentation. Changes that should affect every engine belong in LesliAssets; reusable component styles belong with the corresponding LesliView component.

---

## Create an Engine Entrypoint

Place the entrypoint at `source/tailwind/application.tailwind.css` in the engine:

```css
@layer theme, components, utilities;

@import "tailwindcss/theme.css" layer(theme);
@import "tailwindcss/utilities.css" layer(utilities) source(none);

@source "../../app/views/my_engine/**/*.html.erb";
@source "../../app/helpers/my_engine/**/*.rb";

@layer components {
  .ticket-status {
    @apply inline-flex rounded-full px-2.5 py-1 text-sm font-medium;
  }
}
```

`source(none)` disables automatic source detection. Every file containing Tailwind classes must therefore be covered by an `@source` rule. Include Ruby helpers and ViewComponent classes when they construct complete utility class names.

Tailwind cannot discover fragments such as `"bg-#{color}-500"`. Map application states to complete class strings instead:

```ruby
STATUS_CLASSES = {
  open: "bg-info-100 text-info-800",
  resolved: "bg-success-100 text-success-800"
}.freeze
```

---

## Build Stylesheets

The LesliAssets builder discovers every `*.tailwind.css` file below a `source/tailwind` directory in the workspace and compiles each one into its package's Rails asset directory.

From `gems/LesliAssets`, run:

```shell
make build.tailwind
```

Use the watcher while editing views or source styles:

```shell
make watch.tailwind
```

Build minified production assets with:

```shell
make prod.tailwind
```

The builder excludes dependency, temporary, version-control, and generated asset directories. If a new entrypoint is not discovered, verify both parts of its name and location:

```text
<package>/source/tailwind/<name>.tailwind.css
```

---

## Colors and Theme Tokens

Prefer a token that describes the role of a color instead of copying a hexadecimal value.

```erb
<button class="bg-primary text-white hover:bg-primary-600">
  Save changes
</button>

<p class="bg-success-100 text-success-800">
  Changes saved successfully.
</p>
```

There are two forms of the primary color:

* `primary-50` through `primary-900` are stable Lesli brand colors.
* Unnumbered `primary` follows the active application's runtime theme.

Use the numbered palette when the interface must retain a stable design-system color. Use unnumbered `primary` when a surface or action should follow account customization.

When the controller supplies customization colors in `@lesli`, the application layout exposes them as CSS custom properties. Tailwind's theme maps runtime-aware utilities such as `bg-primary`, `bg-background`, `bg-header`, and `text-foreground` to those properties.

See the [Lesli color system](/gems/assets/theme/colors), [semantic colors](/gems/assets/theme/semantics), and [brand guide](/gems/assets/theme/brand) before introducing a new color.

---

## Responsive and Accessible Styling

* Start with the smallest layout, then add `sm:`, `md:`, and `lg:` changes only when the content needs them.
* Use visible `focus-visible:` states for interactive controls.
* Pair semantic color with text or an icon; color alone must not communicate status.
* Keep sufficient contrast, especially for muted text and disabled states.
* Respect reduced-motion preferences for decorative animation.
* Prefer utilities for local presentation and component classes for a repeated, named pattern.

Do not use arbitrary values to recreate a token that already exists. A small amount of repetition in a template is preferable to a global class whose name does not describe a reusable interface concept.
