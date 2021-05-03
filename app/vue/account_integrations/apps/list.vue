<script>
export default {
    props: {},

    data() {
        return {
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
            }).catch(error => {
                console.log(error)
            })
        },

        showIntegration(integration) {
            this.$router.push(`${integration.id}`)
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
            <div class="card-content">
                <b-table
                    @click="showIntegration"
                    :data="integrations"
                >

                    <template v-slot="props">

                        <b-table-column :label="translations.core.integrations.column_id" field="id">
                            {{ props.row.id }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.column_name" field="name">
                            {{ props.row.name }}
                        </b-table-column>

                        <b-table-column :label="translations.core.users.column_active" field="active">
                            {{ props.row.active ? translations.core.shared.view_text_yes : translations.core.shared.view_text_no }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.view_text_usage_count" field="usage_count">
                            {{ props.row.usage_count }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.view_text_last_used_at" field="last_used_at">
                            {{ props.row.last_used_at }}
                        </b-table-column>

                        <b-table-column :label="translations.core.integrations.view_text_expiration_at" field="expiration_at">
                            {{ props.row.expiration_at }}
                        </b-table-column>
                    </template>
                </b-table>
            </div>
        </div>
    </section>
</template>
