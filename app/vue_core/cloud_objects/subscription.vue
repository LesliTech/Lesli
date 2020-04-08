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
            events: [],
            module_name: {
                slash: null,
                underscore: null
            },
            object_name: {
                singular: null,
                plural: null
            },
            master_fields: {
                subscribed: false,
                notification_type: 'web'
            }
        }
    },
    
    mounted(){
        this.setTranslations()
        this.mountListeners()
        this.parseCloudModule()
        this.getEvents()
    },

    methods: {

        mountListeners(){
            this.bus.subscribe('show:/module/app/subscriptions', () => {
                this.show = !this.show
            })
        },

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        setTranslations(){
        },

        getEvents(){
            if(this.cloudId){
                let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers`
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.events = result.data
                    } else {
                        this.notification.alert(result.error.message, 'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        submitSubscription(subscription_event, show_alerts = true){
            if(subscription_event.id){
                if(subscription_event.subscribed){
                    this.patchSubscription(subscription_event, show_alerts)
                }else{
                    this.deleteSubscription(subscription_event, show_alerts)
                }
            }else{
                if(subscription_event.subscribed){
                    this.postSubscription(subscription_event, show_alerts)
                }
            }
        },

        postSubscription(subscription_event, show_alerts){
            let foreign_key = `cloud_${this.module_name.underscore}_${this.object_name.plural}_id`
            subscription_event[foreign_key] = this.cloudId

            let data = {
                subscriber: subscription_event
            }
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers`

            this.http.post(url, data).then(result =>{
                if (result.successful) {
                    subscription_event.id = result.data.id
                    if(show_alerts){
                        this.notification.alert('Subscriptions successfully updated', 'success')
                    }
                }else{
                    this.notification.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchSubscription(subscription_event, show_alerts){
            let data = {
                subscriber: subscription_event
            }
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers/${subscription_event.id}`

            this.http.patch(url, data).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.notification.alert('Subscriptions successfully updated', 'success')
                    }
                }else{
                    this.notification.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        deleteSubscription(subscription_event, show_alerts){
            let data = {
                subscriber: subscription_event
            }
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers/${subscription_event.id}`

            this.http.delete(url).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.notification.alert('Subscriptions successfully updated', 'success')
                    }
                    delete subscription_event.id
                }else{
                    this.notification.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {

        cloudId(){
            this.getEvents()
        },

        'master_fields.notification_type': function(){
            this.events.forEach( event => {
                if(event.notification_type != this.master_fields.notification_type){
                    event.notification_type = this.master_fields.notification_type
                    this.submitSubscription(event, false)
                }
            })
            this.notification.alert('Subscriptions type successfully updated', 'success')
        },

        'master_fields.subscribed': function(){
            this.events.forEach( event =>{
                if(event.subscribed != this.master_fields.subscribed){
                    event.subscribed = this.master_fields.subscribed
                    this.submitSubscription(event, false)
                }
            })
            this.notification.alert('Subscriptions successfully updated', 'success')
        }
    }
}
</script>
<template>
    <section>
        <div :class="[{ 'is-active': show }, 'quickview']">
            <header class="quickview-header" @click="show = false">
                <p class="title">
                    Manage your subscriptions
                </p>
                <i class="fas fa-chevron-right clickable"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <div class="field">
                            <div class="columns">
                                <div class="column is-7">
                                    <b-checkbox v-model="master_fields.subscribed">
                                        All Events
                                    </b-checkbox>
                                </div>
                                <div class="column is-5">
                                    <b-field>
                                        <b-select expanded v-model="master_fields.notification_type">
                                            <option value="email">Email</option>
                                            <option value="web">Web</option>
                                        </b-select>
                                    </b-field>
                                </div>
                            </div>
                            <hr />
                        </div>
                        <div v-for="event in events" :key="event.event" class="field">
                            <div class="columns">
                                <div class="column is-7">
                                    <b-checkbox v-model="event.subscribed" @change.native="submitSubscription(event)">
                                        {{event.event}}
                                    </b-checkbox>
                                </div>
                                <div class="column is-5">
                                    <b-field>
                                        <b-select
                                            @change.native="submitSubscription(event)"
                                            placeholder="Type"
                                            expanded
                                            v-model="event.notification_type"
                                        >
                                            <option value="email">Email</option>
                                            <option value="web">Web</option>
                                        </b-select>
                                    </b-field>
                                </div>
                            </div>
                            <hr />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
<style scoped>
    .clickable{
        cursor: pointer;
    }
</style>
