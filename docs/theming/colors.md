# Lesli colors

The Lesli identity is built around a primary blue inspired by Maya Blue, supported by neutral mineral tones, restrained semantic colors, and a set of collection colors that extend the system without breaking consistency.

## Primary brand color

<div class="columns">
    <div class="br-2 py-5 has-text-centered lesli-background-lesli-light">light</div>
    <div class="br-2 py-5 has-text-centered lesli-background-lesli-primary has-text-white">primary</div>
    <div class="br-2 py-5 has-text-centered lesli-background-lesli-dark has-text-white">dark</div>
</div>

<br />

| Token   | Hex       | Lesli                         | Variable                      |
| ------- | --------- | ----------------------------- | ----------------------------- |
| Light   | `#E3EEF6` | `lesli-color(lesli, light)`   | `--lesli-color-lesli-light`   |
| Primary | `#245F93` | `lesli-color(lesli, primary)` | `--lesli-color-lesli-primary` |
| Dark    | `#123553` | `lesli-color(lesli, dark)`    | `--lesli-color-lesli-dark`    |


This is the core visual color of Lesli. It should represent the platform globally and remain the main interactive brand color across the product.

### Primary scale

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-primary-50">50</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-200">200</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-400">400</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-600 has-text-white">600</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-800 has-text-white">800</div>
    <div class="br-2 py-4 has-text-centered lesli-background-primary-900 has-text-white">900</div>
</div>

| Token       | Hex       | Lesli                        | Variable                    |
| ----------- | --------- | ---------------------------- | --------------------------- |
| Primary 50  | `#F2F7FB` | `lesli-color(primary, 50)`   | `--lesli-color-primary-50`  |
| Primary 100 | `#E3EEF6` | `lesli-color(primary, 100)`  | `--lesli-color-primary-100` |
| Primary 200 | `#C1D8E9` | `lesli-color(primary, 200)`  | `--lesli-color-primary-200` |
| Primary 300 | `#9EC1DC` | `lesli-color(primary, 300)`  | `--lesli-color-primary-300` |
| Primary 400 | `#6F9FC3` | `lesli-color(primary, 400)`  | `--lesli-color-primary-400` |
| Primary 500 | `#4A80AE` | `lesli-color(primary, 500)`  | `--lesli-color-primary-500` |
| Primary 600 | `#245F93` | `lesli-color(primary, 600)`  | `--lesli-color-primary-600` |
| Primary 700 | `#1F527F` | `lesli-color(primary, 700)`  | `--lesli-color-primary-700` |
| Primary 800 | `#19446A` | `lesli-color(primary, 800)`  | `--lesli-color-primary-800` |
| Primary 900 | `#123553` | `lesli-color(primary, 900)`  | `--lesli-color-primary-900` |

### Recommended use

* **Primary 600**: primary buttons, links, active states, highlights
* **Primary 700**: hover state
* **Primary 800**: active/pressed state
* **Primary 50–100**: soft informational backgrounds
* **Primary 200–300**: borders, subtle surfaces, selected states
* **Primary 900**: text on light blue backgrounds

### Accessibility guidance

* Use white text on `Primary 600` and darker.
* Use dark text on `Primary 50` to `Primary 300`.
* Avoid placing small body text on `Primary 400` or `Primary 500` unless contrast has been tested.

---

## Neutral palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-50">50</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-200">200</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-400">400</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-600 has-text-white">600</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-800 has-text-white">800</div>
    <div class="br-2 py-4 has-text-centered lesli-background-neutral-900 has-text-white">900</div>
</div>

The neutral system supports the interface and should feel lightly mineral and subtly blue-gray rather than generic grayscale.

| Token       | Hex       | Lesli       | Variable       |
| ----------- | --------- | ----------- | -------------- |
| Neutral 50  | `#F8FAFC` | `lesli-color(neutral, 50)`  | `--lesli-color-neutral-50`  |
| Neutral 100 | `#F1F4F8` | lesli-color(neutral, 100) | --lesli-color-neutral-100 |
| Neutral 200 | `#E5EAF0` | lesli-color(neutral, 200) | --lesli-color-neutral-200 |
| Neutral 300 | `#D5DDE6` | lesli-color(neutral, 300) | --lesli-color-neutral-300 |
| Neutral 400 | `#B7C2CF` | lesli-color(neutral, 400) | --lesli-color-neutral-400 |
| Neutral 500 | `#8F9BAA` | lesli-color(neutral, 500) | --lesli-color-neutral-500 |
| Neutral 600 | `#667383` | lesli-color(neutral, 600) | --lesli-color-neutral-600 |
| Neutral 700 | `#4B5663` | lesli-color(neutral, 700) | --lesli-color-neutral-700 |
| Neutral 800 | `#34404C` | lesli-color(neutral, 800) | --lesli-color-neutral-800 |
| Neutral 900 | `#1F2933` | lesli-color(neutral, 900) | --lesli-color-neutral-900 |

