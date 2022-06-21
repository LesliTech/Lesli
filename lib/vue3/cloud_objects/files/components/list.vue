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

import { onMounted, computed } from "vue"
import { useFileStore } from "LesliVue/stores/file"

const store = useFileStore()
const files = computed(() => store.files)
const cloudModule = computed(() => store.cloudModule)
const cloudId = computed(() => store.cloudId)

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
