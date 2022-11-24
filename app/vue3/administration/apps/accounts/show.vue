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
import { computed, onMounted } from "vue"


// · import lesli stores
import { useAccount } from "Lesli/vue3/administration/stores/account"

// · import account components
import formInformation from "./components/info-form.vue"
import addressForm from "./components/address-form.vue"
import contactForm from "./components/contact-form.vue"

// · implement stores
const storeAccount = useAccount()


// · translations
const translations = {
    core: {
        onboardings: I18n.t("core.onboardings"),
        accounts: I18n.t("core.accounts")
    }
}

// . get reactive info from onboarding store
const companyInfo = computed(()=> storeOnboarding.companyInfo)

onMounted(() => {
    storeAccount.fetch()
})

</script>
<template>
    <section class="application-component">
        <lesli-header 
            title="Account information">
        </lesli-header>
        <lesli-tabs v-model="tab">
            <lesli-tab-item title="General Information" icon="business">
                <form-information></form-information>
            </lesli-tab-item>
            <lesli-tab-item title="Address" icon="location_on">
                <address-form></address-form>
            </lesli-tab-item>
            <lesli-tab-item title="Contact" icon="contact_page">
                <contact-form></contact-form>
            </lesli-tab-item>
        </lesli-tabs>
    </section>

</template>
