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
import { ref, watch, computed } from "vue"

// · defining emits
/**
 * @files this event emits the files when the user drops, selects or deletes the files
 * @eventsAfterClear this event is emitted when the files are cleared, this is useful to clear something in a father component
 */
const emit = defineEmits(["filesChange", "eventsAfterClear"])

// · defining props
const props = defineProps({
    // · prop that indicates if the file uploader component have to clear the files
    // · if this prop is true the files will be cleared, is used to clear files when
    // · the father component indicates
    clearFiles: {
        type: Boolean,
        required: false,
        default: false,
    },
    // · prop that indicates if the file type
    fileType: {
        type: String,
        required: false,
        default: "",
    },
    // · prop that shows the drop zone or not
    isDropzoneActive: {
        type: Boolean,
        required: false,
        default: true,
    },
    acceptedFiles: {
        type: String,
        required: false,
        default: "image/*",
    },
})

// · translations
const translations = {
    core: {
        shared: I18n.t("core.shared")
    }
}

// · this variable idicates if drag and drop is enabled
const isDragActive = ref(false)

// · this variable have the files that user have dropped or selected
const files = ref([])
const imagesToRender = ref([])

// · this is a reactive prop variable that indicates if the component have to clear the files
const clearCurrentFiles = computed(() => props.clearFiles)

/**
 * @description this function change the value of the dragActive variable
 */
const toggleIsDragActive = () => {
    if (files.value.length === 0) {
        isDragActive.value = !isDragActive.value
    }
}


/**
 * @param {Event} event is the event that triggered the function
 * @description this function is called when the user select a files
 */
const onSelectOrDropFiles = (event, isDropzone = true) => {
    files.value = []
    imagesToRender.value = []
    // · get the files that user have selected
    files.value = !isDropzone ? Array.from(event.dataTransfer.files) : Array.from(event.target.files)
    // · if user have selected files, the drag and drop is enabled
    isDragActive.value = isDropzone

    for (let i = 0; i < files.value.length; i++) {
        const reader = new FileReader()
        reader.onload = (e) => {
            imagesToRender.value.push(e.target.result)
        }
        reader.readAsDataURL(files.value[i]);
    }

    // · emit the files that user have selected
    emit("filesChange", files.value)
}

/**
 * @param {File} fileToRemove is the file that user want to remove
 * @description this function is called when the user click on the remove button of a file
 */
const onRemoveFile = (fileToRemove, position) => {
    
    if (files.value.length === 0) return
    
    // · update the files without the file that user want to remove
    files.value = files.value.filter((file) => file.name !== fileToRemove.name)

    // · update the images to render without the image that user want to remove
    imagesToRender.value.splice(position, 1)

    // · emit the files without the file that user want to remove
    emit("filesChange", files.value)
}

// · this watcher is called when the reactive variable clearCurrentFiles changes
watch(clearCurrentFiles, (value) => {
    // · if the value is true, clear the files
    if (value) {
        files.value = []
        // · emit an event after clear the files
        // · this event is useful to clear something in a father component
        emit("eventsAfterClear")
    }
})
</script>

<template>
    <div class="lesli-file-uploader mt-2">
        
        <template v-if="!isDropzoneActive">
            <label for="file">
                <span class="button is-primary">
                    <span>{{ translations.core.shared.view_text_add_new_files }}</span>
                    <span class="icon is-small">
                        <span class="material-icons">add</span>
                    </span>
                </span>
                <input
                    type="file"
                    @change="onSelectOrDropFiles"
                    name="file"
                    id="file"
                    class="is-hidden"
                    multiple
                    :accept="props.acceptedFiles"
                />
            </label>
            <div v-if="files.length !== 0" class="preview mt-5 mb-4">
                <div v-for="(file, i) in files" :key="i" class="preview-item">
                    <img :src="imagesToRender[i]" alt="">
                    <span class="material-icons" @click="onRemoveFile(file, i)">cancel</span>
                </div>
            </div>
        </template>

        <template v-else>
            <div v-if="files.length !== 0" class="my-4">
                <div v-for="(file, i) in files" :key="i" class="item mt-4 ml-0 is-flex is-justify-content-space-between is-align-items-center is-fullwidth box">
                    <div>
                        <p class="has-text-weight-semibold">{{ file.name }}</p>
                        <p>{{ props.fileType }}</p>
                    </div>
                    <button
                        class="button is-white delete-button ml-2 is-round"
                        @click="onRemoveFile(file)"
                    >
                        <span class="delete-icon material-icons">delete</span>
                    </button>
                </div>
            </div>
            <div
                v-if="isDropzoneActive"
                class="dropzone is-flex is-flex-direction-column is-justify-content-center is-align-items-center p-4 pointer"
                @dragenter.prevent="toggleIsDragActive()"
                @dragleave.prevent="toggleIsDragActive()"
                @dragover.prevent
                @drop.prevent="onSelectOrDropFiles($event, false)"
            >
                <div class="is-flex is-flex-direction-column is-align-items-center">
                    <span class="upload-icon material-icons">file_upload</span>
                    <h5 class="mt-4">{{ translations.core.shared.view_text_drag_files }}</h5>
                    <p class="mt-1">{{ translations.core.shared.view_text_prefer_question }}</p>
                    <label
                        for="file"
                        class="mt-2 is-flex is-flex-direction-column is-align-items-center"
                    >
                        <span class="button is-primary is-small">
                            {{ translations.core.shared.view_text_select_files }}
                        </span>
                        <input
                            type="file"
                            @change="onSelectOrDropFiles"
                            name="file"
                            id="file"
                            class="is-hidden"
                            multiple
                            :accept="props.acceptedFiles"
                        />
                    </label>
                </div>
            </div>
        </template>
    </div>
</template>
