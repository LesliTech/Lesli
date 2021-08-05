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
import componentFormPasswordFormats from "../components/form-password-formats.vue"
import componentFormInviteUsers from "../components/form-invite-users.vue"


export default {

    components: {
        'component-form-basic-information': componentFormBasicInformation,
        'component-form-contact-information': componentFormContactInformation,
        'component-form-public-information': componentFormPublicInformation,
        'component-form-datetime-formats': componentFormDatetimeFormats,
        'component-form-password-formats': componentFormPasswordFormats,
        'component-form-invite-users': componentFormInviteUsers,
    },

    data() {
        return {
            settings: {
                "password_enforce_complexity": null,
                "password_minimum_length": null,
                "password_expiration_time_days": null,
                "password_special_char_count": null,
                "password_uppercase_count": null,
                "password_lowercase_count": null,
                "password_digit_count": null,
                "datetime_time_zone": null,
                "datetime_start_week_on": null,
                "datetime_format_date": null,
                "datetime_format_time": null,
                "datetime_format_date_time": null,
                "datetime_format_date_words": null,
                "datetime_format_date_time_words": null,
            }
        }
    },

    methods: {
        getAccountData() {
            this.http.get(this.url.admin("onboarding")).then(result => {
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

        finishConfiguration() {
            this.url.go(this.url.admin("/"))
        }
    },

    mounted() {
        this.getAccountData()
    }

}
</script>
<template>
    <section class="application-component">

        <br />
        <br />
        <b-steps type="is-info" icon-pack="fas">
            <b-step-item icon="building">
                <component-form-basic-information></component-form-basic-information>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-contact-information></component-form-contact-information>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-public-information></component-form-public-information>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-datetime-formats></component-form-datetime-formats>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-password-formats></component-form-password-formats>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-invite-users></component-form-invite-users>
            </b-step-item>
            <b-step-item icon="account-key">
                <div class="card">
                    <div class="card-content">
                        <form @submit.prevent="finishConfiguration()">
                            <div class="welcome-title centered">
                                <h1><strong>Welcome</strong></h1>
                            </div>

                            <br />
                            <div class="centered">
                                <button class="button is-primary">
                                    <span>
                                        {{ "Finish Configuration" }}
                                    </span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </b-step-item>
        </b-steps>

    </section>
</template>
<style scoped>
.welcome-title {
    font-size: 4rem;
}
.centered {
    text-align: center;
}
</style>
