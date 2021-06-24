<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h3 align="center">Vue plugin data</h3>

<hr/>


#### Description
Vue storage plugin. It works as a centralized web storage wich stores data from client side using local storage and session storage.  

<hr>

#### Initialize
This plugin initializes automatically when the app is loaded and is included in every standard vue app.
It can be accessed from js like **this.storage.(global|local|storage)** .

<hr>

#### How to use it

example with a vue app using local storage.
```html
<script>
export default {
    data(){
        return {
            filters: {
                search: '',
                type: ''
            }
        }
    },

    mounted(){
        this.localStorage()
    },

    methods: {
        localStorage(){
            
            this.filters = {
                search: 'search test',
                type: 'type test'
            }


            // store an object with filters key on the local storage
            this.storage.local("filters", this.filters) 

            // Printing the values stored on local storage
            console.log(this.storage.local("filters")) 

            // Should print something like
            /*
            {
                search: 'search test',
                type: 'type test'
            }
            */
        }
    }
}
</script>
<template>
    <section class="application-component">
        {{ this.storage.local("filters") }}
    </section>
</template>

```

**IMPORTANT:**

Assuming we want yo use storage plugin on company index. 
- controller: companies
- method: index
- key: filters
- current_user_id: 2
- engine : my_engine

The complete key where the filters are being stored will be: 
- **engine_controller_method-current_user_id_key**: my_engine_companies_index-2-filters
<hr>



#### List of available functions

**local()**
- params:
    - **String** key: The key of the object 
    - **Object** data: The data to save on a specific key
- returns: [**Object**|**Void**] 
- description: This function use local storage and has two purposes. Retrieves data on a specific giving key if data param is null. If a data param is included the function saves the data on the  the specific key. 
- example:
```js
    this.storage.locale("filters", {name: 'test'}) //save the object on the filters key 
    this.storage.locale("filters") //retrieves the data stored on the filters key
```

**session()**
- params:
    - **String** key: The key of the object 
    - **Object** data: The data to save on a specific key
- returns: [**Object**|**Void**] 
- description: This function use session storage and has two purposes. Retrieves data on a specific giving key if data param is null. If a data param is included the function saves the data on the  the specific key. 
- example:
```js
    this.storage.session("filters", {name: 'test'}) //save the object on the filters key 
    this.storage.session("filters") //retrieves the data stored on the filters key
```

**global()**
- params:
    - **String** key: The key of the object 
    - **Object** data: The data to save on a specific key
- returns: [**Object**|**Void**] 
- description: This function use local storage and has two purposes. Retrieves data on a specific giving key if data param is null. If a data param is included the function saves the data on the specific key. The main idea of using this function is to has a global place to store general keys on the client-side. 
- example:
```js
    this.storage.global("filters", {name: 'test'}) //save the object on the filters key 
    this.storage.global("filters") //retrieves the data stored on the filters key
```
