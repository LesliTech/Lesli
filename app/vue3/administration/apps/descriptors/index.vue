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
import {onMounted, inject } from "vue"
import { useRouter } from 'vue-router'


// · import lesli stores
import { useDescriptor } from "../../stores/descriptor"


// · initialize/inject plugins
const url = inject("url")


// · 
const storeDescriptor = useDescriptor()

const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        role_descriptors: I18n.t('core.role_descriptors'),
        shared: I18n.t("core.shared")
    }
}

// · 
const columns = [{
    field: "id",
    label: "ID",
    sort: true
}, {
    field: "name",
    label: "Name",
    sort: true
},  {
    field: "reference",
    label: "Reference",
    sort: true
}, {
    field: "updated_at",
    label: "Updated at"
}]


// · 
onMounted(() => {
    storeDescriptor.fetch()
})

</script>
<template>
    <section class="application-component">
        <lesli-header title="Role Descriptors">
            <lesli-button
                outlined
                icon="refresh"
                :loading="storeDescriptor.loading"
                @click="storeDescriptor.fetch()"
            >
                {{ translations.core.shared.view_text_btn_reload }}
            </lesli-button>
            <lesli-button icon="add" :to="url.admin(`descriptors/new`)">
                {{ translations.core.role_descriptors.view_btn_new_role_descriptor }}
            </lesli-button>
        </lesli-header>
        <lesli-toolbar @search="storeDescriptor.search"></lesli-toolbar>
        <lesli-table
            :link="(descriptor) => url.admin('descriptors/:id', descriptor.id).s"
            :columns="columns"
            :records="storeDescriptor.records"
            :pagination="storeDescriptor.index.pagination"
            @paginate="storeDescriptor.paginateIndex"
            @sort="storeDescriptor.sortIndex"
        ></lesli-table>
    </section>
</template>
