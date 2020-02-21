<script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/
export default {
    data() {
        return {
            id: null
        }
    },
    mounted() {
        if (this.$route && this.$route.params.id) {
            this.id = this.$route.params.id
        }
    },
    methods: {
        showActions() {
            this.bus.publish("show:/module/app/actions")
        },
        showFiles() {
            this.bus.publish("show:/module/app/files")
        },
        showSubscriptions() {
            this.bus.publish("show:/module/app/subscriptions")
        },
        showActivities() {
            this.bus.publish("show:/module/app/activities")
        }
    },
    watch: {
        '$route.params.id': function(id) {
            this.id = id
        }
    }
}
</script>
<template>
    <nav class="lesli-module-navigation">
        <div class="navbar-menu">
            <div class="navbar-start">
                <slot name="left"></slot>
            </div>
            <div class="navbar-end">
                <slot name="right"></slot>
                <template v-if="id && ! $router.options.base.includes('workflows')">
                    <a class="navbar-item" @click="showSubscriptions">Subscriptions</a>
                    <a class="navbar-item" @click="showActions">Actions</a>
                    <a class="navbar-item" @click="showFiles">Files</a>
                    <a class="navbar-item" @click="showActivities">Activities</a>
                </template>
            </div>
        </div>
    </nav>
</template>
