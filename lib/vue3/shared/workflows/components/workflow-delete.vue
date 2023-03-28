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


// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"


// · implement stores
const storeWorkflow = useWorkflow()


// · 
const translations = {
    workflows: I18n.t("core.workflows")
}

</script>
<template>
    <div class="p-5">
        <h5 class="title is-5">{{ translations.workflows.view_title_delete_workflow }}</h5>
        <p class="mb-5">
            {{ translations.workflows.messages_danger_delete_workflow_description }}
        </p>
        <lesli-button danger icon="delete" @click="storeWorkflow.deleteWorkflow()">Delete</lesli-button>
    </div>
</template>
