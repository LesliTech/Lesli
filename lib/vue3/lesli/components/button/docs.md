# Buttons

lesli-button provides a wrapper around standard buttons, allowing manipulate the state of the button and the ability to use icon family like material icons.

You can build action buttons and vue router links.

By default the button is outlined

## Props and emited functions
**:to**
(Object) Lesli URL instance 

**:icon**
(String) Material Icon name

**:loading**
(Boolean) Indicates if the button is waiting to finish and action

**@click**
(Function) Callback for clicking action

**primary**
(Boolean) Style primary for the button (default)

**solid**
(Boolean) Style solid for the button 

## Slots
This component accepts a slot for the button text.

## Examples

**Example simple plain button:**

```html
    <lesli-button>
        My button
    </lesli-button>
```

**Result:**

```raw
    <lesli-button>
        My button
    </lesli-button>
```

**Example of a simple vue router link:**

```html
    <lesli-button :to="url.admin('users/new')">
        My button
    </lesli-button>
```

**Result:**

```raw
    <lesli-button :to="url.admin('users/new')">
        My button
    </lesli-button>
```

**Example of a loding button:**

```html
    <lesli-button :loading="true">
        My loading button
    </lesli-button>
```

**Result:**

```raw
    <lesli-button :loading="true">}
        My loading button
    </lesli-button>
```

**Example of icon button:**

```html
    <lesli-button icon="refresh">
        My refresh button
    </lesli-button>
```

**Result:**

```raw
    <lesli-button icon="refresh">
        My refresh button
    </lesli-button>
```
**Example of solid button:**

```html
    <lesli-button icon="refresh" solid>
        My outlined button
    </lesli-button>
```

**Result:**

```raw
    <lesli-button icon="refresh" solid>
        My outlined button
    </lesli-button>
```
