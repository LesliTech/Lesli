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
import { useRouter, useRoute } from "vue-router"
import componentFormRole from "./componentForm.vue"


// · import lesli stores
import { useRole } from "../../stores/role"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()


// · 
const translations = {
    core: {
        shared: I18n.t('core.shared'),
        roles: I18n.t('core.roles')
    }
}

// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "administration/roles",
    }
})

// · 
onMounted(() => {
    storeRole.fetchRole(route.params.id)
})

</script>
<template>
    <section class="application-component">
        <lesli-header :title="'Edit: ' + storeRole.role.name + ' role '">
            <lesli-button icon="list" :to="url.root(props.appMountPath)">
                {{  translations.core.roles.view_btn_roles_list }}
            </lesli-button>
            <lesli-button icon="settings" :to="url.root(props.appMountPath+`/${storeRole.role.id}`)">
               {{  translations.core.roles.view_btn_edit_privilege_actions }}
            </lesli-button>
        </lesli-header>
        <componentFormRole></componentFormRole>
    </section>
</template>
