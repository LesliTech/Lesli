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
import DatePicker from 'v-calendar/lib/components/date-picker.umd'


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentUsers from '../../../forms/users-autocomplete.vue'
// ·
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~<script>
export default {
    props: {
        model_type: {
            required: true
        },
        model_id: {
            required: true
        },
        options: {
            required: true
        },
        engineEndpoint: {
            required: true
        },
    },

    components: {
        'component-users': componentUsers,
        'vc-date-picker': DatePicker
    },

    data() {
        return {
            task: {
                send_email: false,
                model_type: this.model_type,
                model_id: this.model_id,
                user_main_id: null,
                cloud_focus_catalog_task_types_id: null,
                detail_attributes: {
                    title: '',
                    description: '',
                    deadline: null,
                    importance: 0
                }
            },
            submitting_form: false,
            lesli: lesli,
            translations: {
                tasks: I18n.t('deutscheleibrenten.tasks'),
                shared: I18n.t('deutscheleibrenten.shared'),
                focus: {
                    tasks: I18n.t('focus.tasks')
                }
            }
        }
    },

    methods:{
        sortArray(a, b) {
            const textA = a.text.toUpperCase();
            const textB = b.text.toUpperCase();

            let comparison = 0;
            if (textA > textB) {
                comparison = 1;
            } else if (textA < textB) {
                comparison = -1;
            }
            return comparison;
        },

        clearFields() {
            this.task = {
                model_type: this.model_type,
                model_id: this.model_id,
                task_type: null,
                detail_attributes: {
                    title: '',
                    description: '',
                    deadline: null,
                    importance: 0
                }
            },
            this.send_email = false
            this.bus.publish('clear:/users/autocomplete')
        },

        postTask() {
            let data = {
                task: this.task
            }

            this.submitting_form = true

            let url = `/${this.engineEndpoint}/tasks`
            this.http.post(url, data).then(result => {
                this.submitting_form = false
                if (result.successful) {
                    this.msg.success(this.translations.tasks.notification_task_created)
                    this.clearFields();
                    this.bus.publish('get:/focus/tasks', result.data)
                    this.bus.publish('new:/focus/task')
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        parseModelType(){
            let value = this.task.model_type
            let value_splited = value.toLowerCase().split('::')
            value = this.object_utils.pluralize(value_splited[value_splited.length - 1])

            return value
        },
    },

    watch: {
        model_id(){
            this.task.model_id = this.model_id
        }
    }
}
</script>

<template>
    <div class="card is-shadowless">
        <div class="card-content">
            <fieldset :disabled="submitting_form">
                <form @submit.prevent="postTask">

                    <div class="columns">
                        <div class="column is-half">
                            <!-- Title -->
                            <div class="field">
                                <label class="label">{{ translations.tasks.form_task_title }}<sup class="has-text-danger">*</sup></label>
                                <div class="control">
                                    <input required v-model="task.detail_attributes.title" class="input" :name="`${parseModelType()}_task_title`" type="text" >
                                </div>
                            </div>
                        </div>

                        <div class="column is-half">
                            <!-- Type -->
                            <div class="field">
                                <label class="label">{{ translations.tasks.form_task_type }}<sup class="has-text-danger">*</sup></label>
                                <b-select
                                    :placeholder="translations.shared.text_select_option"
                                    v-model="task.cloud_focus_catalog_task_types_id"
                                    required
                                    expanded
                                >
                                    <option
                                        v-for="task_type in options.task_types"
                                        :value="task_type.value"
                                        :key="task_type.value"
                                    >
                                        {{ task_type.text }}
                                    </option>
                                </b-select>
                            </div>
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-half">
                            <!-- Deadline -->
                            <div class="field">
                                <label class="label">
                                    {{ translations.tasks.form_task_deadline }}
                                    <sup class="has-text-danger">*</sup>
                                </label>
                                <div class="control">
                                    <vc-date-picker
                                        v-model="task.detail_attributes.deadline"
                                        :locale="date.vcDatepickerConfig()"
                                        :popover="{ visibility: 'focus' }"
                                        :min-date="new Date()"
                                    >
                                        <template v-slot="{ inputValue, inputEvents }">
                                            <input
                                                class="input is-default"
                                                v-on="inputEvents"
                                                :value="inputValue"
                                                :placeholder="translations.shared.text_select_date"
                                                required
                                            />
                                        </template>
                                    </vc-date-picker>
                                </div>
                            </div>
                        </div>

                        <div class="column is-half">
                            <!-- Importance -->
                            <div class="field">
                                <label class="label">
                                    {{ translations.tasks.form_task_importance }}
                                    <sup class="has-text-danger">*</sup>
                                </label>
                                <b-radio
                                    v-for="importance in options.importances"
                                    :key="importance.value"
                                    v-model="task.detail_attributes.importance"
                                    type="is-info"
                                    name="tasks-new-importance"
                                    :native-value="importance.value"
                                    required>
                                    {{ object_utils.translateEnum(translations.focus.tasks, 'column_enum_task_importance', importance.text) }}
                                </b-radio>
                            </div>
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-half">
                            <!-- Users -->
                            <component-users
                                v-if="options.users"
                                :user_id="lesli.current_user.id"
                                :users="options.users"
                                :focus="true"
                                :required="true"
                                @select="(user) => task.user_main_id = user.id"
                            >
                            </component-users>
                        </div>

                        <div class="column is-half">
                            <!-- Workflow -->
                            <b-field :label="translations.tasks.view_title_workflow" :message="translations.tasks.view_text_workflow_description">
                                <b-select
                                    v-model="task.cloud_focus_workflows_id"
                                    expanded
                                >
                                    <option :value="null">{{translations.tasks.view_placeholder_set_workflow_automatically}}</option>
                                    <option
                                        v-for="workflow in options.workflows"
                                        :value="workflow.value"
                                        :key="workflow.value"
                                    >
                                        {{ workflow.text }}
                                    </option>
                                </b-select>
                            </b-field>
                        </div>
                    </div>

                    <div class="field">
                        <label class="label">{{ translations.shared.send_email }}</label>
                        <b-checkbox v-model="task.send_email"></b-checkbox>
                    </div>

                    <div class="field">
                        <label class="label">{{ translations.tasks.form_task_description }}</label>
                        <div class="control">
                            <textarea v-model="task.detail_attributes.description" class="textarea" rows="6"></textarea>
                        </div>
                    </div>

                    <!-- Submit -->
                    <p class="control">
                        <button class="button is-primary">
                            <span v-if="submitting_form">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                &nbsp;
                                {{translations.shared.btn_saving}}
                            </span>
                            <span v-else>
                                {{translations.shared.btn_save}}
                            </span>
                        </button>
                    </p>
                </form>
            </fieldset>
        </div>
    </div>
</template>
