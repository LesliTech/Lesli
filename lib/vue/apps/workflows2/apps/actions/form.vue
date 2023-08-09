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
import { useActions } from "Lesli/stores/shared/workflows/actions"
import notificationForm from "./forms/notification-form.vue"
import emailForm from "./forms/email-form.vue"
import taskForm from "./forms/task-form.vue"
import chatroomForm from "./forms/chatroom-form.vue"
import cloudObjectFileForm from "./forms/cloud-object-file-form.vue"
import cloudObjectCloneForm from "./forms/cloud-object-clone-form.vue"
import sendCloudObjectFileForm from "./forms/send-cloud-object-file.vue"



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

/**
 * @description This function is used to update the action information
 */
 const onUpdate = () => {
    storeActions.updateAction()
}

/**
 * @description This function is used to create a new action
 */
const onCreate = () => {
    storeActions.postAction()
}


</script>

<template>
    <form 
        @submit.prevent="isEditable? onUpdate() : onCreate()"
        v-if="!storeActions.loading">

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

        <notification-form v-if="storeActions.action.action_type == 'create_bell_notification'"></notification-form>
        <email-form v-if="storeActions.action.action_type == 'send_core_email'"></email-form>
        <task-form v-if="storeActions.action.action_type == 'create_focus_task'"></task-form>
        <chatroom-form v-if="storeActions.action.action_type == 'send_talk_chatroom_message'"></chatroom-form>
        <cloud-object-file-form v-if="storeActions.action.action_type == 'create_cloud_object_file'"></cloud-object-file-form>
        <cloud-object-clone-form v-if="storeActions.action.action_type == 'cloud_object_clone'"></cloud-object-clone-form>
        <send-cloud-object-file-form v-if="storeActions.action.action_type =='create_and_send_cloud_object_file'"></send-cloud-object-file-form>


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
