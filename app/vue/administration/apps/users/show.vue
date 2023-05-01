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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { ref, reactive, onMounted, watch, computed, onUnmounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useUser } from "LesliApp/administration/stores/user"
import { useProfile } from "Lesli/shared/stores/profile"


// · import profile components
import cardInformation from "./components/card-information.vue"
import formInformation from "./components/form-information.vue"
import managementSession from "./components/management-sessions.vue"
import formSecurity from "./components/form-security.vue"
import formRoles from "./components/form-roles-privileges.vue"
import integrationsInformation from "./components/integrations-information.vue"
import settings from "./components/settings.vue"
import actions from "./components/actions.vue"
import accessManagement from "./components/access-management.vue"


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


// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "administration/users",
    }
})


// · 
const tab = ref(0)


// · initializing
onMounted(() => {
    storeUser.getOptions()
    storeUser.fetch(route.params?.id)
})


</script>
<template>
    <section class="application-component">
        <card-information></card-information>
        <lesli-tabs v-model="tab" v-if="storeUser.user.id">
            <lesli-tab-item icon="info_outline" :title="translations.core.users.view_tab_title_information">
                <form-information is-editable></form-information>
            </lesli-tab-item>
            <lesli-tab-item icon="security" :title="translations.core.users.view_tab_title_roles_and_privileges">
                <form-roles></form-roles>
            </lesli-tab-item>
            <lesli-tab-item icon="devices" :title="translations.core.users.view_tab_title_session_management" paddingless>
                <management-session></management-session>
            </lesli-tab-item>
            <lesli-tab-item icon="settings" :title="translations.core.users.view_tab_title_settings">
                <settings></settings>
            </lesli-tab-item>
            <lesli-tab-item icon="sync_alt" :title="translations.core.users.view_tab_title_integrations || 'Integrations'">
                <integrations-information></integrations-information>
            </lesli-tab-item>
            <lesli-tab-item icon="manage_accounts" :title="translations.core.users.view_tab_title_actions || 'Actions'">
                <actions></actions>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
</template>
