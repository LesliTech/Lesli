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


// · Component list
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentStatusName from 'LesliVue/shared/workflows/components/status-name.vue'

export default {
    components: {
        'component-status-name': componentStatusName
    },

    props: {
        selectedStatus: {
            required: true
        },

        statusForeignKey: {
            type: String,
            default: null
        },

        translationsPath: {
            default: null,
            type: String
        },

        cloudObjectVariable: {
            type: String,
            required: true
        },
        busSuffix: {
            type: String,
            default: ''
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
            this.bus.publish(`cancel:/status-change${this.busSuffix}`)
        },

        patchCloudObjectStatus(event){
            if(event){
                event.preventDefault()
            }
            
            this.bus.publish(`execute:/status-change${this.busSuffix}`, this.selectedStatus, ()=>{
                this.cancelStatusChange()
                // Reloading all important components when we change the status
                if(this.data.reload){
                    for(let key in this.data.reload){
                        this.data.reload[key] = true
                    }
                }

                // Setting the new status in the cloud_object_variable variable
                this.data[this.cloudObjectVariable].status = this.selectedStatus.name
                this.data[this.cloudObjectVariable].status_number = this.selectedStatus.number
                this.data[this.cloudObjectVariable].status_type = this.selectedStatus.status_type

                // This is for flexibility. This way the foreign key for the status can have any name
                if(this.statusForeignKey){
                    this.data[this.cloudObjectVariable][this.statusForeignKey] = this.selectedStatus.id
                }
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
