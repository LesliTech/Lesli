<script setup>
/*
Copyright (c) 2022, all rights reserved.

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

// · import vue tools
import { onMounted, ref } from "vue"

// · import lesli stores
import { useAccountSettings } from "Lesli/vue3/administration/stores/accountSettings"

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

// Format date variables
const currentDate = new Date()
const yyyy = currentDate.getFullYear()
let mm = currentDate.getMonth() + 1 < 10 ?  '0' + (currentDate.getMonth() + 1) : currentDate.getMonth() + 1
let dd = currentDate.getDate() < 10 ? '0' + currentDate.getDate() : currentDate.getDate()
let hh = currentDate.getHours() < 10 ? '0' + currentDate.getHours() : currentDate.getHours()
let min = currentDate.getMinutes() < 10 ? '0' + currentDate.getMinutes() : currentDate.getMinutes()
let sec = currentDate.getSeconds() < 10 ? '0' + currentDate.getSeconds() : currentDate.getSeconds()
let longDate = currentDate.toLocaleDateString('en-US', { weekday: 'long' }) +", "+ currentDate.toLocaleDateString('en-US', { month: 'long' }) +" "+ dd+ ", "+ yyyy
let shortDate =  currentDate.toLocaleDateString('en-US', { weekday: 'short' }) +", "+ currentDate.toLocaleDateString('en-US', { month: 'short' }) +" "+ dd+ ", "+ yyyy
let onlyMonthShort =  currentDate.toLocaleDateString('en-US', { month: 'short' }) +" "+ dd+ ", "+ yyyy
let onlyMonthLong = currentDate.toLocaleDateString('en-US', { month: 'long' }) +" "+ dd+ ", "+ yyyy
let hh_twelve = hh % 12 || 12 < 10 ? '0' + hh % 12 || 12  : hh % 12 || 12 
let period = currentDate.toLocaleString([], { hour12: true}).match(/[a-zA-Z]+/g)[0]

// . Functions for updating date format values in store 
function updateDatetime() {
    if (storeAccountSettings.settings.datetime_format_date == "%d.%m.%Y"){
        formatDate = dd +'.'+ mm +'.'+ yyyy
    } else if (storeAccountSettings.settings.datetime_format_date == "%d-%m-%Y"){
        formatDate = dd +'-'+ mm +'-'+ yyyy
    } else if (storeAccountSettings.settings.datetime_format_date == "%d/%m/%Y"){
        formatDate = dd +'/'+ mm +'/'+ yyyy
    }

    if (storeAccountSettings.settings.datetime_format_time == '%I:%M'){
        formatTime = hh_twelve +':'+ min
    } else if (storeAccountSettings.settings.datetime_format_time == '%I:%M:%S'){
        formatTime = hh_twelve +':'+ min +':'+ sec
    } else if (storeAccountSettings.settings.datetime_format_time == '%I:%M %p'){
        formatTime = hh_twelve +':'+ min +" "+period
    } else if (storeAccountSettings.settings.datetime_format_time == '%H:%M'){
        formatTime = hh +':'+ min
    } else if (storeAccountSettings.settings.datetime_format_time == '%H:%M:%S'){
        formatTime = hh +':'+ min +':'+ sec
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
        formatDateWords = longDate
    } else if (storeAccountSettings.settings.datetime_format_date_words== '%a, %b %d, %Y'){
        formatDateWords = shortDate
    } else if (storeAccountSettings.settings.datetime_format_date_words == '%b %d, %Y'){
        formatDateWords = onlyMonthShort
    } else if (storeAccountSettings.settings.datetime_format_date_words == '%B %d, %Y'){
        formatDateWords = onlyMonthLong
    }

    dateWords.value = formatDateWords + " " + formatTime
    storeAccountSettings.settings.datetime_format_date_time_words = storeAccountSettings.settings.datetime_format_date_words +" "+ storeAccountSettings.settings.datetime_format_time
}

onMounted(() => {
    storeAccountSettings.getOptions()
    storeAccountSettings.getSettings()
    initializeValues()
})

</script>
<template>
    <section class="application-component">
        <lesli-header 
            :title="translations.core.account.settings.view_tab_title_time_settings">
        </lesli-header>
        <form @submit.prevent="storeAccountSettings.postSettings" v-if="!storeAccountSettings.loading">
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
                                label: dd +'.'+ mm +'.'+ yyyy,
                                value: '%d.%m.%Y',
                            },
                            {
                                label: dd +'-'+ mm +'-'+ yyyy,
                                value: '%d-%m-%Y',
                            },
                            {
                                label: dd +'/'+ mm +'/'+ yyyy,
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
                                label: hh_twelve +':'+ min,
                                value: '%I:%M',
                            },
                            {
                                label: hh_twelve +':'+ min +':'+ sec,
                                value: '%I:%M:%S',
                            },
                            {
                                label: hh +':'+ min +' '+period,
                                value: '%I:%M %p',
                            },
                            {
                                label: hh +':'+ min,
                                value: '%H:%M',
                            },
                            {
                                label: hh +':'+ min +':'+ sec,
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
                                label: longDate,
                                value: '%A, %B %d, %Y',
                            },
                            {
                                label: shortDate,
                                value: '%a, %b %d, %Y',
                            },
                            {
                                label: onlyMonthShort,
                                value: '%b %d, %Y',
                            },
                            {
                                label: onlyMonthLong,
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
        </form>
    </section>
</template>
