<script setup>
/*
Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~
// ·
*/

// · import vue tools
import { onMounted } from "vue"

// · import store
import { useCloudObjectAction } from "LesliVue/stores/cloud-objects/action"

// · import components


// · defining translations
const translations = {
    core: I18n.t('core.shared')
}

// · implement store
const actionStore = useCloudObjectAction()

// · defining props
const props = defineProps({
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the resource that you need to interact with.
    cloudObject: {
        type: Object,
        required: true,
    },
    // · prop that indicates the object id of the resource that you need to interact with.
    cloudObjectId: {
        type: String,
        required: true,
    }
})

actionStore.cloudModule = props.cloudModule
actionStore.cloudObject = props.cloudObject 
actionStore.cloudObjectId = props.cloudObjectId

function  completedActions(group){
    return group.actions.filter(action => action.complete).length
}


onMounted(() => {
    actionStore.getActions()
    actionStore.singularize(props.cloudObject)
})

</script>

<template>
    <h2 class=" title is-4">
        {{ translations.core.view_text_quick_actions }}
    </h2>

    <form @submit.prevent="actionStore.createGroup">
        <fieldset>
            <div class="columns">
                <div class="column is-10">
                    <div class="field">
                        <label class="label">{{ translations.core.view_text_cloud_object_actions_add_new_group }}<sup class="has-text-danger">*</sup></label>
                        <div class="control">
                            <input class="input" type="text" v-model="actionStore.new_group_name" required>
                        </div>
                    </div>
                </div>

                <div class="column is-2">
                    <div class="field">
                        <label class="label">&nbsp;</label>
                        <div class="control">
                            <lesli-button icon="add">
                                {{ translations.core.view_btn_add }}
                            </lesli-button> 
                        </div>
                    </div>
                </div>
            
            </div>
        </fieldset>
    </form>

    <hr>

    <div class="columns is-multiline">
                    
        <div class="column is-6" v-for="(group, name, index) in actionStore.actions_groups" :key="name">

            <div class="card">
                <div
                    :class="['card-header', {'has-text-success': completedActions(group) == group.actions.length}]"
                    role="button"
                    :aria-controls="`action-group-${index}`"
                >
                    <p class="card-header-title">
                        {{name}}
                    </p>
                    <a class="card-header-icon">
                        <span>{{completedActions(group)}}/{{group.actions.length}}</span>
                        &nbsp;
                        <span class="icon">
                            <span class="material-icons">check_box</span>
                        </span>
                    </a>
                </div>

                <div class="card-content">
                    <div class="content">
                        <form @submit.prevent="actionStore.createAction(name)">
                            <fieldset>
                                <div class="columns">
                                    <div class="column is-10">
                                        <div class="field">
                                            <label class="label">{{ translations.core.view_text_cloud_object_actions_add_new }}<sup class="has-text-danger">*</sup></label>
                                            <div class="control">
                                                <input class="input" type="text" required v-model="group.new_action.instructions">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="column is-2">
                                        <div class="field">
                                            <label class="label">&nbsp;</label>
                                            <div class="control">
                                                <lesli-button icon="add">
                                                    {{ translations.core.view_btn_add }}
                                                </lesli-button> 
                                            </div>
                                        </div>
                                    </div>
                                
                                </div>
                            </fieldset>
                        </form>
                        <hr>

                        <div class="panel-block is-justify-content-space-between" v-for="(action, index) in group.actions" :key="index">
                            <div class="is-pulled-left">

                                <input type="checkbox" v-model="action.complete" @input="actionStore.putAction(action)">{{action.instructions}}
                                <br>
                                <sub><small>{{action.user_creator_name}} - {{action.created_at_text}}</small></sub>
                            </div>
                            <div class="is-pulled-right">
                                <button v-if="! action.submitting" class="delete is-small" @click="actionStore.deleteAction(name, action)"></button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </div>

    
</template>
