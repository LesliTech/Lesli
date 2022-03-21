<script>
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


// ·
export default {
    data(){
        return {
            announcements: [],
            announcements_abilities: this.abilities.privilege("announcements", "cloud_bell")
        }
    },

    mounted(){
        if (this.announcements_abilities.list) {
            setTimeout(() => { this.getAnnouncements() }, 1500);
        }
    },

    methods: {
        getAnnouncements(){
            let url = this.url.bell('announcements/list').filters({
                base_path: this.$router.currentRoute.path,
                start_at: true,
                end_at: true,
                status: true
            })
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.announcements = result.data
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        closeAnnouncement(announcement_id){
            this.announcements = this.announcements.filter(e => e.id !== announcement_id)
        }
    },

    watch: {
        '$route'(){
            this.announcements = []
            this.getAnnouncements()
        }
    }
}
</script>
<template>
    <section class="application-notices" v-if="announcements.length > 0">
        <article v-for="announcement in announcements"
            :key="announcement.id"
            :class="['notification', `is-${announcement.category}`]">
            <button v-if="announcement.can_be_closed" @click="closeAnnouncement(announcement.id)" class="delete"></button>
            <div class="notification-body" v-html="announcement.message.html"></div>
        </article>
    </section>
</template>
