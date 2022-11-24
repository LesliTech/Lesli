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

const streetNumber = ref("")
const postalCode = ref("")

onMounted(() => {
    storeAccount.getOptions()
})

</script>
<template>
    <form @submit.prevent="storeAccount.updateInfo">
        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_column_street }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_street_number"
                    v-model="storeAccount.accountInfo.address"
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
                    v-model="storeAccount.accountInfo.postal_code"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.onboardings.view_text_column_city }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    :placeholder="translations.core.onboardings.view_placeholder_city"
                    v-model="storeAccount.accountInfo.city"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_country }}</label>
            <div class="control">
                <lesli-select 
                    :options="storeAccount.options.countries"
                    v-model="storeAccount.accountInfo.country"
                    >
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_region }}</label>
            <div class="control">
                <lesli-select 
                    :options="storeAccount.options.regions"
                    v-model="storeAccount.accountInfo.region"
                    >
                </lesli-select>
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
