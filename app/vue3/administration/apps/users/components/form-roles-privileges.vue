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
    users: I18n.t("core.users")
}

onMounted(() => {
    storeUser.getOptions()
})

const userRole = ref({ label:"", value:"" })

// function updateRole(){
//     storeUser.user.roles_id = userRole.value.value
// }

</script>

<template>

<div class="columns">
    <div class="column is-4">
        <form @submit.prevent="storeUser.putUserRole">
            <div class="field">
                <label class="label"> {{ translations.users.view_text_assing_role }} </label>
                <div class="control has-icons-left">
                    <div class="select">
                        <lesli-select
                            :options="storeUser.options.roles"
                            v-model="userRole"
                            @change="updateRole"
                        >
                        </lesli-select>
                    </div>
                    <div class="icon is-small is-left">
                        <i class="fas fa-key"></i>
                    </div>
                </div>
            </div>

            <div class="field">
                <div class="control">
                    <button class="button is-info"> {{ translations.shared.view_btn_save }}</button>
                </div>
            </div>
        </form>
    </div>

    <div class="column is-6">
        <div>
            <label class="label"> {{ translations.users.view_text_roles_assigned }}</label>
            <span class="tag is-success" v-for="role in storeUser.user.roles" :key="role">
                {{role.name}}
                <button class="delete is-small" @click="storeUser.deleteUserRole(role.id)"></button>
            </span>
        </div>
    </div>

</div>

</template>
    
