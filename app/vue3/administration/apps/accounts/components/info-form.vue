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
import { ref, reactive, onMounted, watch, computed } from "vue"


// · import lesli stores
import { useAccount } from "Lesli/vue3/administration/stores/account"

// · implement stores
const storeAccount = useAccount()


// · 
const translations = {
    shared: I18n.t("core.shared"),
    passwords: I18n.t("core.users/passwords"),
    core: {
        accounts: I18n.t("core.accounts"),
        onboardings: I18n.t("core.onboardings")
    }
}

</script>
<template>
    <form @submit.prevent="storeAccount.updateInfo">
        <div class="field">
            <label class="label">{{ translations.core.accounts.column_company_name }}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder="translations.core.onboardings.view_placeholder_company_name"
                    v-model="storeAccount.accountInfo.company_name" 
                    >
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_company_legal_name }}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder="translations.core.onboardings.view_placeholder_company_legal_name" 
                    v-model="storeAccount.accountInfo.company_name_legal" 
                    >
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_tag_line }}</label>
            <div class="control">
                <input 
                    class="input" 
                    type="text" 
                    :placeholder="translations.core.onboardings.view_placeholder_company_slogan"
                    v-model="storeAccount.accountInfo.company_tag_line"
                    >
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
