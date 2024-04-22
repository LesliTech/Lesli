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
import { ref, computed } from "vue"

// · import store
import { useCloudObjectDiscussionStore } from "../stores/discussion.js"

// · defining props
const props = defineProps({
    isReply: {
        type: Boolean,
        default: false,
    },
    mainDiscussion: {
        type: Object,
        default: null,
    },
});

// · defining emits
const emit = defineEmits(["onAddComment"])

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · implement stores
const discussionStore = useCloudObjectDiscussionStore()

// · comment to add a new discussion
const comment = ref(null)

// · component's title
const title = computed(() => props.isReply ? translations.core.shared.view_text_reply : translations.core.shared.view_text_add_new_comment)

// · button's text
const buttonText = computed(() => props.isReply ? translations.core.shared.view_btn_add_reply : translations.core.shared.view_btn_add_comment)

/**
 * @description function to be called when the user clicks on the 'Add Comment' or 'Add Reply' button
 */
const onAddComment = () => {
    if (!comment.value) return

    // · the discussion model to be used for adding a new discussion
    let discussionModel = `${discussionStore.utils.singularize(discussionStore.cloudObject)}_discussion`

    const payload = {}

    if (props.isReply) {
        // · add the discussion id to the payload when is a reply
        payload[discussionModel] = {
            content: comment.value,
            discussion_parent_id: props.mainDiscussion.id
        }
    } else {
        // · payload for a basic discussion
        payload[discussionModel] = {
            content: comment.value
        }
    }

    // · add a new discussion
    discussionStore.createDiscussion(payload)
    
    // · emit event after adding a new discussion
    emit("onAddComment")

    // · clear the comment
    comment.value = null
}
</script>

<template>
    <div>
        <div class="field">
            <label class="label">{{ title }} Add new comment</label>
            <div class="control">
                <textarea
                    name="comment"
                    rows="2"
                    maxlength="1000"
                    class="textarea has-fixed-size"
                    :placeholder="translations.core.shared.view_placeholder_enter_comment + 'Type your comments :)'"
                    v-model="comment">
                </textarea>
            </div>
        </div>
        <div class="field is-grouped is-grouped-right">
            <div class="control">
                <lesli-button solid icon="save" @click="onAddComment">
                    {{ buttonText }} Add comment
                </lesli-button>
            </div>
        </div>
    </div>
</template>
