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
import { onMounted } from "vue"

import ComponentFiles from "LesliVue/cloud-objects/file.vue"

// · import lesli stores
import { useAccountSettings } from "Lesli/vue3/administration/stores/accountSettings"

// · implement stores
const storeAccountSettings = useAccountSettings()

// · translations
const translations = {
    core: {
        accounts: I18n.t("core.accounts"),
        shared: I18n.t('core.shared'),
        account: {
            settings: I18n.t("core.account/settings"),
            files: I18n.t('core.account/files')
        }
    },
}

// . declare variables 

const columns = [{
    field: "name",
    label: translations.core.account.files.view_table_header_logo
}, {
    field: "description",
    label: translations.core.account.files.view_table_header_description
},  {
    field: "format",
    label: translations.core.account.files.view_table_header_format
}]

onMounted(() => {
    storeAccountSettings.getSettings()
})


</script>
<template>

    <lesli-table
        :columns="columns"
        :records="storeAccountSettings.record_files">
        <template #options="records">
            <a class="dropdown-item" v-if="records.record.file" :href="`${storeAccountSettings.getUrl(records.record.file.id)}?download=true`">
                <span class="download-icon material-icons">file_download</span>
                {{ translations.core.shared.view_btn_download }}
            </a>
            <a class="dropdown-item" v-if="records.record.file" @click="storeAccountSettings.confirmFileDeletion(records.record.file)">
                <span class="delete-icon material-icons">delete</span>
                {{translations.core.shared.view_btn_delete}}
            </a>
            <a class="dropdown-item" v-if="!records.record.file">
                <span class="upload-icon material-icons">upload_file</span>
                {{ translations.core.account.files.view_btn_browse_files }}
                <input :accept="records.record.acceptc" class="file-input" type="file" @change="storeAccountSettings.processFile($event, records.record)"/>
            </a>
        </template>

    </lesli-table>
</template>
