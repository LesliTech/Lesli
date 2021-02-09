<script>
export default {
    props: {},

    data() {
        return {
            endpoint: "/administration/account/integrations",
            integration: {},
            id: null,
            translations: {
                core: {
                    integrations: I18n.t("core.account/integrations"),
                    shared: I18n.t("core.shared")
                }
            }
        }
    },
    mounted() {
        this.id = this.$route.params.id
        this.getIntegration()
    },
    methods: {

        getIntegration() {
            this.http.get(`${this.endpoint}/${this.id}.json`).then(result => {
                this.integration = result.data
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="integration.name">
            <template slot="">
                <div class="buttons">
                    <router-link class="button" to="/">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.shared.view_btn_list }}</span>
                    </router-link>
                </div>
            </template>
        </component-header>

        <div class="card">
            <div class="card-content" v-if="integration.session">
                <p>{{ translations.core.integrations.view_text_token}}: {{ integration.session.session_token }}</p>
                <p>{{ translations.core.integrations.view_text_usage_count}}: {{ integration.session.usage_count }}</p>
            </div>
        </div>
    </section>
</template>
