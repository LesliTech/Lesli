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


// · List of Imported Components
import componentForm from '../components/form.vue'


// ·
export default {

    props: {

    },

    components: {
        'component-form': componentForm
    },

    data(){
        return {
            view_type: 'new',
            role: {
                object_level_permission: 10
            },
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    roles: I18n.t('core.roles'),
                }
            }
        }
    },
}
</script>

<template>
    <section class="application-component">
        <component-header :title="translations.core.roles.view_title_create_new_role">
            <div class="buttons">
                <router-link class="button" tag="button" to="/">
                    <span class="icon">
                        <i class="fas fa-list"></i>
                    </span>
                    <span>{{ translations.core.shared.view_btn_list }}</span>
                </router-link>
            </div>
        </component-header>
        <component-form
            :role="role"
            :view_type="view_type">
        </component-form>
    </section>
</template>
