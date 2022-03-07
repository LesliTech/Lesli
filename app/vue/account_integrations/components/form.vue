<script>
import DatePicker from '@v-calendar/lib/components/date-picker.umd'

export default {
    data(){
        return {
            endpoint: "/administration/account/integrations",
            session: {
                session_token: ""
            },
            integration: {
                name: "",
            },
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        integrations: I18n.t("core.account/integrations"),
                    },
                    users: {
                        sessions: I18n.t("core.users/sessions")
                    }
                }
            },
            submitting_form: false,
            integration_created: false
        }
    },

    components: {
        "vc-date-picker": DatePicker
    },

    methods: {

        postIntegration() {
            this.submitting_form = true

            let params = {
                account_integration: this.integration,
                session: this.session
            }

            this.http.post(this.endpoint,params).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.session.session_token = result.data
                this.integration_created = true
                this.msg.success(this.translations.core.account.integrations.messages_success_created_successfully)

            }).catch(error => {
                console.log(error)
            })
        },

        copyToClipboard() {
            const el = document.createElement('textarea');
            el.value = this.session.session_token 
            el.setAttribute('readonly', '');
            el.style.position = 'absolute';
            el.style.left = '-9999px';
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);
            this.msg.info("Copied to clipboard")
        },

    }
}
</script>
<template>
    <div>
        <form @submit.prevent="postIntegration" v-if="!integration_created">
            <div class="columns">
                <div class="column">
                    <label class="label"> {{ translations.core.account.integrations.column_name }} </label>
                    <div class="control">
                        <input class="input" type="text" placeholder="" v-model="integration.name">
                    </div>
                </div>
                <div class="column">
                    <label class="label">{{ translations.core.users.sessions.column_expiration_at }}</label>
                    <vc-date-picker 
                        v-model="session.expiration_at" 
                        :popover="{ visibility: 'focus'}"
                        :locale="date.vcDatepickerConfig()"
                        :min-date="new Date()">
                        <template v-slot="{ inputValue, inputEvents }">
                            <input 
                                class="input is-default" 
                                name="session-expiration-at"
                                :value="date.toString(session.expiration_at)" 
                                v-on="inputEvents"
                                :placeholder="translations.core.shared.view_placeholder_select_date"
                                autocomplete="off">
                        </template>
                    </vc-date-picker>
                </div>
            </div>
            <p class="control">
                <b-button class="button is-primary submit-button" native-type="submit" expanded>
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
        <div v-else class="is-flex is-flex-direction-row is-align-items-center">
            <p>{{ translations.core.account.integrations.view_text_token }}:</p>
            <b-tooltip label="Click to copy">
                <b-button :label="session.session_token" type="is-ghost" class="button" @click="copyToClipboard" />
            </b-tooltip>
        </div>
    </div>
</template>
