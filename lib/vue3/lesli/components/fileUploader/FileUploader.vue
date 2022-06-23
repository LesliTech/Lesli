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
import { ref, watch, computed } from "vue"

// · defining emits
const emit = defineEmits(["files", "clearAfterClear"])

// · defining props
const props = defineProps({
    // · prop that indicates if the file uploader component have to clear the files
    clearFiles: {
        type: Boolean,
        required: false,
        default: false,
    },
})

// · this variable idicates if drag and drop is enabled
const dragActive = ref(false)

// · this variable have the files that user have dropped or selected
const files = ref([])

// · this is a reactive prop variable that indicates if the component have to clear the files
const clearCurrentFiles = computed(() => props.clearFiles)

/**
 * @description this function change the value of the dragActive variable
 */
const toggleActive = () => {
    if (files.value.length === 0) {
        dragActive.value = !dragActive.value
    }
}

/**
 * @param {Event} event is the event that triggered the function
 * @description this function is called when the user drop a files
 */
const onDropFiles = (event) => {
    // · get the files that user have dropped
    files.value = Array.from(event.dataTransfer.files)
    // · emit the files that user have dropped
    emit("files", files.value)
}

/**
 * @param {Event} event is the event that triggered the function
 * @description this function is called when the user select a files
 */
const onSelectFiles = (event) => {
    // · get the files that user have selected
    files.value = Array.from(event.target.files)
    // · if user have selected files, the drag and drop is enabled
    dragActive.value = true
    // · emit the files that user have selected
    emit("files", files.value)
}

/**
 * @param {File} fileToRemove is the file that user want to remove
 * @description this function is called when the user click on the remove button of a file
 */
const onRemoveFile = (fileToRemove) => {
    // · update the files without the file that user want to remove
    files.value = files.value.filter((file) => file.name !== fileToRemove.name)
    // · emit the files without the file that user want to remove
    emit("files", files.value)
}

// · this watcher is called when the reactive variable clearCurrentFiles changes
watch(clearCurrentFiles, (value) => {
    // · if the value is true, clear the files
    if (value) {
        files.value = []
        // · emit an event after clear the files
        emit("eventsAfterClear")
    }
})
</script>

<template>
    <div
        class="lesli-file-uploader is-flex is-flex-direction-column is-justify-content-center is-align-items-center p-4 pointer"
        @dragenter.prevent="toggleActive()"
        @dragleave.prevent="toggleActive()"
        @dragover.prevent
        @drop.prevent="onDropFiles"
    >
        <div class="is-flex is-flex-direction-column is-align-items-center">
            <span class="upload-icon material-icons">cloud_upload</span>
            <h5 class="mt-4">Drag a files here</h5>
            <p class="mt-1">Or if you prefer</p>
            <label
                for="file"
                class="mt-2 is-flex is-flex-direction-column is-align-items-center"
            >
                <span class="button is-primary is-small">
                    Select a files from your device
                </span>
                <input
                    type="file"
                    @change="onSelectFiles"
                    name="file"
                    id="file"
                    class="is-hidden"
                    multiple
                    accept="image/png, image/jpeg, image/jpg"
                />
            </label>

            <div
                v-if="files.length !== 0"
                class="mt-4 is-flex is-align-items-center is-flex-wrap-wrap is-justify-content-center"
            >
                <div v-for="(file, i) in files" :key="i" class="m-4">
                    <span>File: {{ file.name }}</span>
                    <button
                        class="button is-white delete-button ml-2 is-round"
                        @click="onRemoveFile(file)"
                    >
                        <span class="material-icons has-text-danger"
                            >delete</span
                        >
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
