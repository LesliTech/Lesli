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
export const useSystemController = defineStore("administration.systemController", {
    state: () => {
        return {
            options: { categories: []},
            controllerActions: {},
        }
    },
    actions: {

        fetchControllers() {
            this.http.get(this.url.admin("system_controllers")).then(result => {
                result.forEach(controllerAction => {
                    if (!this.controllerActions[controllerAction.action]) {
                        this.controllerActions[controllerAction.action] = []
                    }
                    controllerAction['active'] = false
                    this.controllerActions[controllerAction.action].push(controllerAction)
                })
            }).catch(error => {
                console.log(error)
            })
        },

        fetchOptions() {
            this.http.get(this.url.admin("system_controllers/options")).then(result => {
                this.options = result
            })
        }
    }
})
