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



// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store"


// · implement stores
const storeOnboarding = useOnboarding()


// · translations
const translations = storeOnboarding.translations

</script>
<template>
    <div class="welcome has-text-centered">
        <lesli-icon id="rocket"></lesli-icon>
        <h1>{{translations.core.onboardings.view_title_finish_onboarding}} </h1>
        <p class="mb-5">{{translations.core.onboardings.view_text_finish_configuration}}</p>
        <div class="has-text-centered">
            <button class="button is-primary mb-1 start" @click="storeOnboarding.saveConfiguration()">{{translations.core.onboardings.view_btn_continue_lesli}}</button>
            <button class="button is-text skip" @click="storeOnboarding.back()">{{translations.core.onboardings.view_btn_back_onboarding}}</button>
        </div>
    </div>
</template>
