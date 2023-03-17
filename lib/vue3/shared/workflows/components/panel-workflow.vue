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
import { useWorkflow } from "LesliVue/stores/shared/workflow"


// · implement store
const storeWorkflow = useWorkflow()


// · defining translations
const translations = {
    core: {
        workflows: I18n.t("core.workflows"),
        shared: I18n.t("core.shared"),
        actions: I18n.t("core.workflow/actions.column_name")
    }
}

</script>
<template>
    <lesli-panel :open="storeWorkflow.panelNew">
        <template #header>
            New workflow
        </template>
        <template #default>
            <form class="p-5" @submit.prevent="storeWorkflow.postWorkflow()">
                <div class="field">
                    <label class="label">Name</label>
                    <div class="control">
                        <input class="input" type="text" v-model="storeWorkflow.workflow.name">
                    </div>
                </div>
                <lesli-button icon="save">
                    save
                </lesli-button>
            </form>
        </template>
    </lesli-panel>
</template>
