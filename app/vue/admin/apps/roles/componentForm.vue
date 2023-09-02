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
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from "vue-router"


// · import lesli stores
import { useRole } from "../../stores/role"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()


// · 
const translations = {
    core: {
        shared: I18n.t('core.shared'),
        roles: I18n.t('core.roles')
    }
}


// · 
onMounted(() => {
    if (route.params.id) {
        storeRole.fetchRole(route.params.id)
    } else {
        storeRole.$reset()
    }
    storeRole.getOptions()
})


// · 
function submitRole() {

    if (storeRole.role.id) {
        storeRole.putRole()
    }

    if (!storeRole.role.id) {
        return storeRole.postRole().then(result => {
            msg.success(translations.core.roles.messages_success_role_created_successfully)
            router.push(url.admin("roles/:id/edit", result.id).s)
        })
    }

}


// · 
function isObjectLevelPermissionSelected(olp) {
    return storeRole.role.object_level_permission == olp
}

</script>
<template>
    <form @submit.prevent="submitRole" class="box">

        <!-- Role name -->
        <div class="field">
            <label class="label">
                {{ translations.core.roles.column_name }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <input v-model="storeRole.role.name" class="input" type="text" required />
            </div>
        </div>

        <!-- Default path -->
        <div class="field">
            <label class="label">{{ translations.core.roles.column_default_path }}</label>
            <div class="control">
                <input v-model="storeRole.role.default_path" class="input" type="text" :placeholder="translations.core.roles.view_placeholder_default_path_at_login">
            </div>
            <p class="help"> {{ translations.core.roles.view_text_default_path_description }}</p>
        </div>

        <!-- Limit to default path -->
        <div class="field">
            <label class="label">
                {{ translations.core.roles.column_limit_to_path }}
            </label>
            <div class="control">
                <div class="select">
                    <lesli-select 
                        v-model="storeRole.role.limit_to_path"
                        :options="[{
                            label: translations.core.roles.view_text_limit_to_path,
                            value: true
                        }, {
                            label: translations.core.roles.view_text_allow_all_paths,
                            value: false
                        }]">
                    </lesli-select>
                </div>
            </div>
            <p class="help"> {{ translations.core.roles.view_text_default_path_description }}</p>
        </div>

        <hr>

        <!-- Object level permission -->
        <div class="field">
            <label class="label">
                {{ translations.core.roles.view_text_hierarchical_level }}
                <sup class="has-text-danger">*</sup>
            </label>
            <ul class="hierarchical_level_selector">
                <li :class="['hover', 'p-1', { 'has-background-info has-text-light' : isObjectLevelPermissionSelected(olp.level) }]"
                    v-for="(olp, index) in storeRole.options.object_level_permissions" :key="index"
                    v-on:click="storeRole.role.object_level_permission = olp.level">
                    <p class="icon-text">
                        <span class="icon">
                            <span class="material-icons">
                                {{ isObjectLevelPermissionSelected(olp.level) ? 'check_box' : 'check_box_outline_blank' }}
                            </span>
                            <i :class="['fas', isObjectLevelPermissionSelected(olp.level) ? 'fa-check' : 'fa-chevron-right']"></i>
                        </span>
                        <span>
                            {{ `${translations.core.roles.view_text_level || 'Level' } ${ index + 1 }` }}
                            <i v-if="olp.roles.length">- {{ olp.roles.map(role => role.name).join(', ') }}</i>
                        </span>
                    </p>
                </li>
            </ul>
        </div>

        <hr>

        <!-- Only own data -->
        <div class="field">
            <label class="label">
                {{ translations.core.roles.column_only_my_data }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <div class="select">
                    <lesli-select 
                        v-model="storeRole.role.only_my_data"
                        :options="[{
                            label: translations.core.roles.view_text_restrict_data_access,
                            value: true
                        }, {
                            label: translations.core.roles.view_text_allow_to_see_all_the_data,
                            value: false
                        }]">
                    </lesli-select>
                </div>
            </div>
        </div>

        <hr>

        <!-- Enable/disable role -->
        <div class="field">
            <label class="label">
                {{ translations.core.roles.view_text_status }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <div class="select">
                    <lesli-select 
                        v-model="storeRole.role.active"
                        :options="[{
                            label: translations.core.roles.view_text_active,
                            value: true
                        },{
                            label: translations.core.roles.view_text_disabled,
                            value: false
                        }]">
                    </lesli-select>
                </div>
            </div>
        </div>

        <hr>

        <div class="field is-grouped">
            <div class="control">
                <lesli-button icon="save">
                    {{ translations.core.shared.view_btn_save }}
                </lesli-button>      
            </div>
        </div>
    </form>
</template>
