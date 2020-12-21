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


// · Import core components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentForm from './files/form.vue'
import componentList from './files/list.vue'


// · 
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
        },
        translationsFileTypesPath: {
            type: String,
            default: null
        },
        acceptedFileExtensions: {
            type: Array,
            default: null
        }
    },

    components: {
        'component-form': componentForm,
        'component-list': componentList
    },

    data() {
        return {
            show: false,
            translations: {
                core: I18n.t('core.shared')
            },
            active_tab: 0
        }
    },

    mounted() {
        this.setSubscriptions()
        this.setTranslations()
    },

    beforeDestroy(){
        this.deleteSubscriptions()
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe('show:/module/app/files', () => this.show = !this.show )
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath)) 
        },

        deleteSubscriptions(){
            this.bus.$off('show:/module/app/files')
        },

        switchToList(){
            this.active_tab = 1
        }
    }
}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <div class="card-header-title is-shadowless">
                <h4 class=" title is-4">
                    {{translations.core.view_text_files}}
                </h4>
            </div>
        </div>
        <div class="card-content">
            <b-tabs expanded v-model="active_tab">
                <b-tab-item :label="translations.core.view_tab_title_files_new">
                    <component-form
                        :cloud-module="cloudModule"
                        :cloud-id="cloudId"
                        :active="active"
                        @upload-complete="switchToList"
                        :translations-file-types-path="translationsFileTypesPath"
                        :accepted-file-extensions="acceptedFileExtensions"
                    />
                </b-tab-item>
                <b-tab-item :label="translations.core.view_tab_title_files_list">
                    <component-list
                        :cloud-module="cloudModule"
                        :cloud-id="cloudId"
                        :active="active"
                        :translations-file-types-path="translationsFileTypesPath"
                    />
                </b-tab-item>
            </b-tabs>
        </div>
    </div>
</template>
