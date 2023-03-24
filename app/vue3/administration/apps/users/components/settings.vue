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
import { useUser } from "LesliVue/stores/user" 


// · implement stores
const storeUser = useUser()


// · translations
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}


// · initializing
onMounted(() => {
    storeUser.getOptions()
})


</script>
<template>
    <form @submit.prevent="storeUser.setLanguage">
        <div class="field is-horizontal">
            <div class="field-label">
                <label class="label"> Select preferred language </label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control">
                        <div class="select">
                            <lesli-select 
                                icon="language" 
                                v-model="storeUser.language"
                                :options="storeUser.options.locales">
                            </lesli-select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="field is-horizontal">
            <div class="field-label is-normal">
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-button icon="save">
                            {{ translations.shared.view_btn_save }}
                        </lesli-button>                    
                    </div>
                </div>
            </div>
        </div>
    </form>
            <nav class="level">
            <div class="level-left">
                <div class="level-item">
                    <button class="button is-small" @click="doRequestPasswordChange()">
                        <span class="icon">
                            <span class="material-icons">
                                key
                            </span>
                        </span>
                        <span> {{ translations.users.view_btn_request_password_change }}</span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button" @click="doUserLogout()">
                        <span class="icon">
                            <span class="material-icons">
                                logout
                            </span>
                        </span>
                        <span>  {{ translations.users.view_btn_force_logout }}</span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button is-white" @click="doRevokeAccess()">
                        <span class="icon">
                            <span class="material-icons">
                                lock_outline
                            </span>
                        </span>
                        <span> {{ translations.users.view_btn_revoke_access }} </span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button is-white" @click="confirmMarkUserAsDeleted()">
                        <span class="icon"><i class="fas fa-user-slash"></i></span>
                        <span> {{ translations.users.view_btn_mark_user_as_deleted }} </span>
                    </button>
                </div>
            </div>
        </nav>
</template>