### Recommended use

* **Neutral 50**: application background
* **Neutral 100**: subtle sections and muted cards
* **Neutral 200**: default borders and dividers
* **Neutral 300**: stronger borders and input outlines
* **Neutral 700**: secondary text
* **Neutral 900**: primary text

### Text hierarchy

* **Primary text**: `Neutral 900`
* **Secondary text**: `Neutral 700`
* **Muted text**: `Neutral 600`
* **Disabled text**: `Neutral 500`

---


# Semantic colors

Semantic colors follow the same visual philosophy as the Lesli primary blue: restrained, mineral, and product-oriented.

## Info palette

Typical uses include informational alerts, help panels, onboarding hints, documentation callouts, and non-critical status indicators.

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-info-50">50</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-200">200</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-400">400</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-600 has-text-white">600</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-800 has-text-white">800</div>
    <div class="br-2 py-4 has-text-centered lesli-background-info-900 has-text-white">900</div>
</div>

The info palette communicates neutral guidance, system messages, and contextual information without implying success, warning, or failure.

| Token    | Hex       | Lesli                    | Variable                 |
| -------- | --------- | ------------------------ | ------------------------ |
| Info 50  | `#F2F7FB` | `lesli-color(info, 50)`  | `--lesli-color-info-50`  |
| Info 100 | `#E3EEF6` | `lesli-color(info, 100)` | `--lesli-color-info-100` |
| Info 200 | `#C1D8E9` | `lesli-color(info, 200)` | `--lesli-color-info-200` |
| Info 300 | `#9EC1DC` | `lesli-color(info, 300)` | `--lesli-color-info-300` |
| Info 400 | `#6F9FC3` | `lesli-color(info, 400)` | `--lesli-color-info-400` |
| Info 500 | `#4A80AE` | `lesli-color(info, 500)` | `--lesli-color-info-500` |
| Info 600 | `#245F93` | `lesli-color(info, 600)` | `--lesli-color-info-600` |
| Info 700 | `#1F527F` | `lesli-color(info, 700)` | `--lesli-color-info-700` |
| Info 800 | `#19446A` | `lesli-color(info, 800)` | `--lesli-color-info-800` |
| Info 900 | `#123553` | `lesli-color(info, 900)` | `--lesli-color-info-900` |

**Usage guidelines**

Use the info palette for neutral messages, contextual guidance, helper content, and informative UI states.

* Use **50–100** for soft backgrounds in banners, callouts, and informational surfaces.
* Use **200–400** for borders, subtle accents, and supporting visual elements.
* Use **500–600** as the default range for icons, links, badges, and emphasis.
* Use **700–900** for high-contrast text, strong highlights, or darker themed surfaces.


## Success palette

The success palette signals confirmation, positive outcomes, and completed actions with a calm and trustworthy green range.

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-success-50">50</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-200">200</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-400">400</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-600 has-text-white">600</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-800 has-text-white">800</div>
    <div class="br-2 py-4 has-text-centered lesli-background-success-900 has-text-white">900</div>
</div>

Typical uses include success alerts, completed states, confirmation messages, approved statuses, and positive validation feedback.

| Token       | Hex       | Lesli                       | Variable                    |
| ----------- | --------- | --------------------------- | --------------------------- |
| Success 50  | `#F1FAF7` | `lesli-color(success, 50)`  | `--lesli-color-success-50`  |
| Success 100 | `#DDF2EA` | `lesli-color(success, 100)` | `--lesli-color-success-100` |
| Success 200 | `#B8E2D2` | `lesli-color(success, 200)` | `--lesli-color-success-200` |
| Success 300 | `#8DD0B8` | `lesli-color(success, 300)` | `--lesli-color-success-300` |
| Success 400 | `#5FB995` | `lesli-color(success, 400)` | `--lesli-color-success-400` |
| Success 500 | `#399C77` | `lesli-color(success, 500)` | `--lesli-color-success-500` |
| Success 600 | `#267E60` | `lesli-color(success, 600)` | `--lesli-color-success-600` |
| Success 700 | `#1F694F` | `lesli-color(success, 700)` | `--lesli-color-success-700` |
| Success 800 | `#19543F` | `lesli-color(success, 800)` | `--lesli-color-success-800` |
| Success 900 | `#123F30` | `lesli-color(success, 900)` | `--lesli-color-success-900` |

