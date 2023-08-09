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
import { inject, onMounted, watch } from "vue"


// · import stores
import { useDashboard } from "Lesli/shared/stores/dashboard"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement stores
const storeDashboard = useDashboard()


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")
const msg = inject("msg")
const route = useRoute()


// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
    engine: {
        type: String,
        required: true,
    },
})


// · translations
const translations = {
    dashboards: I18n.t('core.dashboards'),
    components: I18n.t('core.dashboard/components'),
    core: I18n.t('core.shared'),
    roles: I18n.t('core.roles'),
    main: I18n.t(`${storeDashboard.engine}.dashboards`),
    main_components: I18n.t(`${storeDashboard.engine}.dashboard/components`)
}


const default_options = {
    yes: { 
        label: translations.core.view_text_yes, 
        value: true
    },
    no: {
        label: translations.core.view_text_no,
        value: false
    }
}


const layout_options = [{
    label: '25%',
    value: 3
}, {
    label: '33%',
    value: 4
}, {
    label: '50%',
    value: 6
}, {
    label: '66%',
    value: 8
}, {
    label: '75%',
    value: 9
}, {
    label: '100%',
    value: 12
}]


/**
 * @description This function is used to update the workflow information
 */
const onUpdate = () => {
    storeDashboard.updateDashboard()
}


/**
 * @description This function is used to create a new workflow
 */
const onCreate = () => {
    storeDashboard.postDashboard().then(()=> {
        router.push(url[props.engine]('dashboards').s)
    })
}


/**
* @description This function is used to add a new component to dashboard
*/
function addComponent(){
    msg.warning(translations.dashboards.messages_warning_save_changes_reminder)
    let new_component = {
        id: `${storeDashboard.new_component_id}-${storeDashboard.default_component_configuration.index}`,
        name: '',
        component_id: storeDashboard.new_component_id.replaceAll("_", "-"),
        layout: storeDashboard.default_component_configuration.layout,
        index: storeDashboard.default_component_configuration.index++,
        query_configuration: {
            filters: {},
            pagination: {}
        },
        custom_configuration: {
            arrangement: {}
        }
    }
    storeDashboard.dashboard.components.push(new_component)
}


/**
* @description This function is used to select a component
*/
function selectDashboardComponent(selected_component){
    if(storeDashboard.dashboard.components.find( component => component.id == selected_component.id)){
        storeDashboard.selected_dashboard_component = selected_component
    }  
}


/**
* @description This function is used to remove a component from the dashboard
*/
function removeComponent(deleted_component){
    msg.warning(translations.dashboards.messages_warning_save_changes_reminder)
    storeDashboard.dashboard.components = storeDashboard.dashboard.components.filter((component)=> {
        return component.id != deleted_component.id
    })

    // We check if the component id is a real number. If it is, de stage it to delete it when saved
    if(! isNaN(deleted_component.id)){
        deleted_component._destroy = true
        storeDashboard.deleted_components.push(deleted_component)
    }
}


onMounted(() => {
    storeDashboard.engine = props.engine
    if (!props.isEditable){
        storeDashboard.resetDashboard()
    } else {
        storeDashboard.fetchDashboard(route.params?.id)
    }
})

// This function is used to delete a dashboard
function onDeleteDashboard() {
    storeDashboard.deleteDashboard().then(()=> {
        router.push(url[props.engine]('dashboards').s)
    })
}

</script>
<template>
    <lesli-form class="mb-6" @submit="isEditable ? onUpdate() : onCreate()">
        <div class="columns">
            <div class="column is-4">
                <!-- Name -->
                <div class="field">
                    <label class="label">
                        {{translations.dashboards.column_name}}
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <div class="control">
                        <input class="input" type="text" v-model="storeDashboard.dashboard.name" required>
                    </div>
                </div>
            </div>

            <div class="column is-4">
                <!-- Role -->
                <div class="field">
                    <label class="label">{{ translations.dashboards.column_roles_id }}</label>
                    <div class="control">
                        <lesli-select
                            v-model="storeDashboard.dashboard.roles_id"
                            :options="storeDashboard.options.roles"
                        ></lesli-select>
                    </div>
                </div>
            </div>

            <div class="column is-4">
                <!-- Default -->
                <div class="field">
                    <label class="label">{{ translations.dashboards.column_default }}</label>
                    <lesli-select
                        v-model="storeDashboard.dashboard.default"
                        :options="default_options">
                    </lesli-select>
                </div>
            </div>
        </div>

        <!-- Save button -->
        <div class="is-flex is-justify-content-space-between">
            <div class="field">
                <label class="label">
                    {{ translations.dashboards.view_title_add_component }}
                </label>
                <div class="control">
                    <lesli-select
                        v-model="storeDashboard.new_component_id"
                        :options="storeDashboard.options.component_ids"
                        @change="addComponent">
                    </lesli-select>
                </div>
            </div>
            <div class="buttons">
                <lesli-button icon="save" :loading="storeDashboard.loading">
                    {{ translations.dashboards.view_btn_save_dashboard }}
                </lesli-button> 
                <lesli-button danger icon="delete" @click="onDeleteDashboard">
                    {{ translations.dashboards.view_btn_delete_dashboard }}
                </lesli-button>
            </div>
        </div>
    </lesli-form>
</template>
