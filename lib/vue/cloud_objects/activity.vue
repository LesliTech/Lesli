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


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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
            activities: [],
            module_name: {
                slash: null,
                underscore: null
            },
            object_name: {
                singular: null,
                plural: null
            }
        }
    },

    mounted() {
        this.moutSubscriptions()
        this.parseCloudModule()
        this.getActivities()
    },

    methods: {

        moutSubscriptions(){
            this.bus.subscribe('show:/module/app/activities', () => {
                this.getActivities()
                this.show = !this.show
            })
        },

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },


        getActivities() {
            if(this.cloudId){
                let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/activities`
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.activities = result.data
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    },

    beforeDestroy(){
        this.bus.$off('show:/module/app/activities')
    }
}
</script>
<template>
    <section>
        <div :class="[{ 'is-active': show }, 'quickview']">
            <header class="quickview-header" @click="show = false">
                <p class="title">Activities Log</p>
                <i class="fas fa-chevron-right clickable"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="timeline section">
                        <div class="timeline-item" v-for="activity in activities" :key="activity.id">
                            <div class="timeline-marker" v-if="!activity.icon"></div>
                            <div class="timeline-marker is-icon" v-if="activity.icon">
                                <i :class="['fa', 'fa-' + activity.icon]"></i>
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
