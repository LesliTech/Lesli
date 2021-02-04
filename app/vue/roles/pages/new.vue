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
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentForm from '../components/forms/form.vue'

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
                shared: I18n.t('deutscheleibrenten.shared')
            }
        }
    },
}
</script>

<template>
    <section class="application-component">
        <component-form 
            :role="role"
            :view_type="view_type"
        >
        </component-form>
    </section>
</template>
