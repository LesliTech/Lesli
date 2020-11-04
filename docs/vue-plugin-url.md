<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h2 align="center">Vue plugins: URL</h2>


### Description
Vue global url constructor


<hr>


### Initialize
This plugin initializes automatically when the app is loaded and is included in every standard vue app.
It can be accessed from js like **this.url** and from html like **url**.

Example of accessing it:
```html
<script>

export default {
    methods: {
        goToExampleMethod(event) {
            this.url.go('/administration/users') // This is the way to use it on js
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="Example Vue">
            <div class="buttons">
                <!-- This is the way to use it from html -->
                <b-button size="is-primary" @click="url.go(`/projects/new`)" >
                    <b-icon icon="plus" size="is-small" />
                    <span>New</span>
                </b-button>
            </div>
        </component-header>
    </section>
</template>
```


<hr>


### List of available methods

**go**
* params:
    * **String** url: Some url on the app.
* returns: [**Null**]
* description: This method will redirect to the specified url.
* example:
```js
this.url.go('/administration/users')
```


**to**
* params:
    * **String** path: Some path of the app.
* returns: [**URL**]
* description: This method will return a construted url from some given path. If no path is defined it takes the root value "/".
* example:
```js
this.url.to('/administration/users') // This will output:
/**
URL
    hash: ""
    host: "127.0.0.1:3000"
    hostname: "127.0.0.1"
    href: "http://127.0.0.1:3000/administration/users"
    origin: "http://127.0.0.1:3000"
    password: ""
    pathname: "/administration/users"
    port: "3000"
    protocol: "http:"
    search: ""
    searchParams: URLSearchParams {  }
    username: ""
**/
```


<hr>
