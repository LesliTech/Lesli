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

// · This store is needed to make http requests, manage the reactivity 
// · of certain global properties available to child components of the 
// · cloud object.

import { defineStore } from "pinia"

export const useCloudObjectAction = defineStore("cloudObjectAction", {
    state: () => {
        return {
            new_group_name: "",
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
            actions: {}
        }
    },
   
    actions: {

        getActions(url){

            if (!url) url = this.url[this.cloudModule](`${this.cloudObject}/:id/actiuons`, this.cloudObjectId)

            this.loading = true

            this.http.get(url).then(result => {
                this.actions = this.result
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loaded = true
                this.loading = false
            })
        },

        putAction(action){
            let data = {}
            data[`${this.cloudObject}_action`] = {
                complete: action.complete
            }

            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/actions/${action.id}`, this.cloudObjectId)

            this.http.put(url, data).then(result => {
                this.msg.success(this.translations.core.messages_success_cloud_object_actions_updated)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        deleteAction(group, deleted_action){
            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/actions/${deleted_action.id}`, this.cloudObjectId)

            this.http.delete(url).then(result => {
                this.msg.success(I18n.t("core.messages_success_cloud_object_actions_destroyed"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },

       
    }
})
