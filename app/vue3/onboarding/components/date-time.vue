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
import { onMounted, computed, ref } from "vue";

// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store";

// · implement stores
const storeOnboarding = useOnboarding();

// · translations
const translations = {
    core: {
        onboardings: I18n.t("core.onboardings"),
        accounts: I18n.t("core.accounts"),
        account_settings: I18n.t("core.account/settings"),
    },
};

onMounted(() => {
    storeOnboarding.getOptions();
});

// . get reactive info from onboarding store
const companyInfo = computed(() => storeOnboarding.companyInfo)
const settings = computed(() => storeOnboarding.settings)

// . declare variables
const timezoneValue = ref([])
const timeFormat = ref({ label:"", value:"" })
const dateFormat = ref({ label:"", value:"" })
const dateWords = ref({ label:"", value:"" })
const datetimeWords = ref(dateWords.value.label + timeFormat.value.label )
const combinedDate = ref(dateFormat.value.label + timeFormat.value.label )

// . Functions for updating date format values in store 

function updateTimezone() {
    settings.value.datetime_time_zone = timezoneValue.value.value
}
function updateDatetime() {
    combinedDate.value = dateFormat.value.label +" "+ timeFormat.value.label
    settings.value.datetime_format_date_time = dateFormat.value.value +" "+timeFormat.value.value
}

function updateDate() {
    settings.value.datetime_format_date = dateFormat.value.value
    updateDatetime()
}

function updateTime() {
    settings.value.datetime_format_time = timeFormat.value.value
    updateDatetime()
    updateDateWords()
}

function updateDateWords(){
    datetimeWords.value = dateWords.value.label +" "+ timeFormat.value.label
    settings.value.datetime_format_date_time_words = dateWords.value.value +" "+timeFormat.value.value
}

</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{
                translations.core.account_settings.column_time_zone
            }}</label>
            <div class="control">
                <lesli-select
                    :options="storeOnboarding.options.time_zones"
                    v-model="timezoneValue"
                    @change="updateTimezone"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_date_format
            }}</label>
            <div class="control">
                <lesli-select
                    :options="[
                        {
                            label: '24.03.2018',
                            value: '%d.%m.%Y',
                        },
                        {
                            label: '24-03-2018',
                            value: '%d-%m-%Y',
                        },
                        {
                            label: '24/03/2018',
                            value: '%d/%m/%Y',
                        },
                    ]"
                    v-model="dateFormat"
                    @change="updateDate"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_time_format
            }}</label>
            <div class="control">
                <lesli-select
                    :options="[
                        {
                            label: '10:30',
                            value: '%I:%M',
                        },
                        {
                            label: '10:30:20',
                            value: '%I:%M:%S',
                        },
                        {
                            label: '10:30 PM',
                            value: '%I:%M %p',
                        },
                        {
                            label: '22:30',
                            value: '%H:%M',
                        },
                        {
                            label: '22:30:20',
                            value: '%H:%M:%S',
                        },
                    ]"
                    v-model="timeFormat"
                    @change="updateTime"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_format_combined
            }}</label>
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
            <label class="label">{{ translations.core.onboardings.view_text_date_text }}</label>
            <div class="control">
                <lesli-select
                    :options="[
                        {
                            label: 'Saturday, March 24, 2018',
                            value: '%A, %B %d, %Y',
                        },
                        {
                            label: 'Sat, Mar 24, 2018',
                            value: '%a, %b %d, %Y',
                        },
                        {
                            label: 'Mar 24, 2018',
                            value: '%b %d, %Y',
                        },
                        {
                            label: 'March 24, 2018',
                            value: '%B %d, %Y',
                        }
                    ]"
                    v-model="dateWords"
                    @change="updateDateWords"
                >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_time_text }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    readonly
                    v-model="datetimeWords"
                />
            </div>
        </div>
    </form>
</template>
