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
    passwords: I18n.t("core.users/passwords"),
    users: I18n.t("core.users"),
    confirmations: I18n.t("core.users/confirmations")
}

const status = ref({})

function updateStatus(){
    storeUser.user.active = status.value.value
    storeUser.changeUserStatus()
}

</script>
<template>
    <h4>{{ translations.users.view_title_manage_access }}</h4>
    <form>
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">{{ translations.users.view_text_access_status }}</label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control">
                        <div class="select is-fullwidth">
                            <lesli-select
                                @change="updateStatus()"
                                v-model="status"
                                :options="[{
                                                label: translations.shared.view_text_active,
                                                value: true
                                            }, {
                                                label: translations.shared.view_text_inactive,
                                                value: false
                                            }]"
                            >
                            </lesli-select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <h4>{{ translations.confirmations.view_title_change_email }}</h4>
    <form @submit.prevent="storeUser.changeEmail">
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">{{ translations.confirmations.view_text_new_email }}</label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control has-icons-left">
                        <input
                            required
                            class="input"
                            type="email"
                            v-model="storeUser.user.new_email"
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
