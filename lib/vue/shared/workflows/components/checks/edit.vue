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
import componentForm from './form.vue'

export default {
    props: {
        workflowId: {
            required: true
        },

        engineNamespace: {
            required: true
        },
        statusesTranslationsPath: {
            required: true,
            type: String
        },
    },

    components: {
        'component-form': componentForm
    },
}
</script>
<template>
    <div class="tab-content">
        <component-form
            :workflow-id="workflowId"
            :engine-namespace="engineNamespace"
            :statuses-translations-path="statusesTranslationsPath"
            view-type="edit"
        >
        </component-form>
    </div>
</template>
