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
import { ref, reactive, onMounted, watch, computed, onUnmounted } from "vue";

// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store";

// · implement stores
const storeOnboarding = useOnboarding();

// . translations
const translations = storeOnboarding.translations;

var countries = ref([]);
var regions = ref([]);
var selectedCountry = ref([]);
var selectedRegion = ref([]);

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
                translations.core.onboardings.view_text_column_street
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter your street and number"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_column_postal_code
            }}</label>
            <div class="control">
                <input class="input" type="text" placeholder="XXXXXX" />
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_column_city
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter city name"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.accounts.column_country
            }}</label>
            <div class="control">
                <select>
                    <option v-for="country in countries"
                            :value="country.name"
                            :key="country.id"> {{ country.name }}</option>
                </select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{
                translations.core.accounts.column_region
            }}</label>
            <div class="control">
                <select>
                    <option v-for="region in regions"
                            :value="region.value"
                            :key="region.key"> {{ region.value }}</option>
                </select>
            </div>
        </div>
    </form>
</template>
