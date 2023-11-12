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
import { useCloudObjectDiscussionStore } from "Lesli/cloudobjects/stores/discussion"

// · import components
import DiscussionNew from "Lesli/cloudobjects/components/discussion/new.vue"
import DiscussionContent from "Lesli/cloudobjects/components/discussion/content.vue"
import DiscussionFilters from "Lesli/cloudobjects/components/discussion/filters.vue"

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
        type: String,
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
