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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { onMounted, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useDescriptor } from "LesliApp/administration/stores/descriptor"


// · import components
import descriptorForm from "./components/form.vue"


// · initialize/inject plugins
const route = useRoute()
const url = inject("url")


// · 
const storeDescriptor = useDescriptor()


// · 
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
})
</script>
<template>
    <section class="application-component">
        <lesli-header :title="'Descriptor: '+storeDescriptor.descriptor.name">
            <lesli-button icon="list" :to="url.admin('descriptors')">
                {{ translations.core.view_btn_list }}
            </lesli-button>
            <lesli-button icon="settings" :to="url.admin('descriptors/:id/privileges', storeDescriptor.descriptor.id)">
               {{  translations.core.roles.view_btn_edit_privilege_actions }}
            </lesli-button>
        </lesli-header>
        <descriptor-form is-editable></descriptor-form>
    </section>
</template>
