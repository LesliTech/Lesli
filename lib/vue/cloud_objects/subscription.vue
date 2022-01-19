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
import componentUsers from 'LesliVue/components/forms/users-autocomplete.vue'

export default {
    components: {
        'component-users': componentUsers
    },

    props: {
        allowedNotificationTypes: {
            type: Array,
            default: ()=>{
                return [
                    'email',
                    'webpush',
                    'mobilepush',
                    'mobiledialog',
                    'push'
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
            options: {},
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
            },
            selected_user_id: null,
            loading_users: false
        }
    },
    
    mounted(){
        this.setTranslations()
        this.parseCloudModule()
        this.getSubscriptions()
        this.getUsers()
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
        
        getUsers(){
            if( (! this.data.third_party_subscriptions) || (! this.data.third_party_subscriptions.enabled)){
                return
            }

            this.loading_users = true
            let url = this.url.lesli('administration/users/list')
            url.query = {role: (this.data.third_party_subscriptions.roles || ''), type: (this.data.third_party_subscriptions.type || 'exclude')}

            this.http.get(url).then(result => {
                if (result.successful) {

                    // We remove users that have no name, because we cannot identify them
                    let valid_users = result.data.filter(user => user.name.trim().length > 0)

                    this.$set(this.options, 'users', valid_users)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loading_users = false
            })
        },

        getSubscriptions(){
            if(this.cloudId){
                this.loading.subscriptions = true

                let url = this.url.lesli(`${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers`)
                if(this.selected_user_id){
                    url.query = {users_id: this.selected_user_id}
                }

                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.subscriptions = result.data
                    } else {
                        this.msg.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                }).finally(()=>{
                    this.loading.subscriptions = false
                })
            }
        },

        submitSubscription(subscription, show_alerts = true){
            this.$set(subscription, 'submitting', true)
            if(subscription.id){
                if(subscription.subscribed){
                    this.patchSubscription(subscription, show_alerts)
                }else{
                    this.deleteSubscription(subscription, show_alerts)
                }
            }else{
                if(subscription.subscribed){
                    this.postSubscription(subscription, show_alerts)
                }else{
                    this.$set(subscription, 'submitting', false)
                }
            }
        },

        postSubscription(subscription, show_alerts){
            let foreign_key = `cloud_${this.module_name.underscore}_${this.object_name.plural}_id`
            subscription[foreign_key] = this.cloudId

            let data = {}
            data[`${this.object_name.singular}_subscriber`] = subscription
            data.users_id = this.selected_user_id
            
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers.json`

            this.http.post(url, data).then(result =>{
                if (result.successful) {
                    subscription.id = result.data.id
                    if(show_alerts){
                        this.msg.success('Subscriptions successfully updated')
                    }
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.$set(subscription, 'submitting', false)
                this.reviewSubscriptions()
            })
        },

        patchSubscription(subscription, show_alerts){
            let data = {}
            data[`${this.object_name.singular}_subscriber`] = subscription

            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers/${subscription.id}.json`

            this.http.patch(url, data).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.msg.success('Subscriptions successfully updated')
                    }
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.$set(subscription, 'submitting', false)
                this.reviewSubscriptions()
            })
        },
        
        deleteSubscription(subscription, show_alerts){
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/subscribers/${subscription.id}.json`

            this.http.delete(url).then(result =>{
                if (result.successful) {
                    if(show_alerts){
                        this.msg.success('Subscriptions successfully updated')
                    }
                    delete subscription.id
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.$set(subscription, 'submitting', false)
                this.reviewSubscriptions()
            })
        },
        
        reviewSubscriptions(){
            let subscribed = false
            for(let i = 0; i < this.subscriptions.length; i++){
                let subscription = this.subscriptions[i]
                if(subscription.subscribed){
                    subscribed = true
                    break
                }
            }

            if(subscribed){
                this.$emit('subscribed')
            }else{
                this.$emit('unsubscribed')
            }
        }
    },

    watch: {
        selected_user_id(){
            this.getSubscriptions()
        },

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
            this.msg.success('Subscriptions type successfully updated')
        },

        'master_fields.subscribed': function(){
            this.subscriptions.forEach( event =>{
                if(event.subscribed != this.master_fields.subscribed){
                    event.subscribed = this.master_fields.subscribed
                    this.submitSubscription(event, false)
                }
            })
            this.msg.success('Subscriptions successfully updated')
        }
    }
}
</script>
<template>
    <b-sidebar
        :open.sync="data.global.show_panel_subscriptions"
        class="application-panel-support"
        right
        :can-cancel="['escape']"
        fullheight
        overlay
    >

        <div class="panel-title is-size-5">
            <h4>
                {{ translations.core.view_title_subscribers_manage_subscriptions }}
            </h4>
            <span class="icon is-large hover" @click="data.global.show_panel_subscriptions = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>

        
        <div class="panel-content" v-if="loading.subscriptions">
            <component-data-loading>
            </component-data-loading>
        </div>
        <div class="panel-content" v-else>
            <div v-if="data.third_party_subscriptions && data.third_party_subscriptions.enabled">
                <div class="columns" >
                    <div class="column">
                        <b-field v-if="options.users" :message="translations.core.view_text_subscriptions_autocomplete_leave_empty_for_self_subscribing">
                            <component-users
                                :title="translations.core.view_title_subscriptions_autocomplete_select_other_user"
                                :user_id="selected_user_id"
                                :users="options.users"
                                :required="false"
                                @select="(user) => selected_user_id = user.id"
                                @clear-user="() => selected_user_id = null"
                                :focus="true"
                            >
                            </component-users>
                        </b-field>
                        <component-data-loading v-else>
                        </component-data-loading>
                    </div>
                </div>
                <hr>
            </div>
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
                            <b-checkbox :disabled="subscription.submitting" v-model="subscription.subscribed" @change.native="submitSubscription(subscription)">
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
    </b-sidebar>
</template>
<style scoped>
    .clickable{
        cursor: pointer;
    }
</style>
