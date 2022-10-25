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
        <card-information></card-information>
        <lesli-tabs v-if="storeUser.user.id">
            <lesli-tab-item :title="translations.core.users.view_tab_title_information">
                <form-information is-editable></form-information>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_subscriptions">
                <subscriptions-component>
                </subscriptions-component>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_security">
                <form-security></form-security>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_access_management">
                <change-email></change-email>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_session_management">
                <management-session></management-session>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_settings">
                <settings></settings>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_integrations">
                <integrations-information></integrations-information>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
</template>
