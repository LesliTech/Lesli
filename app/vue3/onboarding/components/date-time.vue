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
import { onMounted, computed, ref } from "vue"

// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store"

// · implement stores
const storeOnboarding = useOnboarding()

// . translations
const translations = storeOnboarding.translations

onMounted(() => {
    storeOnboarding.getOptions()
})

// . get reactive info from onboarding store
const companyInfo = computed(()=> storeOnboarding.companyInfo)
const settings = computed(()=> storeOnboarding.settings)

const timezoneValue = ref([])

function updateTimezone (){
    settings.value.datetime_time_zone = timezoneValue.value.value
}

</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{ translations.core.account_settings.column_time_zone }}</label>
            <div class="control">
                <lesli-select
                    :options="storeOnboarding.options.time_zones"
                    v-model="timezoneValue"
                    @change="updateTimezone">
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_date_format }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%d.%m.%Y"
                    v-model="settings.datetime_format_date"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_time_format }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%H:%M"
                    v-model="settings.datetime_format_time"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_format_combined }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%d.%m.%Y %H:%M"
                    v-model="settings.datetime_format_date_time"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_date_text }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%A, %B %d, %Y"
                    v-model="settings.datetime_format_date_words"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_time_text }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%A, %B %d, %Y, %H:%M"
                    v-model="settings.datetime_format_date_time_words"
                />
            </div>
        </div>
    </form>
</template>
