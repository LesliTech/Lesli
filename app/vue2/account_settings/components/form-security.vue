<script>

export default {
    data(){
        return {
            loading: true,
            submitting_form: false,
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        settings: I18n.t("core.account/settings"),
                    }
                }
            },
            settings: {
                "password_enforce_complexity": null,
                "password_minimum_length": null,
                "password_expiration_time_days": null,
                "password_special_char_count": null,
                "password_uppercase_count": null,
                "password_lowercase_count": null,
                "password_digit_count": null
            }
        }
    },
    mounted() {
        this.getSettings();
    },
    methods: {
        parseSettings(settings_raw){
            settings_raw.forEach(setting_raw => {
                if (setting_raw.name in this.settings){
                    this.settings[setting_raw.name] = setting_raw.value
                }
            });
        },
        getSettings(){
            this.http.get(this.url.admin("account/settings")
            .filters({password: true}))
            .then(result => {
                if (result.successful) {
                    this.parseSettings(result.data);
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },
        postSettings() {
            this.submitting_form = true
            this.http.post(this.url.admin("account/settings"), {
                settings: this.settings
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
    <div class="box pr-6 settings-general">
        <form class="pr-6 mr-6" @submit.prevent="postSettings()">
            <fieldset class="py-5 pl-2 pr-6 mr-6">
                <div class="field is-horizontal mb-5">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_password_complex_enable }}
                        </label>
                    </div>
                    <div class="field-body">
                        <b-field>
                            <b-select v-model="settings.password_enforce_complexity" expanded>
                                <option value="1">{{translations.core.account.settings.view_text_password_enforcement_enabled}}</option>
                                <option value="0">{{translations.core.account.settings.view_text_password_enforcement_disabled}}</option>
                            </b-select>
                            <template v-slot:message>
                                <p class="has-text-info">
                                    {{ translations.core.account.settings.view_text_password_complex_description }}
                                </p>
                            </template>
                        </b-field>
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
                                <input class="input" type="number" v-model="settings.password_lowercase_count">
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
                                <input class="input" type="number" v-model="settings.password_uppercase_count">
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
                                <input class="input" type="number" v-model="settings.password_digit_count">
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
                                <input class="input" type="number" v-model="settings.password_special_char_count">
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
                                <input class="input" type="number" v-model="settings.password_minimum_length">
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
                                <input class="input" type="number" v-model="settings.password_expiration_time_days">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-grouped is-grouped-right">
                    <div class="control">
                        <button class="button is-primary">
                            <span v-if="submitting_form">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                &nbsp;
                                {{translations.core.shared.view_btn_saving}}
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small" />
                                &nbsp;
                                {{translations.core.shared.view_btn_save}}
                            </span>
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
</template>
<style>
    div.field-label {
        flex-basis: 140px;
    }
</style>
