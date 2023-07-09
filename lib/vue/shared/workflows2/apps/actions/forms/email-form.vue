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
    bell: I18n.t('bell.notifications')
}

</script>

<template>

    <!-- Subject -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.column_subject }}
                <sup class="has-text-danger">*</sup>
            </label>

            <div class="field has-addons">
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('global_identifier', 'subject')" :title="translations.actions.messages_info_tooltip_add_resource_identifier_reference">
                        <span class="material-icons">format_list_numbered</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('status', 'subject')" :title="translations.actions.messages_info_tooltip_add_status_reference">
                        <span class="material-icons">info</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('current_user', 'subject')" :title="translations.actions.messages_info_tooltip_add_current_user_reference">
                        <span class="material-icons">person</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_creator', 'subject')" :title="translations.actions.messages_info_tooltip_add_user_creator_reference">
                        <span class="material-icons">person_add</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_reviewer', 'subject')" :title="translations.actions.messages_info_tooltip_add_user_reviewer_reference">
                        <span class="material-icons">person_search</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_branch_office', 'subject')" :title="translations.actions.messages_info_tooltip_add_user_branch_office_reference">
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
                    v-model="storeActions.action.input_data.subject"
                />
            </div>
        </div>
    </div>

    <!-- Body -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.column_body }}
            </label>
            <div class="field has-addons">
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('global_identifier', 'body')" :title="translations.actions.messages_info_tooltip_add_resource_identifier_reference">
                        <span class="material-icons">format_list_numbered</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('status', 'body')" :title="translations.actions.messages_info_tooltip_add_status_reference">
                        <span class="material-icons">info</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('current_user', 'body')" :title="translations.actions.messages_info_tooltip_add_current_user_reference">
                        <span class="material-icons">person</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_creator', 'body')" :title="translations.actions.messages_info_tooltip_add_user_creator_reference">
                        <span class="material-icons">person_add</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_reviewer', 'body')" :title="translations.actions.messages_info_tooltip_add_user_reviewer_reference">
                        <span class="material-icons">person_search</span>
                    </button>
                </p>
                <p class="control">
                    <button class="button is-outlined" @click="storeActions.addReference('user_branch_office', 'body')" :title="translations.actions.messages_info_tooltip_add_user_branch_office_reference">
                        <span class="material-icons">person_pin_circle</span>
                    </button>
                </p>
            </div>
            <textarea
                name="body"
                rows="3"
                maxlength="500"
                class="textarea"
                v-model="storeActions.action.input_data.body"
            ></textarea>
        </div>
    </div>

     <!-- Send email to -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.column_send_email_to }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <lesli-select
                    required
                    v-model="storeActions.action.concerning_users.type"
                    :options="storeActions.options['concerning_user_types']">
                </lesli-select>
            </div>
        </div>

        <!-- Custom users -->
        <div class="column"  v-if="storeActions.action.concerning_users.type == 'custom' ">
            <label class="label">{{ translations.actions.view_title_employee}}</label>
            <div class="control">
                <lesli-input-tag
                    v-model="storeActions.action.concerning_users.list"
                    :options="storeActions.options['users']"
                    :filterFields="['name', 'email']"
                    showField="email"
                />
            </div>
        </div>
    </div>


</template>
