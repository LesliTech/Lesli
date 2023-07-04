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
