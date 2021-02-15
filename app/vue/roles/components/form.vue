<script>
/*

Copyright (c) 2020, all rights reserved.

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


export default {
    props: {
        edit: {
            default: true
        },
        role: {
            type: Object,
            default() { 
                return {
                    name: "",
                    active: true,
                    default_path: "",
                    only_my_data: false,
                    object_level_permission: 10,
                }
            }
        }
    },
    data() {
        return {
            roles: [],
        }
    },
    mounted() {
        this.getRoles()
    },
    methods: {

        submit() {

            if (this.role.id) {
                this.putRole()
            } else {
                this.postRole()
            }

        },

        putRole() {

            this.http.put(this.url.admin("roles/:id", { id: this.role.id }), {
                role: this.role
            }).then(result => {
                if (!result.successful) {
                    this.msg.warn(result.error.message)
                    return
                }
                this.msg.success("Role updated successfully")
            })

        },

        postRole() {

            this.http.post(this.url.admin("roles"), {
                role: this.role
            }).then(result => {
                if (!result.successful) {
                    this.msg.warn(result.error.message)
                    return
                }
                this.msg.success("Role created successfully")
            })

        },

        getRoles() {

            this.http.get(this.url.admin("roles/list")).then(result => {
                
                result.data.forEach((role, index) => {

                    this.roles.push({
                        id: role.id,
                        name: role.name,
                        object_level_permission: role.object_level_permission
                    })

                    if (index < result.data.length - 1) {
                        
                        let next_olp = result.data[index + 1].object_level_permission

                        let level = (role.object_level_permission + next_olp) / 2

                        if (role.object_level_permission == level) {
                            return
                        }

                        this.roles.push({
                            id: 0,
                            name: "- - -",
                            object_level_permission: level
                        })

                    }

                    
                })

            })

        }

    }
    
}
</script>
<template>
    <div class="box">
        <form @submit.prevent="submit">
            <fieldset :disabled="!edit">

                <div class="field">
                    <label class="label">
                        Name
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <div class="control">
                        <input v-model="role.name" class="input" type="text" required />
                    </div>
                </div>

                <div class="field">
                    <label class="label">
                        Hierarchical level
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <div class="control">
                        <div class="select">
                            <select v-model="role.object_level_permission">
                                <option 
                                    v-for="(role, i) in roles" 
                                    :key="i" 
                                    :disabled = "i == 0"
                                    :value="role.object_level_permission">
                                    {{ i + 1 }}.  {{ role.name }}
                                </option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="field">
                    <label class="label">Default path</label>
                    <div class="control">
                        <input v-model="role.default_path" class="input" type="text" placeholder="Default path at login">
                    </div>
                </div>

                <hr>

                <div class="columns">
                    <div class="column is-4">
                        <div class="field">
                            <label class="label">
                                Status
                                <sup class="has-text-danger">*</sup>
                            </label>
                            <div class="control">
                                <div class="select">
                                    <select v-model="role.active">
                                        <option value="true">Active</option>
                                        <option value="false">Disabled</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="column is-4">
                        <div class="field">
                            <label class="label">
                                Only own data 
                                <sup class="has-text-danger">*</sup>
                            </label>
                            <div class="control">
                                <div class="select">
                                    <select v-model="role.only_my_data">
                                        <option value="true">Restrict data access</option>
                                        <option value="false">Allow to see all the data</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                

                <hr>

                <!-- Submitt -->
                <p class="control">
                    <button class="button is-primary">
                        <span class="icon">
                            <i class="far fa-save"></i>
                        </span>
                        <span>Save</span>
                    </button>
                </p>

            </fieldset>
        </form>
    </div>
</template>
