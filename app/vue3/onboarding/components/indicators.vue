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

// . translations
const translations = storeOnboarding.translations


</script>
<template>
    <ul class="indicator is-flex">
        <li :class="{'active': storeOnboarding.view == 1 }">
            <lesli-icon id="company"></lesli-icon>
            <span>{{ translations.core.shared.view_tab_title_general_information }}</span>
        </li>
        <li><hr></li>
        <li :class="{'active': storeOnboarding.view == 2 }">
            <lesli-icon id="location"></lesli-icon>
            <span>{{translations.core.accounts.column_address}}</span>
        </li>
        <li><hr></li>
        <li :class="{'active': storeOnboarding.view == 3 }">
            <lesli-icon id="contacts"></lesli-icon>
            <span>{{translations.core.onboardings.view_title_contact_information}}</span>
        </li>
        <li><hr></li>
        <li :class="{'active': storeOnboarding.view == 4 }">
            <lesli-icon id="datetime"></lesli-icon>
            <span>{{translations.core.onboardings.view_tab_title_date_and_time}}</span>
        </li>
    </ul>
</template>