**Usage guidelines**

Use the success palette to confirm completed actions, positive outcomes, valid states, and healthy system feedback.

* Use **50–100** for soft success backgrounds in alerts, notices, and passive confirmations.
* Use **200–400** for borders, supporting accents, and lighter positive indicators.
* Use **500–600** as the default range for success badges, icons, confirmations, and active positive feedback.
* Use **700–900** for high-contrast text, strong emphasis, or darker success surfaces.


## Warning palette

Typical uses include warning alerts, incomplete forms, pending verifications, temporary issues, and states that require user review.

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-warning-50">50</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-200">200</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-400">400</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-600 has-text-white">600</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-800 has-text-white">800</div>
    <div class="br-2 py-4 has-text-centered lesli-background-warning-900 has-text-white">900</div>
</div>

The warning palette highlights caution, pending issues, and states that need attention without escalating to error severity.

| Token       | Hex       | Lesli                       | Variable                    |
| ----------- | --------- | --------------------------- | --------------------------- |
| Warning 50  | `#FFF9ED` | `lesli-color(warning, 50)`  | `--lesli-color-warning-50`  |
| Warning 100 | `#FFF1D6` | `lesli-color(warning, 100)` | `--lesli-color-warning-100` |
| Warning 200 | `#FDE2A8` | `lesli-color(warning, 200)` | `--lesli-color-warning-200` |
| Warning 300 | `#F8CF74` | `lesli-color(warning, 300)` | `--lesli-color-warning-300` |
| Warning 400 | `#E9B84A` | `lesli-color(warning, 400)` | `--lesli-color-warning-400` |
| Warning 500 | `#D29A2E` | `lesli-color(warning, 500)` | `--lesli-color-warning-500` |
| Warning 600 | `#B67D1F` | `lesli-color(warning, 600)` | `--lesli-color-warning-600` |
| Warning 700 | `#95651B` | `lesli-color(warning, 700)` | `--lesli-color-warning-700` |
| Warning 800 | `#775117` | `lesli-color(warning, 800)` | `--lesli-color-warning-800` |
| Warning 900 | `#5B3D12` | `lesli-color(warning, 900)` | `--lesli-color-warning-900` |

**Usage guidelines**

Use the warning palette for cautionary states, pending risks, incomplete flows, and situations that need attention but are not critical failures.

* Use **50–100** for soft warning backgrounds in alerts, notices, and highlighted sections.
* Use **200–400** for borders, subtle emphasis, and secondary caution indicators.
* Use **500–600** as the default range for warning badges, icons, notices, and attention-grabbing UI states.
* Use **700–900** for strong text contrast, emphasis, or darker warning surfaces.


## Danger palette

Typical uses include error alerts, failed validations, destructive actions, blocked flows, and critical system states.

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-danger-50">50</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-200">200</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-400">400</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-600 has-text-white">600</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-800 has-text-white">800</div>
    <div class="br-2 py-4 has-text-centered lesli-background-danger-900 has-text-white">900</div>
</div>

The danger palette is reserved for destructive actions, critical errors, and states that require immediate attention.

| Token      | Hex       | Lesli                      | Variable                   |
| ---------- | --------- | -------------------------- | -------------------------- |
| Danger 50  | `#FFF3F1` | `lesli-color(danger, 50)`  | `--lesli-color-danger-50`  |
| Danger 100 | `#FFE3DE` | `lesli-color(danger, 100)` | `--lesli-color-danger-100` |
| Danger 200 | `#F8C1B8` | `lesli-color(danger, 200)` | `--lesli-color-danger-200` |
| Danger 300 | `#EE9A8E` | `lesli-color(danger, 300)` | `--lesli-color-danger-300` |
| Danger 400 | `#DF6D5E` | `lesli-color(danger, 400)` | `--lesli-color-danger-400` |
| Danger 500 | `#C94E3C` | `lesli-color(danger, 500)` | `--lesli-color-danger-500` |
| Danger 600 | `#A93B2D` | `lesli-color(danger, 600)` | `--lesli-color-danger-600` |
| Danger 700 | `#8B3126` | `lesli-color(danger, 700)` | `--lesli-color-danger-700` |
| Danger 800 | `#6F281F` | `lesli-color(danger, 800)` | `--lesli-color-danger-800` |
| Danger 900 | `#541E18` | `lesli-color(danger, 900)` | `--lesli-color-danger-900` |

