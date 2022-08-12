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

// · import store
import { useCloudObjectDiscussionStore } from "LesliVue/stores/cloud-objects/discussion"

import DiscussionElement from "LesliVue/cloud-objects/discussion/element.vue"

const discussionStore = useCloudObjectDiscussionStore()

</script>

<template>
    <div class="discussion-content mt-6">
        <discussion-element v-for="discussion in discussionStore.mergedArray" :key="discussion.id" :discussion="discussion">
            <template v-slot:replies>
                <!-- Discussion responses -->
                <div class="pl-2 pb-4" v-if="discussion.type === 'discussion'">
                    <discussion-element v-for="response in discussion.responses" :key="response.id" :discussion="response" is-reply></discussion-element>
                </div>
            </template>
        </discussion-element>
    </div>
</template>
