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
        shared:  I18n.t("core.shared"),
        accounts: I18n.t("core.accounts"),
    }
}

// . get reactive info from onboarding store
const companyInfo = computed(()=> storeOnboarding.companyInfo)

</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_email }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_email"
                    v-model="companyInfo.public_email"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{translations.core.shared.view_text_telephone}}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder= "translations.core.onboardings.view_placeholder_phone"
                    v-model="companyInfo.phone_number_1"
                />
            </div>
        </div>

        <p>{{translations.core.onboardings.view_title_social_profiles}}</p>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_github }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_github"
                    v-model="companyInfo.github"
                />
            </div>
        </div>


        <div class="field">
            <label class="label">{{ translations.core.accounts.column_twitter }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_twitter"
                    v-model="companyInfo.twitter"
                />
            </div>
        </div>

        
        <div class="field">
            <label class="label">{{ translations.core.accounts.column_youtube }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_youtube"
                    v-model="companyInfo.youtube"
                />
            </div>
        </div>

                
        <div class="field">
            <label class="label">{{ translations.core.accounts.column_linkedin }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_linkedin"
                    v-model="companyInfo.linkedin"
                />
            </div>
        </div>

                
        <div class="field">
            <label class="label">{{ translations.core.accounts.column_facebook }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_facebook"
                    v-model="companyInfo.facebook"
                />
            </div>
        </div>
    </form>
</template>
