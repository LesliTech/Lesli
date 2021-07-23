<script>
/*

Lesli

Copyright (c) 2020, all rights reserved.

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


// · 
export default {

}
</script>
<template>
    <section class="application-notices">
        <article v-for="announcement in lesli.announcements" 
            :key="announcement.id"
            :class="['notification', `is-${announcement.category}`]">
            <button class="delete"></button>
            <div class="notification-body" v-html="announcement.message.html"></div>
        </article>
    </section>
</template>
