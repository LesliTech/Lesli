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
