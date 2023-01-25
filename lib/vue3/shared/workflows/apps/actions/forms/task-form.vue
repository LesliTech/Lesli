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
import { onMounted, inject } from "vue"

// · import store
import { useActions } from "LesliVue/stores/shared/workflows/actions"

// · implement store
const storeActions = useActions()

// . Defining translations
const translations = {
    core: I18n.t('core.shared'),
    actions: I18n.t('core.workflow/actions'),
    tasks: I18n.t('focus.tasks')
}


</script>

<template>

    <!-- Title -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.column_title }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control is-clearfix">
                <input
                    type="text"
                    autocomplete="on"
                    name="subject"
                    required
                    class="input"
                    v-model="storeActions.action.input_data.title"
                />
            </div>
        </div>
    </div>

    <!-- Description -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.column_description}}
            </label>
            <textarea
                name="body"
                rows="3"
                maxlength="500"
                class="textarea"
                v-model="storeActions.action.input_data.description"
            ></textarea>
        </div>
    </div>


    <div class="columns is-marginless has-border-bottom">
        <!-- Task type -->
        <div class="column">
            <label class="label">
                {{ translations.actions.column_task_type }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <lesli-select
                    required
                    v-model="storeActions.action.input_data.task_type"
                    :options="storeActions.options['task_types']">
                </lesli-select>
            </div>
        </div>

        <!-- Importance -->
        <div class="column">
            <label class="label">
                {{ translations.tasks.column_importance }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <lesli-select
                    required
                    v-model="storeActions.action.input_data.importance"
                    :options="storeActions.options['task_importances']">
                </lesli-select>
            </div>
        </div>

         <!-- Days until deadline -->
        <div class="column">
            <label class="label">
                {{ translations.actions.column_days_until_deadline }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <input type="number" class="input" v-model="storeActions.action.input_data.days_until_deadline">
            </div>
        </div>
    </div>

    <!-- Assign task to -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.column_assign_task_to }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <lesli-select
                    required
                    v-model="storeActions.concerning_users.type"
                    :options="storeActions.options['concerning_user_types']">
                </lesli-select>
            </div>
        </div>
        <!-- Custom users -->
        <div class="column"  v-if="storeActions.concerning_users.type == 'custom' ">
            <label class="label">{{ translations.actions.view_title_employee}}</label>
            <div class="control">
                <lesli-autocomplete
                    :placeholder="translations.core.view_placeholder_select_option"
                    v-model="storeActions.action.concerning_users.list"
                    :options="storeActions.options['users']"
                    :select-by="user => user.name">
                </lesli-autocomplete>
            </div>
        </div>

        <!-- Send notification email -->
        <div class="column">
            <label class="label">
                {{ translations.actions.view_title_send_task_notification_email }}
            </label>

            <label class="checkbox">
                <input type="checkbox" v-model="storeActions.action.configuration.send_email">
                <span v-if="storeActions.action.configuration.send_email"> {{translations.core.view_text_yes}} </span>
                <span v-else> {{translations.core.view_text_no}} </span>
            </label>       
        </div>

        <!-- Log any error that occurs -->
        <div class="column">
            <label class="label">
                {{ translations.actions.view_title_log_task_errors }}
            </label>

            <label class="checkbox">
                <input type="checkbox" v-model="storeActions.action.configuration.log_errors">
                <span v-if="storeActions.action.configuration.log_errors"> {{translations.core.view_text_yes}} </span>
                <span v-else> {{translations.core.view_text_no}} </span>
            </label>       
        </div>
    </div>



</template>
