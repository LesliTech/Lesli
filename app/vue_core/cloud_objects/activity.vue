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


// · LesliCloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    data() {
        return {
            show: false,
            activities: [{
                id: 0,
                created_at: 'January 2019',
                content: 'Information logged successfully',
                type: 'goal'
            },{
                id: 1,
                created_at: 'January 2018',
                content: 'Information logged successfully',
                type: null
            },{
                id: 2,
                created_at: 'January 2017',
                content: 'Information logged successfully',
                type: 'goal'
            },{
                id: 3,
                created_at: 'January 2016',
                content: 'Information logged successfully',
                type: null
            },{
                id: 4,
                created_at: 'January 2015',
                content: 'Information logged successfully',
                type: 'goal'
            },{
                id: 5,
                created_at: 'January 2014',
                content: 'Information logged successfully',
                type: null
            },{
                id: 6,
                created_at: 'January 2013',
                content: 'Information logged successfully',
                type: 'goal'
            },{
                id: 7,
                created_at: 'January 2012',
                content: 'Information logged successfully',
                type: null
            },{
                id: 8,
                created_at: 'January 2011',
                content: 'Information logged successfully',
                type: 'goal'
            },{
                id: 9,
                created_at: 'January 2010',
                content: 'Information logged successfully',
                type: null
            }]
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {
        mountListeners(){
            this.bus.subscribe("show:/module/app/activities", () => this.show = !this.show )
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
                                <p>{{ activity.content }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
