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

import componentForm from "../components/form.vue"

export default {
    props: {
        appMountPath: {
            type: String,
            default: ''
        }
    },

    components: {
        "component-form": componentForm
    },
    data() {
        return {
            translations: {
                role_descriptors: I18n.t('core.role_descriptors'),
                core: I18n.t('core.shared')
            },
            role_descriptor: {
                id: null,
                role_descriptors_id: null                
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.role_descriptors.view_btn_new_role_desccriptors">
            <div class="buttons">
                <router-link class="button" :to="appMountPath">
                    <span class="icon"><i class="fas fa-list"></i></span>
                    <span> {{ translations.core.view_btn_list }}</span>
                </router-link>
            </div>
        </component-header>

        <div class="card">
            <div class="card-content">
                <component-form :app-mount-path="appMountPath" :role_descriptor="role_descriptor"></component-form>
            </div>
        </div>
    </section>
</template>
