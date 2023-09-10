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


// · import lesli stores
import { useOnboarding } from "LesliApp/onboarding/store"

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

