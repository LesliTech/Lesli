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

import componentFormBasicInformation from "../components/form-basic-information.vue"
import componentFormContactInformation from "../components/form-contact-information.vue"
import componentFormPublicInformation from "../components/form-public-information.vue"
import componentFormDatetimeFormats from "../components/form-datetime-formats.vue"
import componentFormInviteUsers from "../components/form-invite-users.vue"


export default {

    components: {
        'component-form-basic-information': componentFormBasicInformation,
        'component-form-contact-information': componentFormContactInformation,
        'component-form-public-information': componentFormPublicInformation,
        'component-form-datetime-formats': componentFormDatetimeFormats,
        'component-form-invite-users': componentFormInviteUsers,
    },

    data() {
        return {
            logo: null, 
            settings: {
                "datetime_time_zone": null,
                "datetime_start_week_on": null,
                "datetime_format_date": null,
                "datetime_format_time": null,
                "datetime_format_date_time": null,
                "datetime_format_date_words": null,
                "datetime_format_date_time_words": null,
            },
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    roles: I18n.t("core.roles"),
                    shared: I18n.t("core.shared"),
                    account: {
                        settings: I18n.t("core.account/settings")
                    },
                    onboardings: I18n.t("core.onboardings")
                }
            },
        }
    },
    mounted() {
        this.logo = logo
        console.log(this.logo)
        this.getAccountData()
    },
    methods: {
        getAccountData() {
            this.http.get("/onboarding.json").then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.data.account = result.data.account
                this.parseSettings(result.data.account_settings)
                this.data.account_settings = this.settings
            }).catch(error => {
                console.log(error)
            })
        },

        parseSettings(settings_raw) {
            settings_raw.forEach(setting_raw => {
                if (setting_raw.name in this.settings) {
                    this.settings[setting_raw.name] = setting_raw.value
                }
            });
        },

        finishConfiguration(skipped = false) {
            this.http.post(this.url.lesli("onboarding"), {
                account: this.data.account,
                account_settings: this.data.account_settings
            }).then(result => {
                if (result.successful) {
                    if(skipped){
                        this.msg.info(this.translations.core.onboardings.messages_info_onboarding_process_skipped)
                    }else{
                        this.msg.success(this.translations.core.account.settings.messages_success_settings_saved_successfully)
                    }
                    this.url.go(this.url.lesli(''))
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        showSkipModal(event){
            if(event){
                event.preventDefault()
            }

            this.$buefy.dialog.confirm({
                title: this.translations.core.onboardings.view_text_skip_onboarding_title,
                message: this.translations.core.onboardings.view_text_skip_onboarding_body,
                cancelText: this.translations.core.shared.view_btn_cancel,
                confirmText: this.translations.core.shared.view_btn_accept,
                type: 'is-warning',
                onConfirm: () => {
                    this.finishConfiguration(true)
                }
            })

        }
    }

}
</script>
<template>
    <section class="application-component">
        <div class="container">
            <figure>
                <a href="/">
                    <img class="app-logo" :src="logo" alt="App logo">
                </a>
            </figure>
            <b-steps type="is-info" icon-pack="fas" >
                <b-step-item clickable icon="building">
                    <component-form-basic-information></component-form-basic-information>
                </b-step-item>
                <b-step-item clickable icon="phone">
                    <component-form-contact-information></component-form-contact-information>
                </b-step-item>
                <b-step-item clickable icon="envelope">
                    <component-form-public-information></component-form-public-information>
                </b-step-item>
                <b-step-item clickable icon="clock">
                    <component-form-datetime-formats></component-form-datetime-formats>
                </b-step-item>
                <b-step-item clickable icon="smile-beam">
                    <div class="card">
                        <div class="card-header">
                            <h3>{{ translations.core.onboardings.view_text_welcome }}</h3>
                        </div>
                        <div class="card-content">
                            <form @submit.prevent="finishConfiguration()">
                                <div class="has-text-centered">
                                    <button class="button is-primary">
                                        <span>
                                            {{ translations.core.onboardings.view_btn_finish_configuration }}
                                        </span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </b-step-item>
                <a href="#" @click="showSkipModal"> <small>{{translations.core.onboardings.view_text_skip_process}}</small></a>
            </b-steps>
        </div>
    </section>
</template>
