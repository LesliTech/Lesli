# Buttons

lesli-button provides a wrapper around standard buttons, allowin manipulate the state of the button and the ability to use different icon families like material icons and remixicons.

You can build action buttons and vue router links.

## Props and emited functions
**:label**
(String) Text of the button

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

## Examples

**Example simple plain button:**

```html
    <lesli-button label="My button">
    </lesli-button>
```

**Result:**

```raw
    <lesli-button label="My button">
    </lesli-button>
```

**Example of a simple vue router link:**

```html
    <lesli-button :to="url.admin('users/new')" label="My button">
    </lesli-button>
```

**Result:**

```raw
    <lesli-button :to="url.admin('users/new')" label="My button">
    </lesli-button>
```

**Example of a loding button:**

```html
    <lesli-button :loading="true" label="My loading button">
    </lesli-button>
```

**Result:**

```raw
    <lesli-button :loading="true" label="My loading button">
    </lesli-button>
```

**Example of icon button:**

```html
    <lesli-button :mdi="refresh" label="My refresh button">
    </lesli-button>
```

**Result:**

```raw
    <lesli-button :mdi="refresh" label="My refresh button">
    </lesli-button>
```
