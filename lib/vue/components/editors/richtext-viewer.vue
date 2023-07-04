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
