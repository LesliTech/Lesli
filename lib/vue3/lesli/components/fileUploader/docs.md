# File Uploader

The component lesli file uploader is registered globally and is meant to be used in all the vue apps as lesli-file-uploader

## Props

**:clearFiles**
reactive prop that indicates if the file will be cleared when the do some action. If you want to clear the files you need to change the value to true. It must be a reactive variable.
- **type**: Boolean
- **required**: false
- **default**: false

*:isDropzoneActive*
prop that indicates if the dropzone will be displayed as active or not. It must be a reactive variable.
- **type**: Boolean
- **required**: false
- **default**: true

## Events
**@files-change**
event that emits the files that user has dropped or selected. If you don't use the event, you not will receive the files.
- **emits**: File[]
- **required**: true

**@eventsAfterClear**
event that can be used after the files are cleared. if the prop clearFile changes to false, this event will be emitted.
- **emits**: Void
- **required**: false

## Slots
No slots are defined for this component.

## Example 1

If you want to clear the files after the user do some action, you can use this example.

```javascript

    import { ref } from "vue"

    // you can save the files here or in the store
    const myFiles = ref([])

    // if you want to clear files after an action, the initial value 
    // for the variable that helps to clear the files is false
    const clearFileUploader = ref(false)

    // this method will be called every time the user drops,
    // selects or deletes files 
    const onFilesChange = (files) => {

        // do something with the files
        console.log(files)

        // you can save the files in the myFiles reactive variable 
        // and can keep the files up to date
        myFiles.value = files
    }

    // this method will be called when user submit some form
    const onClick = () => {
        // do something with the myFiles.value
        console.log(myFiles.value)
        
        // save the files in the server

        // clear the files
        clearFileUploader.value = true
    }
```

```html
<!-- 
    the @events-after-clear event can reset the value 
    of the variable which helps us clean up the component files
-->
<lesli-file-uploader 
    @files-change="onFilesChange"
    @events-after-clear="clearFileUploader = false"
    :clear-files="clearFileUploader"
>
</lesli-file-uploader>

<button @click="onClick">Do something</button>
```

## Example 2

If you don't want to clear the files after the user do some action, you can use this example.

```javascript

    import { ref } from "vue"

    // you can save the files here or in the store
    const myFiles = ref([])

    // this method will be called every time the user drops,
    // selects or deletes files 
    const onFilesChange = (files) => {

        // do something with the files
        console.log(files)

        // you can save the files in the myFiles reactive variable 
        // and can keep the files up to date
        myFiles.value = files
    }

    // this method will be called when user submit some form
    const onClick = () => {
        // do something with the myFiles.value
        console.log(myFiles.value)
        
        // save the files in the server

    }
```

```html
<lesli-file-uploader @files-change="onFilesChange" is-dropzone-active="false">
</lesli-file-uploader>

<button @click="onSubmit">Submit</button>

```
