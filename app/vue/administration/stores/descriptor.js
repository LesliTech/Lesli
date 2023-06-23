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

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { defineStore } from "pinia"


// · 
export const useDescriptor = defineStore("administration.descriptor", {
    state: () => {
        return {
            list: [],
            descriptor: {},
            privileges: [],
            privilegesLoading: false
        }
    },
    actions: {

        fetchDescriptor(id) {
            if (this.descriptor.id != null) {
                return 
            }

            this.getDescriptor(id)
        },

        getDescriptor(id) {
            this.http.get(this.url.admin("descriptors/:id", id)).then(result => {
                this.descriptor = result
                this.getDescriptorPrivileges()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                
            })
        },

        resetDescriptor() {
            this.descriptor = {}
            this.privileges = []
        },

        getDescriptorPrivileges() {
            this.privilegesLoading = true
            this.http.get(this.url.admin("descriptors/:id/privileges", this.descriptor.id)).then(result => {
                this.privileges = result
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.privilegesLoading = false
            })
        },

        // Add privilege to descriptor
        postDescriptorPrivilege(action) {

            this.http.post(this.url.admin("descriptors/:id/privileges", this.descriptor.id), {
                descriptor_privilege: {
                    //controller_id: action.controller_id,
                    action_id: action.action_id
                }
            }).then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        },


        // Add privilege to descriptor
        deleteDescriptorPrivilege(action) {
            console.log(action)
            this.http.delete(this.url.admin("descriptors/:descriptorId/privileges/:descriptorPrivilegeId", {
                descriptorId: this.descriptor.id,
                descriptorPrivilegeId: action.descriptor_privilege_id
            })).then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        }
    }
})
