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


// · initialize/inject plugins
const url = inject("url")
const date = inject("date")


// · import stores
import { useTask } from "LesliVue/stores/panels/task"
import { useLayout } from "LesliVue/stores/layout"


// · implement stores
const storeTask = useTask()
const storeLayout = useLayout()


const translations = {
    focus: {
        tasks: I18n.t('focus.tasks'),
    }
}

// · defining props
const props = defineProps({
    instanceEndpoint: {
        type: String,
        default: 'focus'
    }
})

// · 
watch(() => storeLayout.showTasks, () => {
    storeTask.fetch()
})


function classColor(notification){
    switch (notification.importance) {
        case 'urgent': {
            return 'has-text-danger'
        }
        case 'important': {
            return 'has-text-success'
        }
        default: {
            return 'has-text-info'
        }
    }
}

</script>
<template>
    <lesli-panel class="lesli-panel-tasks" v-model:open="storeLayout.showTasks">
        <template #header>
            {{ translations.focus.tasks.view_title_tasks_due_today }}
            ({{ storeTask.records.length }})
        </template>
        <template #default>
            <ul class="menu-list p-2">
                <li v-for="notification in storeTask.records" :key="notification.id" >
                    <a :href="`/${instanceEndpoint}/tasks/${notification.id}/edit`">
                        {{ notification.title }}
                    </a> 
                    <p v-if="notification.model_global_identifier">
                        <small class="has-text-grey-light"> 
                            {{ `${notification.model_global_identifier}` }} 
                        </small>
                    </p>
                    <p>
                        <small class="has-text-grey-light"> 
                            {{ `${translations.focus.tasks.column_deadline} : ${notification.deadline}` }} 
                        </small>
                    </p>
                    <p>
                        <small class="has-text-grey-light">
                            {{ `${translations.focus.tasks.column_importance} :` }}
                        </small>
                        <small :class="classColor(notification)">
                            {{ notification.importance }}
                        </small>
                    </p>
                </li>
            </ul>
        </template>
    </lesli-panel>
</template>
