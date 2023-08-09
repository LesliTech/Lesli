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
import { ref, computed, onMounted } from "vue"

// · import stores
import { useChecks } from "Lesli/stores/shared/workflows/checks"
import checksForm from "./form.vue"

// · implement store
const storeChecks = useChecks()

const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "",
    }
})

// · defining translations
const translations = {
    core: {
        workflows: I18n.t("core.workflows"),
        shared: I18n.t("core.shared"),
    }
}

// · columns of the table
const columns = [
    {
        field: "name",
        label: "Name",
    },
    {
        field: "initial_status_name",
        label: "Initial status",
    },
    {
        field: "final_status_name",
        label: "Final status",
    },
    {
        field: "role_name",
        label: "Role",
    },
    {
        field: "user_type",
        label: "Verification type",
    },
    {
        field: "user_name",
        label: "Employee",
    },
]

onMounted(() => {
    // · get workflow status
    storeChecks.fetchChecks()
})

/**
 * @description This function is used to fetch check info
 */
function showCheck(check){
    storeChecks.fetchCheck(check.id).then(()=>{
        storeChecks.showPanel = "true"
    })
    
}

/**
 * @description This function is used to create a new check
 */
 const onCreate = () => {
    storeChecks.reset()
    storeChecks.showPanel = true
}



</script>

<template>
    <lesli-header title="Checks">
        <lesli-button
            outlined
            icon="refresh"
            :loading="storeChecks.loading"
            @click="storeChecks.fetchChecks()"
        >
            {{ translations.core.shared.view_text_btn_reload }}
        </lesli-button>
        
        <lesli-button  icon="add" @click="onCreate">
            add
        </lesli-button>
    </lesli-header>

    <lesli-table 
        :columns="columns" 
        :records="storeChecks.checks"
        @click="showCheck"
    >
        <template #buttons="{ record }">
            <button class="button is-outlined is-danger" @click="storeChecks.deleteCheck(record.id)">
                <span class="material-icons">
                    delete
                </span>
            </button>
        </template>
        
    </lesli-table>


    <lesli-panel v-model:open="storeChecks.showPanel">
        <template #header>
            Check
        </template>
        <template #default>
            <checks-form></checks-form>

        </template>
    </lesli-panel>


</template>
