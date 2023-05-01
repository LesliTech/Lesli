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
import { onMounted, ref } from "vue"

// · import store
import { useCloudObjectFileStore } from "Lesli/cloudobjects/stores/file.js"
import { useLayout } from "Lesli/shared/stores/layout"

// · implement store
const store = useCloudObjectFileStore()
const storeLayout = useLayout()

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · columns of the table
const columns = [
    {
        field: "name",
        label: translations.core.shared.column_files_name,
    },
    {
        field: "file_type",
        label: translations.core.shared.column_files_file_type,
    },
    {
        field: "created_at",
        label: translations.core.shared.column_created_at,
    },
]


/**
* @description function that is called when the user click on the new file button.
*/
const onClickNewFile = () => {
    storeLayout.showFiles = !storeLayout.showFiles
}

onMounted(() => {
    // · fetch the files from server
    store.fetchFiles()
})

</script>

<template>

    <div class="is-flex is-justify-content-end mb-4">
        <button class="button is-primary"  type="button" @click="onClickNewFile">
            <span >
                {{ translations.core.shared.view_title_new_file }}
            </span>
            <span class="icon is-small">
                <span class="material-icons">add</span>
            </span>
        </button>
    </div>

    <lesli-table :columns="columns" :records="store.files">
        <template #options="record">
                <a class="dropdown-item" :href="`${store.getUrl(record.value)}.json`" target="_blank">{{ translations.core.shared.view_btn_view_file }}</a>
                <a class="dropdown-item" :href="`${store.getUrl(record.value)}.json?download=true`" download>{{ translations.core.shared.view_btn_download }}</a>
                <a class="dropdown-item" @click="store.deleteFile(record.value)">{{ translations.core.shared.view_btn_delete }}</a>
        </template>
    </lesli-table>

</template>
