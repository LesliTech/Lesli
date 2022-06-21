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

import { computed, ref, watch } from "vue"
import { useFileStore } from "LesliVue/stores/file"

const emit = defineEmits(["files"])

const store = useFileStore()

const dragActive = ref(false)
const droppedFiles = ref([])
const clearDropZone = computed( () => store.clearDropZone )

const toggleActive = () => {
    if (droppedFiles.value.length === 0) {
        dragActive.value = !dragActive.value
    }
}

const drop = (event) => {
    droppedFiles.value = Array.from(event.dataTransfer.files)
    emit("files", droppedFiles.value)
}

const selectedFiles = (event) => {
    droppedFiles.value = Array.from(event.target.files)
    dragActive.value = true
    emit("files", droppedFiles.value)
}

const clearDropped = (fileToRemove) => {
    droppedFiles.value = droppedFiles.value.filter(
        (file) => file.name !== fileToRemove.name
    )
    emit("files", droppedFiles.value)
}

watch(clearDropZone, (value) => {
    if (value) {
        droppedFiles.value = []
        store.clearDropZone = false
    }
})
</script>

<template>
    <div
        class="lesli-drop-zone is-flex is-flex-direction-column is-justify-content-center is-align-items-center p-4 pointer"
        @dragenter.prevent="toggleActive()"
        @dragleave.prevent="toggleActive()"
        @dragover.prevent
        @drop.prevent="drop"
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
                    @change="selectedFiles"
                    name="file"
                    id="file"
                    class="is-hidden"
                    multiple
                    accept="image/png, image/jpeg, image/jpg"
                />
            </label>

            <div
                v-if="droppedFiles.length !== 0"
                class="mt-4 is-flex is-align-items-center is-flex-wrap-wrap is-justify-content-center"
            >
                <div v-for="(file, i) in droppedFiles" :key="i" class="m-4">
                    <span>File: {{ file.name }}</span>
                    <button
                        class="button is-white delete-button ml-2 is-round"
                        @click="clearDropped(file)"
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
