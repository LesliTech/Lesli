<script>
/*

Copyright (c) 2020, all rights reserved.

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

export default {
    props: {
        model_id: {
            required: true
        },

        model_type: {
            required: true
        },

        options: {
            required: true
        },
        statusEvent: {
            default: null
        },
        engineEndpoint: {
            required: true
        },
        subscribeToEventChanges: {
            type: Boolean,
            default: false
        },
        openNewTaskTab: {
            type: Function,
            default: ()=>{}
        }
    },

    data() {
        return {
            translations: {
                tasks: I18n.t('deutscheleibrenten.tasks'),
                shared: I18n.t('deutscheleibrenten.shared'),
                workflows: I18n.t('deutscheleibrenten.workflows'),
                events: I18n.t('deutscheleibrenten.events'),
                focus: {
                    tasks: I18n.t('focus.tasks')
                }
            },
            loading: false,
            tasks: [],
            pagination: {
                tasks_count: 0,
                current_page: 1,
                range_before: 3,
                range_after: 3,
                per_page: 5
            },
            abilities: {
                tasks: this.abilities.privilege('tasks', 'deutsche_leibrenten')
            },
            actions: {
                current: null
            },
            sorting: {
                field: 'deadline',
                order: 'desc'
            }
        }
    },

    mounted() {
        this.setSubscriptions()
        this.getTasks()
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe('get:/focus/tasks', () => {
                this.getTasks()
            })

            this.bus.subscribe('put:/focus/tasks/done', ()=>{
                this.getTasks()
            })

            this.bus.subscribe('delete:/focus/tasks', ()=>{
                this.tasks = this.tasks.filter(e => e.id !== task_id)
            })

            if(this.statusEvent){
                this.bus.subscribe(this.statusEvent, ()=>{
                    this.getTasks()
                })
            }
        },

        getTasks() {
            let url = this.url.focus('tasks').order(
                this.sorting.field,
                this.sorting.order
            ).paginate(
                this.pagination.current_page,
                this.pagination.per_page
            ).filters({
                model_type: this.model_type,
                model_id: this.model_id,
                exclude: 'completed'
            })

            this.loading = true
            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.pagination.tasks_count = result.data.count_total
                    this.tasks = result.data.records

                    if(this.tasks.length == 0){
                        this.openNewTaskTab()
                    }
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        hideCurrentAction(){
            this.actions.current.classList.toggle('visible')
        },

        showActions(id) {
            let menuList = document.getElementById(`menu-list-${this.model_type}-${id}`)

            if (this.actions.current) {
                if (menuList !== this.actions.current && this.actions.current.classList.contains('visible')) {
                    this.hideCurrentAction()
                }
            }
            menuList.classList.toggle('visible')
            this.actions.current = menuList
        },

        putTaskStatus(task, new_status) {
            this.$set(task, 'editing', true)
            let form_data = {
                task: {
                    cloud_focus_workflow_statuses_id: new_status.id
                }
            }


            this.http.put(`/${this.engineEndpoint}/tasks/${task.id}.json`, form_data).then(response => {
                this.$set(task, 'editing', false)
                if (response.successful) {
                    if(new_status.status_type == 'completed_successfully' || new_status.status_type == 'completed_unsuccessfully'){
                        this.bus.publish('put:/focus/tasks/done', response.data)
                    }
                    this.msg.success(this.translations.tasks.notification_task_updated)
                }else{
                    this.msg.error(response.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        cloneTask(task) {
            this.$set(task, 'editing', true)
            let importance = this.options.importances.find(e => e.text === task.importance)
            let form_data = {
                task: {
                    model_type: task.model_type,
                    model_id: task.model_id,
                    user_main_id: task.user_main_id,
                    cloud_focus_catalog_task_types_id: task.cloud_focus_catalog_task_types_id,
                    clone: true,
                    detail_attributes: {
                        title: task.title,
                        description: task.description,
                        deadline: task.deadline_raw,
                        importance: importance.value
                    }
                }
            }

            this.http.post(`/${this.engineEndpoint}/tasks`, form_data).then(response => {
                this.$set(task, 'editing', false)
                if (response.successful) {
                    this.msg.success(this.translations.tasks.notification_task_created)
                    this.bus.publish('get:/focus/tasks', response.data)
                }else{
                    this.msg.error(response.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        colorTaskImportance(importance){
            switch(importance){
                case 'normal':
                    return 'is-default'
                case 'important':
                    return 'is-warning'
                case 'urgent':
                    return 'is-danger'
            }
        },

        deleteTask(deleted_task) {
            this.$set(deleted_task, 'editing', true)

            this.http.delete(`/${this.engineEndpoint}/tasks/${deleted_task.id}`).then(response => {
                this.$set(deleted_task, 'editing', false)
                if (response.successful) {
                    this.tasks = this.tasks.filter((task)=>{
                        return task.id != deleted_task.id
                    })
                    this.msg.success(this.translations.tasks.notification_task_deleted)
                    this.bus.publish('delete:focus/tasks')
                } else {
                    console.log(response)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        sortTasks(field, order){
            if(this.sorting.field == field){
                if(this.sorting.order == 'asc'){
                    this.sorting.order = 'desc'
                }else{
                    this.sorting.order = 'asc'
                }
            }else{
                this.sorting.field = field
                this.sorting.order = 'desc'
            }
            this.getTasks()
        },

        showTask(task) {
            this.url.go(`/${this.engineEndpoint}/tasks/${task.id}/edit?previous_view=parent`)
        },
    },

    beforeDestroy(){
        this.bus.$off('get:/focus/tasks')
        this.bus.$off('put:/focus/tasks/done')

        if(this.statusEvent){
            this.bus.$off(this.statusEvent)
        }
    },

    watch: {
        'pagination.current_page'(){
            this.getTasks()
        },

        'model_id'(){
            if(this.model_id){
                this.getTasks()
            }
        }
    }
}

</script>
<template lang="">
    <div class="card is-shadowless overflowed">
        <div class="card-content task-list">
            <div class="has-text-right">
                <button class="button" @click="getTasks" :disabled="loading">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span>{{ translations.shared.btn_reload }}</span>
                </button>
            </div>
            <br>
            <component-data-loading v-if="loading"></component-data-loading>
            <component-data-empty v-if="!loading && tasks.length === 0" />
            <div v-if="!loading && tasks.length > 0">
                <b-table
                    :data="tasks"
                    :hoverable="true"
                    backend-sorting
                    @sort="sortTasks"
                    @click="showTask"
                >
                    <template v-slot="props">

                        <b-table-column field="id" :label="translations.tasks.table_header_id" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'id'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            {{ props.row.id }}
                        </b-table-column>

                        <b-table-column field="title" :label="translations.tasks.table_header_title" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'title'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <span v-if="subscribeToEventChanges && props.row.model_type == 'CloudDriver::Event'">
                                [{{translations.events.event_title}} {{props.row.model_id}}]
                            </span>
                            {{ props.row.title }}
                        </b-table-column>

                        <b-table-column field="deadline" :label="translations.tasks.table_header_deadline" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'deadline'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            {{ props.row.deadline }}
                        </b-table-column>

                        <b-table-column field="user_creator_value" :label="translations.tasks.table_header_creator" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'user_creator_value'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            {{ props.row.user_creator_value }}
                        </b-table-column>

                        <b-table-column field="user_main_value" :label="translations.tasks.table_header_assigned" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'user_main_value'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            {{ props.row.user_main_value }}
                        </b-table-column>

                        <b-table-column field="importance" :label="translations.tasks.table_header_importance" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'importance'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <b-tag :type="colorTaskImportance(props.row.importance)" rounded> {{ object_utils.translateEnum(translations.focus.tasks, 'column_enum_task_importance', props.row.importance) }} </b-tag>
                        </b-table-column>

                        <b-table-column :label="translations.tasks.table_header_actions">
                            <div class="menu-dots" :id="`menu-${model_type}-${props.row.id}`" @click.stop="showActions(props.row.id)">
                                <span class="">
                                    <i class="fas fa-ellipsis-h fa-1x"></i>
                                </span>
                            </div>
                            <ul class="menu-list" :id="`menu-list-${model_type}-${props.row.id}`">
                                <span v-if="props.row.editing">
                                    <li class="menu-item">
                                        <b-icon
                                            icon="circle-notch"
                                            custom-class="fa-spin"
                                            size="is-small"
                                        >
                                        </b-icon>
                                        <strong>
                                            {{translations.shared.btn_saving}}
                                        </strong>
                                    </li>
                                </span>
                                <span v-else>
                                    <li v-if="props.row.editable && abilities.tasks.update" class="menu-item" @click.stop="showTask(props.row)">
                                        <strong>
                                            {{ translations.shared.edit }}
                                        </strong>
                                    </li>
                                    <span v-if="props.row.editable && abilities.tasks.update">
                                        <li class="menu-item" v-for="status in props.row.next_workflow_statuses" :key="status.id" @click.stop="putTaskStatus(props.row, status)">
                                            <strong>
                                                {{object_utils.translateEnum(translations.workflows, 'status', status.name)}}
                                            </strong>
                                        </li>
                                    </span>
                                    <li v-if="abilities.tasks.create" class="menu-item" @click.stop="cloneTask(props.row)">
                                        <strong>
                                            {{ translations.shared.clone }}
                                        </strong>
                                    </li>
                                    <li v-if="props.row.editable && abilities.tasks.destroy" class="menu-item" @click.stop="deleteTask(props.row)">
                                        <strong>
                                            {{ translations.shared.text_delete }}
                                        </strong>
                                    </li>
                                </span>
                            </ul>
                        </b-table-column>
                    </template>
                </b-table>
                <b-pagination
                    :simple="false"
                    :total="pagination.tasks_count"
                    :current.sync="pagination.current_page"
                    :range-before="pagination.range_before"
                    :range-after="pagination.range_after"
                    :per-page="pagination.per_page"
                    order="is-centered"
                    icon-prev="chevron-left"
                    icon-next="chevron-right"
                    aria-next-label="Next page"
                    aria-previous-label="Previous page"
                    aria-page-label="Page"
                    aria-current-label="Current page"
                >
                </b-pagination>
            </div>
        </div>
    </div>
</template>

<style scoped>
    .menu-dots {
        user-select: none;
        cursor: pointer;
        border-width: 2px;
        border-radius: 50%;
        border-style: solid;
        width: 30px;
        height: 30px;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .menu-list {
        display: none;
        list-style: none;
        padding: 5px 0px 0px 5px;
        background-color: rgb(255, 255, 255);
    }

    .menu-list.visible {
        display: block;
        position: absolute;
    }

    .menu-item {
        cursor: pointer;
        padding: 5px 10px 0px 5px;
        text-align: left;
        margin-top: 1px;
        border-radius: 2px;
    }

    .menu-item:hover {
        background-color: rgb(224, 224, 224);
    }

    .overflowed {
        overflow: visible;
    }
</style>
