
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
import { useAnnouncements } from "Lesli/vue/stores/bell-announcements"


// · 
const storeAnnouncements = useAnnouncements()


// · initializing
onMounted(() => {
    setTimeout(() => storeAnnouncements.index(), 0)
})


</script>
<template>
    <section class="lesli-application-bell-announcements" v-if="storeAnnouncements.announcements.pagination.results > 0">
        <div 
            class="container px-4"
            :key="announcement.id"
            v-for="announcement in storeAnnouncements.announcements.records">
            <div 
                :class="['notification', `is-${announcement.category}`]" 
                v-if="announcement.status!='closed'">
                <button class="delete" aria-label="delete" 
                    v-if="announcement.can_be_closed" 
                    @click="storeAnnouncements.close(announcement)">
                    <span>x</span>
                </button>
                <div v-html="announcement.message"></div>
            </div>
        </div>
    </section>
</template>
