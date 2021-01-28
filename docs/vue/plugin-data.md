
# Vue plugin data  
Vue global state management built on top of observables



## Initialize
First register your reactive objects into app.js through app builder function

example:

```javascript

// core/app/vue/users/app.js

app("Core", "[list|new|edit|show]", "/administration/users", [{
    path: "/",
    component: appList
},{
    path: "/new",
    component: appNew
},{
    path: "/:id",
    component: appShow
},{
    path: "/:id/edit",
    component: appShow
}], {
    user: {}, // reactive object for vue data plugin
    options: {} // reactive object for vue data plugin
})

```

Now we have a global reactive object for our users, this object is available in all the components that belongs to the current app through this.data property



## Add data to our plugin

example:

```javascript

// core/app/vue/users/apps/show.vue

export default {
    data() {
        return {
    },
    mounted() {
        this.user_id = this.$route.params.id
        this.getUser()
        this.getOptions()

        // here we can execute the action getUser from any component that belongs to the current app
        this.data.users.getUser = () => this.getUser()
    },
    methods: {
        getUser() {
            this.http.get(`/administration/users/${this.user_id}.json`).then(result => {
                // store result into our data users container
                this.data.user = result.data
            })
        },
        getOptions(){
            this.http.get("/administration/users/options.json").then(result => {
                // store result into our data users container
                this.data.options = result.data
            })
        }
    }
}

```
**IMPORTANT:** The this.data plugin is completelly different than the data() method of vue components



## Working with data from external components

There are two ways to work with data, through plugin instance and watchers

example:

```javascript

// core/app/vue/users/components/card-information.vue
export default {
    data(){
        return {
        }
    },
    watch: {
        // working with data through vue watcher
        "data.user": function(user) {
            console.log(users)
        }
    }
}

```
```html

<template>
    <div>
        <!-- working with data through plugin instance -->
        {{ data.users }}

        <!-- execute an action from different component -->
        <button @click="data.users.getUsers()">get users<button>

    </div>
</template>

```
