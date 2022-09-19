
<script setup>
/*
Copyright (c) 2022, all rights reserved.

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


import {onMounted} from 'vue'
// · import stores
import { useAnnouncements } from "LesliVue/stores/announcements"

// · 
const storeAnnouncements = useAnnouncements()

// · initializing
onMounted(() => {
    storeAnnouncements.getAnnouncements()
})


</script>
<template>
    <section class="application-announcements" v-if="storeAnnouncements.announcements.length > 0">
        <article :class="['message', `is-${announcement.category}`]" v-for="announcement in storeAnnouncements.announcements" :key="announcement.id">
            <div  v-if="announcement.status!='closed'">
                <div class="message-header">
                    <p>{{announcement.name}}</p>
                    <button class="delete" aria-label="delete" v-if="announcement.can_be_closed" @click="storeAnnouncements.closeAnnouncement(announcement)"></button>
                </div>
                <div class="message-body">
                    {{announcement.message}}
                </div>
            </div>
        </article>
    </section>
</template>
