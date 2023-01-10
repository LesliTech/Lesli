<script setup>
/*

Copyright (c) 2023, all rights reserved.

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


// · import vue tools
import { onMounted, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useDescriptor } from "../../stores/descriptor"

// · import components
import descriptorForm from "./components/descriptor-form.vue"


// · initialize/inject plugins
const route = useRoute()
const url = inject("url")


// · 
const storeDescriptor = useDescriptor()

const translations = {
    core: {
        roles: I18n.t("core.roles"),
        role_descriptors: I18n.t('core.role_descriptors'),
        shared: I18n.t("core.shared")
    }
}


// · 
onMounted(() => {
    storeDescriptor.fetchDescriptor(route.params.id)
    storeDescriptor.getDescriptorsOptions()
})


const columns = [{
    field: 'id',
    label: 'ID'
}, {
    field: 'controller',
    label: 'Controller'
}, {
    field: 'action',
    label: 'Action'
}, {
    field: 'created_at',
    label: 'Created at'
}]

</script>
<template>
    <section class="application-component">
        <lesli-header :title="'Descriptor: '+storeDescriptor.descriptor.name">
            <lesli-button icon="list" :to="url.admin('descriptors')">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>
        <div class="box">
            <descriptor-form is-editable></descriptor-form>
        </div>
    </section>
</template>
