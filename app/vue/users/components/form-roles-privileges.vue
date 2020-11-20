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
            user: {},
            roles: [],
            filteredRoles: []
        }
    },
    mounted() {
        this.getRoles()
    },
    methods: {

        doFilterRoles(text) {
            this.filteredRoles = this.roles.filter((option) => {
                return option.name
                    .toString()
                    .toLowerCase()
                    .indexOf(text.toLowerCase()) >= 0
            })
        },

        getRoles() {
            this.http.get("/administration/roles.json").then(result => {
                this.roles = result.data
            })
        },

        putUserRole() {
            setTimeout(() => {
                this.http.put(`/administration/users/${this.data.user.id}.json`, {
                    user: {
                        roles_id: this.data.user.roles_id
                    }
                }).then(result => {
                    if (!result.successful) {
                        this.alert(result.error.message, "danger")
                        return 
                    }
                    this.alert(this.translations.users.messages_success_user_updated, "success")
                })
            }, 500)
        }
        
    }
}
</script>

<template>
    <div class="card">
        <div class="card-content" style="min-height: 400px;">

            <b-field label="User roles">
                <b-taginput
                    attached
                    autocomplete
                    field="name"
                    type="is-info"
                    size="is-medium"
                    icon="fas fa-key"
                    v-model="user.roles"
                    :placeholder="'Assign a new role to user'"
                    :data="filteredRoles"
                    :allow-new="false"
                    :open-on-focus="true"
                    @add="doFilterRoles('')"
                    @typing="doFilterRoles">
                </b-taginput>
            </b-field>

        </div>
    </div>
</template>
