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
        appMountPath: {
            required: true
        },
        role: {
            type: Object,
            required: true
        }
    },

    components: {

    },

    mounted(){
        this.getRoles()
    },

    data(){
        return {
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    roles: I18n.t('core.roles')
                }
            },
            submitting_form: false,
            roles: []
        }
    },

    methods: {
        handleSubmit(event){
            if (event) { event.preventDefault() }

            if(this.role.id){
                this.putRole()
            } else {
                this.postRole()
            }
        },

        getRoles() {
            const url = this.url.admin('roles/list').filters({
                object_level_permission: this.role.object_level_permission
            })

            this.http.get(url).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                } else {
                    this.roles = result.data.map(e => e.name)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postRole() {
            let form_data = {
                role: this.role
            }

            const url = this.url.admin('roles')

            this.submitting_form = true
            this.msg.info(this.translations.core.roles.messages_info_waiting_role_creation)

            this.http.post(url, form_data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.core.roles.messages_success_created)
                    this.$router.push(`${this.appMountPath}/${result.data.id}/edit`)

                    this.submitting_form = false
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putRole() {
            let form_data = {
                role: this.role
            }

            const url = this.url.admin('roles/:id', {id: this.role.id})

            this.http.put(url, form_data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.core.roles.messages_success_updated)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
    },

    watch: {
        'role.object_level_permission'(){
            this.getRoles()
        }
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
                    <router-link class="button" :to="appMountPath">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.roles.view_btn_roles_list }}</span>
                    </router-link>
                    <b-button v-if="role.id" class="button" @click.stop="$set(data, 'view_type', 'logs')">
                        <b-icon icon="history" size="is-small" />
                        <span>{{ translations.core.roles.view_btn_logs }}</span>
                    </b-button>
                    <b-button v-if="role.id" class="button" @click.stop="$set(data, 'view_type', 'simple')">
                        <b-icon icon="cogs" size="is-small" />
                        <span>{{ translations.core.roles.view_btn_edit_privilege_actions }}</span>
                    </b-button>
                </div>
            </template>
        </component-header>
        <div class="card">
            <div class="card-content">
                <form @submit.prevent="handleSubmit">
                    <fieldset :disabled="submitting_form">
                        <div class="field">
                            <label class="label">
                                {{ translations.core.roles.column_name }}
                                <sup class="has-text-danger">*</sup>
                            </label>
                            <div v-if="!role.id">
                                <input
                                    v-model="role.name"
                                    class="input"
                                    type="text"
                                    required
                                >
                            </div>
                            <div v-else class="control">
                                <input
                                    :value="object_utils.translateEnum(translations.core.roles, 'column_enum_role', role.name)"
                                    class="input"
                                    type="text"
                                    required
                                    :readonly="role.id"
                                >
                            </div>
                        </div>

                        <div class="field">
                            <label class="label">{{ translations.core.roles.column_default_path }}</label>
                            <div class="control">
                                <input v-model="role.default_path" class="input" type="text" :placeholder="translations.core.roles.view_placeholder_default_path_at_login">
                            </div>
                        </div>

                        <div class="columns">
                            <div class="column is-10">
                                <b-field :message="translations.core.roles.view_text_object_level_permission_description">
                                    <template v-slot:label>
                                        {{ translations.core.roles.view_text_object_level_permission }}
                                        <sup class="has-text-danger">*</sup>
                                    </template>
                                    <b-select v-model="role.object_level_permission" expanded required>
                                        <option :value="10">{{translations.core.roles.view_text_object_level_permission_10_description}}</option>
                                        <option :value="1000">{{translations.core.roles.view_text_object_level_permission_1000_description}}</option>
                                        <option :value="10000">{{translations.core.roles.view_text_object_level_permission_10000_description}}</option>
                                        <option :disabled="role.name != 'owner'" :value="2147483647"> {{translations.core.roles.view_text_object_level_permission_max_description}}</option>
                                    </b-select>
                                </b-field>

                                <template>
                                    <b-taglist>
                                        <b-tag v-for="role in roles" :key="role.id">
                                            {{  object_utils.translateEnum(translations.core.roles, 'column_enum_role', role) }}
                                        </b-tag>
                                    </b-taglist>
                                </template>
                            </div>

                            <div class="column is-2">
                                <div class="field">
                                    <label class="label">{{ translations.core.roles.view_text_active }}</label>
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
                                    {{translations.core.shared.view_btn_saving}}
                                </span>
                                <span v-else>
                                    <b-icon icon="save" size="is-small" />
                                    &nbsp;
                                    {{translations.core.shared.view_btn_save}}
                                </span>
                            </button>
                        </p>
                    </fieldset>
                </form>
            </div>
        </div>
    </section>
</template>
