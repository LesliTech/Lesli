<script>
/*

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
export default {
    props: {
        title: {
            default: null
        },
        subtitle: {
            default: null
        },
        buttons: {
            default: true
        },
        titleButtonCreate: {
            default: "Create"
        }
    },
    data() {
        return {
            loading: false,
            announcements: []
        }
    },
    mounted() {
        this.getAnnouncements()
    },
    methods: {

        getAnnouncements() {

            if (this.lesli.announcements > 0) {
                setTimeout(() => {
                    this.http.get(this.url.bell("announcements")).then(result => {
                        this.announcements = result.data.records
                    })
                }, 5000)
            }

        },

        clickButtonReload() {
            this.loading = true
            setTimeout(() => { this.loading = false }, 1000);
            this.$emit("clickButtonReload");
        }

    }
}
</script>
<template>
    <section>
        <b-notification 
            v-for="announcement in announcements" 
            :key="announcement.id" 
            type="is-info">
            <div v-html="announcement.message.html">
            </div>
        </b-notification>
        <nav class="navbar component-header">
            <div class="navbar-menu">
                <div class="navbar-start">
                    <div class="navbar-item">
                        <h3 v-if="title" class="is-size-3">
                            {{ title }}
                        </h3>
                        <h4 v-if="subtitle" class="is-size-4">
                            {{ subtitle }}
                        </h4>
                    </div>
                </div>
                <div class="navbar-end">
                    <div class="navbar-item">
                        <slot></slot>
                    </div>
                </div>
            </div>
        </nav>        
    </section>
</template>
