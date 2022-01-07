# Layout components
The layout components are registered globally


## Component header

**Example:**

```html
<component-header title="Component header example">
    <div class="buttons">
        <router-link class="button" tag="button" to="/">
            <span class="icon">
                <i class="fas fa-list"></i>
            </span>
            <span>List resources</span>
        </router-link>
        <router-link class="button" tag="button" to="/">
            <b-icon icon="plus" size="is-small" />
            <span>New resource</span>
        </router-link>
    </div>
</component-header>
```

**Result:**

```raw
<component-header title="Component header example">
    <div class="buttons">
        <router-link class="button" tag="button" to="/">
            <span class="icon">
                <i class="fas fa-list"></i>
            </span>
            <span>List resources</span>
        </router-link>
        <router-link class="button" tag="button" to="/">
            <b-icon icon="plus" size="is-small" />
            <span>New resource</span>
        </router-link>
    </div>
</component-header>
```

## Component toolbar

**Example:**

```html
<component-toolbar @search="doSearch">
    <div class="control">
        <b-select 
            class="mr-2"
            icon="box"
            icon-pack="fas"
            placeholder="Select a bucket">
            <option v-for="bucket in [{id:1,name:'option1'}]" :key="bucket.id" :value="bucket">
                {{ bucket.name }}
            </option>
        </b-select>
    </div>
    <div class="control">
        <input class="input is-primary" type="text" placeholder="Primary input">
    </div>
    <div class="control">
        <div class="select">
            <select>
                <option :value="20">20</option>
                <option :value="50">50</option>
                <option :value="75">75</option>
                <option :value="100">100</option>
            </select>
        </div>
    </div>
    <template slot="second-row">
        <button class="button is-info is-outlined">button 1</button>
        <button class="button is-info is-outlined">button 2</button>
        <button class="button is-info is-outlined">button 3</button>
        <button class="button is-info is-outlined">button 4</button>
        <button class="button is-info is-outlined">button 5</button>
    </template>
</component-toolbar>
```

**Result:**

```raw
<component-toolbar @search="doSearch">
    <div class="control">
        <b-select 
            class="mr-2"
            icon="box"
            icon-pack="fas"
            placeholder="Select a bucket">
            <option v-for="bucket in [{id:1,name:'option1'}]" :key="bucket.id" :value="bucket">
                {{ bucket.name }}
            </option>
        </b-select>
    </div>
    <div class="control">
        <input class="input is-primary" type="text" placeholder="Primary input">
    </div>
    <div class="control">
        <div class="select">
            <select>
                <option :value="20">20</option>
                <option :value="50">50</option>
                <option :value="75">75</option>
                <option :value="100">100</option>
            </select>
        </div>
    </div>
    <template slot="second-row">
        <button class="button is-info is-outlined">button 1</button>
        <button class="button is-info is-outlined">button 2</button>
        <button class="button is-info is-outlined">button 3</button>
        <button class="button is-info is-outlined">button 4</button>
        <button class="button is-info is-outlined">button 5</button>
    </template>
</component-toolbar>
```
