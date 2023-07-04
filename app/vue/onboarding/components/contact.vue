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
import { computed } from "vue"

// · import lesli stores
import { useOnboarding } from "LesliApp/onboarding/store"

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
