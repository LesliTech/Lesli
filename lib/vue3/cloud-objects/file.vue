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
import { defineAsyncComponent } from "vue"

// · import store
import { useCloudObjectFileStore } from "LesliVue/stores/cloud-objects/file"

// · import components with lazy loading
const filesForm = defineAsyncComponent(() => import("./file/form.vue"))
const filesList = defineAsyncComponent(() => import("./file/list.vue"))

// · implement store
const store = useCloudObjectFileStore()

// · get translations from store
const translations = store.translations

// · defining props
const props = defineProps({
    // · prop that indicates if the will be shown the new file tab, by default it is true.
    showNewFileTab: {
        type: Boolean,
        required: false,
        default: true,
    },
    // · prop that indicates if the will be shown the list files tab, by default it is true.
    showListFilesTab: {
        type: Boolean,
        required: false,
        default: true,
    },
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the resource that you need to interact with.
    cloudObject: {
        type: Object,
        required: true,
    },
    // · prop that indicates the object id of the resource that you need to interact with.
    cloudObjectId: {
        type: String,
        required: true,
    },
    // · prop the indicates the maximun size of each file that can be uploaded,
    // · by default it is 1MB but the value is in bytes. That means that 
    // · if you want to upload a file with a size of 5MB you need to set the value to 5000000.
    maxSizeFile: {
        type: Number,
        required: false,
        default: 1000000,
    },
    // · prop that indicates the maximun number of files that can be uploaded, by default it is 10.
    maxFiles: {
        type: Number,
        required: false,
        default: 10,
    },
})

// set cloudModule to store
store.cloudModule = props.cloudModule
// set cloudId to store
store.cloudObject = props.cloudObject
// set cloudObjectId to store
store.cloudObjectId = props.cloudObjectId
// set maxFile to store
store.maxFiles = props.maxFiles
// set maxSizeFile to store
store.maxSizeFile = props.maxSizeFile
</script>

<template>
    <lesli-tabs>
        <lesli-tab-item :title="translations.core.shared.view_tab_title_files_new">
            <files-form></files-form>
        </lesli-tab-item>

        <lesli-tab-item :title="translations.core.shared.view_tab_title_files_list">
            <files-list></files-list>
        </lesli-tab-item>
    </lesli-tabs>
</template>
