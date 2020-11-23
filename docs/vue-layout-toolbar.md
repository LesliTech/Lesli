<p align="center">
    <img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h3 align="center">Vue plugin date</h3>

<hr/>


#### Description
Vue  generic toolbart component. This component provides a standard layout for adding search and filter elements. It contains a search input for general queries and a couple of slots in case you want to add extra HTML elements. It is designed mainly to be used in the **index** views.



<hr/>



#### Initialize
This component is imported automatically from the core, so you do not have to declare it or import it in the *components* part of the *script* section. Instead, you can use it directly in the *template* section:

```html
<template>
    <section>
        <div class="my-div-class">
            <component-toolbar></component-toolbar>
        </div>
    </section>
</template>
```

#### Props
- **String *<span style="color:blue">search-text</span>*:**  The placeholder text to be displayed when the search field is empty. If no field is provided, it defaults to "**Search...**"

- **String *<span style="color:blue">initial-value</span>*:**  The initial value to be displayed into the search input. If defaults to **null**

#### Functions

- **void search(String text_to_be_searched)**
    - params:
        - **String** *<span style="color:blue">text_to_be_searched</span>*: The text that the user typed into the input. This function has a small delay, in case of backend search, so not all characters typed will trigger an HTTP request.
    - returns: [**void**]
    - description: You can use this function from your own component to do some action when the search is triggered from the component. On a normal execution, the search is triggered 0.8s after the user stopped writting on the input.
    - example:
```hml
    <!-- When the user writes a text in the search input, the function seachProjects will be executed -->
    <component-toolbar
        v-if="filters_ready"
        search-text="Filter by Code"
        @search="searchProjects"
    >
```

#### Slots

- **default slot**: If you want to add extra HTML elements to the toolbar (for example, an autocomplete, or a dropdown), you can use the default slot. Since this is the default slot, you can skip the **< template >** directive and write your html directly inside the toolbar component:
```hml
    <component-toolbar search-text="Search..." @search="searchProjects">
        <!-- These components will go into the default slot -->
        <div class="control">
            <div class="select">
            <select v-model="filters.per_page" name="projects-filters-per-page">
                <option :value="10">10</option>
                <option :value="15">15</option>
                <option :value="30">30</option>
                <option :value="50">50</option>
            </select>
            </div>
        </div>
    </component-toolbar>
```

- **slot[name=second-row]**: In case you have several filters, and/or you have a to adapt your view for small screens, you can use the **second-row** slot to place some HTML elements inside the toolbar, but on a row below.
```hml
    <component-toolbar search-text="Search..." @search="searchProjects">
        <!-- These components will go into the default slot (first row) -->
        <div class="control">
            <div class="select">
            <select v-model="filters.per_page" name="projects-filters-per-page">
                <option :value="10">10</option>
                <option :value="15">15</option>
                <option :value="30">30</option>
                <option :value="50">50</option>
            </select>
            </div>
        </div>
        <!-- These components will be on a row bellow -->
        <template v-slot:second-row>
            <div class="column is-12">
                <div class="field is-grouped component-toolbar">
                    <div class="control">
                        <div class="select">
                            <select  v-model="filters.importance" >
                                <option value=""> {{ translations.tasks.search_by_importance_text_placeholder }} </option>
                                <option value="normal">Normal</option>
                                <option value="important">Important</option>
                                <option value="urgent">Urgent</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </template>
    </component-toolbar>
```