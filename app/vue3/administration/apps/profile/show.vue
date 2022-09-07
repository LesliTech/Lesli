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
import { ref, reactive, onMounted, watch, computed, onUnmounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useUser } from "LesliVue/stores/user"
import { useProfile } from "Lesli/vue3/administration/stores/users/profile"

// · import profile components
import cardInformation from "../users/components/card-information.vue"
import formInformation from "../users/components/form-information.vue"
import managementSession from "../users/components/management-sessions.vue"
import formSecurity from "../users/components/form-security.vue"
import integrationsInformation from "../users/components/integrations-information.vue"
import subscriptionsComponent from "./components/subscriptions.vue"
import settings from "../users/components/settings.vue"
import changeEmail from "./components/change-email.vue"


// · implement stores
const storeUser = useUser()
const storeProfile = useProfile()
const router = useRouter()
const route = useRoute()

// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared")
    }
}


// · initializing
onMounted(() => {
    storeUser.fetch()
    storeUser.getOptions()
    storeProfile.fetchProfile()
})

</script>
<template>
    <section class="application-component">
        <cardInformation></cardInformation>
        <lesli-tabs>
            <lesli-tab-item title="Information">
                <formInformation></formInformation>
            </lesli-tab-item>
            <lesli-tab-item title="Subscriptions">
                <subscriptionsComponent>
                </subscriptionsComponent>
            </lesli-tab-item>
            <lesli-tab-item title="Security">
                <formSecurity></formSecurity>
            </lesli-tab-item>
            <lesli-tab-item title="Access management">
                <changeEmail></changeEmail>
            </lesli-tab-item>
            <lesli-tab-item title="Session management">
                <managementSession></managementSession>
            </lesli-tab-item>
            <lesli-tab-item title="Settings">
                <settings></settings>
            </lesli-tab-item>
            <lesli-tab-item title="Integrations">
                <integrationsInformation></integrationsInformation>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
</template>
