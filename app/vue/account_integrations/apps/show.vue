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
        },

        confirmDeleteIntegration(){
            this.$buefy.dialog.confirm({
                title: this.translations.core.integrations.messages_danger_delete_integration,
                message: this.translations.core.integrations.messages_danger_delete_integration_message_detail,
                confirmText: this.translations.core.integrations.messages_danger_delete_integration_confirm,
                cancelText: this.translations.core.integrations.messages_danger_delete_integration_cancel,
                type: "is-danger",
                hasIcon: true,
                onConfirm: () => this.deleteIntegration()
            })
        },

        deleteIntegration(){
            this.http.delete(`${this.endpoint}/${this.id}.json`).then(result => {

                if(!result.successful){
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.core.integrations.messages_success_integration_deleted)
                this.$router.push(`/`)

            }).catch(error => {
                console.log(error);
            })
        },

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
                    <b-button class="button" @click="confirmDeleteIntegration()">
                        <b-icon icon="trash" size="is-small" />
                        <span>{{ translations.core.shared.view_btn_delete }}</span>
                    </b-button>
                </div>
            </template>
        </component-header>
    </section>
</template>
