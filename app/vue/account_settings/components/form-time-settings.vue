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
            options: {
                "time_zones": [],
                "days_into_week": []
            },
            settings: {
                "date_format": null,
                "date_format_full": null,
                "date_format_time": null,
                "time_zone": null,
                "start_week_on": null,
            }
        }
    },
    mounted() {
        window.settings = this.translations.core.account.settings
        this.getSettings();
        this.getOptions();
    },
    methods: {
        getOptions(){
            this.http.get(
                this.url.admin("account/settings/options")
            ).then(result => {
                if (result.successful) {
                    this.options = result.data;
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        parseSettings(settings_raw){
            settings_raw.forEach(setting_raw => {
                if (setting_raw.name in this.settings){
                    this.settings[setting_raw.name] = setting_raw.value
                }
            });
        },
        getSettings(){
            let filters = {
                time_settings: true
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
                this.msg.success(this.translations.core.account.settings.messages_success_settings_saved_successfully)
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
                            <b-field :label="translations.core.account.settings.column_date_format">
                                <b-input v-model="settings.date_format"></b-input>
                            </b-field>
                        </div>
                        <div class="column is-12">
                            <b-field :label="translations.core.account.settings.column_date_format_full">
                                <b-input v-model="settings.date_format_full"></b-input>
                            </b-field>
                        </div>
                        <div class="column is-12">
                            <b-field :label="translations.core.account.settings.column_date_format_time">
                                <b-input v-model="settings.date_format_time"></b-input>
                            </b-field>
                        </div>
                        <div class="column is-12">
                            <b-field :label="translations.core.account.settings.column_time_zone">
                              <b-select
                                  v-if="options.time_zones"
                                  name="settings-time-time_zone"
                                  v-model="settings.time_zone"
                                  placeholder="translations.main.view_placeholder_select_brand"
                                  expanded
                              >
                                <option
                                    v-for="time_zone in options.time_zones"
                                    :value="time_zone.value"
                                    :key="time_zone.value"
                                >
                                  {{time_zone.text}}
                                </option>
                              </b-select>
                            </b-field>
                        </div>
                        <div class="column is-12">
                            <b-field :label="translations.core.account.settings.column_start_week_on">
                                <b-select
                                    v-if="options.days_into_week"
                                    name="settings-time-start_week_on"
                                    v-model="settings.start_week_on"
                                    placeholder="translations.main.view_placeholder_select_brand"
                                    expanded
                                >
                                  <option
                                      v-for="day in options.days_into_week"
                                      :value="day.value"
                                      :key="day.value"
                                  >
                                      {{day.text}}
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
                </fieldset>
            </form>
        </div>
    </div>
</template>
