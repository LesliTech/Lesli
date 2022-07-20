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
        <indicators-component v-if="storeOnboarding.view < 5"></indicators-component>
        <general-info-component v-if="storeOnboarding.view == 1"></general-info-component>
        <address-component v-else-if="storeOnboarding.view == 2"></address-component>
        <contact-component v-else-if="storeOnboarding.view == 3"></contact-component>
        <datetime-component v-else-if="storeOnboarding.view == 4"></datetime-component>
        <buttons-component v-if="storeOnboarding.view < 5"></buttons-component>
        <finish-component v-else-if="storeOnboarding.view == 5"></finish-component>
    </template>
</template>

