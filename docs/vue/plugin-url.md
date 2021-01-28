# Vue plugin url
Vue global url constructor



## Initialize
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



## List of available methods

**go**

- params:
    - String url: Some url on the app.
- returns: null
- description: This method will redirect to the specified url.

Example:

```javascript
this.url.go('/administration/users')
```



**to**

- params:
    - String path: Some path of the app.
- returns: URL object
- description: This method will return a construted url from some given path. If no path is defined it takes the root value "/".

Example:

```javascript
this.url.to('/administration/users') 
{
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
}
```



**Engine routes**
Every engine has a dedicated method to build their own routes. You can access them using the engine code. 
This methods are mostly used to point to the remote API, for navigation please visit: [/development/docs/rails-layout-navigation](/development/docs/rails-layout-navigation)  

- params:
    - String path: Some path of the app.
    - String template: Template-like url querystring (optional)
- returns: URL object
- description: This method will return a construted url from some given path. If no path is defined it takes the root value "/".

Examples:

```javascript

// Basic example
this.url.babel('translations') 
// result: 
// http://127.0.0.1:3000/babel/translations.json


// Multi params
this.url.babel('translations/:id', { id: 4 }) 
this.url.babel('translations/:id/edit', { id: 4 }) 

// result: 
// http://127.0.0.1:3000/babel/translations/4.json
// http://127.0.0.1:3000/babel/translations/4/edit.json


// Integration with http plugin
this.http.get(this.url.babel('translations/:id', { id: 4 })).then(result => {
    // code...
})
```


## TODOs

- Add search params as query string
- Add method to return the url without the ".json" 
