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
            user: {}
        }
    },
    methods: {

        putUserActive() {
            setTimeout(() => {
                this.http.put(`/administration/users/${this.data.user.id}.json`, {
                    user: {
                        active: this.data.user.active
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
        <div class="card-content">

            <form v-if="lesli.current_user.id !=  data.user.id">
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">{{ translations.users.view_text_access_status }}</label>
                    </div>
                    <div class="field-body">
                        <div class="field is-narrow">
                            <div class="control">
                                <div class="select is-fullwidth">
                                    <select 
                                        @input="putUserActive()"
                                        v-model="data.user.active">
                                        <option :value="true">{{ translations.shared.view_text_active }}</option>
                                        <option :value="false">{{ translations.shared.view_text_inactive }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

        </div>
    </div>
</template>
