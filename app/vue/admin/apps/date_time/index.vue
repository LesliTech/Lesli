<script setup>
/*
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { onMounted, ref } from "vue"


// · import lesli stores
import { useAccountSettings } from "LesliApp/administration/stores/accountSettings"


// · Import dayjs library
import dayjs from "dayjs"


// · implement stores
const storeAccountSettings = useAccountSettings()


// · translations
const translations = {
    core: {
        onboardings: I18n.t("core.onboardings"),
        accounts: I18n.t("core.accounts"),
        account: {
            settings: I18n.t("core.account/settings"),
            files: I18n.t('core.account/files')
        },
        shared: I18n.t('core.shared'),
    },
}


// . declare variables
const combinedDate = ref("")
const dateWords = ref("")
let formatDate = ""
let formatTime = ""
let formatDateWords = ""


// . Functions for updating date format values in store 
function updateDatetime() {
    if (storeAccountSettings.settings.datetime_format_date == "%d.%m.%Y"){
        formatDate = dayjs().format('DD.MM.YYYY')
    } else if (storeAccountSettings.settings.datetime_format_date == "%d-%m-%Y"){
        formatDate = dayjs().format('DD-MM-YYYY')
    } else if (storeAccountSettings.settings.datetime_format_date == "%d/%m/%Y"){
        formatDate = dayjs().format('DD/MM/YYYY')
    }

    if (storeAccountSettings.settings.datetime_format_time == '%I:%M'){
        formatTime = dayjs().format('hh:mm')
    } else if (storeAccountSettings.settings.datetime_format_time == '%I:%M:%S'){
        formatTime = dayjs().format('hh:mm:ss')
    } else if (storeAccountSettings.settings.datetime_format_time == '%I:%M %p'){
        formatTime = dayjs().format('hh:mm A')
    } else if (storeAccountSettings.settings.datetime_format_time == '%H:%M'){
        formatTime = dayjs().format('HH:mm')
    } else if (storeAccountSettings.settings.datetime_format_time == '%H:%M:%S'){
        formatTime = dayjs().format('HH:mm:ss')
    }
    combinedDate.value = formatDate + " " + formatTime
    storeAccountSettings.settings.datetime_format_date_time = storeAccountSettings.settings.datetime_format_date +" "+storeAccountSettings.settings.datetime_format_time
}

function updateTime() {
    updateDatetime()
    updateDateWords()
}

function updateDateWords(){

    if (storeAccountSettings.settings.datetime_format_date_words == '%A, %B %d, %Y'){
        formatDateWords = dayjs().format('dddd, MMMM DD, YYYY')
    } else if (storeAccountSettings.settings.datetime_format_date_words== '%a, %b %d, %Y'){
        formatDateWords = dayjs().format('ddd, MMM DD, YYYY')
    } else if (storeAccountSettings.settings.datetime_format_date_words == '%b %d, %Y'){
        formatDateWords = dayjs().format('MMM DD, YYYY')
    } else if (storeAccountSettings.settings.datetime_format_date_words == '%B %d, %Y'){
        formatDateWords = dayjs().format('MMMM DD, YYYY')
    }

    dateWords.value = formatDateWords + " " + formatTime
    storeAccountSettings.settings.datetime_format_date_time_words = storeAccountSettings.settings.datetime_format_date_words +" "+ storeAccountSettings.settings.datetime_format_time
}


onMounted(() => {
    storeAccountSettings.getOptions()
    storeAccountSettings.getSettings()
    updateTime()
})

</script>
<template>
    <application-component>
        <lesli-header :title="translations.core.account.settings.view_tab_title_time_settings">
        </lesli-header>
        <lesli-form @submit="storeAccountSettings.postSettings" v-if="!storeAccountSettings.loading">
            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{translations.core.account.settings.column_time_zone}}
                    </label>
                </div>
                <div class="column is-6">
                    <lesli-select v-if="!storeAccountSettings.loading"
                        :options="storeAccountSettings.options.time_zones"
                        v-model="storeAccountSettings.settings.datetime_time_zone"
                    >
                    </lesli-select>
                </div>
            </div>

            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{translations.core.onboardings.view_text_date_format}}
                    </label>
                </div>

                <div class="column is-6">
                    <lesli-select
                        :options="[
                            {
                                label: dayjs().format('DD.MM.YYYY'),
                                value: '%d.%m.%Y',
                            },
                            {
                                label: dayjs().format('DD-MM-YYYY'),
                                value: '%d-%m-%Y',
                            },
                            {
                                label: dayjs().format('DD/MM/YYYY'),
                                value: '%d/%m/%Y',
                            },
                        ]"
                        v-model="storeAccountSettings.settings.datetime_format_date"
                        @change="updateDatetime"
                    >
                    </lesli-select>
                </div>
            </div>

            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{translations.core.onboardings.view_text_time_format}}
                    </label>
                </div>
                <div class="column is-6">
                    <lesli-select
                        :options="[
                            {
                                label: dayjs().format('hh:mm'),
                                value: '%I:%M',
                            },
                            {
                                label: dayjs().format('hh:mm:ss'),
                                value: '%I:%M:%S',
                            },
                            {
                                label: dayjs().format('hh:mm A'),
                                value: '%I:%M %p',
                            },
                            {
                                label: dayjs().format('HH:mm'),
                                value: '%H:%M',
                            },
                            {
                                label: dayjs().format('HH:mm:ss'),
                                value: '%H:%M:%S',
                            },
                        ]"
                        v-model="storeAccountSettings.settings.datetime_format_time"
                        @change="updateTime"
                    >
                    </lesli-select>
                </div>
            </div>

            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{translations.core.onboardings.view_text_format_combined}}
                    </label>
                </div>
                <div class="column is-6">
                    <input
                        class="input"
                        type="text"
                        readonly
                        v-model="combinedDate"
                    />
                </div>
            </div>

            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{ translations.core.onboardings.view_text_date_text}}
                    </label>
                </div>
                <div class="column is-6">
                    <lesli-select
                        :options="[
                            {
                                label: dayjs().format('dddd, MMMM DD, YYYY'),
                                value: '%A, %B %d, %Y',
                            },
                            {
                                label: dayjs().format('ddd, MMM DD, YYYY'),
                                value: '%a, %b %d, %Y',
                            },
                            {
                                label: dayjs().format('MMM DD, YYYY'),
                                value: '%b %d, %Y',
                            },
                            {
                                label: dayjs().format('MMMM DD, YYYY'),
                                value: '%B %d, %Y',
                            }
                        ]"
                        v-model="storeAccountSettings.settings.datetime_format_date_words"
                        @change="updateDateWords"
                    >
                    </lesli-select>
                </div>
            </div>

            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{ translations.core.onboardings.view_text_time_text }}
                    </label>
                </div>
                <div class="column is-6">
                    <input
                        class="input"
                        type="text"
                        readonly
                        v-model="dateWords"
                    />
                </div>
            </div>


            <div class="field is-grouped is-grouped-centered">
                <div class="control">
                    <lesli-button icon="save">
                        <span v-if="storeAccountSettings.submitting_form">
                            {{translations.core.shared.view_btn_saving}}
                        </span>
                        <span v-else>
                            {{translations.core.shared.view_btn_save}}
                        </span>
                    </lesli-button>
                </div>
            </div>
        </lesli-form>
    </application-component>
</template>
