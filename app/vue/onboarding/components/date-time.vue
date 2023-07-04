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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/

// · import vue tools
import { onMounted, computed, ref } from "vue"

// · import lesli stores
import { useOnboarding } from "LesliApp/onboarding/store"

// · Import dayjs library
import dayjs from "dayjs"

// · implement stores
const storeOnboarding = useOnboarding()

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
    }
}

onMounted(() => {
    storeOnboarding.getOptions()
})


// . Functions for updating date format values in store 
function updateDate() {
    updateDatetime()
}

// . declare variables
const combinedDate = ref("")
const dateWords = ref("")
let formatDate = ""
let formatTime = ""
let formatDateWords = ""

// . Functions for updating date format values in store 
function updateDatetime() {
    if (storeOnboarding.settings.datetime_format_date == "%d.%m.%Y"){
        formatDate = dayjs().format('DD.MM.YYYY')
    } else if (storeOnboarding.settings.datetime_format_date == "%d-%m-%Y"){
        formatDate = dayjs().format('DD-MM-YYYY')
    } else if (storeOnboarding.settings.datetime_format_date == "%d/%m/%Y"){
        formatDate = dayjs().format('DD/MM/YYYY')
    }

    if (storeOnboarding.settings.datetime_format_time == '%I:%M'){
        formatTime = dayjs().format('hh:mm')
    } else if (storeOnboarding.settings.datetime_format_time == '%I:%M:%S'){
        formatTime = dayjs().format('hh:mm:ss')
    } else if (storeOnboarding.settings.datetime_format_time == '%I:%M %p'){
        formatTime = dayjs().format('hh:mm A')
    } else if (storeOnboarding.settings.datetime_format_time == '%H:%M'){
        formatTime = dayjs().format('HH:mm')
    } else if (storeOnboarding.settings.datetime_format_time == '%H:%M:%S'){
        formatTime = dayjs().format('HH:mm:ss')
    }
    combinedDate.value = formatDate + " " + formatTime
    storeOnboarding.settings.datetime_format_date_time = storeOnboarding.settings.datetime_format_date +" "+storeOnboarding.settings.datetime_format_time
}

function updateTime() {
    updateDatetime()
    updateDateWords()
}

function updateDateWords(){

    if (storeOnboarding.settings.datetime_format_date_words == '%A, %B %d, %Y'){
        formatDateWords = dayjs().format('dddd, MMMM DD, YYYY')
    } else if (storeOnboarding.settings.datetime_format_date_words== '%a, %b %d, %Y'){
        formatDateWords = dayjs().format('ddd, MMM DD, YYYY')
    } else if (storeOnboarding.settings.datetime_format_date_words == '%b %d, %Y'){
        formatDateWords = dayjs().format('MMM DD, YYYY')
    } else if (storeOnboarding.settings.datetime_format_date_words == '%B %d, %Y'){
        formatDateWords = dayjs().format('MMMM DD, YYYY')
    }

    dateWords.value = formatDateWords + " " + formatTime
    storeOnboarding.settings.datetime_format_date_time_words = storeOnboarding.settings.datetime_format_date_words +" "+ storeOnboarding.settings.datetime_format_time
}

onMounted(() => {
    storeOnboarding.getOptions()
})

</script>
<template>
    <form>

        <div class="field">
            <label class="label">
                {{translations.core.account.settings.column_time_zone}}
            </label>
            <div class="control">
                <lesli-select
                    :options="storeOnboarding.options.time_zones"
                    v-model="storeOnboarding.settings.datetime_time_zone"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{translations.core.onboardings.view_text_date_format}}
            </label>

            <div class="control">
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
                    v-model="storeOnboarding.settings.datetime_format_date"
                    @change="updateDatetime"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{translations.core.onboardings.view_text_time_format}}
            </label>
            <div class="control">
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
                    v-model="storeOnboarding.settings.datetime_format_time"
                    @change="updateTime"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{translations.core.onboardings.view_text_format_combined}}
            </label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    readonly
                    v-model="combinedDate"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{ translations.core.onboardings.view_text_date_text}}
            </label>
            <div class="control">
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
                    v-model="storeOnboarding.settings.datetime_format_date_words"
                    @change="updateDateWords"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{ translations.core.onboardings.view_text_time_text }}
            </label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    readonly
                    v-model="dateWords"
                />
            </div>
        </div>
    </form>
</template>
