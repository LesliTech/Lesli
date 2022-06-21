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

import { defineAsyncComponent } from "vue"
import { useFileStore } from "LesliVue/stores/file"

const filesForm = defineAsyncComponent(() => import("./components/form.vue"))
const filesList = defineAsyncComponent(() => import("./components/list.vue"))

const store = useFileStore()

const props = defineProps({
    name: {
        type: String,
        required: false,
        default: "Files",
    },
    showNewFileTab: {
        type: Boolean,
        default: true,
    },
    showListFilesTab: {
        type: Boolean,
        default: true,
    },
    cloudModule: {
        type: String,
        required: false,
    },
    cloudId: {
        type: String,
        required: false,
    },
    // This is the max size of each file in bytes
    maxSizeFile: {
        type: Number,
        required: false,
        default: 1000000,
    },
    maxFiles: {
        type: Number,
        required: false,
        default: 10,
    },
})


store.cloudModule = props.cloudModule
store.cloudId = props.cloudId
store.maxFiles = props.maxFiles
store.maxSizeFile = props.maxSizeFile

</script>

<template>
    <lesli-tabs>
        <lesli-tab-item title="New Documents">
            <files-form></files-form>
        </lesli-tab-item>

        <lesli-tab-item title="All Documents">
            <files-list></files-list>
        </lesli-tab-item>
    </lesli-tabs>
</template>
