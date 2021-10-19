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
import componentActionForm from "./actions/form.vue"
import componentActionList from "./actions/list.vue"


export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudId: {
            required: true
        }
    },

    components: {
        'component-action-form': componentActionForm,
        'component-action-list': componentActionList
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            }
        }
    }
}
</script>
<template>
    <section>
        <div class="card">
            <div class="card-header">
                <div class="card-header-title is-shadowless">
                    <h4 class=" title is-4">
                        {{translations.core.view_text_quick_actions}}
                    </h4>
                </div>
            </div>
            <div class="card-content">
                <component-action-form :cloud-module="cloudModule" :cloud-id="cloudId" />
                <component-action-list :cloud-module="cloudModule" :cloud-id="cloudId" />
            </div>
        </div>
    </section>
</template>
