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

    components: {

    },
    
    // @return [Object] Data used by this component"s methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    data() {
        return {
            translations: {
                users: I18n.t("core.users"),
                shared: I18n.t("core.shared")
            },
            user: {
                roles_id: null,
                detail_attributes: {}
            },
            options: {roles:[]}
        }
    },

    watch: {
        "data.user": function(user) {
            this.user = user
        },
        "data.options": function(data) {
            this.options = data
        }
    },

    methods: {
        submitUser(event){
            if (event) { event.preventDefault() }
            if (this.user.id) {
                this.putUser()
            } else {
                this.postUser()
            }
        },
        
        postUser() {
            let url = `/administration/users.json`

            let data = {
                user: {
                    ...this.user,
                    active: true
                }
            }

            this.http.post(url, data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.users.notification_user_created, "success")
                    this.url.go("/administration/users")
                }else{
                    this.alert(result.error.message,"danger")
                }
            }).catch(error => {
                console.log(error)
            }) 
        },

        putUser() {
            let url = `/administration/users/${this.user.id}.json`
            let data = {
                user: this.user
            }
            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.users.notification_user_updated, "success")
                }else{
                    this.alert(result.error.message,"danger")
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }

}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <form @submit.prevent="submitUser">
                <div class="columns">
                    <div class="column is-half">

                        <!-- Email -->
                        <div class="field">
                            <label class="label">{{ translations.users.view_table_header_email }}</label>
                            <div class="control">
                                <input required v-model="user.email" name="user_email" class="input" type="email">
                            </div>
                        </div>

                        <!-- Roles  -->
                        <div class="field">
                            <label class="label">{{ translations.users.view_text_role }}</label>
                            <div class="control">
                                <b-select 
                                    name="user_role"
                                    :placeholder="translations.shared.text_role"
                                    v-model="user.roles_id">
                                    <option
                                        v-for="role in options.roles"
                                        :value="role.value"
                                        :key="role.value">
                                        {{ object_utils.translateEnum(translations.users, "enum_role", role.text) }}
                                    </option>
                                </b-select>
                            </div>
                        </div>
                    </div>

                    <div class="column is-half">

                        <!-- Salutation  -->
                        <div class="field">
                            <label class="label">{{ translations.shared.view_text_salutation }}</label>
                            <b-radio
                                v-for="option in options.salutations"
                                :key="option.value"
                                v-model="user.detail_attributes.salutation"
                                type="is-info"
                                :native-value="option.value">
                                {{ translations.shared[`column_enum_salutation_${option.text}`] }}
                            </b-radio>
                            
                        </div>

                        <!-- First name -->
                        <div class="field">
                            <label class="label">{{ translations.shared.view_text_first_name }}</label>
                            <div class="control">
                                <input required v-model="user.detail_attributes.first_name" name="user_first_name" class="input" type="text">
                            </div>
                        </div>

                        <!-- Last name -->
                        <div class="field">
                            <label class="label">{{ translations.shared.view_text_last_name }}</label>
                            <div class="control">
                                <input required v-model="user.detail_attributes.last_name" name="user_last_name" class="input">
                            </div>
                        </div>

                        <!-- Title -->
                        <div class="field">
                            <label class="label">{{ translations.users.view_text_title }}</label>
                            <div class="control">
                                <input v-model="user.detail_attributes.title" class="input">
                            </div>
                        </div>
        
                        <!-- phone -->
                        <div class="field">
                            <label class="label">{{ translations.shared.view_text_telephone }}</label>
                            <div class="control">
                                <input v-model="user.detail_attributes.telephone" class="input">
                            </div>
                        </div>
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary">{{ translations.shared.view_btn_save }}</button>
                </p>
            </form>
        </div>
    </div>
</template>
