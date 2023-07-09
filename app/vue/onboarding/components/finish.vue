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



// · import lesli stores
import { useOnboarding } from "LesliApp/onboarding/store"


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
        <lesli-icon id="rocket"></lesli-icon>
        <h1>{{translations.core.onboardings.view_title_finish_onboarding}} </h1>
        <p class="mb-5">{{translations.core.onboardings.view_text_finish_configuration}}</p>
        <div class="has-text-centered">
            <button class="button is-primary mb-1 start" @click="storeOnboarding.saveConfiguration()">{{translations.core.onboardings.view_btn_continue_lesli}}</button>
            <button class="button is-text skip" @click="storeOnboarding.back()">{{translations.core.onboardings.view_btn_back_onboarding}}</button>
        </div>
    </div>
</template>
