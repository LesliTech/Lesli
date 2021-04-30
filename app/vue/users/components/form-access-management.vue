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
                roles: I18n.t("core.roles"),
                shared: I18n.t("core.shared"),
                confirmations: I18n.t("core.users/confirmations")
            },
            user: {},
            submit: {
                email: false
            }
        }
    },
    methods: {

        putUserActive() {
            setTimeout(() => {
                this.http.put(`/administration/users/${this.data.user.id}.json`, {
                    user: {
                        active: this.data.user.active
                    }
                }).then(result => {
                    if (!result.successful) {
                        this.msg.error(result.error.message)
                        return
                    }
                    this.msg.success(this.translations.users.messages_success_user_updated)
                })
            }, 500)
        },

        confirmEmailAdddressChange(){
            this.$buefy.dialog.confirm({
                title: this.translations.confirmations.view_title_change_email,
                message: this.translations.confirmations.view_text_change_email_confirmation_body,
                cancelText: this.translations.shared.view_btn_cancel,
                confirmText: this.translations.view_btn_accept,
                type: 'is-warning',
                onConfirm: ()=>{
                    this.changeEmailAddress()
                }
            })
        },

        changeEmailAddress(){
            let url = this.url.lesli(`administration/users/${this.data.user.id}/actions/email`)
            let data = {
                user: {
                    email: this.user.email
                }
            }

            this.http.put(url, data).then(result => {
                if(result.successful){
                    this.msg.success(this.translations.confirmations.messages_success_confirmation_email_sent)
                }else{
                    this.msg.error(result.error.message)
                }
            })

        }
    }
}
</script>

<template>
    <div class="card">
        <div class="card-content">

            <form v-if="lesli.current_user.id !=  data.user.id">
                <h4 class="is-size-4 mb-3"> {{ translations.users.view_title_manage_access }}</h4>
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">{{ translations.users.view_text_access_status }}</label>
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

            <form @submit.prevent="confirmEmailAdddressChange()">
                <h4 class="is-size-4 mb-3"> {{ translations.confirmations.view_title_change_email }}</h4>

                <fieldset :disabled="submit.email">
                    <div class="field is-horizontal">
                        <div class="field-label is-normal">
                            <label class="label">{{ translations.confirmations.view_text_new_email }}</label>
                        </div>
                        <div class="field-body">
                            <div class="field">
                                <div class="control has-icons-left">
                                    <input
                                        required
                                        class="input"
                                        type="text"
                                        v-model="user.email"
                                        :placeholder="translations.confirmations.view_placeholder_new_email">
                                    <span class="icon is-small is-left">
                                        <i class="fas fa-envelope"></i>
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
                                <b-button type="is-primary" native-type="submit">
                                    <b-icon v-if="submit.email" custom-class="fa-spin" size="is-small" icon="circle-notch"></b-icon>
                                    <b-icon v-else size="is-small" icon="save"></b-icon>
                                    <span>{{translations.users.view_btn_change_email}}</span>
                                </b-button>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </form>

        </div>
    </div>
</template>
