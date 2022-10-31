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


// · 
import { defineStore } from "pinia"
import { useLayout } from "LesliVue/stores/layout"


// · 
export const useTickets = defineStore("core.tickets", {
    state: () => {
        return {
            loading: false,
            loaded: false,
            ticket: {
                cloud_help_catalog_ticket_types_id: 2,
                cloud_help_catalog_ticket_workspaces_id: null,
                subject: '',
                description: '',
                reference_url: null
            },
            tickets: {},
            options: {
                types: [],
                categories: [],
                priorities: []
            },
            typesSelect : [],
            workspaceSelect: [],
            storeLayout: useLayout()
        }
    },
    actions: {
        /**
         * @description This action is used to get get tickets
         */
        fetchTickets() {
            this.loading = true
            this.http.get(this.url.help('tickets')
                .paginate(1,3) // Here we only fetch the last 3 tickets assigned to show in the support ticket panel
                .filter({search_type: ['active'], user_type:['own']})
            ).then(result => {
                this.tickets = result.records
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })

        },

        /**
         * @description This action is used to create a new ticket
         */
        postTicket(){
            this.loading = true
            this.ticket.reference_url = window.location.href
            this.http.post(this.url.help('tickets'), this.ticket).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.resetForm()
                this.loading = false
                this.storeLayout.showTickets = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to reset form
         */
        resetForm(){
            this.ticket.subject = ''
            this.ticket.description = ''
            this.ticket.type = 2
        },

        /**
         * @description This action is used to get get tickets options
         */
        getTicketOptions() {
            this.loaded = true
            this.http.get(this.url.help('tickets/options')).then(result => {
                this.options = result

                result.types.map((type)=>{
                    this.typesSelect.push({label: type.name, value: type.id})
                })

                result.workspaces.map((workspace)=>{
                    this.workspaceSelect.push({label: workspace.name, value: workspace.id})
                })

            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
    }
})
