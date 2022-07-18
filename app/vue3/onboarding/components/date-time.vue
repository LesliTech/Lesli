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
import { onMounted, watch, computed } from "vue"

// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store"

// · implement stores
const storeOnboarding = useOnboarding()

// . translations
const translations = storeOnboarding.translations

// . get reactive info from onboarding store
const companyInfo = computed(()=> storeOnboarding.companyInfo)
const settings = computed(()=> storeOnboarding.settings)

onMounted(() => {
    storeOnboarding.getOptions()
})

watch(() => storeOnboarding.options, () => {    
    countries.value = storeOnboarding.options.countries
    regions.value = storeOnboarding.options.regions
})

</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_select_city
            }}</label>
            <div class="control">
                <lesli-select></lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_date_format
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%d.%m.%Y"
                    v-model="settings.date_format"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_time_format
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%H:%M"
                    v-model="settings.time_format"
                />
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
                    placeholder="%d.%m.%Y %H:%M"
                    v-model="settings.date_format_time"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_date_text
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%A, %B %d, %Y"
                    v-model="settings.date_text"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_time_text
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="%A, %B %d, %Y, %H:%M"
                    v-model="city"
                />
            </div>
        </div>
    </form>
</template>
