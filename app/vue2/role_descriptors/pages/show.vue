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

*/

import componentForm from '../components/form.vue'
import componentPrivileges from '../components/privileges.vue'

export default {
    props: {
        appMountPath: {
            type: String,
            default: '/administration/roles'
        }
    },

    components: {
        'component-form': componentForm,
        'component-privileges': componentPrivileges
    },
    data() {
        return {
            role_descriptor_id: null,
            role_descriptor: {},
            translations: {
                core: I18n.t('core.shared')
            },
            active_tab: 1
        }
    },
    mounted() {
        this.role_descriptor_id = this.$route.params.id
        this.getPrivilegeGroup()
    },
    methods: {
        getPrivilegeGroup() {
            let url = this.url.admin('role_descriptors/:id', {id: this.role_descriptor_id})
            this.http.get(url).then(result => {

                if (!result.successful) {
                    return
                }

                this.role_descriptor = result.data
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="role_descriptor.name">
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" :to="appMountPath">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.view_btn_list }}</span>
                    </router-link>
                </div>
            </div>
        </component-header>

        <div class="card">
            <div class="card-content">
                <component-form v-if="role_descriptor.id" :app-mount-path="appMountPath" :role_descriptor="role_descriptor"></component-form>
            </div>
        </div>
        <br>
        <div class="card">
            <div class="card-header">
                <p class="card-header-title">
                    {{ 'Actions' }}
                </p>
            </div>
            <div class="card-content">
                <component-privileges v-if="role_descriptor.id" :role_descriptor="role_descriptor"></component-privileges>
            </div>
        </div>
    </section>
</template>
