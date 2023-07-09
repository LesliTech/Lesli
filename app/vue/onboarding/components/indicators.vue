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


// · implement stores
const storeOnboarding = useOnboarding()

// · translations
const translations = {
    core: {
        onboardings: I18n.t("core.onboardings"),
        shared:  I18n.t("core.shared"),
        accounts: I18n.t("core.accounts"),
    }
}


</script>
<template>
    <ul class="indicator is-flex">
        <li :class="{'active': storeOnboarding.view == 1 }" v-on:click="storeOnboarding.view = 1">
            <lesli-icon id="company"></lesli-icon>
            <span>{{ translations.core.shared.view_tab_title_general_information }}</span>
        </li>
        <li><hr></li>
        <li :class="{'active': storeOnboarding.view == 2 }" v-on:click="storeOnboarding.view = 2">
            <lesli-icon id="location"></lesli-icon>
            <span>{{translations.core.accounts.column_address}}</span>
        </li>
        <li><hr></li>
        <li :class="{'active': storeOnboarding.view == 3 }" v-on:click="storeOnboarding.view = 3">
            <lesli-icon id="contacts"></lesli-icon>
            <span>{{translations.core.onboardings.view_title_contact_information}}</span>
        </li>
        <li><hr></li>
        <li :class="{'active': storeOnboarding.view == 4 }" v-on:click="storeOnboarding.view = 4">
            <lesli-icon id="datetime"></lesli-icon>
            <span>{{translations.core.onboardings.view_tab_title_date_and_time}}</span>
        </li>
    </ul>
</template>
