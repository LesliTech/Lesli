
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



// · 
import {onMounted} from 'vue'


// · import stores
import { useAnnouncements } from "Lesli/shared/stores/announcements"
import RichtextViewer from "Lesli/components/editors/richtext-viewer.vue"


// · 
const storeAnnouncements = useAnnouncements()


// · initializing
onMounted(() => {

    // IMPORTANT: here we have to watch for Router changes, due vue router
    // does not reload the entire window, so ouMounted is executed only once
    // due rightnow we have to manage two different vue applications (vue2 & vue3)
    // we reload the window everytime, this works... but the best way is to use
    // only the vue3 router
    setTimeout(() => storeAnnouncements.getAnnouncements(), 2000)
})


</script>
<template>
    <section class="application-announcements" v-if="storeAnnouncements.announcements.length > 0">
        <div v-for="announcement in storeAnnouncements.announcements" :key="announcement.id" class="block">
            <div 
                :class="['notification', `is-${announcement.category}`]" 
                v-if="announcement.status!='closed'">
                <button class="delete" aria-label="delete" 
                    v-if="announcement.can_be_closed" 
                    @click="storeAnnouncements.closeAnnouncement(announcement)">
                </button>
                <richtext-viewer v-model="announcement.message"></richtext-viewer>
            </div>
        </div>
    </section>
</template>
