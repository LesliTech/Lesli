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
import { onMounted, inject } from "vue"

// · import store
import { useActions } from "Lesli/stores/shared/workflows/actions"

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
            <div class="field has-addons">
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('global_identifier', 'title')" :title="translations.actions.messages_info_tooltip_add_resource_identifier_reference">
                        <span class="material-icons">format_list_numbered</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('status', 'title')" :title="translations.actions.messages_info_tooltip_add_status_reference">
                        <span class="material-icons">info</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('current_user', 'title')" :title="translations.actions.messages_info_tooltip_add_current_user_reference">
                        <span class="material-icons">person</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_creator', 'title')" :title="translations.actions.messages_info_tooltip_add_user_creator_reference">
                        <span class="material-icons">person_add</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_reviewer', 'title')" :title="translations.actions.messages_info_tooltip_add_user_reviewer_reference">
                        <span class="material-icons">person_search</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_branch_office', 'title')" :title="translations.actions.messages_info_tooltip_add_user_branch_office_reference">
                        <span class="material-icons">person_pin_circle</span>
                    </button>
                </p>
            </div>
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
            <div class="field has-addons">
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('global_identifier', 'description')" :title="translations.actions.messages_info_tooltip_add_resource_identifier_reference">
                        <span class="material-icons">format_list_numbered</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('status', 'description')" :title="translations.actions.messages_info_tooltip_add_status_reference">
                        <span class="material-icons">info</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('current_user', 'description')" :title="translations.actions.messages_info_tooltip_add_current_user_reference">
                        <span class="material-icons">person</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_creator', 'description')" :title="translations.actions.messages_info_tooltip_add_user_creator_reference">
                        <span class="material-icons">person_add</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_reviewer', 'description')" :title="translations.actions.messages_info_tooltip_add_user_reviewer_reference">
                        <span class="material-icons">person_search</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_branch_office', 'description')" :title="translations.actions.messages_info_tooltip_add_user_branch_office_reference">
                        <span class="material-icons">person_pin_circle</span>
                    </button>
                </p>
            </div>
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
