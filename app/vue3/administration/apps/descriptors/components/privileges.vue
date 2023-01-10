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
import { inject, onMounted, ref } from "vue"


// · import lesli stores
import { useDescriptor } from "LesliCore/administration/stores/descriptor"
import { useSystemController } from "LesliCore/administration/stores/systemController"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement stores
const storeDescriptor = useDescriptor()
const storeSystemController = useSystemController()


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")
const route = useRoute()


// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
})


// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        shared: I18n.t("core.shared"),
        descriptors: I18n.t('core.role_descriptors')
    }

}


const tab = ref(0)

const columns = [{
    label: 'name',
    field: 'name' 
}, {
    label: 'Privileges',
    field: 'active'
}]

onMounted(() => {
    storeSystemController.fetchControllers()
    storeSystemController.fetchOptions()
})

</script>
<template>
    <lesli-tabs v-model="tab">
        <lesli-tab-item title="index">
            <lesli-table
                headless
                :columns="columns"
                :records="storeSystemController.controllerActions">
                <template #active="{ record }">
                    <lesli-toggle v-model="record.active"></lesli-toggle>
                    0/{{ record.actions.length }}
                </template>
                <template #detail="{ record }">
                    <tr v-for="(action, index) in record.actions" :key="index">
                        <td></td>
                        <td> 
                            {{ action.action }} 
                        </td>
                        <td>
                            <lesli-toggle v-model="action.active"></lesli-toggle>
                        </td>
                    </tr>

                    <!--lesli-table 
                        headless
                        :columns="[{ label: 'action', field: 'action' }, { label: 'active', field: 'active' }]"
                        :records="record.actions">
                        <template #active="{ record }">
                            <lesli-toggle v-model="record.active"></lesli-toggle>
                        </template>
                    </lesli-table -->
                </template>
            </lesli-table>
        </lesli-tab-item>
    </lesli-tabs>
</template>
