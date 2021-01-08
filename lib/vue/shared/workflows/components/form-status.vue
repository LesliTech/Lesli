<script>
import componentStatusName from 'LesliCoreVue/cloud_objects/workflows/components/status-name.vue'

export default {
    components: {
        'component-status-name': componentStatusName
    },

    props: {
        selectedStatus: {
            required: true
        },

        translationsPath: {
            default: null,
            type: String
        },

        cloudObjectVariable: {
            type: String,
            required: true
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            },
            saving_status: false
        }
    },

    mounted(){
    },

    methods: {
        cancelStatusChange(){
            this.bus.publish('cancel:/status-change')
        },

        patchCloudObjectStatus(event){
            if(event){
                event.preventDefault()
            }
            
            this.bus.publish('execute:/status-change', this.selectedStatus, ()=>{
                this.cancelStatusChange()
                // Reloading timelines and activities when we change the status
                this.data.reload.timelines = true
                this.data.reload.activities = true

                // Setting the new status in the cloud_object_variable variable
                this.data[this.cloudObjectVariable].status = this.selectedStatus.name
                this.data[this.cloudObjectVariable].status_number = this.selectedStatus.number
                this.data[this.cloudObjectVariable].status_type = this.selectedStatus.status_type
            })
        },
    }
}
</script>
<template>
    <div class="card box" v-if="selectedStatus">
        <form @submit="patchCloudObjectStatus">
            <h4 class="title is-5">
                {{translations.core.view_title_change_status}}:
                <component-status-name :translations-path="translationsPath" :name="selectedStatus.name">
                </component-status-name>
            </h4>
            <div class="buttons justify-content-right">
                <b-button type="is-primary" native-type="submit" :disabled="saving_status" class="submit-button">
                    <span v-if="saving_status">
                        <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                        &nbsp;
                        {{translations.core.view_btn_saving}}
                    </span>
                    <span v-else>
                        {{translations.core.view_btn_save}}
                    </span>
                </b-button>
                <b-button type="is-danger" native-type="button" :disabled="saving_status" class="submit-button" @click="cancelStatusChange">
                    {{translations.core.view_btn_cancel}}
                </b-button>
            </div>
        </form>
    </div>
</template>
