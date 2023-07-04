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
import { inject, watch } from "vue"
import { useRouter } from 'vue-router'


// · import store
import { useLayout } from "Lesli/shared/stores/layout"
import { useTickets } from "Lesli/shared/stores/panels/tickets"


// · 
import editorRichText from "Lesli/components/editors/richtext.vue"


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


// · 
const columns = [{
    field: "subject",
    label: "subject"
}, {
    field: "status_name",
    label: "Status"
}]

// · defining props
const props = defineProps({
    instanceEndpoint: {
        type: String,
        default: 'help'
    }
})

// . Reset form on create
storeTicketsPanel.resetForm()


watch(() => storeLayout.showTickets, () => {
    if(storeLayout.showTickets){
        storeTicketsPanel.fetchTickets()

        if(!storeTicketsPanel.loaded){
            storeTicketsPanel.getTicketOptions()
        }
    }    
})

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
                    class="is-narrow"
                    :columns="columns"
                    :records="storeTicketsPanel.tickets"
                    :loading="storeTicketsPanel.loading"
                    :href="(ticket) => url.to(`${props.instanceEndpoint}/tickets/${ticket.id}`)">
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
                                {{translations.main.column_description}} <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-1"></div>
                        <div class="column is-10">
                            <editorRichText mode="small" v-model="storeTicketsPanel.ticket.description"></editorRichText>
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
