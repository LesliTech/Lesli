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
import { onMounted, computed } from "vue"

// · import store
import { useFileStore } from "LesliVue/stores/cloud-objects/file"

// · implement store
const store = useFileStore()

// · get in a reactive way the files in server
const files = computed(() => store.files)

// · get in a reactive way the current cloud module
const cloudModule = computed(() => store.cloudModule)

// · get in a reactive way the current cloud id
const cloudId = computed(() => store.cloudId)

// · columns of the table
const columns = [
    {
        field: "name",
        label: "Name",
    },
    {
        field: "file_type",
        label: "File Type",
    },
    {
        field: "created_at",
        label: "Created At",
    },
    {
        label: "Actions",
        field: "id",
    }
];

onMounted(() => {
    // · fetch the files from server
    store.fetchFiles()
})

</script>

<template>
    <div class="card">
        <header>
            <p class="card-header-title subtitle">All files</p>
        </header>
        <div class="card-content">
            <lesli-table :columns="columns" :records="files">
                <template #id="{ column, value }">
                    <a 
                        :href="`/${cloudModule}/${cloudId}/files/${value}`" 
                        target="_blank" 
                        class="button mr-2"
                    >
                        <span class="material-icons">visibility</span>
                    </a>
                    <a
                        :href="`/${cloudModule}/${cloudId}/files/${value}?download=true`" 
                        download
                        class="button mr-2"
                    >
                        <span class="material-icons">download</span>
                    </a>
                    <button class="button mr-2 is-danger" @click="store.deleteFile(value)">
                        <span class="material-icons">delete</span>
                    </button>
                </template>
            </lesli-table>
        </div>
    </div>
</template>
