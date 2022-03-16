<script>
/*
Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

TODO:
- Add "disbled class" to the owner level
*/
export default {
    props: {
        appMountPath: {
            required: true
        },
        edit: {
            default: true
        },
        role: {
            type: Object,
            default() {
                return {
                    name: "",
                    active: true,
                    default_path: "",
                    only_my_data: false,
                    object_level_permission: 10
                }
            }
        }
    },
    data() {
        return {
            roles: [],
            options: [],
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    roles: I18n.t('core.roles')
                }
            },
            submitting_form: false
        }
    },
    mounted() {
        this.getRoles()
    },
    methods: {

        setObjectLevelPermission(level) {
            this.role.object_level_permission = level
        },
        submit() {
            if (this.role.id) {
                this.putRole()
            } else {
                this.postRole()
            }
        },
        putRole() {
            this.submitting_form = true
            this.http.put(this.url.admin("roles/:id", { id: this.role.id }), {
                role: this.role
            }).then(result => {
                this.submitting_form = false
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.success(this.translations.core.roles.messages_success_role_successfully_updated)
            })
        },
        postRole() {
            this.submitting_form = true
            this.http.post(this.url.admin("roles"), {
                role: this.role
            }).then(result => {
                this.submitting_form = false
                if (!result.successful) {
                    this.msg.warn(result.error.message)
                    return
                }
                this.msg.success(this.translations.core.roles.messages_success_role_created_successfully)

                this.$router.push(`${this.appMountPath}/${result.data.id}`)
            })
        },
        getRoles() {

            this.http.get(this.url.admin("roles/options")).then(result => {
                this.options = result.data
            })

            this.http.get(this.url.admin("roles/list")).then(result => {
                result.data.forEach((role, index) => {
                    this.roles.push({
                        id: role.id,
                        name: role.name,
                        object_level_permission: role.object_level_permission
                    })
                    if (index < result.data.length - 1) {
                        let next_olp = result.data[index + 1].object_level_permission
                        let level = (role.object_level_permission + next_olp) / 2
                        if (role.object_level_permission == level) {
                            return
                        }
                        this.roles.push({
                            id: 0,
                            name: "- - -",
                            object_level_permission: level
                        })
                    }
                })
            })

        },

        getTitle(){
            if (!this.role.id) return this.translations.core.roles.view_text_new_role

            return this.role.name
        },

        isSelected(level) {
            return level === this.role.object_level_permission
        }

    }

}
</script>
<template>
    <section>
        <component-header :title="getTitle()">
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
        </component-header>

        <div class="box">
            <form @submit.prevent="submit">
                <fieldset :disabled="!edit||submitting_form">

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
                                    :disabled="role.id"
                                >
                            </div>
                    </div>

                    <div class="field">
                        <label class="label">{{ translations.core.roles.column_default_path }}</label>
                        <div class="control">
                            <input v-model="role.default_path" class="input" type="text" :placeholder="translations.core.roles.view_placeholder_default_path_at_login">
                        </div>
                            <p class="help"> {{ translations.core.roles.view_text_default_path_description }}</p>
                    </div>

                    <hr>

                    <div class="field">
                        <label class="label">
                            {{ translations.core.roles.view_text_hierarchical_level }}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <!--
                        <b-menu>
                            <b-menu-list>
                                <b-menu-item
                                    :active="isSelected(option.level)"
                                    :disabled="index == 0 ? true : false"
                                    @click="setObjectLevelPermission(option.level)"
                                    :key="index"
                                    v-for="(option, index) in options.levels">
                                    <template #label="props">
                                        <span class="icon is-small">
                                            <i :class="['fas',
                                                {'fa-chevron-right': !props.expanded},
                                                {'fa-check': props.expanded}
                                            ]"></i>
                                        </span>
                                        {{ `${translations.core.roles.view_text_level||''} ${index + 1}` }}
                                        {{ (isSelected(option.level)||props.expanded)? `- ${translations.core.roles.view_text_selected||''}` :  `(${option.roles.length||0})` }}
                                    </template>
                                    <b-menu-item
                                        disabled
                                        :label="object_utils.translateEnum(translations.core.roles, 'column_enum_role', role.name)"
                                        :value="index"
                                        :key="role.id"
                                        v-for="role in option.roles">
                                    </b-menu-item>
                                </b-menu-item>
                            </b-menu-list>
                        </b-menu>
                        -->
                        <ul class="hierarchical_level_selector">
                            <li :class="{ 'has-background-info has-text-light' : isSelected(option.level) }"
                                v-for="(option, index) in options.levels" :key="index"
                                v-on:click="setObjectLevelPermission(option.level)">
                                <span class="icon is-medium">
                                    <i :class="['fas', isSelected(option.level) ? 'fa-check' : 'fa-chevron-right']"></i>
                                </span>
                                {{ `${translations.core.roles.view_text_level || 'Level' } ${ index + 1 }` }}
                                <span
                                    v-if="option.roles.length"
                                    :class="{ 'has-text-grey-light' : !isSelected(option.level) }">
                                    - {{ option.roles.map(role => role.name).join(', ') }}
                                </span>
                            </li>
                        </ul>
                    </div>

                    <hr>

                    <div class="field">
                        <label class="label">
                            {{ translations.core.roles.column_only_my_data }}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <div class="control">
                            <div class="select">
                                <b-select v-model="role.only_my_data">
                                    <option :value="true">{{ translations.core.roles.view_text_restrict_data_access }}</option>
                                    <option :value="false">{{ translations.core.roles.view_text_allow_to_see_all_the_data }}</option>
                                </b-select>
                            </div>
                        </div>
                    </div>

                    <div class="field">
                        <label class="label">
                            {{ translations.core.roles.view_text_status }}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <div class="control">
                            <div class="select">
                                <b-select v-model="role.active">
                                    <option :value="true">{{ translations.core.roles.view_text_active }}</option>
                                    <option :value="false">{{ translations.core.roles.view_text_disabled }}</option>
                                </b-select>
                            </div>
                        </div>
                    </div>

                    <div class="field mt-6">
                        <div class="control">
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
                        </div>
                    </div>
                </fieldset>
            </form>
        </div>
    </section>
</template>
