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


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },

        cloudId: {
            required: true
        },

        active: {
            type: Boolean,
            default: true
        }
    },

    data() {
        return {
            activities: null,
            module_name: {
                slash: null,
                underscore: null
            },
            object_name: {
                singular: null,
                plural: null
            },
            translations: {
                core: I18n.t('core.shared')
            },
            loading: false
        }
    },

    mounted() {
        this.parseCloudModule()
        this.setTranslations()
        this.getBackendData()
    },

    methods: {

        getBackendData(){
            if(this.active){
                this.getActivities()
            }
        },

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(`${this.module_name.slash}.${this.object_name.singular}/activities`))
            this.$set(this.translations, 'workflow_statuses', I18n.t(`${this.module_name.slash}.workflow/statuses`))
        },

        getActivities() {
            this.loading = true
            if(this.cloudId){
                let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/activities.json`
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.activities = result.data
                        this.loading = false
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    },

    watch: {
        cloudId(){
            this.getActivities()
        },

        'data.reload.activities'(){
            if(this.data.reload.activities){
                this.data.reload.activities = false
                if(this.activities){
                    this.getActivities()
                }
            }
        },

        active(){
            if(! this.activities){
                this.getBackendData()
            }
        }
    }
}
</script>
<template>
    <section>
        <div class="timeline section" v-if="loading">
            <component-data-loading>
            </component-data-loading>
        </div>
        <div class="timeline section" v-else>
            <div class="timeline-item" v-for="activity in activities" :key="activity.id">
                <div class="timeline-marker" v-if="!activity.icon"></div>
                <div class="timeline-marker is-icon" v-if="activity.icon">
                    <i :class="['fa', 'fa-' + activity.icon]"></i>
                </div>
                <div class="timeline-content">
                    <p class="heading">{{activity.user_name}} - {{ activity.created_at }}</p>
                    <p>
                        {{
                            object_utils.translateEnum(translations.core, 'column_enum_activities', activity.category, null) ||
                            object_utils.translateEnum(translations.main, 'column_enum', activity.category)
                        }}
                        <span v-if="activity.description && activity.description.length > 0">
                            - {{
                                object_utils.translateEnum(translations.core, 'column_enum_status', activity.description, null) ||
                                object_utils.translateEnum(translations.workflow_statuses, 'column_enum_status', activity.description)
                            }}
                        </span>
                    </p>
                    <span v-if="activity.category == 'action_update'">
                        {{activity.field_name}}: ({{activity.value_from || 'null'}}) - ({{activity.value_to}}) 
                    </span>
                </div>
            </div>
        </div>
    </section>
</template>
<style scoped>
.timeline {
    max-height: 30rem;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: thin;
    scrollbar-color: #ffffff #ffffff;
}
</style>
