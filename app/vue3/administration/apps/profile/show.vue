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
import { useProfile } from "LesliVue/stores/profile"


// · implement stores
const storeProfile = useProfile()


// · import profile components
import cardInformation from "./components/card-information.vue"
import formInformation from "./components/form-information.vue"


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
    storeProfile.fetch()
})


</script>
<template>
    <section class="application-component">
        <cardInformation></cardInformation>
        <lesli-tabs>
            <lesli-tab-item title="Information">
                <formInformation></formInformation>
            </lesli-tab-item>
            <lesli-tab-item title="Suscripciones"></lesli-tab-item>
            <lesli-tab-item title="Security"></lesli-tab-item>
            <lesli-tab-item title="Session management"></lesli-tab-item>
            <lesli-tab-item title="Settings"></lesli-tab-item>
            <lesli-tab-item title="Integraciones"></lesli-tab-item>
        </lesli-tabs>
    </section>
</template>
