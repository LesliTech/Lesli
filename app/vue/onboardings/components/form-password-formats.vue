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

    data() {
        return {
            submitting_form: false,
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    roles: I18n.t("core.roles"),
                    shared: I18n.t("core.shared"),
                    account: {
                        settings: I18n.t("core.account/settings")
                    }
                }
            },
        }
    },

    methods: {
        submit() {
            this.submitting_form = true
            this.http.post(this.url.admin("onboarding"), {
                account: this.data.account,
                account_settings: this.data.account_settings
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.info(this.translations.core.account.settings.messages_success_settings_saved_successfully)
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.submitting_form = false
            })
        }
    }

}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <form @submit.prevent="submit()">
                <br />
                <h1><strong>Security</strong></h1>
                <br />
                <br />
                <div class="field is-horizontal mb-5">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_complex_enable }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <div class="select">
                                    <select v-model="data.account_settings.password_enforce_complexity">
                                        <option value="1">Enabled</option>
                                        <option value="0">Disabled</option>
                                    </select>
                                </div>
                            </div>
                            <p><small class="has-text-info">
                                IMPORTANT: {{ translations.core.account.settings.view_text_password_complex_description }}
                            </small></p>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_lowercase_count }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input class="input" type="number" v-model="data.account_settings.password_lowercase_count">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_uppercase_count }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input class="input" type="number" v-model="data.account_settings.password_uppercase_count">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_numeric_count }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input class="input" type="number" v-model="data.account_settings.password_digit_count">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_special_char_count }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input class="input" type="number" v-model="data.account_settings.password_special_char_count">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_minimum_length }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input class="input" type="number" v-model="data.account_settings.password_minimum_length">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_expiration_time_days }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field">
                            <div class="control">
                                <input class="input" type="number" v-model="data.account_settings.password_expiration_time_days">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field">
                    <div class="control">
                        <button class="button is-primary">
                            <span v-if="submitting_form">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                &nbsp;
                                {{ translations.core.shared.view_btn_saving }}
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small" />
                                &nbsp;
                                {{ translations.core.shared.view_btn_save }}
                            </span>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>
