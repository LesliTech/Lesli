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

import { stringifyStyle } from "@vue/shared"
import { defineStore } from "pinia"

export const useCloudObjectAction = defineStore("cloud.object.action", {
    state: () => {
        return {
            new_group_name: "",
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
            cloudObjectSingular: "",
            actions_groups: {},
            new_action: {}
        }
    },
   
    actions: {

        /**
        * @description this action is used to get all the quick actions for a cloud object
        */
        getActions(){
            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/actions`, this.cloudObjectId)

            this.loading = true

            this.http.get(url).then(result => {
                this.actions_groups = this.parseActions(result)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
        * @param {Object} action to be updated
        * @description this action is used to update action status
        */
        putAction(action){

            let data = {}
            data[`${this.cloudObjectSingular}_action`] = {
                complete: !action.complete
            }

            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/actions/${action.id}`, this.cloudObjectId)

            this.http.put(url, data).then(result => {
                this.msg.success(I18n.t("core.shared.messages_success_actions_updated"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
        * @param {Object} group of the action
        * @param {Object} deleted_action the action to be deleted
        * @description this action is used to delete an action
        */
        deleteAction(group, deleted_action){

            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/actions/${deleted_action.id}`, this.cloudObjectId)

            this.http.delete(url).then(result => {
                this.msg.success(I18n.t("core.shared.messages_success_actions_destroyed"))
                this.actions_groups[group].actions = this.actions_groups[group].actions.filter((action)=>{
                    return action.id != deleted_action.id
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },

        /**
         * @param {string} cloudObject to be singularized
         * @description singularizes a word that ends with 's' and 'es'
         * @returns {string} singularized word
         */
        singularize(cloudObject) {
            if (cloudObject.endsWith('ies')) this.cloudObjectSingular = cloudObject.slice(0, -3) + 'y'
            else if (cloudObject.endsWith('es')) this.cloudObjectSingular = cloudObject.slice(0, -2)
            else if (cloudObject.endsWith('s')) this.cloudObjectSingular = cloudObject.slice(0, -1)
            else this.cloudObjectSingular = cloudObject
        },
        /**
        * @description this action is used to create the object of a new group of actions
        */
        createGroup(){
            if (Object.keys(this.actions_groups).indexOf(this.new_group_name) == -1) {
                this.actions_groups[this.new_group_name]= { 
                    new_action: { instructions: '' }, 
                    actions: []
                }

                this.new_group_name = ""
            } else {
                this.msg.warning(I18n.t("core.shared.messages_warning_actions_group_taken"))
            }
 
        },
        /**
        * @param {String} group_name
        * @description this action is used to create an action
        */
        createAction(group_name){

            let group = this.actions_groups[group_name]

            let data = {}
            data[`${this.cloudObjectSingular}_action`] = {
                instructions: group.new_action.instructions,
                group: group_name
            }

            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/actions`, this.cloudObjectId)

            this.loading = true

            this.http.post(url, data).then(result => {
                this.actions_groups[group_name].actions.push(result)
                group.new_action.instructions = ''
                this.msg.success(I18n.t("core.shared.messages_success_actions_updated"))
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
        * @param {Object} actions list of actions
        * @description this action is used to parse the result of the list of actions
        */
        parseActions(actions){
            for(let key in actions){
                actions[key] = {
                    new_action: {
                        instructions: ''
                    },
                    actions: actions[key]
                }
            }

            return actions
        },
       
    }
})