**Usage guidelines**

Use the danger palette for destructive actions, critical problems, failed operations, and states that require immediate attention.

* Use **50–100** for soft danger backgrounds in error banners, destructive confirmations, and critical notices.
* Use **200–400** for borders, supporting accents, and secondary error indicators.
* Use **500–600** as the default range for destructive buttons, critical badges, icons, and primary error states.
* Use **700–900** for strong emphasis, high-contrast text, or dark critical surfaces.



# Collections palette

Collections give color identity to product areas, modules, or content groups without replacing the global primary color.

## Collections

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-maya-500 has-text-white">Maya</div>
    <div class="br-2 py-4 has-text-centered lesli-background-jade-500 has-text-white">Jade</div>
    <div class="br-2 py-4 has-text-centered lesli-background-agave-500 has-text-white">Agave</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maize-500 has-text-white">Maize</div>
    <div class="br-2 py-4 has-text-centered lesli-background-clay-500 has-text-white">Clay</div>
    <div class="br-2 py-4 has-text-centered lesli-background-orchid-500 has-text-white">Orchid</div>
    <div class="br-2 py-4 has-text-centered lesli-background-cenote-500 has-text-white">Cenote</div>
    <div class="br-2 py-4 has-text-centered lesli-background-obsidian-500 has-text-white">Obsidian</div>
</div>

## Collection color usage rules

* Do not use collection colors as the global product primary.
* Use collections for module identity, category badges, section headers, charts, avatars, tabs, and accents.
* Prefer `100` for background, `600` for accent, and `800` for text or strong iconography.

## Maya palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-maya-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maya-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maya-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maya-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maya-900 has-text-white">900</div>
</div>

| Token    | Hex       | Lesli                    | Variable                 |
| -------- | --------- | ------------------------ | ------------------------ |
| Maya 100 | `#E3EEF6` | `lesli-color(maya, 100)` | `--lesli-color-maya-100` |
| Maya 300 | `#8DAEC9` | `lesli-color(maya, 300)` | `--lesli-color-maya-300` |
| Maya 500 | `#245F93` | `lesli-color(maya, 500)` | `--lesli-color-maya-500` |
| Maya 700 | `#1E507C` | `lesli-color(maya, 700)` | `--lesli-color-maya-700` |
| Maya 900 | `#12324F` | `lesli-color(maya, 900)` | `--lesli-color-maya-900` |

## Jade palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-jade-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-jade-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-jade-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-jade-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-jade-900 has-text-white">900</div>
</div>

| Token    | Hex       | Lesli                    | Variable                 |
| -------- | --------- | ------------------------ | ------------------------ |
| Jade 100 | `#E2F1EC` | `lesli-color(jade, 100)` | `--lesli-color-jade-100` |
| Jade 300 | `#91BBB1` | `lesli-color(jade, 300)` | `--lesli-color-jade-300` |
| Jade 500 | `#2D7A68` | `lesli-color(jade, 500)` | `--lesli-color-jade-500` |
| Jade 700 | `#256656` | `lesli-color(jade, 700)` | `--lesli-color-jade-700` |
| Jade 900 | `#143F33` | `lesli-color(jade, 900)` | `--lesli-color-jade-900` |

## Agave palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-agave-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-agave-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-agave-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-agave-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-agave-900 has-text-white">900</div>
</div>

| Token     | Hex       | Lesli                     | Variable                  |
| --------- | --------- | ------------------------- | ------------------------- |
| Agave 100 | `#ECF2E7` | `lesli-color(agave, 100)` | `--lesli-color-agave-100` |
| Agave 300 | `#ACBDA2` | `lesli-color(agave, 300)` | `--lesli-color-agave-300` |
| Agave 500 | `#5D7C4D` | `lesli-color(agave, 500)` | `--lesli-color-agave-500` |
| Agave 700 | `#4F6942` | `lesli-color(agave, 700)` | `--lesli-color-agave-700` |
| Agave 900 | `#34442C` | `lesli-color(agave, 900)` | `--lesli-color-agave-900` |

## Maize palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-maize-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maize-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maize-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maize-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-maize-900 has-text-white">900</div>
</div>

