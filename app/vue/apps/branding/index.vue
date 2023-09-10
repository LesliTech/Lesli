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
import { onMounted } from "vue"

import ComponentFiles from "Lesli/cloudobjects/components/file.vue"

// · import lesli stores
import { useAccountSettings } from "LesliApp/administration/stores/accountSettings"

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
    storeAccountSettings.initializeBrandingLogos()
    storeAccountSettings.getAccountLogos()
})


</script>
<template>
    <section class="application-component">
        <lesli-header 
            :title="translations.core.account.settings.view_tab_title_branding">
        </lesli-header>
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
    </section>
</template>
