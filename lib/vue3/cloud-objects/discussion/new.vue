<script setup>
/*
Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~
// ·
*/

// · import vue tools
import { ref, computed } from "vue"

// · import store
import { useCloudObjectDiscussionStore } from "LesliVue/stores/cloud-objects/discussion"

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
 * 
 * @param {string} word to be singularized
 * @description singularizes a word that ends with 's'
 * @returns {string} singularized word
 */
const singularize = (word) => {
    if (word.endsWith("s")) {
        return word.slice(0, -1)
    }
    return word
}

/**
 * @description function to be called when the user clicks on the 'Add Comment' or 'Add Reply' button
 */
const onAddComment = () => {
    if (!comment.value) return

    // · the discussion model to be used for adding a new discussion
    const discussionModel = `${singularize(discussionStore.cloudObject.split('/').pop())}_discussion`
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
    <div class="discussion-comment mb-2 mt-2">
        <div class="discussion-comment-input">
            <p class="is-size-5 mb-4">{{ title }}</p>
            <textarea
                name="comment"
                rows="2"
                maxlength="1000"
                class="textarea"
                :placeholder="translations.core.shared.view_placeholder_enter_comment"
                v-model="comment"
            />
        </div>
        <div class="is-flex is-justify-content-flex-end pb-2">
            <button @click="onAddComment" class="discussion-comment-button mt-4 button is-primary has-text-weight-bold">
                {{ buttonText }}
            </button>
        </div>
    </div>
</template>
