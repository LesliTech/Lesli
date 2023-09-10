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
import { ref, reactive, onMounted, watch, computed, onUnmounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useUser } from "CloudAdmin/stores/user"
import { useProfile } from "Lesli/shared/stores/profile"


// · import profile components
import informationCard from "CloudAdmin/apps/users/components/information-card.vue"
import informationForm from "CloudAdmin/apps/users/components/information-form.vue"

import managementSession from "CloudAdmin/apps/users/components/management-sessions.vue"
import managementSecurity from "CloudAdmin/apps/users/components/management-security.vue"

import integrationsInformation from "CloudAdmin/apps/users/components/integrations-information.vue"
import settings from "CloudAdmin/apps/users/components/management-settings.vue"
/*
import cardInformation from "../users/components/information-card.vue"
import formInformation from "../users/components/information-form.vue"
import managementSession from "../users/components/management-sessions.vue"
import integrationsInformation from "../users/components/integrations-information.vue"
import subscriptionsComponent from "./components/subscriptions.vue"
import settings from "../users/components/settings.vue"
import changeEmail from "./components/change-email.vue"
*/


// · implement stores
const storeUser = useUser()
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


// · 
const tab = ref(0)


// · 
onMounted(() => {
    storeUser.getUser()
    storeUser.getOptions()
})

</script>
<template>
    <application-component>
        <information-card></information-card>
        <lesli-tabs v-model="tab" v-if="storeUser.user.id">
            <lesli-tab-item icon="info_outline" :title="translations.core.users.view_tab_title_information">
                <information-form></information-form>
            </lesli-tab-item>
            <lesli-tab-item icon="security" :title="translations.core.users.view_tab_title_roles_and_privileges">
                <!--form-roles></form-roles -->
            </lesli-tab-item>
            <lesli-tab-item icon="lock_outline" :title="translations.core.users.view_tab_title_security || 'Security'">
                <management-security></management-security>
            </lesli-tab-item>
            <lesli-tab-item icon="devices" :title="translations.core.users.view_tab_title_session || 'Sessions'" paddingless>
                <management-session></management-session>
            </lesli-tab-item>
            <lesli-tab-item icon="settings" :title="translations.core.users.view_tab_title_settings">
                <!--settings></settings-->
            </lesli-tab-item>
        </lesli-tabs>
    </application-component>
    <!--
    <section class="application-component">
        <information-card></information-card>
        <lesli-tabs v-if="storeUser.user.id">
            <lesli-tab-item :title="translations.core.users.view_tab_title_information">
                <information-form></information-form>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_subscriptions">
                <subscriptions-component>
                </subscriptions-component>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.users.view_tab_title_security">
                <form-security></form-security>
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
    -->
</template>
