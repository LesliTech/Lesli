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
import { watch } from "vue"

// · import store
import { useCloudObjectDiscussionStore } from "Lesli/cloudobjects/stores/discussion"

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
        
        <div class="discussion-filters-item mt-5">
            <lesli-select
                :options="[
                    {
                        label: '10',
                        value: 10
                    }, {
                        label: '15',
                        value: 15
                    }, {
                        label: '30',
                        value: 30
                    }, {
                        label: '50',
                        value: 50
                    },
                ]"
                v-model="discussionStore.filters.per_page"
                @change="discussionStore.fetchDiscussions()">
            </lesli-select>
        </div>
    </div>
</template>
