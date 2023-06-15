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
export const useDescriptor = defineStore("administration.descriptor", {
    state: () => {
        return {
            list: [],
            descriptor: {},
            privileges: {},
            index: { 
                loading: false,
                pagination: {},
                records: []
            }
        }
    },
    actions: {


        fetchDescriptors(id) {
            if (this.index.records.length > 0) {
                return 
            }

            this.getDescriptors()
        },

        fetchDescriptor(id) {
            if (this.descriptor.id != null) {
                return 
            }

            this.getDescriptor(id)
        },

        getDescriptors() {
            this.index.loading = true
            this.http.get(this.url.admin("descriptors")).then(result => {
                this.index.pagination = result.pagination
                this.index.records = result.records
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.index.loading = false
            })
        },

        getDescriptor(id) {
            this.http.get(this.url.admin("descriptors/:id", id)).then(result => {
                this.descriptor = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        fetchDescriptorPrivileges() {
            this.http.get(this.url.admin("descriptors/:id/privileges", this.descriptor.id)).then(result => {
                result.forEach(controllerAction => {

                    controllerAction.controller = controllerAction.controller.replace("cloud_", "")

                    if (!this.privileges[controllerAction.action]) {
                        this.privileges[controllerAction.action] = []
                    }
                    controllerAction["active"] = controllerAction.descriptor_privilege_id ? true : false
                    this.privileges[controllerAction.action].push(controllerAction)
                })
            })
        },

        /*
        fetch(url=this.url.admin("descriptors")) {
            this.loading = true
            this.http.get(url).then(result => {
                this.index = result
                this.records = result.records
                this.loading = false
            })
        },

        fetchDescriptor(id) {
            console.log("fetch",id)
            this.http.get(this.url.admin("descriptors/:id", id)).then(result => {
                this.descriptor = result
                this.getDescriptorsOptions()
                this.fetchDescriptorPrivileges()
            })
        },

        fetchDescriptorList() {
            this.http.get(this.url.admin("descriptors/list")).then(result => {
                this.list = result.map(descriptor => {
                    descriptor.active = false
                    return descriptor
                })
            })
        },

        /**
        * @description This action is used to reset descriptor object
        * /
        resetDescriptor() {
            this.descriptor = {}
            this.privileges = {}
        },
        
        /**
        * @description This action is used to create a descriptor
        * /
        createDescriptor(){
            this.loading = true
            this.http.post(this.url.admin("descriptors"), { descriptor: this.descriptor }).then(result => {
                this.descriptor.id = result.id
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        
        /**
        * @description This action is used to update a descriptor
        * /
        updateDescriptor(){
            this.loading = true
            this.http.put(this.url.admin("descriptors/:id", this.descriptor.id), { descriptor: this.descriptor }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })

        },
        /**
        * @description This action is used to sort the results
        * /
        sortIndex(column, direction) {
            this.fetch(this.url.admin("descriptors").order(column, direction))
        },
        /**
         * @description This action is used to search
         * @param {string} search_string
         * /
        search(search_string) {
            this.fetch(this.url.admin("descriptors").search(search_string))
        },
        /**
         * @description This action is used to paginate index
         * @param {string} page actual page 
         * /
        paginateIndex(page) {
            this.pagination.page = page
            this.fetch(this.url.admin("descriptors").paginate(this.pagination.page))
        },
        /**
        * @description This action is used to get descriptors as options
        * /
        getDescriptorsOptions(){
            this.loading = true
            this.descriptors_options = []
            this.http.get(this.url.admin("descriptors/list")).then(result => {
                result.forEach((descriptor)=>{
                    this.descriptors_options.push({
                        label: descriptor.name,
                        value: descriptor.id
                    })
                })
                
                this.loading = false
            })
        },




        // Add privilege to descriptor
        postPrivilege(action) {
            this.http.post(this.url.admin("descriptors/:id/privileges", this.descriptor.id), {
                descriptor_privilege: {
                    controller_id: action.controller_id,
                    action_id: action.action_id
                }
            }).then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        },


        // Add privilege to descriptor
        deletePrivilege(action) {
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
        */
    }
})
