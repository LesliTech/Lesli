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
import { onMounted } from "vue"

// · import store
import { useActions } from "Lesli/stores/shared/workflows/actions"

// · implement store
const storeActions = useActions()

// . Defining translations
const translations = {
    core: I18n.t('core.shared'),
    actions: I18n.t('core.workflow/actions')
}

onMounted(() => {
    
})


</script>

<template>

    <div class="has-text-centered" v-if="storeActions.action_unavailable">
        <span class="material-icons">report_problem</span>
        <br>
        {{translations.actions.view_text_no_templates_available}}
    </div>
    
    <div v-else>

        <!-- Subject -->
        <div class="columns is-marginless has-border-bottom">
            <div class="column">
                <label class="label">
                    {{ translations.actions.column_subject }}
                    <sup class="has-text-danger">*</sup>
                </label>
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
                        v-model="storeActions.concerning_users.type"
                        :options="storeActions.options['concerning_user_types']">
                    </lesli-select>
                </div>
            </div>

            <!-- Custom users -->
            <div class="column"  v-if="storeActions.concerning_users.type == 'custom' ">
                <label class="label">{{ translations.actions.view_title_employee}}</label>
                <div class="control">
                    <lesli-input-tag
                        v-model="storeActions.action.concerning_users.list[0]"
                        :options="storeActions.options['users']"
                        :filterFields="['name', 'email']"
                        showField="email"
                    />
                </div>
            </div>
        </div>


         <!-- Templates -->
        <div class="columns is-marginless has-border-bottom">
            <div class="column">
                <label class="label">
                    {{ translations.actions.column_template }}
                    <sup class="has-text-danger">*</sup>
                </label>
                <div class="control">
                    <lesli-select
                        required
                        v-model="storeActions.action.input_data.template_id"
                        :options="storeActions.file_options.templates">
                    </lesli-select>
                </div>
            </div>
        </div>

        <!-- File type -->
        <div class="columns is-marginless has-border-bottom">
            <div class="column">
                <label class="label">
                    {{ translations.actions.column_file_type }}
                    <sup class="has-text-danger">*</sup>
                </label>
                <div class="control">
                    <lesli-select
                        required
                        v-model="storeActions.action.input_data.file_type"
                        :options="storeActions.file_options.file_types">
                    </lesli-select>
                </div>
            </div>
        </div>
    </div>

</template>
