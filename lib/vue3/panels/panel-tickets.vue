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
import { ref, inject, watch, onMounted } from "vue"

// · import store
import { useLayout } from "LesliVue/stores/layout"

import { useTickets } from "LesliVue/stores/panels/tickets"

// · implement stores
const storeLayout = useLayout()
const storeTickets = useTickets()

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    },
    main: I18n.t('help.tickets')
}

const columns = [{
    field: "subject",
    label: "subject"
}, {
    field: "status",
    label: "Status"
}]

// · initializing
onMounted(() => {
    storeTickets.getTicketOptions()
})

// watch(() => storeLayout.showTickets, () => {
//     storeTickets.getTicketOptions()
// })


</script>

<template>
    <lesli-panel v-model:open="storeLayout.showTickets">
        <template #header>
            <h2>test</h2>
        </template>
        <template #default>

            <lesli-table
                :columns="columns"
                :records="records"
            
            ></lesli-table>

            <form @submit.prevent="storeTickets.postTicket">
                <div class="columns">
                    <div class="column is-4">
                        <label class="label">
                            {{translations.main.column_subject}} <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column is-8">
                        <input type="text" class="input" required v-model="storeTickets.subject">
                    </div>
                </div>

                <div class="columns">
                    <div class="column is-4">
                        <label class="label">
                            {{translations.main.column_cloud_help_catalog_ticket_types_id}}<sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column is-8">

                            <lesli-select
                                :options="storeTickets.typesSelect"
                                v-model="storeTickets.cloud_help_catalog_ticket_types_id"
                            >
                            </lesli-select>
                    </div>
                </div>

                <div class="columns">
                    <div class="column is-4">
                        <label class="label">
                            {{translations.main.column_cloud_help_catalog_ticket_workspaces_id}}<sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column is-8">
                        <lesli-select
                            :options="storeTickets.workspaceSelect"
                            v-model="storeTickets.cloud_help_catalog_ticket_workspaces_id"
                        >
                        </lesli-select>
                    </div>
                </div>

                <div class="columns">
                    <div class="column is-4">
                        <label class="label">
                            {{translations.main.column_description}} <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column is-8">
                        <textarea class="textarea" v-model="storeTickets.description"></textarea>
                    </div>
                </div>

                <div class="control">
                    <lesli-button icon="save">
                        {{ translations.core.shared.view_btn_save }}
                    </lesli-button>                 
                </div>
        
            </form>

        </template>

    </lesli-panel>
</template>
