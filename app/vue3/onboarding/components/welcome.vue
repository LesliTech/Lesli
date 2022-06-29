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


// · implement stores
const storeOnboarding = useOnboarding()


// · translations
const translations = {
    core: {
        onboardings: I18n.t("core.onboardings")
    }
}

</script>
<template>
    <div class="welcome has-text-centered">
        <lesli-icon id="high-five"></lesli-icon>
        <h1>Registration successfully confirmed. <br>Welcome to Lesli!</h1>
        <p>To be able to use Lesli properly we suggest to do onboarding first.</p>
        <p class="mb-5">It takes only couple of minutes to configure everything.</p>
        <div class="has-text-centered">
            <button class="button is-primary mb-1 start" @click="storeOnboarding.next()">Start onboarding</button>
            <button class="button is-text skip" @click="storeOnboarding.skip()">I'll do this later</button>
        </div>
    </div>
</template>
