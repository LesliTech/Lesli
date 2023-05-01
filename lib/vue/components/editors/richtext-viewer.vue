<script setup>
/*

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { ref, reactive, onMounted, watch, getCurrentInstance } from "vue"


// · defining props
const props = defineProps({
    modelValue: {
        type: String,
        required: true,
    }
})


// ·
const html = ref("")

// ·
onMounted(() => {
    updateEditorContent(props.modelValue)
})


// ·
function updateEditorContent(content) {

    // return if content is null or empty
    if (!content || content == "") return;

    try {

        // convert all quill JSON content to JSON
        let json = JSON.parse(content)

        // to keep compatibility we stored quill content as { delta: {}, html: {} }
        // so now it is easy to migrate using the html content stored in the json if it exists
        if (json.html && json.html != "") {
            content = json.html
        }

        // TODO: before we started saving the quill content as a hash including delta and html formats
        // we were saving only the delta content which is a ugly JSON, if we need to add compatibility
        // with that old quill content we have to install the delta parser and then convert delta to html
        
    } catch(ex) {
        // it was not possible to parse content as json, that means this content does not comes
        // from the old quill content saved as JSON :) 
    }

    html.value = content

}


// · waits for possible initial content to load into the richtext editor
const watchModelValue = watch(() => props.modelValue, (newContent) => {  

    // stop the watcher once received the content
    watchModelValue()

    updateEditorContent(newContent)
    
})
</script>
<template>
    <div v-html="html"></div>
</template>
