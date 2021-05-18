<script>
/*

Copyright (c) 2021, all rights reserved.

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
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        settings: I18n.t("core.account/settings"),
                    }
                }
            },
            loading: true,
            submitting_form: false,
            loading_options: true,
            options: [],
            settings: {
                "default_currency": null
            }
        }
    },
    mounted() {
        this.getOptions();
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
        getOptions(){
            this.http.get(
                this.url.admin("account/currencies/list")
            ).then(result => {
                if (result.successful) {
                    this.options = result.data;
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading_options = false
            });
        },
        getSettings(){
            let filters = {
                currency: true
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
    <div class="box settings-currencies">
        <div class="field">
            <form @submit.prevent="putSettings()">
                <div class="columns is-multiline">
                    <div class="column is-12">
                        <b-field label="translations.core.account.settings.column_start_week_on">
                            <b-select
                                name="settings-default-currency"
                                v-model="settings.default_currency"
                                placeholder="translations.main.view_placeholder_select_brand"
                                expanded
                                :loading="loading_options"
                            >
                                <option
                                    v-for="option in options"
                                    :value="option.id"
                                    :key="option.id"
                                >
                                    {{option.name}}
                                </option>
                            </b-select>
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
            </form>
        </div>
    </div>
</template>
