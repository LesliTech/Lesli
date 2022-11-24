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


// · import & define local components
import Trix from 'trix'
import 'trix/dist/trix.css'


// · defining emits
const emit = defineEmits(['update:modelValue', 'change']);


// · randome id for html node
const editorId = `component-richtext-${Math.floor(Math.random() * 10000)}`
const editorNode = ref(null)        // editor node container
const editorContent = ref(null)     // input container


// · defining props
const props = defineProps({
    modelValue: {
        type: String,
        required: true,
    },
    mode: {
        type: String,
        default: 'normal',
        required: false,
        validator: (val) => ['full', 'normal', 'small', 'empty'].includes(val),
    },
    placeholder: {
        type: String,
        required: false
    }
})


// · defining props
const editorOptions = {

}


// · emits every change in the rich text editor
function handleContentChange() {

    // updates the v-model
    emit('update:modelValue', editorContent.value.value)

    // trigger the @change method
    emit('change')
}


// · waits for possible initial content to load into the richtext editor
const watchModelValue = watch(() => props.modelValue, (newContent) => {  

    // check for valid content
    newContent = newContent === undefined ? '' : newContent

    // try to avoid the content update for duplicated content
    if (editorContent?.value?.value != newContent) {

        updateEditorContent(newContent)
        
    }
    
})


onMounted(() => {
    if (props.modelValue && editorNode.value.editor.innerHTML !== props.modelValue) {
        updateEditorContent(props.modelValue)
    }
})


// ·
function updateEditorContent(content) {

    // return if content is null or empty
    if (!content || content == ""){
        editorNode.value.editor.loadHTML("")
        return
    } 

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

    // load the initial html content
    editorNode.value.editor.loadHTML(content)
    
    // after load the content, send the pointer to the end of the content
    // currently not working, maybe this needs to be moved to another function
    // and try to move when focus and if the cursor is at the begining and 
    // if the content is not empty
    editorNode.value.editor.setSelectedRange(content.length - 1)
}

</script>
<template>
    <div :class="['component-editor-richtext', props.mode]">
        <input ref="editorContent" :id="editorId" type="hidden" name="content">
        <trix-editor 
            ref="editorNode" 
            :input="editorId"
            :placeholder="props.placeholder"
            @trix-change="handleContentChange">
        </trix-editor>
    </div>
</template>
