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
import { onMounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useDescriptor } from "LesliApp/administration/stores/descriptor"

// · import components
import descriptorForm from "./components/form.vue"

// · implement stores
const storeDescriptor = useDescriptor()

// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        shared: I18n.t("core.shared"),
        role_descriptors: I18n.t('core.role_descriptors')
    }

}

onMounted(() => {
    storeDescriptor.getDescriptorsOptions()
})

</script>

<template>
    <section class="application-component">
        <lesli-header :title="translations.core.role_descriptors.view_btn_new_role_descriptors">
            <lesli-button icon="list" :to="url.admin('descriptors')">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>
        <descriptor-form></descriptor-form>
    </section>
</template>
