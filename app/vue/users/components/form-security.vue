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
            user: { detail_attributes:{} },
            options: {},
            translations: {
                users: I18n.t('core.users'),
                shared: I18n.t('core.shared')
            },
            submitting_form: {
                password: false,
                access: false,
                role: false
            }
        }
    },
    methods: {

        putUserPassword() {
            this.http.put('/', {
                user: {
                    password: this.user.password,
                    password_confirmation: this.user.password_confirmation
                }
            }).then(result => {
                if (result.successful == true) {
                    this.alert(this.translations.users.notification_password_updated, "success")
                } else {
                    this.alert(result.error.message, "danger")
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putUserRole() { 
            this.submitting_form.role = true

            this.http.put(`/users/${this.user.id}.json`, {
                user: {
                    roles_id: this.user.roles_id
                }
            }).then(result => {
                this.submitting_form.role = false

                if (result.successful == true) {
                    this.alert(this.translations.users.notification_role_updated, "success")
                } else {
                    this.alert(result.error.message, "danger")
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putUserActive() {
            this.submitting_form.access = true

            this.http.put(`/users/${this.user.id}.json`, {
                user: {
                    active: this.user.active
                }
            }).then(result => {
                this.submitting_form.access = false

                if (result.successful == true) {
                    this.alert(this.translations.users.notification_access_updated, "success")
                } else {
                    this.alert(result.error.message, "danger")
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
    },
    watch: {
        "store.data.user": function(user) {
            this.user = user
        },
        "store.data.options": function(data) {
            this.options = data
        }
    }
}
</script>

<template>
    <div class="columns">
        <!-- password -->
        <div class="column" v-if="lesli.current_user.id ==  user.id">
            <form @submit.prevent="putUserPassword()">
                <div class="field">
                    <label class="label"> {{ translations.users.field_name_password }} </label>
                    <div class="control has-icons-left">
                        <input v-model="user.password" class="input" type="password" placeholder="Password">
                        <span class="icon is-small is-left">
                            <i class="fas fa-lock"></i>
                        </span>
                    </div>
                </div>
                <div class="field">
                    <label class="label"> {{ translations.users.field_name_confirm_password }} </label>
                    <div class="control has-icons-left">
                        <input v-model="user.password_confirmation" class="input" type="password" placeholder="Confirm new password">
                        <span class="icon is-small is-left">
                            <i class="fas fa-lock"></i>
                        </span>
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary" type="submit">
                        <span v-if="submitting_form.password">
                            <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                            &nbsp;
                            {{translations.shared.btn_saving}}
                        </span>
                        <span v-else>
                            <b-icon icon="save" size="is-small" />
                            &nbsp;
                            {{translations.shared.btn_save}}
                        </span>
                    </button>
                </p>
            </form>
        </div>

         <!-- role and active -->
        <div class="column" v-if="abilities.isRole('admin','owner')">
            <form @submit.prevent="putUserActive()">
                <div class="field">
                    <label class="label"> {{ translations.users.field_name_system_access }}</label>
                    <div class="select">
                        <select v-model="user.active">
                            <option :value="true"> {{ translations.shared.text_active }} </option>
                            <option :value="false"> {{ translations.shared.text_inactive }} </option>
                        </select>
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary" type="submit">
                        <span v-if="submitting_form.access">
                            <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                            &nbsp;
                            {{translations.shared.btn_saving}}
                        </span>
                        <span v-else>
                            <b-icon icon="save" size="is-small" />
                            &nbsp;
                            {{translations.shared.btn_save}}
                        </span>
                    </button>
                </p>
            </form>
            <form @submit.prevent="putUserRole()">
                <div class="field" vif="abilities.isRole('admin', 'owner')">
                    <label class="label"> {{ translations.shared.text_role }}</label>
                    <div class="control">
                        <div class="select">
                            <select v-model="user.roles_id">
                                <option 
                                    v-for="role in options.roles" :key="role.value"
                                    :value="role.value"
                                    >
                                    {{  object_utils.translateEnum(translations.users, 'enum_role', role.text) }}
                                </option>
                            </select>
                        </div>
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary" type="submit">
                        <span v-if="submitting_form.role">
                            <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                            &nbsp;
                            {{translations.shared.btn_saving}}
                        </span>
                        <span v-else>
                            <b-icon icon="save" size="is-small" />
                            &nbsp;
                            {{translations.shared.btn_save}}
                        </span>
                    </button>
                </p>
            </form>
        </div>
    </div>
</template>
