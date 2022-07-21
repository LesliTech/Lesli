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
import { computed } from "vue"


// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store"

// · implement stores
const storeOnboarding = useOnboarding()

// · translations
const translations = {
    core: {
        onboardings: I18n.t("core.onboardings"),
        accounts: I18n.t("core.accounts")
    }
}

// . get reactive info from onboarding store
const companyInfo = computed(()=> storeOnboarding.companyInfo)


</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{ translations.core.accounts.column_company_name }}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder="translations.core.onboardings.view_placeholder_company_name" 
                    v-model="companyInfo.company_name">
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_company_legal_name }}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder="translations.core.onboardings.view_placeholder_company_legal_name" 
                    v-model="companyInfo.company_name_legal">
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_tag_line }}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder="translations.core.onboardings.view_placeholder_company_slogan"
                    v-model="companyInfo.company_tag_line">
            </div>
        </div>
    </form>
</template>
