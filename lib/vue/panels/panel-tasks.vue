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


// · initialize/inject plugins
const url = inject("url")
const date = inject("date")


// · import stores
import { useTask } from "Lesli/shared/stores/panels/task"
import { useLayout } from "Lesli/shared/stores/layout"


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
