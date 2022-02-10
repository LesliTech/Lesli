<script>

export default {
    data(){
        return {
            endpoint: "/administration/account/integrations",
            session: {},
            integration: {
                name: ""
            },
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        integrations: I18n.t("core.account/integrations"),
                    }
                }
            },
            submitting_form: false,
            integration_created: false
        }
    },
    methods: {

        postIntegration() {
            this.submitting_form = true

            this.http.post(this.endpoint,{ account_integration: this.integration}).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.core.account.integrations.messages_success_created_successfully)
                this.getIntegration(result.data.id)
                this.integration_created = true

            }).catch(error => {
                console.log(error)
            })
        },

        getIntegration(integrationId){
            this.http.get(`${this.endpoint}/${integrationId}.json`).then(result => {
                
                if(!result.successful){
                    this.msg.error(result.error.message)
                }

                this.integration = result.data

            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <div>
        <form @submit.prevent="postIntegration" v-if="!integration_created">
            <div class="field">
                <label class="label"> {{ translations.core.account.integrations.column_name }} </label>
                    <div class="control">
                    <input class="input" type="text" placeholder="" v-model="integration.name">
                </div>
            </div>
            <p class="control">
                <b-button class="button is-primary">
                    <span v-if="submitting_form">
                        <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                        &nbsp;
                        {{ translations.core.shared.btn_saving }}
                    </span>
                    <span v-else>
                        <b-icon icon="save" size="is-small" />
                        &nbsp;
                        {{ translations.core.shared.view_btn_save }}
                    </span>
                </b-button>
            </p>
        </form>
        <div v-else>
            <p>{{ translations.core.account.integrations.view_text_token }}: {{ integration.session.session_token }}</p>
        </div>
    </div>
</template>
