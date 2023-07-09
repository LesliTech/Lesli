<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
        required: false
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

    // load initial content, mostly from database
    if (props.modelValue && editorNode.value.editor.innerHTML !== props.modelValue) {
        updateEditorContent(props.modelValue)
    }

    // listen for file attachment, so we can store images as base64
    editorNode.value.addEventListener("trix-attachment-add", function(event) {

        // create a new reader
        let reader = new FileReader();
        
        // read the attachment
        reader.readAsDataURL(event.attachment.file);

        // listen for the file to be loaded into the reader
        reader.addEventListener('load', ()=> {

            // create a temporary img container for our new attached file
            let image = document.createElement('img');
            image.src = reader.result;
            let tmp = document.createElement('div');
            tmp.appendChild(image);

            // insert our attached image into the main html content (of the editor)
            editorNode.value.editor.insertHTML(tmp.innerHTML)

            // here we should remove the original attachment file from trix
            // but for some reason this does not work :'(
            event.attachment = ""

        }, false);

    })
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
<style>
.attachment--png {
    display: none !important;
}
</style>
