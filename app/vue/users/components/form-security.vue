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
                shared: I18n.t("core.shared"),
                passwords: I18n.t("core.users/passwords")
            },
            user: {}
        }
    },
    methods: {

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

            <form @submit.prevent="putUserPassword()">
                <fieldset :disabled="lesli.current_user.id !== data.user.id">

                    <h4 class="is-size-4 mb-6">Password update</h4>

                    <div class="field is-horizontal">
                        <div class="field-label is-normal">
                            <label class="label">Current password</label>
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
                            <label class="label">New password</label>
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
                            <label class="label">Confirm password</label>
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
                </fieldset>
            </form>

        </div>
    </div>
</template>
