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


**toString**

- params:
    - String api: Defaults to false. If this param is set to true, the returned url will have a **.json** extension.
- returns: String representing the URL object
- description: Returns a string representation of the url object. If the optional param **api** is set to true, it adds a 
    **.json** extension. Note that  you don't have to call this method when using this plugin along with the **http** plugin.

Example:

```javascript
console.log(this.url.babel('/translations').toString())
// The output will be: '/babel/translations'
console.log(this.url.babel('/translations').toString(true))
// The output will be '/babel/translations.json'
```

**search**
- params:
    - String text: The text to be searched
- returns: A URL object that has a **search** param set to the value of **text**
- description: Adds a query param to the URL object. The key is always **search** and the value is the **text** received by the function.

Example:

```javascript
    this.http.get(this.url.babel('/translations').search('hello'))
    // This will perform a GET request to /babel/translations.json?search=hello
```

**paginate**
- params:
    - Integer page: The page number you want to retrieve
    - Integer perPage: Defaults to 0. The amount of records you want to retrieve
- returns: A URL object that has the **page** and **perPage** param set to the respective values.
- description: Adds two query param to the URL object. The first one is the page number and the second one the total
    number of records to be received. This is a standard format already implemented in the backend.

Example:

```javascript
    let request_url = this.url.babel('/translations').search('hello').paginage(1, 15)
    this.http.get(request_url)
    // This will perform a GET request to /babel/translations.json?search=hello&page=1&perPage=15
```

**order**
- params:
    - String column: The column by which you want to order the results
    - String direction: Defaults to null. Either 'asc' or 'desc'. This indicates the sorting order.
- returns: A URL object that has the **orderBy** and **order** param set to the respective values.
- description: Adds two query param to the URL object. The first one is the order column and the second one the order itself.
    This is a standard format already implemented in the backend.

Example:

```javascript
    let request_url = this.url.babel('/translations').search('hello').order('name', 'desc')
    this.http.get(request_url)
    // This will perform a GET request to /babel/translations.json?search=hello&orderBy=name&order=desc
```

**filters**
- params:
    - Object filters: An object containing complex filters
- returns: A URL object that has the **filters** params parsed and added to the query params of the url.
- description: Deeply parses the **filters** param and adds it to the query params of the url.

Example:

```javascript
    let request_url = this.url.babel('/translations').filter({a: {b: 1, c: 2}, d: 3})
    this.http.get(request_url)
    // This will perform a GET request to 
    // /babel/translations.json?filters[a][b]=1&filters[a][c]=2&filters[d]=3
```