| Token     | Hex       | Lesli                     | Variable                  |
| --------- | --------- | ------------------------- | ------------------------- |
| Maize 100 | `#FBF2DF` | `lesli-color(maize, 100)` | `--lesli-color-maize-100` |
| Maize 300 | `#DAC18F` | `lesli-color(maize, 300)` | `--lesli-color-maize-300` |
| Maize 500 | `#B2852D` | `lesli-color(maize, 500)` | `--lesli-color-maize-500` |
| Maize 700 | `#946E25` | `lesli-color(maize, 700)` | `--lesli-color-maize-700` |
| Maize 900 | `#594016` | `lesli-color(maize, 900)` | `--lesli-color-maize-900` |

## Clay palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-clay-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-clay-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-clay-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-clay-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-clay-900 has-text-white">900</div>
</div>

| Token    | Hex       | Lesli                    | Variable                 |
| -------- | --------- | ------------------------ | ------------------------ |
| Clay 100 | `#FAE9E4` | `lesli-color(clay, 100)` | `--lesli-color-clay-100` |
| Clay 300 | `#D9A99E` | `lesli-color(clay, 300)` | `--lesli-color-clay-300` |
| Clay 500 | `#B05A48` | `lesli-color(clay, 500)` | `--lesli-color-clay-500` |
| Clay 700 | `#944C3C` | `lesli-color(clay, 700)` | `--lesli-color-clay-700` |
| Clay 900 | `#5C2F25` | `lesli-color(clay, 900)` | `--lesli-color-clay-900` |

## Orchid palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-orchid-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-orchid-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-orchid-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-orchid-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-orchid-900 has-text-white">900</div>
</div>

| Token      | Hex       | Lesli                      | Variable                   |
| ---------- | --------- | -------------------------- | -------------------------- |
| Orchid 100 | `#EEEAF7` | `lesli-color(orchid, 100)` | `--lesli-color-orchid-100` |
| Orchid 300 | `#B8ADD3` | `lesli-color(orchid, 300)` | `--lesli-color-orchid-300` |
| Orchid 500 | `#7562A6` | `lesli-color(orchid, 500)` | `--lesli-color-orchid-500` |
| Orchid 700 | `#63538E` | `lesli-color(orchid, 700)` | `--lesli-color-orchid-700` |
| Orchid 900 | `#3F345D` | `lesli-color(orchid, 900)` | `--lesli-color-orchid-900` |

## Cenote palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-cenote-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-cenote-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-cenote-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-cenote-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-cenote-900 has-text-white">900</div>
</div>

| Token      | Hex       | Lesli                      | Variable                   |
| ---------- | --------- | -------------------------- | -------------------------- |
| Cenote 100 | `#E3F0F1` | `lesli-color(cenote, 100)` | `--lesli-color-cenote-100` |
| Cenote 300 | `#92B6B8` | `lesli-color(cenote, 300)` | `--lesli-color-cenote-300` |
| Cenote 500 | `#2E6F73` | `lesli-color(cenote, 500)` | `--lesli-color-cenote-500` |
| Cenote 700 | `#265D61` | `lesli-color(cenote, 700)` | `--lesli-color-cenote-700` |
| Cenote 900 | `#173A3D` | `lesli-color(cenote, 900)` | `--lesli-color-cenote-900` |

## Obsidian palette

<div class="columns">
    <div class="br-2 py-4 has-text-centered lesli-background-obsidian-100">100</div>
    <div class="br-2 py-4 has-text-centered lesli-background-obsidian-300">300</div>
    <div class="br-2 py-4 has-text-centered lesli-background-obsidian-500 has-text-white">500</div>
    <div class="br-2 py-4 has-text-centered lesli-background-obsidian-700 has-text-white">700</div>
    <div class="br-2 py-4 has-text-centered lesli-background-obsidian-900 has-text-white">900</div>
</div>

| Token        | Hex       | Lesli                        | Variable                     |
| ------------ | --------- | ---------------------------- | ---------------------------- |
| Obsidian 100 | `#EAEEF2` | `lesli-color(obsidian, 100)` | `--lesli-color-obsidian-100` |
| Obsidian 300 | `#ABB4BD` | `lesli-color(obsidian, 300)` | `--lesli-color-obsidian-300` |
| Obsidian 500 | `#5F6C7D` | `lesli-color(obsidian, 500)` | `--lesli-color-obsidian-500` |
| Obsidian 700 | `#505B69` | `lesli-color(obsidian, 700)` | `--lesli-color-obsidian-700` |
| Obsidian 900 | `#313942` | `lesli-color(obsidian, 900)` | `--lesli-color-obsidian-900` |
