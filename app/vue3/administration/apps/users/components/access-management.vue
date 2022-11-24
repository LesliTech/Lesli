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

</script>
<template>
    <div class="box">
        <h4>{{ translations.users.view_title_manage_access }}</h4>
        <form>
            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <p>{{ translations.users.view_text_access_status }}</p>
                </div>
                
                <div class="field-body">
                    <div class="field is-narrow">
                        <div class="control">
                            <lesli-toggle v-model="storeUser.user.active" @update:modelValue="storeUser.changeUserStatus" show-text enabled-text="active" disabled-text="inactive"></lesli-toggle>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</template>
