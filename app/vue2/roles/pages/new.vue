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

//import componentForm from '../components/forms/form.vue'
import componentForm from '../components/form.vue'

export default {
  
    props: {
        appMountPath: {
            type: String,
            default: ''
        }
    },

    components: {
        'component-form': componentForm
    },

    data(){
        return {
            view_type: 'new',
            role: {
                object_level_permission: 10,
                only_my_data: false,
                active: true
            },
            translations: {
                core: {
                    roles: I18n.t('core.roles'),
                }
            }
        }
    },
}
</script>

<template>
    <section class="application-component">
        <component-form :role="role" :app-mount-path="appMountPath"></component-form>
    </section>
</template>
