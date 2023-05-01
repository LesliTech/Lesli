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
                {{ translations.bell.column_subject }}
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
                {{ translations.bell.column_body }}
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

    <!-- Send notification to -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.column_send_notification_to }}
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
                <lesli-autocomplete
                    :placeholder="translations.core.view_placeholder_select_option"
                    v-model="storeActions.action.concerning_users.list"
                    :options="storeActions.options['users']"
                    :select-by="user => user.name">
                </lesli-autocomplete>

            </div>
        </div>
    </div>


</template>
