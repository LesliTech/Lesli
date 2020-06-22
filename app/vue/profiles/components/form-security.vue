<script>
/**
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
export default {

    data() {
        return {
            user_id: null,
            options: {},
            user: {
                roles_id: null,
                password: "",
                password_confirmation: ""
            },
        }
    },

    mounted() {
        this.user_id = lesli.current_user.id
        this.getUser()
    },

    methods: {

        getUser() {
            this.http.get(`/users/${this.user_id}.json`).then(result => {
                this.user.roles_id = result.data.user.roles_id
                this.options = result.data.options
            }).catch(error => {
                console.log(error)
            })
        },

        putUserPassword() { 
            this.http.put('/', {
                user: {
                    password: this.user.password,
                    password_confirmation: this.user.password_confirmation
                }
            }).then(result => {
                if (result.successful == true) {
                    this.notification.alert("Password updated successfully", "error")
                    return 
                }
                this.notification.alert(result.error.message[0])
            }).catch(error => {
                console.log(error)
            })
        },

        putUserRole() { 
            this.http.put(`/users/${this.user_id}.json`, {
                user: {
                    roles_id: this.user.roles_id
                }
            }).then(result => {
                if (result.successful == true) {
                    this.notification.alert("Role updated successfully", "error")
                    return 
                }
                this.notification.alert(result.error.message[0])
            }).catch(error => {

            })
        }
        
    }

}
</script>

<template>
    <div class="columns">
        <div class="column">
            <form @submit.prevent="putUserRole()">
                <div class="field" vif="abilities.isRole('admin', 'owner')">
                    <label class="label">Rolle</label>
                    <div class="control">
                        <div class="select">
                            <select v-model="user.roles_id">
                                <option 
                                    v-for="role in options.roles" :key="role.id"
                                    :value="role.id"
                                    >
                                    {{ role.name }}
                                </option>
                            </select>
                        </div>
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary">Speichern</button>
                </p>
            </form>
        </div>
        <div class="column">
            <form @submit.prevent="putUserPassword()">
                <div class="field">
                    <label class="label">New password</label>
                    <div class="control has-icons-left">
                        <input v-model="user.password" class="input" type="New password" placeholder="Password">
                        <span class="icon is-small is-left">
                            <i class="fas fa-lock"></i>
                        </span>
                    </div>
                </div>
                <div class="field">
                    <label class="label">Confirm new password</label>
                    <div class="control has-icons-left">
                        <input v-model="user.password_confirmation" class="input" type="password" placeholder="Confirm new password">
                        <span class="icon is-small is-left">
                            <i class="fas fa-lock"></i>
                        </span>
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary">Speichern</button>
                </p>
            </form>
        </div>
    </div>
</template>
