<script setup>
/*
Copyright (c) 2023, all rights reserved.

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
