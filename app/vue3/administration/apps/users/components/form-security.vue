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


// · 
const translations = {
    shared: I18n.t("core.shared"),
    passwords: I18n.t("core.users/passwords")
}

</script>
<template>
    <form @submit.prevent="storeUser.updatePassword()">
        <fieldset disabledd="lesli.current_user.id !== data.user.id">
            <h4 class="is-size-4 mb-4"> {{ translations.passwords.view_title_security }}</h4>
            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label">{{ translations.passwords.view_text_new_password }}</label>
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control has-icons-left">
                            <input 
                                required
                                class="input" 
                                type="password" 
                                v-model="storeUser.user.password" 
                                :placeholder="translations.passwords.view_placeholder_new_password">
                            <span class="icon is-small is-left">
                                <span class="material-icons">
                                    key
                                </span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label"> {{ translations.passwords.view_text_confirm_password }} </label>
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control has-icons-left">
                            <input 
                                required
                                class="input" 
                                type="password" 
                                v-model="storeUser.user.password_confirmation" 
                                :placeholder="translations.passwords.view_placeholder_confirm_password">
                            <span class="icon is-small is-left">
                                <span class="material-icons">
                                    key
                                </span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="field is-horizontal">
                <div class="field-label">
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control">
                            <lesli-button> {{ translations.shared.view_btn_save }}</lesli-button>
                        </div>
                    </div>
                </div>
            </div>
        </fieldset>
    </form>
</template>
