# File Cloud Object

If you want to use this cloud object component, you need to import it in your Vue.js file with 'LesliVue/cloud_objects/files/file.vue' route.

## Props

**:cloudModule**
prop that indicates the cloud module that will be used for interacting with the backend.
- **type**: String
- **required**: true

**:cloudObject**
prop that indicates the resource that you need to interact with.
- **type**: String
- **required**: true

**:cloudObjectId**
prop that indicates the id of the resource that you need to interact with.
- **type**: String
- **required**: true

**:showNewFileTab**
prop that indicates if the will be shown the new file tab, by default it is true.
- **type**: Boolean
- **default**: true
- **required**: false

**:showListFileTab**
prop that indicates if the will be shown the list files tab, by default it is true.
- **type**: Boolean
- **default**: true
- **required**: false

**:showListFileTab**
prop that indicates if the will be shown the list files tab, by default it is true.
- **type**: String
- **default**: true
- **required**: false

**:maxSizeFile**
prop the indicates the maximun size of each file that can be uploaded, by default it is 1MB but the value is in bytes. That means that if you want to upload a file with a size of 5MB you need to set the value to 5000000.
- **type**: Number
- **required**: false
- **default**: 1000000

**:maxFiles**
prop that indicates the maximun number of files that can be uploaded, by default it is 10.
- **type**: Number
- **required**: false
- **default**: 10

**slots** 
No slots are defined for this component.



## Example

You can use defineAsyncComponent to load the component asynchronously. That means that you can use the component in the same time that you are loading the component.

```javascript
    import { defineAsyncComponent } from 'vue'

    const componentFiles = defineAsyncComponent(() => import("LesliVue/cloud_objects/files/file.vue"))
```

```html
<component-files 
    cloud-module="mitwerken"
    cloud-object="projects"
    :cloud-object-id="project.id"
></component-files>
```
