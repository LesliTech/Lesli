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
import { inject, onMounted, watch } from "vue"

// · import stores
import { useDashboard } from "LesliVue/stores/shared/dashboard"

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
    cloudModule: {
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
    main: I18n.t(`${storeDashboard.cloudModule}.dashboards`),
    main_components: I18n.t(`${storeDashboard.cloudModule}.dashboard/components`)
}

const radio_options = {
    yes: { 
        label: translations.core.view_text_yes, 
        value: true
    },
    no: {
        label: translations.core.view_text_no,
        value: false
    }
}

const layout_options = [
    {
        label: '8.3%',
        value: 1,
    }, {
        label: '16.7%',
        value: 2,
    }, {
        label: '25%',
        value: 3,
    }, {
        label: '33.3%',
        value: 4,
    }, {
        label: '41.7%',
        value: 5,
    }, {
        label: '50%',
        value: 6,
    }, {
        label: '58.3%',
        value: 7,
    }, {
        label: '66.7%',
        value: 8,
    }, {
        label: '75%',
        value: 9,
    }, {
        label: '83.3%',
        value: 10,
    }, {
        label: '91.7%',
        value: 11,
    }, {
        label: '100%',
        value: 12,
    }
]

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
        router.push(url[props.cloudModule]('dashboards').s)
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
        component_id: storeDashboard.new_component_id,
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
    if (!props.isEditable){
        storeDashboard.resetDashboard()
    } else {
        storeDashboard.resetDashboard()
        storeDashboard.fetchDashboard(route.params?.id)     
    }
})

</script>
<template>
    
    <div class="block">
        <form class="mb-4"  
            @submit.prevent="isEditable ? onUpdate() : onCreate()"
        >
            <fieldset>
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
                            <div class="control">
                                <input type="checkbox" v-model="storeDashboard.dashboard.default">
                                <span v-if="storeDashboard.dashboard.default"> {{translations.core.view_text_yes}} </span>
                                <span v-else> {{translations.core.view_text_no}} </span>
                            </div>
                        </div>
                    </div>
                </div>
            </fieldset>

            <hr>
        
            <div class="columns">

                <div class="column is-6">
                    <h6 class="title is-6">
                        {{ translations.dashboards.view_title_add_component }}
                    </h6>
                    <!-- Select a new component -->
                    <div class="field">
                        <div class="control">
                            <lesli-select
                                v-model="storeDashboard.new_component_id"
                                :options="storeDashboard.options.component_ids"
                                @change="addComponent"
                            ></lesli-select>
                        </div>
                    </div>

                    <!-- Dashboard list of components -->
                    <div class="menu-list is-hoverable">
                        <a
                            v-for="(component, index) in storeDashboard.dashboard.components"
                            :key="index"
                            @click="selectDashboardComponent(component)"
                            :class="['list-item',  {'is-active':  ( storeDashboard.selected_dashboard_component && component.id == storeDashboard.selected_dashboard_component.id) }]"
                        >
                            {{ component.component_id }}
                            <button type="button" class="delete is-small is-pulled-right" @click="removeComponent(component)">
                            </button>
                        </a>
                    </div>
                </div>

                <!-- Components settings -->
                <div class="column is-6" v-if="storeDashboard.selected_dashboard_component.component_id">
                    <h6 class="title is-6">
                        {{ translations.dashboards.view_title_component_configuration }}
                    </h6>
                    <!-- Name component -->
                    <div class="field">
                        <label class="label">
                            {{ translations.components.column_name }}
                        </label>
                        <div class="control">
                            <input class="input" type="text" v-model="storeDashboard.selected_dashboard_component.name">
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-6">
                            <!-- Index component -->
                            <div class="field">
                                <label class="label">
                                    {{ translations.components.column_number }}
                                </label>
                                <div class="control">
                                    <input class="input" type="number" v-model="storeDashboard.selected_dashboard_component.index">
                                    <p>{{ translations.components.view_text_column_number_description }}</p>
                                </div>
                            </div>
                        </div>

                        <div class="column is-6">
                            <!-- Width component -->
                            <div class="field">
                                <label class="label">
                                    {{ translations.components.column_layout }}
                                </label>
                                <div class="control">
                                    <lesli-select
                                        v-model="storeDashboard.selected_dashboard_component.layout"
                                        :options="layout_options"
                                    >
                                    </lesli-select>
                                    <p>{{ translations.components.view_text_column_layout_description }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Conditional options -->
                    <div
                        class="column is-6"
                        v-for="(option, index) in storeDashboard.options.components_configuration_options[storeDashboard.selected_dashboard_component.component_id]"
                        :key="`query-${index}`"
                    >
                        <!-- Boolean options -->
                        <div class="field" v-if="option.type == 'Boolean'">
                            <label class="label">
                                {{ translations.main_components[`column_configuration_${option.name}`] }}
                            </label>
                            <div class="control">
                                <label :for="option_radio.label" class="radio" v-for="option_radio in radio_options" :key="option_radio">
                                    <input 
                                        name="active" 
                                        type="radio" 
                                        :id="option_radio.label" 
                                        :value="option_radio.value"
                                        v-model="storeDashboard.selected_dashboard_component[option.column][option.group][option.name]" 
                                    />
                                    {{ option_radio.label }}
                                </label>
                                <p>{{ translations.main_components[`view_text_column_configuration_${option.name}_description`] }}</p> 
                            </div>
                        </div>

                        <!-- Integer options -->
                        <div class="field" v-if="option.type == 'Integer'">
                            <label class="label">
                                {{ translations.main_components[`column_configuration_${option.name}`] }}
                            </label>
                            <div class="control">
                                <input class="input" type="number" v-model="storeDashboard.selected_dashboard_component[option.column][option.group][option.name]">
                                <p>{{ translations.main_components[`view_text_column_configuration_${option.name}_description`] }}</p> 
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Save button -->
            <div class="field is-grouped">
                <div class="control">
                    <lesli-button icon="save" :loading="storeDashboard.loading">
                        {{ translations.dashboards.view_btn_save_dashboard }}
                    </lesli-button> 
                </div>
            </div>
        </form>
        
    </div>

</template>
