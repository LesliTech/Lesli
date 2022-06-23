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

// · get translations from store
const translations = store.translations

// · get in a reactive way the files in server
const files = computed(() => store.files)

// · get in a reactive way the current cloud module
const cloudModule = computed(() => store.cloudModule)

// · get in a reactive way the current cloud object
const cloudObject = computed(() => store.cloudObject)

// · get in a reactive way the current cloud object id
const cloudObjectId = computed(() => store.cloudObjectId)

// · columns of the table
const columns = [
    {
        field: "name",
        label: translations.core.shared.column_files_name,
    },
    {
        field: "file_type",
        label: translations.core.shared.column_files_type,
    },
    {
        field: "created_at",
        label: translations.core.shared.column_created_at,
    },
    {
        field: "id",
        label: translations.core.shared.view_table_header_actions,
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
            <p class="card-header-title subtitle">{{ translations.core.shared.view_text_show_all_files }}</p>
        </header>

        <div class="card-content">
            <lesli-table :columns="columns" :records="files">
                <template #id="{ column, value }">
                    <a 
                        :href="store.getUrl(value)" 
                        target="_blank"
                        class="button mr-2"
                        
                    >
                        <span class="material-icons">visibility</span>
                    </a>
                    <a
                        :href="`${store.getUrl(value)}?download=true`" 
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
