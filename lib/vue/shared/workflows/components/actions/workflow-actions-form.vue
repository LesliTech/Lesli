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
import { inject, watch, onMounted, ref } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import action components
import workflowActionsFormNotification from "./workflow-actions-form-notification.vue"
import workflowActionsFormEmail from "./workflow-actions-form-email.vue"
import workflowActionsFormTask from "./workflow-actions-form-task.vue"
import workflowActionsFormChatroom from "./workflow-actions-form-chatroom.vue"

/*
import chatroomForm from "./forms/chatroom-form.vue"
import cloudObjectFileForm from "./forms/cloud-object-file-form.vue"
import cloudObjectCloneForm from "./forms/cloud-object-clone-form.vue"
import sendCloudObjectFileForm from "./forms/send-cloud-object-file.vue"
*/


// · import store
import { useActions } from "Lesli/stores/shared/workflows/actions"


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false
    }
})


// · implement stores
const storeActions = useActions()


// · defining translations
const translations = {
    core: I18n.t('core.shared'),
    actions: I18n.t('core.workflow/actions')
}


onMounted(() => {
    // · get workflow actions options
    storeActions.getOptions()
    storeActions.getUsers()
    storeActions.getCloudObjectFileOptions()
    storeActions.getTasksOptions()

    if(!props.isEditable){
        storeActions.reset()
    }

})


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


// This function is used to update the action information
const onUpdate = () => {
    storeActions.updateAction()
}


// This function is used to create a new action
const onCreate = () => {
    storeActions.postAction()
}

</script>
<template>
    <form 
        class="mb-4"
        v-if="!storeActions.loading"
        @submit.prevent="isEditable? onUpdate() : onCreate()">

        <div class="columns is-marginless has-border-bottom">

            <!-- Action name -->
            <div class="column">
                <label class="label">
                    {{translations.actions.column_name}}
                    <sup class="has-text-danger">*</sup>
                </label>
                
                <div class="control">
                    <input type="text" name="name" required class="input" v-model="storeActions.action.name" />
                </div>
            </div>

            <!-- Active -->
            <div class="column">
                <label class="label">{{translations.actions.column_active}}</label>
                <div class="control">
                    <label :for="option.label" class="radio" v-for="option in activeOptions" :key="option">
                        <input name="active" type="radio" :id="option.label" :value="option.value" v-model="storeActions.action.active"/>
                        {{option.label}}
                    </label>  
                </div>
            </div>

            <!-- Execute inmediately -->
            <div class="column">
                <label class="label">
                    {{ translations.actions.column_execute_immediately }}
                </label>

                <label class="checkbox">
                    <input type="checkbox" v-model="storeActions.action.execute_immediately">
                    <span v-if="storeActions.action.execute_immediately"> {{translations.core.view_text_yes}} </span>
                    <span v-else> {{translations.core.view_text_no}} </span>
                </label>                
            </div>

        </div>


        <div class="columns is-marginless has-border-bottom">
             <!-- Initial status -->
            <div class="column">
                <label class="label">{{ translations.actions.column_initial_status_id }}</label>
                <div class="control">
                    <lesli-select
                        v-model="storeActions.action.initial_status_id"
                        :options="storeActions.options['statuses']">
                    </lesli-select>
                </div>
            </div>

            <!-- Final status -->
            <div class="column">
                <label class="label">
                    {{ translations.actions.column_final_status_id }}
                    <sup class="has-text-danger">*</sup>
                </label>

                <div class="control">
                    <lesli-select
                        required
                        v-model="storeActions.action.final_status_id"
                        :options="storeActions.options['statuses']">
                    </lesli-select>
                </div>
            </div>

            <!-- Action type -->
            <div class="column">
                <label class="label">
                    {{ translations.actions.column_action_type }}
                    <sup class="has-text-danger">*</sup>
                </label>
                <div class="control">
                    <lesli-select
                        required
                        v-model="storeActions.action.action_type"
                        :options="storeActions.options['action_types']"
                        :disabled="props.isEditable">
                    </lesli-select>
                    <span>{{ translations.actions.view_text_column_action_type_description }}</span>
                </div>
            </div>
        </div>

        <hr>

        <workflow-actions-form-task v-if="storeActions.action.action_type == 'create_focus_task'"></workflow-actions-form-task>
        <workflow-actions-form-email v-if="storeActions.action.action_type == 'send_core_email'"></workflow-actions-form-email>
        <workflow-actions-form-chatroom v-if="storeActions.action.action_type == 'send_talk_chatroom_message'"></workflow-actions-form-chatroom>
        <workflow-actions-form-notification v-if="storeActions.action.action_type == 'create_bell_notification'"></workflow-actions-form-notification>

        <!--
        < cloud-object-file-form v-if="storeActions.action.action_type == 'create_cloud_object_file'" >< /cloud-object-file-form >
        < cloud-object-clone-form v-if="storeActions.action.action_type == 'cloud_object_clone'" >< /cloud-object-clone-form >
        < send-cloud-object-file-form v-if="storeActions.action.action_type =='create_and_send_cloud_object_file'" >< /send-cloud-object-file-form >
        -->

        <!-- Submit form button -->
        <div class="columns is-marginless has-border-bottom">
            <div class="column">
                <lesli-button icon="save">
                    save
                </lesli-button>  
            </div>
        </div>
    </form>

</template>
