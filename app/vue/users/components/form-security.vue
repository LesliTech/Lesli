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


// · 
export default {
    data() {
        return {
            translations: {
                users: I18n.t("core.users"),
                shared: I18n.t("core.shared"),
                passwords: I18n.t("core.users/passwords"),
                roles: I18n.t("core.roles")
            },
            submitting_form: {
                password: false,
                access: false,
                role: false
            },
            user: {}
        }
    },
    methods: {

        putUserActive() {
            this.http.put(`/administration/users/${this.data.user.id}.json`, {
                user: {
                    active: this.data.user.active
                }
            }).then(result => {
                if (!result.successful) {
                    this.alert(result.error.message, "danger")
                    return 
                }
                this.alert(this.translations.users.messages_success_user_updated, "success")
            })
        },

        putUserPassword() {
            this.http.put("/", {
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
        }
        
    }
}
</script>

<template>
    <div class="card">
        <div class="card-content">
            <form>
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">{{ translations.users.view_table_header_status }}</label>
                    </div>
                    <div class="field-body">
                        <div class="field is-narrow">
                            <div class="control">
                                <div class="select is-fullwidth">
                                    <select 
                                        @input="putUserActive()"
                                        v-model="data.user.active">
                                        <option :value="true">{{ translations.shared.view_text_active }}</option>
                                        <option :value="false">{{ translations.shared.view_text_inactive }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

            <hr>

            <form v-if="lesli.current_user.id ==  data.user.id" @submit.prevent="putUserPassword()">
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">{{ translations.passwords.email_change_password_button }}</label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control has-icons-left">
                                <input 
                                    class="input" 
                                    type="password" 
                                    v-model="user.password" 
                                    :placeholder="translations.passwords.view_placeholder_new_password">
                                <span class="icon is-small is-left">
                                    <i class="fas fa-lock"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label"></label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control has-icons-left">
                                <input 
                                    class="input" 
                                    type="password" 
                                    v-model="user.password_confirmation" 
                                    :placeholder="translations.passwords.view_placeholder_confirm_password">
                                <span class="icon is-small is-left">
                                    <i class="fas fa-lock"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="field is-horizontal">
                    <div class="field-label">
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input type="submit" class="button is-primary" :value="translations.shared.view_btn_save">
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>
