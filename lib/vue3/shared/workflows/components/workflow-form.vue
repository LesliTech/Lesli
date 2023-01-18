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
import { inject, onMounted } from "vue"

// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"

// · import vue router composable
import { useRouter, useRoute } from "vue-router"

// · implement stores
const storeWorkflow = useWorkflow()

// · initialize/inject plugins
const router = useRouter()
const url = inject("url")
const route = useRoute()

// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
    appMountPath: {
        type: String,
        required: false,
        default: "",
    }
})


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}

const columns = [
{
    field: "xpath",
    label: ""
}]


/**
 * @description This function is used to update the workflow information
 */
const onUpdate = () => {
    storeWorkflow.updateWorkflow()
}

/**
 * @description This function is used to create a new workflow
 */
const onCreate = () => {
    storeWorkflow.postWorkflow()
    router.push(url.root(props.appMountPath).s)
}


onMounted(() => {
    if (!props.isEditable){
        storeWorkflow.workflow = {}
    } else {
        storeWorkflow.fetchWorkflow(route.params?.id)
    }
})

</script>
<template>
    <div class="block">
        <!-- Workflow form -->
        <form v-if="!storeWorkflow.loading" class="information" @submit.prevent="
                isEditable
                    ? onUpdate()
                    : onCreate()
        ">

            <!-- Name -->
            <div class="columns is-marginless has-border-bottom">
                <div class="column">
                    <label class="label">
                        Workflow Name
                    </label>
                    <input name="name" v-model="storeWorkflow.workflow.name" type="text" class="input"> 
                </div>
            </div>

        </form>
    </div>
    
    <div class="block">
        <!-- Status workflows form -->
        <form @submit.prevent="">

            <!-- Workflow status name -->
            <div class="columns is-marginless has-border-bottom">
                <div class="column">
                    <label class="label">
                        Add new status to the workflow
                    </label>
                </div>
                <div class="column is-10">
                    <input class="input" type="text">
                </div>
                <div class="column">
                    <lesli-button icon="add">
                        Add
                    </lesli-button>  
                </div>
            </div>


            <div class="columns is-marginless has-border-bottom">
                <div class="column">
                    <lesli-button icon="save">
                        save
                    </lesli-button>  
                </div>
            </div>

        </form>

    </div>

    

</template>
