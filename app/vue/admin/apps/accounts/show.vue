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
import { computed, onMounted } from "vue"


// · import lesli stores
import { useAccount } from "LesliAdmin/stores/account"

// · import account components
import formInformation from "./components/form-information.vue"
// import addressForm from "./components/address-form.vue"
// import contactForm from "./components/contact-form.vue"

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
    //storeAccount.fetch()
})

</script>
<template>
    <lesli-content>
        <lesli-header title="Account information">
        </lesli-header>
        <lesli-tabs v-model="tab">
            <lesli-tab-item title="General Information" icon="business">
                <form-information></form-information>
            </lesli-tab-item>
            <lesli-tab-item title="Address" icon="location_on">
                <!-- <address-form></address-form> -->
            </lesli-tab-item>
            <lesli-tab-item title="Contact" icon="contact_page">
                <!-- <contact-form></contact-form> -->
            </lesli-tab-item>
        </lesli-tabs>
    </lesli-content>
</template>
