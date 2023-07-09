<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useIntegration } from "../../stores/integration"


// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")


// · 
const storeIntegration = useIntegration()

// · 
const columns = [{
    field: "id",
    label: "ID"
}, {
    field: "name",
    label: "Name"
},  {
    field: "active",
    label: "Status"
}, {
    field: "usage_count",
    label: "Usage"
}, {
    field: "created_at",
    label: "Created at"
}, {
    field: "creator_name",
    label: "Created by"
}]


// · 
onMounted(() => {
    storeIntegration.fetch()
})

</script>
<template>
    <section class="application-component">
        <lesli-header 
            title="Integrations"
            add="Add integration">
            <lesli-button 
                icon="add"
                :to="url.admin('account/integrations/new')">
                Add integration
            </lesli-button>
        </lesli-header>
        <lesli-toolbar></lesli-toolbar>
        <lesli-table
            :columns="columns"
            :records="storeIntegration.records">
            <template #creator_name="{value, record}">
                <a :href="url.admin('users/:id', record.creator_id)">
                    {{ value }}
                </a>
            </template>
            <template #options="{ record, value }">
                <a class="dropdown-item" @click="storeIntegration.deleteIntegration(record.id)">
                    <span class="material-icons">
                        delete
                    </span>
                    <span>
                        Delete
                    </span>
                </a>
            </template>
        </lesli-table>
    </section>
</template>
