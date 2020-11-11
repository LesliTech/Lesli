<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h2 align="center">Vue: app.js</h2>


### Description
This is the global application and everything runs by this. This is why all the configuration is in here. This file import all the libraries, frameworks, plugins, functions and vue components; and loads them to the Vue app, so we can access it from anywhere while using the function that is exported in this file. In here, is where the Vue App is mounted to the html DOM.


<hr>


### Initialize
This is the app inizialiter and initialize all the plugins and load the Vue instance on the DOM. It can be access by importing the function that is exported in the file and using it like this:

```js
// · Import main app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import app from "LesliVue/app"



// · Import apps and components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import appList from "./apps/list.vue"
import appNew from "./apps/new.vue"
import appEdit from "./apps/edit.vue"
import appShow from "./apps/show.vue"


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
app("Mitwerken", "[list|new|edit|show]", "/projects", [{
    path: "/",
    component: appList
}, {
    path: "/new",
    component: appNew
}, {
    path: "/:id/edit",
    component: appEdit
}, {
    path: "/:id",
    component: appShow
}], {
    project: {}
})

```

As you can see, you must especify the module, the apps that will work on, the main route, and the list of routes to be loaded, where which route consists of the path and the component to be loaded. Optionally, you can define the last parameter, which is the global data state manager, so the variables that you define here, will be available in the global app.

<hr>


### Exported function

**app**
* params:
    * **String** module: The name of the module where the app is located.
    * **String** apps: The list of apps that will be available on.
    * **String** base_path: The base path where is loaded.
    * **Array** routes: A list of routes that will be loaded, each route consist of a path and component.
    * **Hash** data: A hash that contains variables to be loaded on the global state manager.
* returns: [**Null**]
* description: This is used to register new apps to the global Vue instance.
* example:
```js
// · Import main app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import app from "LesliVue/app"



// · Import apps and components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import appShow from "./apps/show.vue"


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
app("CloudBabel", "[]", "/babel/translations", [{
    path: "/",
    component: appShow
}])

```
