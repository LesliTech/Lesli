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
import { watch } from "vue"

// · import store
import { useCloudObjectDiscussionStore } from "LesliVue/stores/cloud-objects/discussion"

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · implement store
const discussionStore = useCloudObjectDiscussionStore()

watch(discussionStore.filters, (filters) => {

    // · if the toolbar text is not empty, and the filters changed then search
    if (discussionStore.stringToFind) {
        discussionStore.search(discussionStore.stringToFind)
    } else {
        // · if the toolbar text is empty, fetch with the new filters
        if (filters.showDiscussion) discussionStore.fetchDiscussions()
        if (filters.showActivityLog) discussionStore.fetchActivityLogs()
    }

    // · if showDiscussion filter is false, then clear the discussions
    if (!filters.showDiscussion) discussionStore.discussions = []

    // · if showActivityLog filter is false, then clear the activity logs
    if (!filters.showActivityLog) discussionStore.activityLogs = []
})
</script>

<template>
    <div class="discussion-filters mt-2">
        
        <!-- Discussion filter -->
        <div class="discussion-filters-item">
            <p class="mb-2">{{ translations.core.shared.view_text_discussions }}</p>
            <lesli-toggle v-model="discussionStore.filters.showDiscussion"/>
        </div>

        <!-- Activity logs filter -->
        <div class="discussion-filters-item">
            <p class="mb-2">{{ translations.core.shared.view_text_activity_logs }}</p>
            <lesli-toggle v-model="discussionStore.filters.showActivityLog"/>
        </div>
    </div>
</template>
