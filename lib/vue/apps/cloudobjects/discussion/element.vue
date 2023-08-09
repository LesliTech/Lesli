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
import { computed, ref } from "vue"

// · import components
import NewComment from "Lesli/cloudobjects/components/discussion/new.vue" 

// · import store
import { useCloudObjectDiscussionStore } from "Lesli/cloudobjects/stores/discussion"

const props = defineProps({
    // · the discussion or activity log that will be displayed.
    discussion: {
        type: Object,
        required: true,
    },
    isReply: {
        type: Boolean,
        default: false,
    },
});

const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · this variable is used to show the reply form.
const isReplyActive = ref(false)

// · implement store
const discussionStore = useCloudObjectDiscussionStore() 

// · computed property that returns the discussion or activity log content that will be displayed in the component's element. 
const getDiscussionContent = computed(() => {

    if (props.discussion.type === 'activityLog' && props.discussion?.category == 'action_create_notification') return `${props.discussion.description}`
    
    if (props.discussion.type === 'activityLog') return `${props.discussion.field_name}: (${props.discussion.value_from}) - (${props.discussion.value_to})`

    if (props.discussion.type === 'discussion' || props.isReply) return props.discussion.content
})

/**
 * @description This function is called when user clicks on discussion's delete button.
 */
const onDeleteDiscussion = () => {
    discussionStore.deleteDiscussion(props.discussion.id)
}

/**
 * @description This function shows and hides the reply form.
 */
const showReply = () => {
    isReplyActive.value = !isReplyActive.value
}
</script>

<template>
    <div class="discussion-content">
        <div class="discussion-content-item pt-4 px-4">
            <div class="avatar mr-4">
                <lesli-avatar :name="props.discussion.user_name"/>
            </div>
            <div class="info mt-2">
                <!-- Discussion's header -->
                <p>
                    <span class="has-text-weight-bold">{{ props.discussion.user_name }}</span>
                    <span v-if="props.discussion.type !== 'discussion'" class="ml-4">{{ props.discussion.category }}</span>
                </p>
                

                <!-- Discussion's content -->
                <p class="mt-2 has-text-weight-bold">{{ getDiscussionContent }}</p>

                <!-- Discussion's footer -->
                <div class="mt-4 pb-2 is-flex is-align-items-center">
                    <span class="mr-6">{{ props.discussion.created_at }}</span>
                    <template v-if="props.discussion.type === 'discussion' || props.isReply">
                        <button @click="onDeleteDiscussion" v-if="discussionStore.currentUserId === discussion.users_id" class="is-transparent button mr-4 has-text-weight-bold has-text-danger">
                            {{ translations.core.shared.view_btn_delete }}
                        </button>
                        <button @click="showReply" v-if="!props.isReply" class="is-transparent button has-text-weight-bold has-text-primary">
                            {{ translations.core.shared.view_btn_reply }}
                        </button>
                    </template>
                </div>

                <!-- Reply component to answer a discussion -->
                <new-comment is-reply v-if="isReplyActive" :main-discussion="props.discussion" @on-add-comment="showReply"></new-comment>

                <!-- Replies are defined in the content component -->
                <slot name="replies"></slot>
            </div>
        </div>
    </div>
</template>
