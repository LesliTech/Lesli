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
import { useNotification } from "LesliVue/stores/shared/notification"

// · import components
import editorRichText from "LesliVue/components/editors/richtext.vue"

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
            <field>
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
            </field>

            <!-- Subject -->
            <field>
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
            </field>

            <!-- Body -->
            <field>
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
            </field>

            <!-- Send button -->
            <field>
                <lesli-button icon="send">
                    {{ translations.core.view_btn_send }}
                </lesli-button>  
            </field>

        </fieldset>

    </form>


</template>
