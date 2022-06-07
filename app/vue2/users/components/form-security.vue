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
                passwords: I18n.t("core.users/passwords"),
                users: I18n.t("core.users")
            },
            user: {
                mfa_enabled: null
            },
            mfa_methods: {},
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
                    this.msg.success(this.translations.passwords.notification_password_updated)
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })

        },

        putMFAUserEnabled(){
            let endpoint = this.url.admin("users/:id", this.lesli.current_user.id)
            let data = { user: { mfa_enabled:  this.user.mfa_enabled } }
 
            this.http.put(endpoint, data).then(response => {

                if( !response.successful ){
                    this.msg.error(response.error.message)
                    return
                }

                if(this.user.mfa_enabled){
                    this.msg.success(this.translations.users.messages_success_mfa_enabled)
                }else{
                    this.msg.success(this.translations.users.messages_success_mfa_disabled)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putMFAUserMethod(){
            let endpoint = this.url.admin("users/:id", this.lesli.current_user.id)
            let data = { user: { mfa_method:  this.user.mfa_method } }
 
            this.http.put(endpoint, data).then(response => {

                if( !response.successful ){
                    this.msg.error(response.error.message)
                    return
                }

                 this.msg.success(this.translations.users.messages_success_mfa_method_setted)
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {
        "user.mfa_enabled"(current, old){
            if(old != null && current != old){
                this.putMFAUserEnabled()
            }
        },
        "data.user"(user) {
            this.user = user
        },
        "data.options"(options){
            this.mfa_methods = options.mfa_methods
        }
    }
}
</script>

<template>
    <section class="box">
        <form @submit.prevent="putUserPassword()">
            <fieldset :disabled="lesli.current_user.id !== data.user.id">

                <h4 class="is-size-4 mb-4"> {{ translations.passwords.view_title_security }}</h4>
                <!--
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">{{ translations.passwords.view_text_current_password }}</label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control has-icons-left">
                                <input 
                                    class="input" 
                                    type="password" 
                                    v-model="user.password_old" 
                                    :placeholder="translations.passwords.view_placeholder_current_password">
                                <span class="icon is-small is-left">
                                    <i class="fas fa-lock"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                -->
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">{{ translations.passwords.view_text_new_password }}</label>
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
                        <label class="label"> {{ translations.passwords.view_text_confirm_password }} </label>
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
                                <input type="submit" class="button is-primary is-fullwidth" :value="translations.shared.view_btn_save">
                            </div>
                        </div>
                    </div>
                </div>
            </fieldset>
        </form>
        <form @submit.prevent="putMFAUserMethod">
            <fieldset>
                <h4 class="is-size-4 mb-4 mr-2"> {{ translations.users.view_text_multi_factor_authentication}}</h4>
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ user.mfa_enabled ? translations.shared.view_text_enabled : translations.shared.view_text_disabled }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <b-switch v-model="user.mfa_enabled" 
                                    required></b-switch>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="field is-horizontal" >
                    <div class="field-label is-normal">
                        <label class="label"> {{ translations.users.column_mfa_methods }} </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <b-select v-model="user.mfa_method" placeholder="Select an option" expanded required :disabled="!user.mfa_enabled">
                                    <option v-for="(method, index) in mfa_methods" :value="method" :key="index">
                                        {{ object_utils.translateEnum(translations.users, 'column_enum_mfa_method', method) }}
                                    </option>
                                </b-select>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-if="user.mfa_enabled" class="field is-horizontal">
                    <div class="field-label">
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input type="submit" class="button is-primary is-fullwidth" :value="translations.shared.view_btn_save">
                            </div>
                        </div>
                    </div>
                </div>
            </fieldset>
        </form>
    </section>
</template>
