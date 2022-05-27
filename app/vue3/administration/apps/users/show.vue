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
import cardInformation from "./components/card-information.vue"
import formInformation from "./components/form-information.vue"
import managementSession from "./components/management-sessions.vue"


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
    storeUser.$reset
    storeUser.fetch(route.params?.id)
})


onUnmounted(() => {
    storeUser.$reset
})

</script>
<template>
    <section class="application-component">
        <cardInformation></cardInformation>
        <div class="level">
            <div class="level-left">
                <div class="level-item">
                    <button class="button is-light">
                        <span class="icon">
                            <span class="material-icons">
                                lock_open
                            </span>
                        </span>
                        <span>Request password change</span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button is-light">
                        <span class="icon">
                        <span class="material-icons">
                            logout
                        </span>
                        </span>
                        <span>Forced logout</span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button is-light">
                        <span class="icon">
                            <span class="material-icons">
                                lock_outline
                            </span>
                        </span>
                        <span>Revoke access</span>
                    </button>
                </div>
            </div>
            <div class="level-right">
                <div class="level-item">
                    <button class="button is-danger is-outlined">
                        <span class="icon">
                            <span class="material-icons">
                                delete_forever
                            </span>
                        </span>
                        <span>Mark as deleted</span>
                    </button>
                </div>
            </div>
        </div>

        <lesli-tabs>
            <lesli-tab-item title="Information">
                <formInformation></formInformation>
            </lesli-tab-item>
            <lesli-tab-item title="Suscripciones"></lesli-tab-item>
            <lesli-tab-item title="Security"></lesli-tab-item>
            <lesli-tab-item title="Session management"></lesli-tab-item>
            <lesli-tab-item title="Settings"></lesli-tab-item>
            <lesli-tab-item title="Integraciones"></lesli-tab-item>
            <!--
            <lesli-tab-item title="Suscripciones"></lesli-tab-item>
            <lesli-tab-item title="Security"></lesli-tab-item>
            <lesli-tab-item title="Session management">
                <managementSession></managementSession>
            </lesli-tab-item>
            <lesli-tab-item title="Settings"></lesli-tab-item>
            <lesli-tab-item title="Integraciones"></lesli-tab-item>
            -->
        </lesli-tabs>
    </section>
</template>
