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
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    roles: I18n.t("core.roles"),
                    shared: I18n.t("core.shared"),
                    accounts: I18n.t("core.accounts"),
                    account: {
                        settings: I18n.t("core.account/settings")
                    },
                    onboardings: I18n.t("core.onboardings"),
                }
            },
            options: {
                time_zones: [],
                days_into_week: []
            },
        }
    },

    mounted() {
        this.getOptions()
    },

    methods: {
        getOptions(){
            this.http.get(this.url.admin("account/settings/options")).then(result => {
                if (result.successful) {
                    this.options = result.data;
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
    }

}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <p class="card-header-title">
                {{ translations.core.onboardings.view_title_datetime_formats }}
            </p>
        </div>
        <div class="card-content">
            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_time_zone }}
                    </label>
                </div>
                <div class="column">
                    <b-select
                        v-if="options.time_zones"
                        name="time-zone"
                        v-model="data.account_settings.datetime_time_zone"
                        expanded
                    >
                        <option
                            v-for="time_zone in options.time_zones"
                            :value="time_zone.value"
                            :key="time_zone.value"
                        >
                            {{ time_zone.text }}
                        </option>
                    </b-select>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_start_week_on }}
                    </label>
                </div>
                <div class="column">
                    <b-select
                        v-if="options.days_into_week"
                        name="start-week-on"
                        v-model="data.account_settings.datetime_start_week_on"
                        expanded
                    >
                        <option
                            v-for="day in options.days_into_week"
                            :value="day.value"
                            :key="day.value"
                        >
                            {{ day.text }}
                        </option>
                    </b-select>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_date_format }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="date-format" v-model="data.account_settings.datetime_format_date"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_time_format }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="time-format" v-model="data.account_settings.datetime_format_time"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_datetime_format }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="datetime-format" v-model="data.account_settings.datetime_format_date_time"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_date_words }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="date-words" v-model="data.account_settings.datetime_format_date_words"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_datetime_words }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="datetime-words" v-model="data.account_settings.datetime_format_date_time_words"></b-input>
                </div>
            </div>
        </div>
    </div>
</template>
