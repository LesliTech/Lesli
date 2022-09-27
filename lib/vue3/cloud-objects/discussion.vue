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
import { onMounted } from "vue"

// · import store
import { useCloudObjectDiscussionStore } from "LesliVue/stores/cloud-objects/discussion"

// · import components
import DiscussionNew from "LesliVue/cloud-objects/discussion/new.vue"
import DiscussionContent from "LesliVue/cloud-objects/discussion/content.vue"
import DiscussionFilters from "LesliVue/cloud-objects/discussion/filters.vue"

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · implement store
const discussionStore = useCloudObjectDiscussionStore()

// · defining props
const props = defineProps({
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the resource that you need to interact with.
    cloudObject: {
        type: Object,
        required: true,
    },
    // · prop that indicates the object id of the resource that you need to interact with.
    cloudObjectId: {
        type: String,
        required: true,
    },
    onlyDiscussions: {
        type: Boolean,
        required: false,
        default: false
    }
});

discussionStore.cloudModule = props.cloudModule
discussionStore.cloudObject = props.cloudObject 
discussionStore.cloudObjectId = props.cloudObjectId

onMounted(() => {
    if (discussionStore.filters.showActivityLog && !props.onlyDiscussions) discussionStore.fetchActivityLogs()
    if (discussionStore.filters.showDiscussion) discussionStore.fetchDiscussions()
})
</script>

<template>
    <div class="p-2 discussion">
        <discussion-new></discussion-new>
        <lesli-toolbar @search="discussionStore.search" :search-placeholder="translations.core.shared.view_placeholder_discussion_search" class="mt-4"></lesli-toolbar>
        <discussion-filters v-if="!props.onlyDiscussions"></discussion-filters>
        <discussion-content></discussion-content>
    </div>
</template>
