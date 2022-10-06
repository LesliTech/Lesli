<script setup>
/*

Copyright (c) 2022, all rights reserved.

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
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useRole } from "../../stores/role"
import { useDescriptor } from "../../stores/descriptor"


// · import components
import componentPrivilegeCustom from "./componentPrivilegeCustom.vue"
import componentPrivilegeStandard from "./componentPrivilegeStandard.vue"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()

// · 
const editor = ref('standard')
const actualPath = route.fullPath.slice(1)

// · 
onMounted(() => {
    storeRole.fetchRole(route.params.id)
})


// · 
function toggleEditor() {

    if (editor.value == 'standard') {
        return editor.value = 'custom'
    }

    editor.value = 'standard'
}

</script>
<template>
    <section class="application-component">
        <lesli-header :title="'Privileges for: ' + storeRole.role.name + ' role '">
            <lesli-button icon="list" :to="url.admin('roles')">
                All roles
            </lesli-button>
            <lesli-button icon="edit" :to="url.root(actualPath+`/edit`)">
                Edit role
            </lesli-button>
            <lesli-button icon="admin_panel_settings" :solid="editor == 'custom'" @click="toggleEditor">
                Aditional privileges
            </lesli-button>
        </lesli-header>
        <lesli-toolbar @search="storeRole.searchDescriptors"></lesli-toolbar>
        <componentPrivilegeStandard v-if="editor == 'standard'"></componentPrivilegeStandard>
        <componentPrivilegeCustom v-if="editor == 'custom'"></componentPrivilegeCustom>
    </section>
</template>
