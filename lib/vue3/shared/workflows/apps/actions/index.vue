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
import { useChecks } from "LesliVue/stores/shared/workflows/checks"

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

</script>

<template>
    <lesli-header title="Actions">
        <lesli-button
            outlined
            icon="refresh"
            :loading="storeChecks.loading"
            @click="storeChecks.fetchChecks()"
        >
            {{ translations.core.shared.view_text_btn_reload }}
        </lesli-button>
        
        <lesli-button  icon="add" :to="url.root(props.appMountPath + '/new')">
            add
        </lesli-button>
    </lesli-header>

    <lesli-table 
        :columns="columns" 
        :records="storeChecks.checks"
    >
    </lesli-table>

</template>
