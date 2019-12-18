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
                        this.alert(result.error.message, 'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        putSubscriptions(e){
            if (e) { e.preventDefault() }

            let events = this.events.filter(event => {
                return event.id || event.subscribed
            }).map(event => {
                if(! event.subscribed){
                    event._destroy = true
                }
                return event
            })
            
            let form_data = {}
            form_data[this.object_name] = {
                subscribers_attributes: events
            }
            this.show = false
            this.http.put(`/${this.module_name}/${this.object_name}s/${this.cloudId}`, form_data).then(result => {
                if (result.successful) {
                    this.events = result.data
                    this.alert(this.translations.messages.subscribe.successful)
                } else {
                    this.alert(result.error.message, 'danger')
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
                event.notification_type = this.master_fields.notification_type
            })
        },

        'master_fields.subscribed': function(){
            this.events.forEach( event =>{
                event.subscribed = this.master_fields.subscribed
            })
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
                        <form @submit="putSubscriptions" id="form-subscription">
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
                                        <b-checkbox v-model="event.subscribed">
                                            {{translations.events[event.event]}}
                                        </b-checkbox>
                                    </div>
                                    <div class="column is-5">
                                        <b-field>
                                            <b-select
                                                :placeholder="translations.placeholders.notification_type"
                                                expanded
                                                v-model="event.notification_type"
                                                :required="event.subscribed"
                                            >
                                                <option value="email">{{translations.notification_types["email"]}}</option>
                                                <option value="web">{{translations.notification_types["web"]}}</option>
                                            </b-select>
                                        </b-field>
                                    </div>
                                </div>
                                <hr />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <footer class="quickview-footer">
                <button class="card-footer-item button is-primary" type="submit" form="form-subscription">
                    {{translations.actions.subscribe}}
                </button>
            </footer>
        </div>
    </section>
</template>
<style scoped>
    .clickable{
        cursor: pointer;
    }
</style>
