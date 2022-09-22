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
                shared: I18n.t("core.shared")
            },
            options: {},
            user: {
                detail_attributes: {}
            }
        }
    },
    methods: {
        putUser() {
            this.http.put(`/administration/users/${this.user.id}.json`, {
                user: this.user
            }).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.users.messages_success_user_updated)
                }else{
                    this.msg.error(result.error.message)
                }
            })
        }
    },
    watch: {
        "data.user": function(user) {
            this.user = user
        },
        "data.options": function(data) {
            this.options = data
        }
    }
}
</script>

<template>
    <div class="card">
        <div class="card-content">
            <form @submit.prevent="putUser()">
                <fieldset>
                    <div class="columns">
                        <div class="column is-half">
                            <div class="field">
                                <label class="label">
                                    {{ translations.shared.view_text_salutation }}
                                </label>
                                <b-radio
                                    v-for="option in options.salutations"
                                    :key="option.value"
                                    v-model="user.detail_attributes.salutation"
                                    type="is-info"
                                    :native-value="option.value">
                                    {{ translations.shared[`column_enum_salutation_${option.text}`] }}
                                </b-radio>
                            </div>
                            <div class="field">
                                <label class="label"> {{ translations.shared.view_text_first_name}} </label>
                                <div class="control">
                                    <input v-model="user.detail_attributes.first_name" required="required" type="text" class="input">
                                </div>
                            </div>
                            <div class="field">
                                <label class="label"> {{ translations.shared.view_text_last_name }} </label>
                                <div class="control">
                                    <input v-model="user.detail_attributes.last_name" required="required" class="input">
                                </div>
                            </div>
                            <div class="field">
                                <label class="label"> {{ translations.shared.view_text_alias }} </label>
                                <div class="control">
                                    <input v-model="user.alias" class="input">
                                </div>
                            </div>
                            <div class="field">
                                <label class="label"> {{ translations.users.view_text_title }} </label>
                                <div class="control">
                                    <input v-model="user.detail_attributes.title" class="input">
                                </div>
                            </div>
                            <div class="field">
                                <label class="label"> {{ translations.shared.view_text_telephone }} </label>
                                <div class="control">
                                    <input v-model="user.detail_attributes.telephone" class="input">
                                </div>
                            </div>
                            <p class="control">
                                <button class="button is-primary">{{ translations.shared.view_btn_save }}</button>
                            </p>
                        </div>
                        <div class="column is-half">
                            <div v-if="options.regions && options.regions.length > 0" class="field">
                                <label class="label"> {{ translations.users.column_work_region }} </label>
                                <div class="control">
                                    <div :class="['select is-fullwidth', {'is-empty': user.detail_attributes.work_region == null}]">
                                        <select v-model="user.detail_attributes.work_region">
                                            <option :disabled="true" :value="null" :hidden="true">
                                                {{translations.shared.view_placeholder_select_option}}
                                            </option>
                                            <option v-for="region in options.regions" :key="region.name" :value="region.id">
                                                {{region.name}}
                                            </option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div>
    </div>
</template>
