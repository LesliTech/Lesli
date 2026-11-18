# Styles with Tailwind CSS

Lesli uses Tailwind CSS for framework and engine interfaces. LesliAssets owns the shared theme, design tokens, fonts, and icon fonts; each engine can compile a small stylesheet for the utility classes and custom rules used by that engine.

The source files and generated Rails assets are intentionally separate:

```text
source/tailwind/application.css
        ↓ build
app/assets/stylesheets/<package_name>/application.css
```

Edit engine sources under `source/tailwind`. LesliView component styles live beside
their templates under `lib/lesli_view` and are imported by its Tailwind entrypoint.
Files under `app/assets/stylesheets` are generated output.

---

## Stylesheet Order

The authenticated Lesli layout loads three stylesheets in order:

| Stylesheet | Responsibility | Turbo tracking |
| --- | --- | --- |
| `lesli_assets/application` | Base theme, design tokens, fonts, icons, and application-shell utilities | `reload` |
| `lesli_view/view` | Reusable component, partial and layout styles | `reload` |
| `<current_engine>/application` | Utilities and rules used by the current engine | `dynamic` |

LesliAssets compiles its global configuration and shared application utilities
into `lesli_assets/application.css`. Its source entrypoint contains the shared
`@source` declarations; no separate utility asset is required.

Because the engine stylesheet loads last, use it for feature-specific presentation. Changes that should affect every engine belong in LesliAssets; reusable component styles belong with the corresponding LesliView component.

Shared styles use `data-turbo-track="reload"` so Turbo reloads the document when
their fingerprinted URLs change after a deployment. Engine styles use `dynamic`
so Turbo removes them when they are absent from the next page.

Load page-specific styles through `content_for :head`, also with `dynamic`:

```erb
<% content_for :head do %>
    <%= stylesheet_link_tag "my_engine/calendar", media: "all", "data-turbo-track": "dynamic" %>
<% end %>
```

Do not mark a page-specific stylesheet as `reload`: adding or removing it would
force a full reload during Turbo Drive navigation. Head updates apply to full-page
visits; a Turbo Frame response does not load the page's head assets.

The shared dashboard view adds its stylesheet when embedded in another engine.
Inside LesliDashboard, the main layout already includes it.

LesliAssets defines both the global Lesli palette and the complete Tailwind theme.
Its `application` and `public` stylesheets use `theme(static)` so variables needed
only by another package are still available. Load the appropriate shared sheet
before any engine or LesliView stylesheet; the two shared sheets serve different
layouts and do not need to be loaded together.

Engines and LesliView use `@reference` to compile against the theme without
emitting its variables again. Tailwind's internal `--tw-*` properties remain in
each compiled stylesheet because they implement the utilities themselves.

---

## Utility and Component Classes

Core, every engine and LesliAssets use standard Tailwind classes without package
prefixes:

```erb
<div class="flex flex-col gap-4 sm:flex-row">
    <%= render LesliView::Elements::Button.new("Continue", url: next_path) %>
</div>
```

LesliView owns named presentation classes such as `lesli-button` and
`lesli-error`. Preserve these names. Its CSS uses unprefixed `@apply` internally,
but does not publish global utility selectors.

Each package compiles independently against LesliAssets' global configuration.
Repeated utilities between engine bundles are accepted; global theme definitions
remain centralized. Content passed into a LesliView slot belongs to the caller,
so its utility classes must be included in that engine's source discovery.

The documentation website continues using Bulma. This application styling
convention does not require converting website examples or layouts.

---

## Create an Engine Entrypoint

Place the entrypoint at `source/tailwind/application.css` in the engine:

```css
@layer theme, components, utilities;

@import "tailwindcss/theme.css" theme(reference);
@reference "../../../../gems/LesliAssets/source/tailwind/settings/theme.css";
@reference "../../../../gems/LesliAssets/source/tailwind/settings/shared-theme.css";
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

The shared-theme reference above assumes the standard Builder directory layout.
Adjust the reference paths for a different source checkout. Keep `theme(reference)`
on the Tailwind theme import so the engine does not emit another copy of the
global variables.

Tailwind cannot discover fragments such as `"bg-#{color}-500"`. Map application states to complete class strings instead:

```ruby
STATUS_CLASSES = {
  open: "bg-info-100 text-info-800",
  resolved: "bg-success-100 text-success-800"
}.freeze
```

---

## Build Stylesheets

The LesliAssets builder discovers every `.css` file placed directly inside a `source/tailwind` directory in the workspace. It compiles each one into its package's Rails asset directory. Keep imported partials in subdirectories such as `settings`, `fonts`, or `components` so the builder does not compile them independently.

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

The builder excludes dependency, temporary, version-control, and generated asset directories. If a new entrypoint is not discovered, verify that it is a CSS file placed directly in the entrypoint directory:

```text
<package>/source/tailwind/application.css
<package>/source/tailwind/<specialized-name>.css
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

Use the `lesli_theme_*` keys consumed by the shared stylesheet's fallback variables:

```ruby
@lesli[:customization] = {
    colors: {
        lesli_theme_color_primary: "#276AD6",
        lesli_theme_color_background: "#F8FAFC"
    }
}
```

The layout converts underscores to hyphens, producing variables such as
`--lesli-theme-color-primary`. It emits no style block when the colors hash is
empty. The block uses `dynamic` tracking so a previous page's customization is
removed when it changes or is no longer supplied. The built-in customization
loader is not currently active; a host must supply these values explicitly.

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
