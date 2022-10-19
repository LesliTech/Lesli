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
import { inject, watch } from "vue"
import { useRouter } from 'vue-router'

// · import store
import { useLayout } from "LesliVue/stores/layout"
import { useTickets } from "LesliVue/stores/panels/tickets"

// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// · implement stores
const storeLayout = useLayout()
const storeTicketsPanel = useTickets()

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
    field: "status_name",
    label: "Status"
}]


watch(() => storeLayout.showTickets, () => {
    if(storeLayout.showTickets){
        storeTicketsPanel.fetchTickets()

        if(!storeTicketsPanel.loaded){
            storeTicketsPanel.getTicketOptions()
        }
    }    
})

function showTicket(ticket){
    url.go(`/help/tickets/${ticket.id}`)
}


</script>

<template>
    <lesli-panel class="lesli-panel-tickets" v-model:open="storeLayout.showTickets">
        <template #header>
            {{ translations.main.view_text_support_tickets }}
        </template>
        <template #default>
            <div class="lastest-tickets" v-if="storeTicketsPanel.tickets.length > 0">
                <h4>{{ translations.main.view_title_latest_tickets }}</h4>
                <lesli-table
                    :columns="columns"
                    :records="storeTicketsPanel.tickets"
                    @click="showTicket"
                    :loading="storeTicketsPanel.loading"
                >
                </lesli-table>
            </div>
            <hr>
            <div class="form">
                <h4>{{translations.main.view_title_quick_creation}}</h4>
                <form @submit.prevent="storeTicketsPanel.postTicket">
                    <div class="columns">
                        <div class="column is-1"></div>
                        <div class="column is-3">
                            <label class="label">
                                {{translations.main.column_subject}} <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column is-7">
                            <input type="text" class="input" required v-model="storeTicketsPanel.ticket.subject">
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-1"></div>
                        <div class="column is-3">
                            <label class="label">
                                {{translations.main.column_cloud_help_catalog_ticket_types_id}}<sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column is-7">

                                <lesli-select
                                    :options="storeTicketsPanel.typesSelect"
                                    v-model="storeTicketsPanel.ticket.cloud_help_catalog_ticket_types_id"
                                >
                                </lesli-select>
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-1"></div>
                        <div class="column is-3">
                            <label class="label">
                                {{translations.main.column_cloud_help_catalog_ticket_workspaces_id}}<sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column is-7">
                            <lesli-select
                                :options="storeTicketsPanel.workspaceSelect"
                                v-model="storeTicketsPanel.ticket.cloud_help_catalog_ticket_workspaces_id"
                            >
                            </lesli-select>
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-1"></div>
                        <div class="column is-3">
                            <label class="label">
                                {{translations.main.column_description}} <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column is-7">
                            <textarea class="textarea" v-model="storeTicketsPanel.ticket.description"></textarea>
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-1"></div>
                        <div class="column">
                            <lesli-button icon="save">
                                {{ translations.core.shared.view_btn_save }}
                            </lesli-button>   
                        </div>
                    </div>
            
                </form>
            </div>
        </template>

    </lesli-panel>
</template>
