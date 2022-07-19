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


// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store"

// · components
import buttonsComponent from "./components/buttons.vue"
import welcomeComponent from "./components/welcome.vue"
import indicatorsComponent from "./components/indicators.vue"
import generalInfoComponent from "./components/general-info.vue"
import addressComponent from "./components/address.vue"
import contactComponent from "./components/contact.vue"
import datetimeComponent from "./components/date-time.vue"
import finishComponent from "./components/finish.vue"


// · implement stores
const storeOnboarding = useOnboarding()

</script>
<template>
    <welcomeComponent v-if="storeOnboarding.view == 0"></welcomeComponent>
    <template v-if="storeOnboarding.view > 0">
        <indicatorsComponent v-if="storeOnboarding.view < 5"></indicatorsComponent>
        <generalInfoComponent v-if="storeOnboarding.view == 1"></generalInfoComponent>
        <addressComponent v-else-if="storeOnboarding.view == 2"></addressComponent>
        <contactComponent v-else-if="storeOnboarding.view == 3"></contactComponent>
        <datetimeComponent v-else-if="storeOnboarding.view == 4"></datetimeComponent>
        <buttonsComponent v-if="storeOnboarding.view < 5"></buttonsComponent>
        <finishComponent v-else-if="storeOnboarding.view == 5"></finishComponent>
    </template>
</template>

