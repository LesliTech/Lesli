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
import { useActions } from "Lesli/stores/shared/workflows/actions"


import actionForm from "./form.vue"


// · implement store
const storeActions = useActions()

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
        field: "action_type",
        label: "Action type",
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
        field: "active",
        label: "",
    },
]

const tab = ref(0)

/**
 * @description This function is used to show an action info
 */
function showAction(action){
    tab.value = 1
    storeActions.fetchAction(action.id)
}

onMounted(() => {
    // · get workflow status
    storeActions.fetchActions()
})

</script>

<template>
    <lesli-tabs v-model="tab">
        <lesli-tab-item title="List" paddingless>
            <lesli-header title="Actions">
                <lesli-button
                    outlined
                    icon="refresh"
                    :loading="storeActions.loading"
                    @click="storeActions.fetchActions()"
                >
                    {{ translations.core.shared.view_text_btn_reload }}
                </lesli-button>
            </lesli-header>

            <lesli-table 
                :columns="columns" 
                :records="storeActions.actions"
                @click="showAction"
            >
                <template #active="{ value }">
                    <span class="tag is-success" v-if="value">
                        {{ translations.core.shared.view_text_active }}
                    </span>
                    <span class="tag is-warning" v-if="!value">
                        {{ translations.core.shared.view_text_inactive }}
                    </span>
                </template>
            </lesli-table>
        </lesli-tab-item>

        <lesli-tab-item title="New">
            <actionForm></actionForm>
        </lesli-tab-item>
        
        <lesli-tab-item title="Edit action" :disabled="!storeActions.action.id">
            <actionForm is-editable></actionForm>
        </lesli-tab-item>

    </lesli-tabs>

</template>
