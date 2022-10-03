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
import { useAccount } from "Lesli/vue3/administration/stores/account"

// · implement stores
const storeAccount = useAccount()

// · translations
const translations = {
    shared: I18n.t("core.shared"),
    core: {
        onboardings: I18n.t("core.onboardings"),
        accounts: I18n.t("core.accounts"),
    }
}

// . get reactive info from onboarding store
const companyInfo = computed(()=> storeOnboarding.companyInfo)

</script>
<template>
    <form @submit.prevent="storeAccount.updateInfo">
        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_email }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_email"
                    v-model="storeAccount.accountInfo.public_email"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{translations.shared.view_text_telephone}}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder= "translations.core.onboardings.view_placeholder_phone"
                    v-model="storeAccount.accountInfo.phone_number_1"
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
                    v-model="storeAccount.accountInfo.github"
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
                    v-model="storeAccount.accountInfo.twitter"
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
                    v-model="storeAccount.accountInfo.youtube"
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
                    v-model="storeAccount.accountInfo.linkedin"
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
                    v-model="storeAccount.accountInfo.facebook"
                />
            </div>
        </div>

        <div class="field">
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-button icon="save">
                            {{ translations.shared.view_btn_save }}
                        </lesli-button>                 
                    </div>
                </div>
            </div>
        </div>
    </form>
</template>
