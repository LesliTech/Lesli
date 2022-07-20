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

// . get reactive info from onboarding store
const companyInfo = computed(()=> storeOnboarding.companyInfo)


const countryValue = ref({})
const regionValue = ref({})
const streetNumber = ref("")
const postalCode = ref("")


onMounted(() => {
    storeOnboarding.getOptions()
})

// Function to get the value from selected option in country select 
function updateCountry (){
    companyInfo.value.country = countryValue.value.value
}
// Function to get the value from selected option in region select 
function updateRegion (){
    companyInfo.value.region = regionValue.value.value
}
// Function to concat values from address
function updateAddress (){
    companyInfo.value.address = streetNumber.value + ", " + postalCode.value
}

</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_column_street }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_street_number"
                    v-model="streetNumber"
                    @change="updateAddress"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_column_postal_code }}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    placeholder="XXXXXX"
                    v-model="postalCode" 
                    @change="updateAddress"/>
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_column_city }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_city"
                    v-model="companyInfo.city"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_country }}</label>
            <div class="control">
                <lesli-select 
                    :options="storeOnboarding.options.countries"
                    v-model="countryValue"
                    @change="updateCountry">
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_region }}</label>
            <div class="control">
                <lesli-select 
                    :options="storeOnboarding.options.regions"
                    v-model="regionValue"
                    @change="updateRegion">
                </lesli-select>
            </div>
        </div>
    </form>
</template>
