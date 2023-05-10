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
import { useUser } from "LesliApp/administration/stores/user"    
import { useRoles } from "LesliApp/administration/stores/roles"


// · implement stores
const storeUser = useUser()
const storeRoles = useRoles()


// · 
const translations = {
    shared: I18n.t("core.shared"),
    passwords: I18n.t("core.users/passwords"),
    users: I18n.t("core.users")
}


// · 
function updateRole(role){
    if (role.active) {
        storeUser.postRole(role)
    } else {
        storeUser.deleteRole(role)
    }
}


// · 
onMounted(() => {
    storeUser.getRoles()
})
</script>
<template>
    <div class="media px-6" v-for="role in storeUser.roles">
        <div class="media-content pt-4">
            <h4>{{ role.name }}</h4>
            <p style="color:#aaa;">
                {{ role.description }}
                Profile view, Role view, Role create, Role update
            </p>
        </div>
        <div class="media-right pt-4">
            <lesli-toggle v-model="role.active" @change="updateRole(role)">
            </lesli-toggle>
        </div>
    </div>
    <lesli-empty v-if="storeUser.roles.length == 0"></lesli-empty>
    <!--
    <div class="roles-types">
        <div 
            class="card roles-types-item p-4 is-flex is-flex-direction-column is-justify-content-space-between is-clickable" 
            v-for="role in storeUser.options.roles"
            :key="role">
            <div class="role-type-title">
                <span class="has-text-weight-semibold is-size-5 ">
                    {{ role.name }}
                </span>
            </div>
            <div>
                <span>Permission level: {{ role.object_level_permission }} </span>
            </div>
            <div class="is-flex is-justify-content-space-between is-align-items-center">
                <lesli-toggle v-model="storeUser.rolesToggle[role.id]" v-on:update:modelValue="updateRole(role,storeUser.rolesToggle[role.id])" ></lesli-toggle>
            </div>
        </div>
    </div>
    -->
</template>
