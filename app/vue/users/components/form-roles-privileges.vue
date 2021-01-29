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


// · 
export default {
    data() {
        return {
            translations: {
                users: I18n.t("core.users"),
                roles: I18n.t("core.roles"),
                shared: I18n.t("core.shared")
            },
            role_selected: {},
            user: {}
        }
    },

    methods: {

        putUserRole() {
            setTimeout(() => {
                this.http.post(`/administration/users/${this.data.user.id}/roles.json`, {
                    user_role: {
                        id: this.role_selected.id
                    }
                }).then(result => {
                    if (!result.successful) {
                        this.alert(result.error.message, "danger")
                        return 
                    }
                    this.data.user.roles = result.data
                    this.role_selected = {}
                    this.alert(this.translations.users.messages_success_user_updated, "success")
                })
            }, 500)
        },

        deleteUserRole(id) {
            this.http.delete(`/administration/users/${this.data.user.id}/roles/${id}.json`).then(result => {
                this.data.user.roles = result.data
            })
        }

    }

}
</script>

<template>
    <div class="card">
        <div class="card-content" style="min-height: 400px;">
            <div class="columns">
                <div class="column is-4">

                    <form v-on:submit.prevent="putUserRole">
                        <div class="field">
                            <label class="label"> {{ translations.users.view_text_assing_role }} </label>
                            <div class="control has-icons-left">
                                <div class="select">
                                    <select v-model="role_selected">
                                        <option v-for="role in data.options.roles" :key="role.id" :value="role">
                                            {{object_utils.translateEnum(translations.roles, 'column_enum_role', role.name)}} 
                                        </option>
                                    </select>
                                </div>
                                <div class="icon is-small is-left">
                                    <i class="fas fa-key"></i>
                                </div>
                            </div>
                        </div>

                        <div class="field">
                            <div class="control">
                                <button class="button is-info"> {{ translations.shared.view_btn_save }}</button>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="column">

                    <div class="field">
                        <label class="label"> {{ translations.users.view_text_roles_assigned }}</label>
                        <div class="control mb-4" v-for="role in data.user.roles" :key="role.id">
                            <b-tag
                                attached
                                closable
                                type="is-info"
                                size="is-medium"
                                close-type="is-info"
                                aria-close-label="Close tag"
                                @close="deleteUserRole(role.id)">
                                
                                {{object_utils.translateEnum(translations.roles, 'column_enum_role', role.name)}} 
                            </b-tag>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</template>
