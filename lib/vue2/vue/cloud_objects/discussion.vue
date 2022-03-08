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
import componentDiscussionForm from "./discussions/form.vue"
import componentDiscussionList from "./discussions/list.vue"


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
        'component-discussion-form': componentDiscussionForm,
        'component-discussion-list': componentDiscussionList
    }
}
</script>
<template>
    <section>
        <component-discussion-form :cloud-module="cloudModule" :cloud-id="cloudId" />
        <component-discussion-list :cloud-module="cloudModule" :cloud-id="cloudId" />
    </section>
</template>
