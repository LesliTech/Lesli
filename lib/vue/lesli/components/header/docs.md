# Header

The component lesli header is registered globally and is meant to be used in all the vue apps as main header

**Example:**

```html
<lesli-header title="My app header">
    <div class="buttons">
        <button class="button is-primary">fetch</button>
        <button class="button is-warning">reset</button>
    </div>
</lesli-header>
```

**Result:**

```raw
<lesli-header title="My app header">
    <div class="buttons">
        <button class="button is-primary" @click="store.fetchLogs()">fetch</button>
        <button class="button is-warning" @click="store.$reset()">reset</button>
    </div>
</lesli-header>
```
