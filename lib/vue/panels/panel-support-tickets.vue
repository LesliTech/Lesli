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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// TODO: Move this to own engine


// · import vue tools
import { inject, watch } from "vue"
import { useRouter } from "vue-router"


// · import store
import { useLayout } from "Lesli/vue/shared/stores/layout"
import { useTickets } from "Lesli/vue/panels/stores/support-tickets"


// · 
import { LesliTextEditor } from "lesli-vue/components"


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// · implement stores
const storeLayout = useLayout()
const storeTicketsPanel = useTickets()


// · defining translations
const translations = {
    tickets: i18n.t("lesli_support.tickets"),
    lesli: i18n.t("lesli")
}


// · 
const columns = [{
    field: "subject",
    label: "subject"
}, {
    field: "status_name",
    label: "Status"
}]


// . Reset form on create
storeTicketsPanel.resetForm()


// . 
watch(() => storeLayout.showSupportTickets, () => {
    if (storeLayout.showSupportTickets) {
        storeTicketsPanel.fetchTickets()

        if (!storeTicketsPanel.loaded) {
            //storeTicketsPanel.getTicketOptions()
        }
    }    
})

</script>

<template>
    <lesli-panel class="lesli-panel-support-tickets" v-model:open="storeLayout.showSupportTickets">
        <template #header>
            Support tickets
        </template>
        <template #default>
            <div class="lastest-tickets" v-if="storeTicketsPanel.tickets.length > 0">
                <h4>Latest tickets</h4>
                <lesli-table
                    class="is-narrow"
                    :columns="columns"
                    :records="storeTicketsPanel.tickets"
                    :loading="storeTicketsPanel.loading"
                    :href="(ticket) => url.support('tickets/:id', ticket.id)">
                </lesli-table>
            </div>
            <hr>
            <div class="form">
                <lesli-form flat @submit="storeTicketsPanel.postTicket">
                    <div class="field">
                        <label class="label">
                            {{ translations.tickets.column_subject }}
                            {{ translations.tickets.column_subject }}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <div class="control">
                            <input type="text" class="input" required v-model="storeTicketsPanel.ticket.subject">
                        </div>
                    </div>

                    <div class="field">
                        <label class="label">
                            {{ translations.tickets.column_type }}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <div class="control">
                            <lesli-select
                                :options="storeTicketsPanel.typesSelect"
                                v-model="storeTicketsPanel.ticket.cloud_help_catalog_ticket_types_id">
                            </lesli-select>
                        </div>
                    </div>

                    <div class="field">
                        <label class="label">
                            {{ translations.tickets.column_description }}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <div class="control">
                            <lesli-text-editor mode="small" v-model="storeTicketsPanel.ticket.description">
                            </lesli-text-editor>
                        </div>
                    </div>

                    <div class="field">
                        <div class="control">
                            <lesli-button icon="save">
                                {{ translations.lesli.shared.button_save }}
                            </lesli-button>   
                        </div>
                    </div>
                </lesli-form>
            </div>
        </template>
    </lesli-panel>
</template>
