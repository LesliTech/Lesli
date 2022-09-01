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
    storeRole.fetchRole(route.params.id)
    storeRole.getOptions()
})


// · 
function updateRole() {
    storeRole.putRole()
}


// · 
function isObjectLevelPermissionSelected(olp) {
    return storeRole.role.object_level_permission == olp
}

</script>
<template>
    <section class="application-component">
        <lesli-header :title="'Edit: ' + storeRole.role.name + ' role '">
            <lesli-button icon="preview" :to="url.admin('roles/:id', storeRole.role.id)">
                Show role
            </lesli-button>
        </lesli-header>

        <form @submit.prevent="updateRole">

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

            <hr>

            <!-- Object level permission -->
            <div class="field">
                <label class="label">
                    {{ translations.core.roles.view_text_hierarchical_level }}
                    <sup class="has-text-danger">*</sup>
                </label>
                <ul class="hierarchical_level_selector">
                    <li :class="['hover', 'p-1', { 'has-background-info has-text-light' : isObjectLevelPermissionSelected(olp) }]"
                        v-for="(roles, olp, index) in storeRole.options.object_level_permissions" :key="index"
                        v-on:click="storeRole.role.object_level_permission = olp">
                        <p class="icon-text">
                            <span class="icon">
                                <span class="material-icons">
                                    {{ isObjectLevelPermissionSelected(olp) ? 'check_box' : 'check_box_outline_blank' }}
                                </span>
                                <i :class="['fas', isObjectLevelPermissionSelected(olp) ? 'fa-check' : 'fa-chevron-right']"></i>
                            </span>
                            <span>
                                {{ `${translations.core.roles.view_text_level || 'Level' } ${ index + 1 }` }}
                                <i v-if="roles.length">- {{ roles.map(role => role.name).join(', ') }}</i>
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
                    <input type="submit" class="button is-link" :value="translations.core.shared.view_btn_save" />
                </div>
                <div class="control">
                    <button class="button is-link is-light">Cancel</button>
                </div>
            </div>

        </form>
    </section>
</template>
