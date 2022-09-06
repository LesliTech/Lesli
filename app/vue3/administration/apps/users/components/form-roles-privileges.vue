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


/**
 * @description This function is used to assign or delete role from user
 */
function updateRole(role, select){
    if (select) {
        storeUser.addUserRole(role)
    } else {
        storeUser.deleteUserRole(role)
    }
}

</script>

<template>

<h4>{{ translations.users.view_text_roles_assigned }}</h4>

<div v-for="role in storeUser.options.roles" :key="role">
    <p>{{role.name}}</p>
    <lesli-toggle v-model="storeUser.rolesToggle[role.id]" v-on:update:modelValue="updateRole(role,storeUser.rolesToggle[role.id])" ></lesli-toggle>
</div>

</template>
