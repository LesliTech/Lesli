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
