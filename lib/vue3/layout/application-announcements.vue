
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



// · import stores
import { useLayout } from "LesliVue/stores/layout"

// · 
const storeLayout = useLayout()

// · initializing
onMounted(() => {
    storeLayout.getAnnouncements()
})


</script>
<template>
    <h2>tests</h2>
    <section class="application-notices" v-if="storeLayout.announcements.length > 0">
        <div class="notification is-primary" v-for="announcement in storeLayout.announcements" :key="announcement">
            <button class="delete"></button>
                {{announcement.message}}
        </div>
    </section>
</template>
