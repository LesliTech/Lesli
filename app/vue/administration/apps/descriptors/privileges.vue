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
import { useDescriptor } from "LesliApp/administration/stores/descriptor"
import { useSystemController } from "LesliApp/administration/stores/systemController"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement stores
const storeDescriptor = useDescriptor()
const storeSystemController = useSystemController()


// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        shared: I18n.t("core.shared"),
        descriptors: I18n.t('core.role_descriptors')
    }

}


//
const tab = ref(0)


//
const columns = [{
    label: 'name',
    field: 'controller' 
}, {
    label: 'Active',
    field: 'active'
}]


//
onMounted(() => {
    //storeSystemController.fetchControllers()
    setTimeout(() => storeDescriptor.fetchDescriptorPrivileges(), 2000)
    
})


//
function addPrivilege(action) {
    if (action.active) {
        storeDescriptor.postDescriptorPrivilege(action)
    } else {
        storeDescriptor.deleteDescriptorPrivilege(action)
    }
}

</script>
<template>
    <application-component>
        <lesli-header :title="'Descriptor: '+storeDescriptor.descriptor.name">
        </lesli-header>
        <lesli-tabs v-model="tab">
            <lesli-tab-item paddingless icon="list" title="Index">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.index"
                    :columns="columns"
                    :records="storeDescriptor.privileges.index">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="add" title="Create">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.create"
                    :columns="columns"
                    :records="storeDescriptor.privileges.create">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="edit" title="Update">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.update"
                    :columns="columns"
                    :records="storeDescriptor.privileges.update">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="visibility" title="Show">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.show"
                    :columns="columns"
                    :records="storeDescriptor.privileges.show">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="delete" title="Destroy">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.destroy"
                    :columns="columns"
                    :records="storeDescriptor.privileges.destroy">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>
        </lesli-tabs>
    </application-component>
</template>
