<script>
/*
Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   diego-alay
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Allows the user to either view, or edit a Users and save it in the 
    database using HTTP. This component is intended to be used in conjunction with the main apps:
    *new*, *show* and *edit*

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/

export default {

    components: {

    },
    
    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    data() {
        return {
            translations: {
                users: I18n.t('deutscheleibrenten.users'),
                core: {
                    users: I18n.t('core.users'),
                    shared: I18n.t('core.shared')
                }
            },
            user: {
                roles_id: null,
                detail_attributes: {}
            },
            options: {roles:[]}
        }
    },

    watch: {
        "store.data.user": function(user) {
            this.user = user
        },
        "store.data.options": function(data) {
            this.options = data
        }
    },

    methods: {
        submitUser(event){
            if (event) { event.preventDefault() }

            console.log(JSON.parse(JSON.stringify(this.user)))

            if (this.user.id) {
                this.putUser()
            } else {
                this.postUser()
            }
        },
        
        postUser() {
            let url = `/users.json`

            let data = {
                user: {
                    ...this.user,
                    active: true
                }
            }

            this.http.post(url, data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.users.notification_user_created, 'success')
                    //this.url.go('/users')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            }) 
        },

        putUser() {
            let url = `/lock/users/${this.user.id}.json`
            let data = {
                user: this.user
            }
            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.users.notification_user_updated, 'success')
                }else{
                    this.alert(result.error.message,'danger')
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
                            <label class="label">{{ translations.core.shared.text_email }}</label>
                            <div class="control">
                                <input required v-model="user.email" class="input" type="email">
                            </div>
                        </div>

                        <!-- Roles  -->
                        <div class="field">
                            <label class="label">{{ translations.core.shared.text_role }}</label>
                            <div class="control">
                                <b-select 
                                    :placeholder="translations.core.shared.text_role"
                                    v-model="user.roles_id">
                                    <option
                                        v-for="role in options.roles"
                                        :value="role.value"
                                        :key="role.value">
                                        {{ object_utils.translateEnum(translations.core.users, 'enum_role', role.text) }}
                                    </option>
                                </b-select>
                            </div>
                        </div>
                    </div>

                    <div class="column is-half">

                        <!-- Salutation  -->
                        <div class="field">
                            <label class="label">{{ translations.core.shared.text_salutation }}</label>
                            <b-radio
                                v-for="option in options.salutations"
                                :key="option.value"
                                v-model="user.detail_attributes.salutation"
                                type="is-info"
                                :native-value="option.value"
                            >
                            {{ translations.core.shared[`salutation_${option.text}`] }}
                            </b-radio>
                            
                        </div>

                        <!-- First name -->
                        <div class="field">
                            <label class="label">{{ translations.core.shared.text_first_name }}</label>
                            <div class="control">
                                <input required v-model="user.detail_attributes.first_name" class="input" type="text">
                            </div>
                        </div>

                        <!-- Last name -->
                        <div class="field">
                            <label class="label">{{ translations.core.shared.text_last_name }}</label>
                            <div class="control">
                                <input required v-model="user.detail_attributes.last_name" class="input">
                            </div>
                        </div>

                        <!-- Title -->
                        <div class="field">
                            <label class="label">{{ translations.core.shared.text_title }}</label>
                            <div class="control">
                                <input v-model="user.detail_attributes.title" class="input">
                            </div>
                        </div>
        
                        <!-- phone -->
                        <div class="field">
                            <label class="label">{{ translations.core.shared.text_telephone }}</label>
                            <div class="control">
                                <input v-model="user.detail_attributes.telephone" class="input">
                            </div>
                        </div>
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary">{{ translations.core.shared.btn_save }}</button>
                </p>
            </form>
        </div>
    </div>
</template>
