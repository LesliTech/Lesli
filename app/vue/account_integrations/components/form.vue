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
            submitting_form: false
        }
    },
    methods: {

        postIntegration() {
            this.submitting_form = true

            this.http.post(this.endpoint,{ account_integration: this.integration}).then(result => {
                this.submitting_form = false

                if (result.successful) {
                    this.alert(this.translations.core.integrations.messages_success_created_successfully, 'success')

                    this.url.go(`${this.endpoint}/${result.data.id}`)
                } else {
                    this.alert(result.error.message, "danger")
                    return
                }
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <form @submit.prevent="postIntegration">
        <div class="field">
            <label class="label"> {{ translations.core.account.integrations.column_name }} </label>
                <div class="control">
                <input class="input" type="text" placeholder="" v-model="integration.name">
            </div>
        </div>
        <p class="control">
            <button class="button is-primary">
                <span v-if="submitting_form">
                    <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                    &nbsp;
                    {{ translations.core.shared.btn_saving }}
                </span>
                <span v-else>
                    <b-icon icon="save" size="is-small" />
                    &nbsp;
                    {{ translations.core.shared.btn_save }}
                </span>
            </button>
        </p>
    </form>
</template>
