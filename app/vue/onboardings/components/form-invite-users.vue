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

export default {

    components: {},

    data() {
        return {
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    roles: I18n.t("core.roles"),
                    shared: I18n.t("core.shared"),
                    accounts: I18n.t("core.accounts"),
                    onboardings: I18n.t("core.onboardings"),
                }
            },
            invite: {
                email: null,
                detail_attributes: {
                    first_name: null,
                    last_name: null,
                    telephone: null
                },
            },
            invitedUsers: [],
            submittingForm: false,
        }
    },

    watch: {
    },

    methods: {
        postInvite() {
            this.submittingForm = true
            this.http.post(this.url.to("onboarding/invite"), {
                invite: this.invite
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.info(this.translations.core.onboardings.messages_success_invitation_request_sent_successfully)
                this.invitedUsers.push(result.data)
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.submittingForm = false
                this.invite.email = null
                this.invite.detail_attributes = {
                    first_name: null,
                    last_name: null,
                    telephone: null
                }
            })
        }
    }

}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <p class="card-header-title">
                {{ translations.core.onboardings.view_title_invite_users }}
            </p>
        </div>
        <div class="card-content">
            <div v-if="invitedUsers.length > 0">
                <h1>{{ translations.core.onboardings.view_text_invited_users }}</h1>
                <ul>
                    <li v-bind:key="invitedUser.email" v-for="invitedUser in invitedUsers">
                        <label class="label">{{ invitedUser.email }}</label>
                    </li>
                </ul>
            </div>
            <br />
            <br />
            <form @submit.prevent="postInvite()">
                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            {{ translations.core.onboardings.view_text_email }}
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="email" v-model="invite.email" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            {{ translations.core.onboardings.view_text_first_name }}
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="first-name" v-model="invite.detail_attributes.first_name"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            {{ translations.core.onboardings.view_text_last_name }}
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="last-name" v-model="invite.detail_attributes.last_name"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            {{ translations.core.onboardings.view_text_telephone }}
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="telephone" v-model="invite.detail_attributes.telephone"></b-input>
                    </div>
                </div>

                <div class="field has-text-centered">
                    <div class="control">
                        <button class="button is-primary">
                            <span v-if="submittingForm">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                &nbsp;
                                {{ translations.core.shared.view_btn_saving }}
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small" />
                                &nbsp;
                                {{ translations.core.shared.view_btn_save }}
                            </span>
                        </button>
                    </div>
                </div>

            </form>
        </div>
    </div>
</template>
<style scoped>
.has-text-centered {
    text-align: center;
}
</style>
