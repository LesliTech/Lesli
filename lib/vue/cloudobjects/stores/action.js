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


// · This store is needed to make http requests, manage the reactivity 
// · of certain global properties available to child components of the 
// · cloud object.

import { defineStore } from "pinia"

export const useCloudObjectAction = defineStore("cloud.object.action", {
    state: () => {
        return {
            new_group_name: "",
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
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

            let cloudObjectSingular = this.utils.singularize(this.cloudObject)

            let data = {}
            data[`${cloudObjectSingular}_action`] = {
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

            let cloudObjectSingular = this.utils.singularize(this.cloudObject)

            let data = {}
            data[`${cloudObjectSingular}_action`] = {
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
