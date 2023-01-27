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
import { onMounted } from "vue"

// · import store
import { useActions } from "LesliVue/stores/shared/workflows/actions"

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
