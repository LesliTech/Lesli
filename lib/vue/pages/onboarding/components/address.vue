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

// · implement stores
const storeOnboarding = useOnboarding()

// · translations
const translations = {
    core: {
        onboardings: I18n.t("core.onboardings"),
        accounts: I18n.t("core.accounts"),
    }
}

const countryValue = ref({})
const regionValue = ref({})


onMounted(() => {
    storeOnboarding.getOptions()
})

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
                    v-model="storeOnboarding.companyInfo.address"
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
                    v-model="storeOnboarding.companyInfo.postal_code" 
                >
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_column_city }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_city"
                    v-model="storeOnboarding.companyInfo.city"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_country }}</label>
            <div class="control">
                <lesli-select 
                    :options="storeOnboarding.options.countries"
                    v-model="storeOnboarding.companyInfo.country"
                    >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_region }}</label>
            <div class="control">
                <lesli-select 
                    :options="storeOnboarding.options.regions"
                    v-model="storeOnboarding.companyInfo.region"
                    >
                </lesli-select>
            </div>
        </div>
    </form>
</template>
