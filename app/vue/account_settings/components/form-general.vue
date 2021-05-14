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
                "password_minimum_length": null,
                "password_expiration_time_days": null
            }
        }
    },
    mounted() {
        this.getSettings();
        console.log(this.translations.core.account.column_password_minimum_length)
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
            let filters = {
                password: true
            }
            this.http.get(
                this.url.admin("account/settings").filters(filters)
            ).then(result => {
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
        putSettings() {
            this.submitting_form = true
            this.http.put(this.url.admin("account/settings"), {
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
    <div class="box settings-general">
        <div class="field">
            <form @submit.prevent="putSettings()">
                <fieldset>
                    <div class="columns is-multiline">
                        <div class="column is-12">
                            <b-field label="translations.core.account.column_password_minimum_length">
                                <b-input v-model="settings.password_minimum_length"></b-input>
                            </b-field>
                        </div>
                        <div class="column is-12">
                            <b-field label="translations.core.account.column_password_expiration_time_days">
                                <b-input v-model="settings.password_expiration_time_days"></b-input>
                            </b-field>
                        </div>
                        <div class="column is-12">
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
    </div>
</template>
