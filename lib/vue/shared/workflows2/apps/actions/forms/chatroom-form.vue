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

    <!-- Sender user -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.view_text_sender_user }}
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

    <!-- Message content -->
    <div class="columns is-marginless has-border-bottom">
        <div class="column">
            <label class="label">
                {{ translations.actions.view_text_message_content }}
            </label>
            <textarea
                name="body"
                rows="3"
                maxlength="500"
                class="textarea"
                v-model="storeActions.action.input_data.message_text"
            ></textarea>
        </div>
    </div>


</template>
