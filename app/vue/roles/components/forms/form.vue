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
        view_type: {
            type: String,
            required: true
        },
        role: {
            type: Object,
            required: true
        }
    },

    components: {

    },

    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable settings [Object] An object representing a Settings, with
    //      the same params as the associated rails model
    data(){
        return {
            translations: {
                shared: I18n.t('deutscheleibrenten.shared'),
                roles: I18n.t('deutscheleibrenten.roles'),
                core_roles: I18n.t('core.roles')
            },
            main_route: '/administration/roles',
            submitting_form: false,
        }
    },

    methods: {
        handleSubmit(event){
            if (event) { event.preventDefault() }

            if(this.view_type == 'new'){
                this.postRole()
            }else if(this.view_type == 'edit'){
                this.putRole()
            }
        },

        postRole() {
            let form_data = {
                role: this.role
            }
            let url = `${this.main_route}`

            this.submitting_form = true
            this.alert(this.translations.roles.notification_wait_role_creation, 'info')
            this.http.post(url, form_data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.roles.notification_created, 'success')
                    this.$router.push(`${result.data.id}/edit`)

                    this.submitting_form = false
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }, 

        putRole() {
            let form_data = {
                role: this.role
            }
            let url = `${this.main_route}/${this.role.id}.json`

            this.http.put(url, form_data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.roles.notification_updated, 'success')
                }else{
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
    }
}
</script>
<template>
    <section>
        <component-header
            :buttons="false"
        >
            <template slot="">
                <div class="buttons">
                    <router-link class="button" to="/">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.shared.btn_list }}</span>
                    </router-link>
                    <router-link v-if="role.id" class="button" :to="'/' + role.id">
                        <b-icon icon="eye" size="is-small" />
                        <span>{{ translations.shared.btn_show }}</span>
                    </router-link>
                </div>
            </template>
        </component-header>
        <div class="card">
            <div class="card-content">
                <form @submit.prevent="handleSubmit">
                    <fieldset :disabled="submitting_form">
                        <div class="field">
                            <label class="label">
                                {{ translations.shared.text_name }}
                                <sup class="has-text-danger">*</sup>
                            </label>
                            <div class="control">
                                <input
                                    :value="object_utils.translateEnum(translations.core_roles, 'column_enum_role', role.name)"
                                    class="input"
                                    type="text"
                                    required
                                    :readonly="view_type != 'new'"
                                >
                            </div>
                        </div>

                        <div class="columns">
                            <div class="column is-10">
                                <b-field :message="translations.roles.view_text_column_object_level_permission_description">
                                    <template v-slot:label>
                                        {{ translations.roles.text_object_level_permission }}
                                        <sup class="has-text-danger">*</sup>
                                    </template>
                                    <b-select v-model="role.object_level_permission" expanded required>
                                        <option :value="10">{{translations.roles.view_text_object_level_permission_10_description}}</option>
                                        <option :value="1000">{{translations.roles.view_text_object_level_permission_1000_description}}</option>
                                        <option :hidden="role.name != 'owner'" :disabled="role.name != 'owner'" :value="2147483647">
                                            {{translations.roles.view_text_object_level_permission_max_description}}
                                        </option>
                                    </b-select>
                                </b-field>
                            </div>
                            <div class="column is-2">
                                <div class="field">
                                    <label class="label">{{ translations.shared.text_active }}</label>
                                    <div class="control">
                                        <b-checkbox v-model="role.active"></b-checkbox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Submitt -->
                        <p class="control">
                            <button class="button is-primary">
                                <span v-if="submitting_form">
                                    <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                    &nbsp;
                                    {{translations.shared.btn_saving}}
                                </span>
                                <span v-else>
                                    <b-icon icon="save" size="is-small" />
                                    &nbsp;
                                    {{translations.shared.btn_save}}
                                </span>
                            </button>
                        </p>
                    </fieldset>
                </form>
            </div>
        </div>
    </section>
</template>
