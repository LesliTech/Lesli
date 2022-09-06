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


// · implement stores
const storeUser = useUser()
const router = useRouter()
const route = useRoute()


// · import profile components
import cardInformation from "../users/components/card-information.vue"
import formInformation from "../users/components/form-information.vue"
import managementSession from "../users/components/management-sessions.vue"
import integrationsInformation from "../users/components/integrations-information.vue"


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
})

</script>
<template>
    <section class="application-component">
        <cardInformation></cardInformation>
        <lesli-tabs v-if="storeUser.user.id">
            <lesli-tab-item title="Information">
                <formInformation></formInformation>
            </lesli-tab-item>
            <lesli-tab-item title="Suscripciones"></lesli-tab-item>
            <lesli-tab-item title="Security"></lesli-tab-item>
            <lesli-tab-item title="Session management">
                <managementSession></managementSession>
            </lesli-tab-item>
            <lesli-tab-item title="Settings"></lesli-tab-item>
            <lesli-tab-item title="Integraciones">
                <integrationsInformation></integrationsInformation>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
</template>
