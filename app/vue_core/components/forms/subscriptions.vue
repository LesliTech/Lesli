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

@dev      Carlos Hermosilla <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
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
            translations: null,
            show: false,
            events: [],
            module_name: null,
            object_name: null,
            master_fields: {
                subscribed: false,
                notification_type: 'web'
            }
        }
    },
    
    mounted(){
        this.parseCloudModule()
        this.setTranslations()
        this.getEvents()
        this.bus.subscribe("show:/module/app/subscriptions", () => this.show = !this.show )
    },

    methods: {

        parseCloudModule(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },

        setTranslations(){
            this.translations = I18n.t(`cloud_${this.module_name}.${this.object_name}s.subscriptions`)
        },

        getEvents(){
            if(this.cloudId){
                let module = this.cloudModule.split('/')
                this.http.get(`/${this.module_name}/${this.object_name}s/${this.cloudId}/subscribers`).then(result => {
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
            subscription_event[`cloud_${this.module_name}_${this.object_name}s_id`] = this.cloudId
            let data = {
                subscriber: subscription_event
            }

            this.http.post(
                `/${this.module_name}/${this.object_name}s/${this.cloudId}/subscribers`,
                data
            ).then(result =>{
                if (result.successful) {
                    subscription_event.id = result.data.id
                    if(show_alerts){
                        this.notification.alert(this.translations.messages.subscribe.successful)
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

            this.http.patch(
                `/${this.module_name}/${this.object_name}s/${this.cloudId}/subscribers/${subscription_event.id}`,
                data
            ).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.notification.alert(this.translations.messages.subscribe.successful)
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

            this.http.delete(
                `/${this.module_name}/${this.object_name}s/${this.cloudId}/subscribers/${subscription_event.id}`
            ).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.notification.alert(this.translations.messages.subscribe.successful)
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
            this.notification.alert(this.translations.messages.subscribe.successful)
        },

        'master_fields.subscribed': function(){
            this.events.forEach( event =>{
                if(event.subscribed != this.master_fields.subscribed){
                    event.subscribed = this.master_fields.subscribed
                    this.submitSubscription(event, false)
                }
            })
            this.notification.alert(this.translations.messages.subscribe.successful)
        }
    }
}
</script>
<template>
    <section v-if="translations">
        <div :class="[{ 'is-active': show }, 'quickview']">
            <header class="quickview-header" @click="show = false">
                <p class="title">
                    {{translations.title}}
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
                                        {{translations.titles.all_events}}
                                    </b-checkbox>
                                </div>
                                <div class="column is-5">
                                    <b-field>
                                        <b-select expanded v-model="master_fields.notification_type">
                                            <option value="email">{{translations.notification_types["email"]}}</option>
                                            <option value="web">{{translations.notification_types["web"]}}</option>
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
                                        {{translations.events[event.event]}}
                                    </b-checkbox>
                                </div>
                                <div class="column is-5">
                                    <b-field>
                                        <b-select
                                            @change.native="submitSubscription(event)"
                                            :placeholder="translations.placeholders.notification_type"
                                            expanded
                                            v-model="event.notification_type"
                                        >
                                            <option value="email">{{translations.notification_types["email"]}}</option>
                                            <option value="web">{{translations.notification_types["web"]}}</option>
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
