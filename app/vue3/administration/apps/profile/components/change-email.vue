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
import { ref, reactive, onMounted, watch, computed } from "vue"


// · import lesli stores
import { useProfile } from "Lesli/vue3/administration/stores/users/profile"

// · implement stores
const storeProfile = useProfile()
    
    
// · 
const translations = {
    shared: I18n.t("core.shared"),
    passwords: I18n.t("core.users/passwords"),
    users: I18n.t("core.users"),
    confirmations: I18n.t("core.users/confirmations")
}
    
</script>

<template>
    <h4>{{ translations.confirmations.view_title_change_email }}</h4>
    <form @submit.prevent="storeProfile.changeEmail">
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <p>{{ translations.confirmations.view_text_new_email }}</p>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control has-icons-left">
                        <input
                            required
                            class="input"
                            type="email"
                            v-model="storeProfile.new_email"
                            :placeholder="translations.confirmations.view_placeholder_new_email">
                        <span class="icon is-small is-left">
                            <i class="fas fa-envelope"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <div class="field is-horizontal">
            <div class="field-label"></div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-button> {{ translations.shared.view_btn_save }}</lesli-button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</template>    
