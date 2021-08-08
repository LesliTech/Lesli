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
                    object_level_permission: 10,
                }
            }
        }
    },
    data() {
        return {
            roles: [],
            options: {},
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    roles: I18n.t('core.roles'),
                }
            }
        }
    },
    mounted() {
        this.getRoles()
        this.role.active = true
        this.role.only_my_data = false
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
            this.http.put(this.url.admin("roles/:id", { id: this.role.id }), {
                role: this.role
            }).then(result => {
                if (!result.successful) {
                    this.msg.warn(result.error.message)
                    return
                }
                this.msg.success(this.translations.core.roles.messages_success_role_successfully_updated)
            })
        },
        postRole() {
            this.http.post(this.url.admin("roles"), {
                role: this.role
            }).then(result => {
                if (!result.successful) {
                    this.msg.warn(result.error.message)
                    return
                }
                this.msg.success(this.translations.core.roles.messages_success_role_created_successfully)
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

        }

    }

}
</script>
<template>
    <div class="box">
        <form @submit.prevent="submit">
            <fieldset :disabled="!edit">

                <div class="field">
                    <label class="label">
                        {{ translations.core.roles.column_name }}
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <div class="control">
                        <input v-model="role.name" class="input" type="text" required />
                    </div>
                </div>

                <div class="field">
                    <label class="label">{{ translations.core.roles.column_default_path }}</label>
                    <div class="control">
                        <input v-model="role.default_path" class="input" type="text" :placeholder="translations.core.roles.view_placeholder_default_path_at_login">
                    </div>
                     <p class="help">User will be redirected to this route always.</p>
                </div>

                <hr>

                <div class="field">
                    <label class="label">
                        {{ translations.core.roles.view_text_hierarchical_level }}
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <b-menu>
                        <b-menu-list>
                            <b-menu-item 
                                :disabled="index == 0 ? true : false"
                                @click="setObjectLevelPermission(level.level)"
                                :key="index" 
                                v-for="(level, index) in options.levels">
                                <template #label="props">
                                    <span class="icon is-small">
                                        <i :class="['fas', 
                                            {'fa-chevron-right': !props.expanded},
                                            {'fa-check': props.expanded}
                                        ]"></i>
                                    </span>
                                    {{ `Level ${index + 1}` }}
                                    {{ props.expanded ? '- selected' :  `(${level.roles.length})` }}
                                </template>
                                <b-menu-item 
                                    disabled 
                                    :label="role.name" 
                                    :value="index" 
                                    :key="role.id"
                                    v-for="role in level.roles">
                                </b-menu-item>
                            </b-menu-item>
                        </b-menu-list>
                    </b-menu>
                </div>

                <hr>

                <div class="field">
                    <label class="label">
                        {{ translations.core.roles.column_only_my_data }}
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <div class="control">
                        <div class="select">
                            <select v-model="role.only_my_data">
                                <option value="true">{{ translations.core.roles.view_text_restrict_data_access }}</option>
                                <option value="false">{{ translations.core.roles.view_text_allow_to_see_all_the_data }}</option>
                            </select>
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
                            <select v-model="role.active">
                                <option value="true">{{ translations.core.roles.view_text_active }}</option>
                                <option value="false">{{ translations.core.roles.view_text_disabled }}</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="field mt-6">
                    <div class="control">
                        <button class="button is-primary">
                            <span class="icon">
                                <i class="far fa-save"></i>
                            </span>
                            <span>{{ translations.core.shared.view_btn_save }}</span>
                        </button>
                    </div>
                </div>

            </fieldset>
        </form>
    </div>
</template>
