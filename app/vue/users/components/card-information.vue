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
    props: {
        actions: {
            default: true
        }
    },
    data() {
        return {
            translations: {
                users: I18n.t("core.users"),
                shared: I18n.t("core.shared")
            },
            user: {
                detail_attributes: {}
            }
        }
    },
    methods: {

        initials() {
            let initials = ""
            if (this.user.detail_attributes.first_name) {
                initials += this.user.detail_attributes.first_name[0]
            }
            if (this.user.detail_attributes.last_name) {
                initials += this.user.detail_attributes.last_name[0]
            }
            return initials
        },

        doRequestPasswordChange() {
            this.http.post(`/administration/users/${this.user.id}/resources/password`).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.success(this.translations.users.messages_success_user_updated)
            }).catch(error => {
                console.log(error)
            })
        },

        doUserLogout() {
            this.http.post(this.url.admin("/users/:user_id/resources/logout", {
                user_id: this.user.id
            })).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.alert("All the sessions of the user were delted successfully")
            }).catch(error => {
                console.log(error)
            })
        },

        doRevokeAccess() {
            this.http.post(`/administration/users/${this.user.id}/resources/lock`).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.success(this.translations.users.messages_success_user_updated)
            }).catch(error => {
                console.log(error)
            })
        },

        confirmUserDeletion() {
            window.scrollTo(0,0)
            this.$buefy.dialog.confirm({
                title: "Delete user?",
                message: "Once deleted, you will not be able to recover this user.",
                confirmText: "Yes, delete it",
                cancelText: "Cancel",
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteUser()
            })
        },

        deleteUser() {
            this.http.delete(this.url.admin("/users/:user_id", {
                user_id: this.user.id
            })).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                } else {
                    this.msg.success(this.translations.users.messages_success_user_updated)
                    this.url.go(this.url.admin("users"))
                }
            }).catch(error => {
                console.log(error)
            })
        }

    },
    watch: {
        "data.user": function(user) {
            this.user = user
        }
    }
}
</script>
<template>
    <div class="box profile-card-information">
        <div class="media" v-if="user">
            <div class="media-left">
                <figure class="image is-128x128">
                    <span class="alternative-avatar">
                        {{ initials() }}
                    </span>
                </figure>
            </div>
            <div class="media-content">
                <div class="content mb-0">
                    <p>
                        <strong if="user.detail_attributes.salutation">
                            {{ object_utils.translateEnum(translations.shared, 'column_enum_salutation', user.detail_attributes.salutation ) }}
                        </strong>
                        <strong>{{ user.detail_attributes.first_name }}</strong>
                        <strong>{{ user.detail_attributes.last_name }}</strong>
                        <br>
                        {{ user.detail_attributes.title }}
                    </p>
                </div>
                <nav class="level is-mobile mb-0">
                    <div class="level-left">
                        <a  v-if="user.email"
                            :href="'mailto:'+user.email" class="level-item" aria-label="reply">
                            <span class="icon is-small mr-2">
                                <i class="fas fa-envelope" aria-hidden="true"></i>
                            </span>
                            {{ user.email }}
                        </a>
                        <a  v-if="user.detail_attributes.telephone"
                            :href="'tel:'+user.detail_attributes.telephone" class="level-item" aria-label="retweet">
                            <span class="icon is-small mr-2">
                                <i class="fas fa-phone-alt" aria-hidden="true"></i>
                            </span>
                            {{ user.detail_attributes.telephone }}
                        </a>
                    </div>
                </nav>
                <template v-if="actions">
                    <hr class="my-3">
                    <div class="buttons">
                        <button class="button is-white is-small" @click="doRequestPasswordChange()">
                            <span class="icon"><i class="fas fa-unlock-alt"></i></span>
                            <span> {{ translations.users.view_btn_request_password_change }}</span>
                        </button>

                        <button class="button is-white is-small" @click="doUserLogout()">
                            <span class="icon"><i class="fas fa-sign-out-alt"></i></span>
                            <span>  {{ translations.users.view_btn_force_logout }}</span>
                        </button>

                        <button class="button is-white is-small" @click="doRevokeAccess()">
                            <span class="icon"><i class="fas fa-user-lock"></i></span>
                            <span> {{ translations.users.view_btn_revoke_access }} </span>
                        </button>

                        <button class="button is-white is-small" @click="confirmUserDeletion()">
                            <span class="icon"><i class="fas fa-user-slash"></i></span>
                            <span> {{ "Delete User" }} </span>
                        </button>
                    </div>
                </template>
            </div>
        </div>
    </div>
</template>
