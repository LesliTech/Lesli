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
const translations = storeOnboarding.translations


</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{ translations.core.accounts.column_company_name }}</label>
            <div class="control">
                <input class="input" type="text" placeholder="Enter company name">
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_company_legal_name }}</label>
            <div class="control">
                <input class="input" type="text" placeholder="Enter full legal name i.e. Company GmbH">
            </div>
        </div>

        <div class="field">
            <label class="label">{{ translations.core.accounts.column_tag_line }}</label>
            <div class="control">
                <input class="input" type="text" placeholder="Enter company slogan">
            </div>
        </div>
    </form>
</template>
