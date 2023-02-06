/*
Copyright (c) 2023, all rights reserved.

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
export const useDashboard = defineStore("shared.dashboard", {
    state: () => {
        return {
            loading: false,
            dashboard: {
                components: []
            },
            dashboards: [],
            cloudModule: null,
            options: [],
            selected_dashboard_component: {}
        }
    },
    actions: {
        /**
         * @description This action is used to get the default dashboard
         */
        getDashboard(cloudModule) {
            this.http.get(this.url[cloudModule]('dashboards/default')).then(result => {
                this.dashboard = result
            })
        },
        /**
         * @description This action is used to fetch the list of dashboards
         */
        fetchDashboards(url) {
            this.loading = true
            
            if (!url) url = this.url[this.cloudModule](`dashboards`)

            this.http.get(url).then(result => {
                this.loading = false
                this.dashboards = result.dashboards
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @param {string} search_string String to search for
         * @description This action is used to search for a string in the dashboards
         */
        searchDashboards(search_string){
            const url = this.url[this.cloudModule](`dashboards`).search(search_string)
            this.fetchDashboards(url)
        },
        resetDashboard(){},
        /**
        * @description This action is used to update a dashboard
        */
        updateDashboard(){
            this.loading = true
            let data = {
                dashboard: {
                    ...this.dashboard,
                    // components_attributes: this.dashboard.components.map((component)=>{
                    //     let parsed_component = {...component}
                    //     parsed_component.id = null

                    //     return parsed_component
                    // })
                }
            }

            const url = this.url[this.cloudModule](`dashboards/${this.dashboard.id}`)

            return this.http.put(url, data).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
        * @description This action is used to post a dashboard
        */
        async postDashboard(){
            this.loading = true
            let data = {
                dashboard: {
                    ...this.dashboard,
                    // components_attributes: this.dashboard.components.map((component)=>{
                    //     let parsed_component = {...component}
                    //     parsed_component.id = null

                    //     return parsed_component
                    // })
                }
            }

            const url = this.url[this.cloudModule](`dashboards`)

            return this.http.post(url, data).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
        * @description This action is used to get dashboard options
        */
        getDashboardOptions(){

            this.options = {
                component_ids: [],
                roles: [],
                components_configuration_options: {}
            }

            const url = this.url[this.cloudModule](`dashboards/options`)

            this.http.get(url).then(result => {

                result["roles"].forEach((role)=>{
                    this.options["roles"].push({
                        label: role.text,
                        value: role.value
                    })
                })
                result["component_ids"].forEach((component)=>{
                    this.options["component_ids"].push({
                        label: component.text,
                        value: component.value
                    })
                })

                this.options["components_configuration_options"] = result["components_configuration_options"]

            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
        * @description This action is used to get the information for a dashboard
        */
        fetchDashboard(dashboard_id){
            this.loading = true
            const url = this.url[this.cloudModule](`dashboards/:dashboardId`, { dashboardId: dashboard_id })

            return this.http.get(url).then(result => {
                this.dashboard = result
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
        * @description This action is used to delete a dashboard
        */
        deleteDashboard(){
            this.loading = true
            const url = this.url[this.cloudModule](`dashboards/:dashboardId`, { dashboardId: this.dashboard.id })

            this.http.delete(url).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        }

    }
})
