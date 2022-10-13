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


// · 
export const useTickets = defineStore("tickets", {
    state: () => {
        return {
            loading: false,
            ticket: {
                cloud_help_catalog_ticket_types_id: null,
                cloud_help_catalog_ticket_workspaces_id: null,
                subject: '',
                description: {},
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
        }
    },
    actions: {
        /**
         * @description This action is used to get users information
         * @param {String} id Id of the user, if not provided list all users
         */
        fetchTickets(id=null) {
            this.loading = true

            // get the profile by default
            let url = this.url.admin("profile")

            // get an specifick user if id is provided
            if (id) { url = this.url.admin("users/:id", id) }

            this.http.get(url).then(result => {
                this.user = result
                this.user.password = ""
                this.user.password_confirmation = ""
                this.roles = []
                result.roles.forEach(role => {
                    this.roles.push(role.id)
                })
                this.language = result.language ? result.language.value : this.language
                this.parseRolesToggle()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })

        },

        /**
         * @description This action is used to create a new user
         */
        postTicket(){
            this.http.post(this.url.help('tickets'), this.ticket).then(result => {
                this.resetForm()
            }).catch(error => {
                console.log(error)
            })
        },
        resetForm(){
            this.ticket.subject = ''
            this.ticket.description = {}
        },

        getTicketOptions() {
            this.http.get(this.url.help('tickets/options')).then(result => {
                this.options = result

                result.types.map((type)=>{
                    this.typesSelect.push({label: type.name, value: type.id})
                })

                result.workspaces.map((workspace)=>{
                    this.workspaceSelect.push({label: workspace.name, value: workspace.id})
                })

            }).catch(error => {
                console.log(error)
            })
        },
    }
})
