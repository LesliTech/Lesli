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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { onMounted, watch } from "vue"


// · import components
import DiscussionNew from "./discussion/new.vue"
import DiscussionContent from "./discussion/content.vue"
import DiscussionFilters from "./discussion/filters.vue"


// · import store
import { useCloudObjectDiscussionStore } from "./stores/discussion.js"


// · implement store
const discussionStore = useCloudObjectDiscussionStore()


// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}


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
        type: [String, Number],
        required: true,
    },
    onlyDiscussions: {
        type: Boolean,
        required: false,
        default: false
    }
});


onMounted(() => {
    discussionStore.cloudModule = props.cloudModule
    discussionStore.cloudObject = props.cloudObject 
    discussionStore.cloudObjectId = props.cloudObjectId
    discussionStore.fetchDiscussions()
})
</script>
<template>
    <div class="lesli-cloud-object-discussion m-auto py-6">
        <discussion-new></discussion-new>
        <!-- lesli-toolbar @search="discussionStore.search" :search-placeholder="translations.core.shared.view_placeholder_discussion_search" class="mt-4"></lesli-toolbar -->
        <!-- discussion-filters v-if="!props.onlyDiscussions"></discussion-filters -->
        <discussion-content></discussion-content>
    </div>
</template>
