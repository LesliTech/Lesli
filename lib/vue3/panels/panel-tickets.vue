<script setup>
/*
Copyright (c) 2022, all rights reserved.

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
import { ref, inject, watch } from "vue"

// · import store
import { useCloudObjectFileStore } from "LesliVue/stores/cloud-objects/file"
import { useLayout } from "LesliVue/stores/layout"

// · implement stores
const storeFiles = useCloudObjectFileStore()
const storeLayout = useLayout()

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}


</script>

<template>
    <lesli-panel v-model:open="storeLayout.showTickets">
        <template #header>
            <h2>test</h2>
        </template>
        <template #default>

            <form @submit.prevent="postTicket">
                    <!-- <b-field>
                        <template v-slot:label>
                            {{translations.main.column_subject}} <sup class="has-text-danger">*</sup>
                        </template>
                        <b-input type="text" required v-model="ticket.subject">
                        </b-input>
                    </b-field> -->
                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">
                                {{translations.main.column_subject}} <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column is-8">
                            <input type="text" class="input" required>
                        </div>
                    </div>




                    <b-field>
                        <template v-slot:label>
                            {{translations.main.column_cloud_help_catalog_ticket_types_id}}<sup class="has-text-danger">*</sup>
                        </template>
                        <b-select
                            :placeholder="translations.core.view_placeholder_select_option"
                            expanded
                            required
                            v-model="ticket.cloud_help_catalog_ticket_types_id"
                        >
                            <option
                                v-for="type in options.types"
                                :key="type.id"
                                :value="type.id"
                            >
                                {{type.name}}
                            </option>
                        </b-select>
                    </b-field>
                    <b-field :label="translations.main.column_cloud_help_catalog_ticket_workspaces_id">
                        <b-select
                            :placeholder="translations.core.view_placeholder_select_option"
                            expanded
                            v-model="ticket.cloud_help_catalog_ticket_workspaces_id"
                        >
                            <option
                                v-for="workspace in options.workspaces"
                                :key="workspace.id"
                                :value="workspace.id"
                            >
                                {{workspace.name}}
                            </option>
                        </b-select>
                    </b-field>
                    <div class="field text-editor-container">
                        <label class="label">{{translations.main.column_description}}</label>
                        <div class="control">
                            <component-rich-text-editor v-model="ticket.description" mode="simple">
                            </component-rich-text-editor>
                        </div>
                    </div>
                    <div class="field">
                        <b-button class="submit-button" type="is-primary" native-type="submit" expanded :disabled="submitting">
                            <span v-if="submitting">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small">
                                </b-icon>
                                <span>{{translations.core.view_btn_saving}}</span>
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small">
                                </b-icon>
                                <span>{{translations.core.view_btn_save}}</span>
                            </span>
                        </b-button>
                    </div>
        
            </form>

        </template>

    </lesli-panel>
</template>
