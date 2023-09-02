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
import { inject, onMounted } from "vue"


// · import lesli stores
import { useDescriptor } from "../../../stores/descriptor"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement stores
const storeDescriptor = useDescriptor()


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
        role_descriptors: I18n.t('core.role_descriptors')
    }

}

/**
 * @description This function is used to update the descriptor information
 */
const onUpdate = () => {
    storeDescriptor.updateDescriptor()
}

/**
 * @description This function is used to create a new descriptor
 */
const onCreate = () => {
    storeDescriptor.createDescriptor()
}

onMounted(() => {
    if (!props.isEditable){
        storeDescriptor.resetDescriptor()
    } else {
        storeDescriptor.fetchDescriptor(route.params?.id)
    }
})

</script>
<template>
    <lesli-form 
        class="information"
        v-if="!storeDescriptor.loading"
        @submit="isEditable ? onUpdate() : onCreate()">

        <div class="field">
            <label class="label">
                {{ translations.core.view_text_name }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <input name="name" v-model="storeDescriptor.descriptor.name" required="required" type="text" class="input"> 
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{ translations.core.role_descriptors.view_text_assign_parent_descriptor }}
            </label>
            <div class="control">
                <lesli-select
                    v-model="storeDescriptor.descriptor.descriptors_id"
                    :options="storeDescriptor.descriptors_options">
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{ translations.core.role_descriptors.column_description }}
            </label>
            <div class="control">
                <textarea class="textarea" v-model="storeDescriptor.descriptor.description"></textarea>
            </div>
        </div>

        <div class="field">
            <div class="control">
                <lesli-button icon="save">
                    {{ translations.core.shared.view_btn_save }}
                </lesli-button>       
            </div>
        </div>
    </lesli-form>
</template>
