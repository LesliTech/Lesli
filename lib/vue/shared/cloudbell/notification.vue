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
import { useNotification } from "Lesli/stores/shared/cloud_bell/notification"

// · import components
import editorRichText from "Leslicomponents/editors/richtext.vue"

// · implement store
const storeNotification = useNotification()

// . Defining translations
const translations = {
    core: I18n.t('core.shared'),
    bell: I18n.t('bell.notifications')
}

// · defining props
const props = defineProps({
    // · prop that indicates the id of the user to send the notification
    userReceiverId: {
        type: String,
        required: true,
    },
})

// · Set user receiver id for notification from props
storeNotification.notification.user_receiver_id = props.userReceiverId

onMounted(() => {
    storeNotification.getOptions()
})

</script>

<template>

    <form @submit.prevent="storeNotification.sendNotification()">
        <fieldset>
            <!-- Notification type -->
            <div class="field">
                <label class="label">
                    {{ translations.core.view_text_notification_type }}
                    <sup class="has-text-danger">*</sup>
                </label>
                <div class="control">
                    <lesli-select
                        required
                        :options="storeNotification.options['channels']"
                        v-model="storeNotification.notification.channel"
                    >
                    </lesli-select>
                </div>
            </div>

            <!-- Subject -->
            <div class="field">
                <label class="label">
                    {{ translations.core.view_text_subject}}
                    <sup class="has-text-danger">*</sup>
                </label>

                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="subject"
                        required
                        class="input"
                        v-model="storeNotification.notification.subject"
                    />
                </div>
            </div>

            <!-- Body -->
            <div class="field">
                <label class="label">
                    {{ translations.core.view_text_body}}
                </label>
                <editor-rich-text v-if="storeNotification.notification.channel == 'email'"
                    v-model="storeNotification.notification.body"
                ></editor-rich-text>
                <textarea
                    v-else
                    name="body"
                    rows="3"
                    maxlength="500"
                    class="textarea"
                    v-model="storeNotification.notification.body"
                ></textarea>
            </div>

            <!-- Send button -->
            <div class="field">
                <p class="control">
                    <lesli-button icon="send">
                        {{ translations.core.view_btn_send }}
                    </lesli-button>  
                </p>
            </div>

        </fieldset>

    </form>


</template>
