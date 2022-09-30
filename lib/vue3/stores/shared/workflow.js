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

// · This store is needed to make http requests, manage the reactivity 
// · of a workflow.

import { defineStore } from "pinia"

export const useWorkflow = defineStore("core.shared.workflow", {
    state: () => {
        return {
            transitionOptions: [],
            workflows: [],
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
        }
    },
    actions: {
        
        /**
        * @param {*} url is the url of the api to be called
        * @description This action is used to fetch the list of transition options
        */
        fetchWorkflows(url) {
            this.loading = true

            if (!url) url = this.url[this.cloudModule](this.cloudObject)

            this.http.get(url).then(result => {
                this.workflows = result.workflows
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.workflows").messages_danger_getting_workflows)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @param {string} stringToFind String to search for
         * @description This action is used to search for a string in the workflows
         */
        searchWorkflows(stringToFind) {
            const workflowsUrl = this.url[this.cloudModule](this.cloudObject).search(stringToFind)
            this.fetchWorkflows(workflowsUrl)
        },


        /**
        * @description This action is used to fetch the list of transition options
        */
        fetchTransitionOptions(url) {
            this.loading = true

            // · If the cloud object has / split the url
            let cloudObject = this.cloudObject.split("/").pop()
            
            // · Singularize the cloud object
            cloudObject = cloudObject.endsWith("s") ? cloudObject.slice(0, -1) : cloudObject

            if (!url) url = this.url[this.cloudModule]("/workflows/resources/transition-options/:cloudObject/:cloudObjectId", {
                cloudObject: cloudObject,
                cloudObjectId: this.cloudObjectId,
            })

            this.http.get(url).then(result => {
                if (result === "") return this.transitionOptions = []
                this.transitionOptions = result
            }).catch(error => {
                console.log(error)
                if (error?.message === "Not found") return this.transitionOptions = []
                this.msg.danger(I18n.t("core.shared").messages_danger_getting_transition_options)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @param {*} payload
         * @description This action is used to update the cloud object status
         */
        updateStatus(payload) {
            this.loading = true

            const url = this.url[this.cloudModule](`${this.cloudObject}/:cloudObjectId`, { cloudObjectId: this.cloudObjectId })

            this.http.put(url, payload).then(() => {
                this.msg.success(I18n.t("core.shared").messages_success_status_changed)
                this.fetchTransitionOptions()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_updating_status)
            }).finally(() => {
                this.loading = false
            })
        }
    }
})
