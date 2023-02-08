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
    // storeActions.getCloudObjectFileOptions()
})


</script>

<template>

    <div class="has-text-centered" v-if="storeActions.action_unavailable">
        <span class="material-icons">report_problem</span>
        <br>
        {{translations.actions.view_text_no_templates_available}}
    </div>
    
    <div v-else>
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
