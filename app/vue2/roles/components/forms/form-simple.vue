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
            required: true
        }
    },
    data() {
        return {
            pagination: {
                tasks_count: 0,
                current_page: 1,
                per_page: 10,
                range_before: 3,
                range_after: 3
            },
            sort: {
                icon_size: 'is-small',
                direction: 'desc'
            },
            submitted_form: false,
            filters: {
                search: ''
            },
            requests: [],
            options: {},
            ready: false,
            translations: {
                core: {
                    descriptor_assignments: I18n.t('core.role/descriptor_assignments'),
                    role_descriptors: I18n.t('core.role_descriptors'),
                    shared: I18n.t('core.shared'),
                    roles: I18n.t('core.roles'),
                    core: I18n.t('core.shared')
                }
            },
        }
    },
    mounted() {
        this.getRoleDescriptors()
    },

    methods: {   
        getRoleDescriptors(){
            let url = this.url.admin(`roles/:role_id/descriptor_assignments`, {role_id: this.role.id})
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.getRoleDescriptorOptions(result.data)
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        getRoleDescriptorOptions(role_descriptors) {
            let url = this.url.admin(`roles/descriptor_assignments/options`)
            this.http.get(url).then(result => {
                if (result.successful) {
                    let descriptors = []
                    for(let descriptor of result.data.descriptors) {                        
                        for(let index in descriptor.actions) {
                            let role_descriptor = role_descriptors.find(e => 
                                e.role_descriptors_id === descriptor.id &&
                                e.category === index                                
                            )    
                            
                            if (role_descriptor){                                
                                descriptor.actions[index] = {
                                    ...descriptor.actions[index],
                                    status: true,
                                    role_descriptor_id: role_descriptor.id 
                                }
                            }
                        }
                        
                                            
                        if (descriptor.role_descriptors_id) {
                            let parent_index = descriptors.findIndex(e => 
                                e.id ===  descriptor.role_descriptors_id
                            )
                            
                            if (parent_index !== -1){
                                descriptors[parent_index]['subdescriptors'].push(descriptor)   
                            }
                        } else {
                            descriptors.push({
                                ...descriptor,
                                subdescriptors: []
                            })
                        }
                    }
                
                    
                    this.options = {
                        descriptors: descriptors,
                        categories: result.data.categories
                    }
                    
                    this.ready = true
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        handleSubmit(category, descriptor_privilege, event, descriptor_privilege_parent = null){            
            let value = event.target.checked
            
            if  (value) {
                this.postRolePrivilegeDescriptor(category, descriptor_privilege, descriptor_privilege_parent)
            } else {
                this.destroyRolePrivilegeDescriptor(category, descriptor_privilege) 
            }
        },
        
        postRolePrivilegeDescriptor(category, descriptor_privilege, descriptor_privilege_parent){            
            let data = {
                role_descriptor_assignment: {
                    role_descriptors_id: descriptor_privilege.id,
                    category: category   
                }
            }
            
            let url = this.url.admin('roles/:role_id/descriptor_assignments', {role_id: this.role.id})
            this.http.post(url, data).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                if (descriptor_privilege_parent) {
                    let parent_index = this.options.descriptors.findIndex(
                        e => e.id === descriptor_privilege_parent.id
                    )
                    
                    let index = this.options.descriptors[parent_index]['subdescriptors'].findIndex(
                        e => e.id === descriptor_privilege.id
                    )
                
                    this.$set(this.options.descriptors[parent_index]['subdescriptors'][index].actions[category], 'status', true)
                    this.$set(this.options.descriptors[parent_index]['subdescriptors'][index].actions[category], 'role_descriptor_id', result.data.id)    
                } else {
                    let index = this.options.descriptors.findIndex(
                        e => e.id === descriptor_privilege.id
                    )
                
                    this.$set(this.options.descriptors[index].actions[category], 'status', true)
                    this.$set(this.options.descriptors[index].actions[category], 'role_descriptor_id', result.data.id)
                }
                
                let message = descriptor_privilege.name 
                message += ':[' + this.object_utils.translateEnum(this.translations.core.role_descriptors, 'column_enum_category', category) + '] '
                message += this.translations.core.descriptor_assignments.messages_success_role_descriptor_added
                
                this.msg.success(message) 
            }).catch(error => {
                console.log(error)

            })
        },

        destroyRolePrivilegeDescriptor(category, descriptor_privilege){
            let url = this.url.admin('roles/:role_id/descriptor_assignments/:id', 
                {role_id: this.role.id, 
                id: descriptor_privilege.actions[category].role_descriptor_id
            })
            
            this.http.delete(url).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                let message = descriptor_privilege.name 
                message += ':[' + this.object_utils.translateEnum(this.translations.core.role_descriptors, 'column_enum_category', category) + '] '
                message += this.translations.core.descriptor_assignments.messages_success_role_descriptor_deleted
                
                this.msg.success(message) 
            }).catch(error => {
                console.log(error)

            })
        },
        
        searchRoles(text){
            this.filters.search = text
        },

        hasDetails(row){
            return (row.subdescriptors.length > 0)
        }
    },

    computed: {
        filteredRoles(){
            let search_field = this.filters.search.toLowerCase().trim()
            this.pagination.current_page = 1

            if (search_field.length > 0) {
                return this.options.descriptors.filter((role_ability)=>{
                    return (
                        role_ability.name.toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.options.descriptors
            }
        }
    }
}
</script>

<template>
    <section>
        <component-header
            :buttons="false"
            :title="translations.core.roles[`column_enum_role_${(role.name || '').toLowerCase()}`] || role.name"
        >
            <div class="buttons">
                <router-link class="button" :to="`${appMountPath}/`">
                    <b-icon icon="list" size="is-small" />
                    <span>{{ translations.core.roles.view_btn_roles_list }}</span>
                </router-link>
                <b-button class="button" @click.stop="$set(data, 'view_type', 'edit')">
                    <b-icon icon="edit" size="is-small" />
                    <span>{{ translations.core.roles.view_btn_edit_role_information }}</span>
                </b-button>
                <b-button class="button" @click.stop="$set(data, 'view_type', 'logs')">
                    <b-icon icon="history" size="is-small" />
                    <span>{{ translations.core.roles.view_btn_logs }}</span>
                </b-button>
            </div>
        </component-header>

        <component-toolbar
            :initialValue="filters.search"
            :search-text="translations.core.shared.view_toolbar_search_by_placeholder_search"
            @search="searchRoles"
            v-if="ready"    
        >
        </component-toolbar>

        <div class="card">
            <div class="card-content">
                <b-table
                    v-if="ready"
                    :data="filteredRoles"
                    :hoverable="true"
                    custom-detail-row
                    :has-detailed-visible="hasDetails"
                    detailed
                    detail-key="name"
                    focusable
                >
                    <template v-slot="props">
                        <b-table-column field="name" :label="translations.core.view_text_name" >
                            <strong> {{ translations.core.role_descriptors[`view_title_role_descriptor_${props.row.name}`]||props.row.name }} </strong>
                        </b-table-column>
                        
                        <b-table-column v-for="category in options.categories" :key="category" :field="category" :label="object_utils.translateEnum(translations.core.role_descriptors, 'column_enum_category', category)" >
                            <b-switch
                                :ref="props.row.name + '-' + category"
                                v-if="props.row.actions[category]['actions'].length > 0"
                                :value="props.row.actions[category]['status']"
                                @change.native="event => handleSubmit(category, props.row, event)"
                            />
                        </b-table-column>
                    </template>

                    <template slot="detail" slot-scope="props">
                        <tr v-for="subdescriptor in props.row.subdescriptors" :key="`${props.row.name}-${subdescriptor.name}`">
                            <td> </td>
                            <td> &nbsp; &nbsp; {{ subdescriptor.name }} </td>
                            <td v-for="category in options.categories" :field="category" :label="category">
                                <b-switch
                                    :ref="subdescriptor.name + '-' + category"
                                    v-if="subdescriptor.actions[category]['actions'].length > 0"
                                    :value="subdescriptor.actions[category]['status']"
                                    @change.native="event => handleSubmit(category, subdescriptor, event, props.row)"
                                />
                            </td>
                        </tr>
                    </template>
                </b-table>
                <hr>
            </div>
        </div>
    </section>
</template>
