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
        allowedNotificationTypes: {
            type: Array,
            default: ()=>{
                return [
                    'web',
                    'push',
                    'email'
                ]
            }
        },
        cloudModule: {
            type: String,
            required: true
        },
        cloudId: {
            required: true
        },
        translationsPath: {
            type: String,
            default: null
        }
    },
    
    data() {
        return {
            translations: {
                core: I18n.t('core.shared'),
                subscriptions: {}
            },
            loading: {
                subscriptions: false
            },
            subscriptions: [],
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
                notification_type: 'email'
            }
        }
    },
    
    mounted(){
        this.setTranslations()
        this.parseCloudModule()
        this.getSubscriptions()
    },

    methods: {

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        setTranslations(){
            if(this.translationsPath){
                this.$set(this.translations, 'subscriptions', I18n.t(this.translationsPath))
            }
        },

        getSubscriptions(){
            if(this.cloudId){
                this.loading.subscriptions = true

                let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers.json`
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.subscriptions = result.data
                    } else {
                        this.alert(result.error.message, 'danger')
                    }
                }).catch(error => {
                    console.log(error)
                }).finally(()=>{
                    this.loading.subscriptions = false
                })
            }
        },

        submitSubscription(subscription, show_alerts = true){
            if(subscription.id){
                if(subscription.subscribed){
                    this.patchSubscription(subscription, show_alerts)
                }else{
                    this.deleteSubscription(subscription, show_alerts)
                }
            }else{
                if(subscription.subscribed){
                    this.postSubscription(subscription, show_alerts)
                }
            }
        },

        postSubscription(subscription, show_alerts){
            let foreign_key = `cloud_${this.module_name.underscore}_${this.object_name.plural}_id`
            subscription[foreign_key] = this.cloudId

            let data = {}
            data[`${this.object_name.singular}_subscriber`] = subscription
            
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers.json`

            this.http.post(url, data).then(result =>{
                if (result.successful) {
                    subscription.id = result.data.id
                    if(show_alerts){
                        this.alert('Subscriptions successfully updated', 'success')
                    }
                }else{
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchSubscription(subscription, show_alerts){
            let data = {}
            data[`${this.object_name.singular}_subscriber`] = subscription
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers/${subscription.id}.json`

            this.http.patch(url, data).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.alert('Subscriptions successfully updated', 'success')
                    }
                }else{
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        deleteSubscription(subscription, show_alerts){
            let data = {
                subscriber: subscription
            }
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers/${subscription.id}.json`

            this.http.delete(url).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.alert('Subscriptions successfully updated', 'success')
                    }
                    delete subscription.id
                }else{
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {

        cloudId(){
            this.getSubscriptions()
        },

        'master_fields.notification_type': function(){
            this.subscriptions.forEach( event => {
                if(event.notification_type != this.master_fields.notification_type){
                    event.notification_type = this.master_fields.notification_type
                    this.submitSubscription(event, false)
                }
            })
            this.alert('Subscriptions type successfully updated', 'success')
        },

        'master_fields.subscribed': function(){
            this.subscriptions.forEach( event =>{
                if(event.subscribed != this.master_fields.subscribed){
                    event.subscribed = this.master_fields.subscribed
                    this.submitSubscription(event, false)
                }
            })
            this.alert('Subscriptions successfully updated', 'success')
        }
    }
}
</script>
<template>
    <b-sidebar
        :open.sync="data.global.show_panel_subscriptions"
        class="application-panel-support"
        right
        :can-cancel="['escape','outside']"
        fullheight
        overlay
    >
        <div class="sidebar-content">
            <h5 class="title is-5">
                <div class="columns">
                    <div class="column is-11">
                        {{translations.core.view_title_subscribers_manage_subscriptions}}
                    </div>
                    <div class="column is-1">
                        <button type="button" class="delete" @click="() => data.global.show_panel_subscriptions = false">
                        </button>
                    </div>
                </div>
            </h5>
            <component-data-loading v-if="loading.subscriptions">
            </component-data-loading>
            <div class="box is-shadowless" v-else>
                <table class="table is-narrowed is-striped is-fullwidth">
                    <tbody>
                        <tr>
                            <td>
                                <b-checkbox v-model="master_fields.subscribed">
                                    {{translations.core.view_text_subscriptions_subscribe_to_all}}
                                </b-checkbox>
                            </td>
                            <td>
                                <b-field>
                                    <b-select
                                        expanded
                                        v-model="master_fields.notification_type"
                                        size="is-small"
                                    >
                                        <option
                                            v-for="notification_type in allowedNotificationTypes"
                                            :key="notification_type"
                                            :value="notification_type"
                                        >
                                            {{
                                                object_utils.translateEnum(
                                                    translations.subscriptions,
                                                    'column_enum_notification_type',
                                                    notification_type,
                                                    null
                                                ) || (
                                                object_utils.translateEnum(
                                                    translations.core,
                                                    'column_enum_subscriptions_notification_type',
                                                    notification_type
                                                ))
                                            }}
                                        </option>
                                    </b-select>
                                </b-field>
                            </td>
                        </tr>
                        <tr v-for="subscription in subscriptions" :key="subscription.event">
                            <td>
                                <b-checkbox v-model="subscription.subscribed" @change.native="submitSubscription(subscription)">
                                    {{
                                        object_utils.translateEnum(
                                            translations.subscriptions,
                                            'column_enum_action',
                                            subscription.action,
                                            null
                                        ) || (
                                        object_utils.translateEnum(
                                            translations.core,
                                            'column_enum_subscriptions_action',
                                            subscription.action
                                        ))
                                    }}
                                </b-checkbox>
                            </td>
                            <td>
                                <b-field>
                                    <b-select
                                        @change.native="submitSubscription(subscription)"
                                        size="is-small"
                                        :placeholder="translations.core.view_placeholder_select_option"
                                        expanded
                                        v-model="subscription.notification_type"
                                    >
                                        <option
                                            v-for="notification_type in allowedNotificationTypes"
                                            :key="notification_type"
                                            :value="notification_type"
                                        >
                                            {{
                                                object_utils.translateEnum(
                                                    translations.subscriptions,
                                                    'column_enum_notification_type',
                                                    notification_type,
                                                    null
                                                ) || (
                                                object_utils.translateEnum(
                                                    translations.core,
                                                    'column_enum_subscriptions_notification_type',
                                                    notification_type
                                                ))
                                            }}
                                        </option>
                                    </b-select>
                                </b-field>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </b-sidebar>
</template>
<style scoped>
    .clickable{
        cursor: pointer;
    }
</style>
