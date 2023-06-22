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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { defineStore } from "pinia"


// · 
export const useRoles = defineStore("administration.roles", {
    state: () => {
        return {
            list: [],
            index: {
                pagination: {},
                records: []
            }
        }
    },
    actions: {

        fetchList() {
            if (!this.list.length > 0) {
                this.getList()
            }
        },

        // Get the list of role user is able to work with
        // according to object level permissions
        getList() {
            this.http.get(this.url.admin("roles/list")).then(result => {
                this.list = result

                // parse the list of roles to be used in select control
                /*
                this.listOptions = []
                this.listOptions = result.map(role => {
                    return {
                        label: role.name,
                        value: role.id
                    }
                })
                */
            })
        },

        fetchRoles() {
            if (!this.list.length > 0) {
                this.getRoles()
            }
        },

        // Get the list of role user is able to work with
        // according to object level permissions
        getRoles() {
            this.http.get(this.url.admin("roles")).then(result => {
                this.index = result
            })
        },
    }
})
