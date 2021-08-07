<script>
export default {
    data(){
        return {
            options: {},
            translations: {
                subscriptions: I18n.t('core.profile/subscriptions'),
                core: I18n.t('core.shared')
            },
            filters: {
                engine: null
            },
            loading: {
                subscriptions: false
            },
            subscriptions: []
        }
    },

    mounted(){
        this.getOptions()
    },

    methods: {
        getOptions(){
            let url = this.url.profile('subscriptions/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data

                    // If therea are no engine options, we immediately get subscriptions
                    if(! this.options.engines){
                        this.getSubscriptions()
                    }
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getSubscriptions(){
            let url = this.url.profile('subscriptions')
            if(this.filters.engine){
                url = url.filters({engine: this.filters.engine})
            }
            this.loading.subscriptions = true

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.subscriptions = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loading.subscriptions = false
            })
        },

        confirmDeletion(subscription){
            this.$buefy.dialog.confirm({
                title: this.translations.subscriptions.messages_danger_delete_confirmation_title,
                message: this.translations.subscriptions.messages_danger_delete_confirmation_body,
                confirmText: this.translations.core.view_btn_accept,
                cancelText: this.translations.core.view_btn_cancel,
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteSubscription(subscription)
            })
        },

        putSubscription(subscription){
            let data = {}
            data[subscription.subscriber_key] = {
                notification_type: subscription.notification_type
            }

            this.http.put(subscription.url, data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.subscriptions.messages_success_subscription_destroyed)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteSubscription(deleted_subscription){
            this.$set(deleted_subscription, 'deleting', true)

            this.http.delete(deleted_subscription.url).then(result => {
                if (result.successful) {
                    this.subscriptions = this.subscriptions.filter(subscription => deleted_subscription.id != subscription.id)
                    this.msg.success(this.translations.subscriptions.messages_success_subscription_destroyed)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.$set(deleted_subscription, 'deleting', false)
            })
        }
    },

    watch: {
        'filters.engine'(){
            this.getSubscriptions()
        }
    }

}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <h4 class="is-size-4 mb-4"> {{ translations.subscriptions.view_title_main }}</h4>

            <b-field v-if="options.engines" :label="translations.subscriptions.view_toolbar_filter_engine">
                <b-select v-model="filters.engine" expanded :placeholder="translations.core.view_placeholder_select_option">
                    <option v-for="engine in options.engines" :key="engine.value" :value="engine.text">
                        {{engine.value}}
                    </option>
                </b-select>
            </b-field>
            <hr>
            <component-data-loading v-if="loading.subscriptions"> </component-data-loading>
            <component-data-empty v-if="!loading.subscriptions && subscriptions.length == 0"> </component-data-empty>
            <b-table
                narrowed
                v-else
                :data="subscriptions"
                paginated
                per-page="15"
                :hoverable="true"
            >
                <template v-slot="props">
                    <b-table-column :label="translations.subscriptions.column_id" field="id" sortable>
                        {{props.row.id}}
                    </b-table-column>
                    <b-table-column :label="translations.subscriptions.view_table_header_cloud_object_type" field="cloud_object_type" sortable>
                        <a :href="`${props.row.resource_url}${props.row.resource_urn}`">
                            {{props.row.cloud_object_type}}
                        </a>
                    </b-table-column>
                    <b-table-column
                        :label="translations.subscriptions.view_table_header_cloud_object_global_identifier"
                        field="cloud_object_global_identifier"
                        sortable
                    >
                        <a :href="`${props.row.resource_url}${props.row.resource_urn}`">
                            {{props.row.cloud_object_global_identifier}}
                        </a>
                    </b-table-column>
                    <b-table-column :label="translations.subscriptions.column_action" field="action" sortable>
                        {{props.row.action}}
                    </b-table-column>
                    <b-table-column :label="translations.subscriptions.column_notification_type" field="notification_type" sortable>
                        <b-select
                            size="is-small"
                            v-if="options.notification_types && (Object.keys(options.notification_types).length > 1)"
                            @change.native="putSubscription(props.row)"
                            v-model="props.row.notification_type"
                        >
                            <option v-for="(key, value) in options.notification_types" :key="key" :value="key">
                                {{object_utils.translateEnum(translations.core, 'column_enum_subscriptions_notification_type', value)}}
                            </option>
                        </b-select>
                        <span v-else>
                            {{object_utils.translateEnum(
                                translations.core,
                                'column_enum_subscriptions_notification_type',
                                props.row.notification_type
                            )}}
                        </span>
                    </b-table-column>
                    <b-table-column field="actions">
                        <b-button
                            class="is-pulled-right"
                            type="is-danger"
                            size="is-small"
                            native-type="button"
                            @click="confirmDeletion(props.row)"
                            :disabled="props.row.deleting"
                        >
                            <b-icon v-if="props.row.deleting" size="is-small" icon="circle-notch" custom-class="fa-spin">
                            </b-icon>
                            <b-icon v-else size="is-small" icon="trash-alt">
                            </b-icon>
                        </b-button>
                    </b-table-column>
                </template>
            </b-table>
        </div>
    </div>
</template>
