<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

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

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/



// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudId: {
            required: true
        }
    },
    data() {
        return {
            show: false,
            activities: []
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {

        mountListeners(){
            this.bus.subscribe("show:/module/app/activities", () => {
                this.show = !this.show
                this.getActivities()
            })
        },

        getActivities() {
            if(this.cloudId){
                this.http.get(`/${this.cloudModule}s/${this.cloudId}/activities`).then(result => {
                    if (result.successful) {
                        this.activities = result.data
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }

    }
}
</script>
<template>
    <section>
        <div :class="[{ 'is-active': show }, 'quickview']">
            <header class="quickview-header" @click="show = false">
                <p class="title">Activity</p>
                <i class="fas fa-chevron-right clickable"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="timeline section">
                        <div class="timeline-item" v-for="activity in activities" :key="activity.id">
                            <div class="timeline-marker" v-if="!activity.type"></div>
                            <div class="timeline-marker is-icon" v-if="activity.type">
                                <i class="fa fa-flag"></i>
                            </div>
                            <div class="timeline-content">
                                <p class="heading">{{ activity.created_at }}</p>
                                <p>{{ activity.description }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
