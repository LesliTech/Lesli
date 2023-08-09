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
import { inject, watch, onMounted, ref } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import store
import { useChecks } from "Lesli/stores/shared/workflows/checks"


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// · implement stores
const storeChecks = useChecks()

// · defining translations
const translations = {
    core: I18n.t('core.shared'),
    checks: I18n.t('core.workflow/checks'),
    roles: I18n.t('core.roles')
}

const activeOptions = {
    yes: { 
        label: translations.core.view_text_yes, 
        value: true
    },
    no: {
        label: translations.core.view_text_no,
        value: false
    }
}

// · the user selected for checks
const employee = ref(storeChecks.check?.user_name)

const selectUser = () => {
    const user = employee.value

    if(user){
        storeChecks.check.users_id = user.id
    }else{
        storeChecks.check.users_id = null
    }
}


onMounted(() => {
    // · get workflow check options
    storeChecks.getCheckOptions()
})


</script>

<template>
    <form @submit.prevent="storeChecks.formSubmit()" v-if="!storeChecks.loading">
        <div class="card-content">
            <div class="field">
                <label class="label">
                    {{translations.checks.column_name}}
                    <sup class="has-text-danger">*</sup>
                </label>
                <div class="control">
                    <input
                            type="text"
                            autocomplete="on"
                            name="subject"
                            required
                            class="input"
                            v-model="storeChecks.check.name"
                        />
                </div>
            </div>
            <div class="field">
                <label class="label">{{translations.checks.column_active}}</label>
                <div class="control">
                    <label :for="option.label" class="radio" v-for="option in activeOptions" :key="option">
                        <input 
                            name="active" 
                            type="radio" 
                            :id="option.label" 
                            :value="option.value" 
                            v-model="storeChecks.check.active"
                        />
                        {{option.label}}
                    </label>  
                </div>
            </div>
            <div class="field">
                <label class="label">
                    {{ translations.checks.column_initial_status_id }}
                    <sup class="has-text-danger">*</sup>
                </label>
                <sup class="has-text-danger">*</sup>
                <div class="control">
                    <lesli-select
                        required
                        v-model="storeChecks.check.initial_status_id"
                        :options="storeChecks.options['statuses']">
                    </lesli-select>
                </div>
            </div>
            <div class="field">
                <label class="label">{{ translations.checks.column_final_status_id }}</label>
                <div class="control">
                    <lesli-select
                        v-model="storeChecks.check.final_status_id"
                        :options="storeChecks.options['statuses']">
                    </lesli-select>
                </div>
            </div>
            <div class="field" v-if="storeChecks.check.user_type == 'any' || storeChecks.check.user_type == null">
                <label class="label">
                    {{ translations.checks.column_roles_id }}
                    <sup v-if="storeChecks.check.user_type == 'any' || storeChecks.check.user_type == null" class="has-text-danger">*</sup>
                </label>
                <div class="control">
                    <lesli-select
                        :required="storeChecks.check.user_type == 'any' || storeChecks.check.user_type == null"
                        v-model="storeChecks.check.roles_id"
                        :options="storeChecks.options['roles']">
                    </lesli-select>
                </div>
            </div>
            <div class="field">
                <label class="label">
                    {{ translations.checks.column_user_type }}
                    <sup v-if="storeChecks.check.roles_id == null" class="has-text-danger">*</sup>
                </label>
                <div class="control">
                    <lesli-select
                        :required="storeChecks.check.roles_id == null"
                        v-model="storeChecks.check.user_type"
                        :options="storeChecks.options['user_types']">
                    </lesli-select>
                </div>
            </div>

            <div class="field" v-if="storeChecks.check.user_type == 'custom' ">
                <label class="label">{{ translations.checks.column_users_id }}</label>
                <div class="control">
                    <lesli-autocomplete
                        :placeholder="translations.core.view_placeholder_select_option"
                        v-model="employee"
                        @select="selectUser"
                        :options="storeChecks.options['users']"
                        :select-by="user => user.name">
                    </lesli-autocomplete>
                </div>
            </div>


            <div class="control">
                <lesli-button icon="save">
                    save
                </lesli-button>  
            </div>
        </div>
    </form>

</template>
