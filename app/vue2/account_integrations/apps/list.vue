<script>
export default {
    props: {},

    data() {
        return {
            loading: true,
            endpoint: "/administration/account/integrations",
            integrations: [],
            translations: {
                core: {
                    integrations: I18n.t("core.account/integrations"),
                    shared: I18n.t('core.shared'),
                    users: I18n.t('core.users'),
                }
            },
        }
    },

    mounted() {
        this.getIntegrations()
    },

    methods: {
        getIntegrations() {
            this.http.get(this.endpoint.concat(".json")).then(result => {
                if (!result.successful) {
                    return
                }
                this.integrations = result.data
                this.loading = false
            }).catch(error => {
                console.log(error)
            })
        },

        confirmDeleteIntegration(integrationId){
            this.$buefy.dialog.confirm({
                title: this.translations.core.integrations.messages_danger_delete_integration,
                message: this.translations.core.integrations.messages_danger_delete_integration_message_detail,
                confirmText: this.translations.core.integrations.messages_danger_delete_integration_confirm,
                cancelText: this.translations.core.integrations.messages_danger_delete_integration_cancel,
                type: "is-danger",
                hasIcon: true,
                onConfirm: () => this.deleteIntegration(integrationId)
            })
        },

        deleteIntegration(integrationId){
            this.http.delete(`${this.endpoint}/${integrationId}.json`).then(result => {
                
                if(!result.successful){
                    this.msg.error(result.error.message)
                    return
                }

                this.integrations = this.integrations.filter( e => e.id != integrationId)
                this.msg.success(this.translations.core.integrations.messages_success_integration_deleted)

            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.core.integrations.view_title_list_integrations">
            <router-link to="/new" class="button is-primary">
                {{ translations.core.integrations.view_btn_new }}
            </router-link>
        </component-header>
        <div class="card">
            <component-data-loading v-if="loading"> </component-data-loading>
            <component-data-empty v-if="!loading && integrations.length === 0"> </component-data-empty>
            <div class="card-content" v-else>
                <b-table :data="integrations">
                    <template v-slot="props">
                        <b-table-column :label="translations.core.integrations.column_id" field="id" centered>
                            {{ props.row.id }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.column_name" field="name" centered>
                            {{ props.row.name }}
                        </b-table-column>

                        <b-table-column :label="translations.core.users.column_active" field="active" centered>
                            {{ props.row.active ? translations.core.shared.view_text_yes : translations.core.shared.view_text_no }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.view_text_usage_count" field="usage_count" centered>
                            {{ props.row.usage_count }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.view_text_last_used_at" field="last_used_at" centered>
                            {{ props.row.last_used_at }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.view_text_expiration_at" field="expiration_at" centered>
                            {{ props.row.expiration_at }}
                        </b-table-column>

                        <b-table-column @click.native.prevent="e=>e.stopPropagation()" :label="translations.core.shared.view_text_actions" :field="translations.core.shared.view_text_actions" centered>
                            <b-dropdown aria-role="menu" position="is-bottom-left">
                                <button class="button is-rounded is-default" slot="trigger" slot-scope="{ active }">
                                    <span class="icon">
                                        <i v-if="!active" class="fas fa-ellipsis-h fa-1x"></i>
                                        <i v-if="active" class="far fa-circle"></i>
                                    </span>
                                </button>
                                <b-dropdown-item class="has-text-right pr-4" @click="confirmDeleteIntegration(props.row.id)">
                                    {{ translations.core.shared.view_btn_delete }}
                                    <b-icon class="mr-4" icon="trash" />
                                </b-dropdown-item>
                            </b-dropdown>
                        </b-table-column>
                    </template>
                </b-table>
            </div>
        </div>
    </section>
</template>
