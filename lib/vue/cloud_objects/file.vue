<script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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
        translationsPath: {
            type: String,
            default: 'core.shared'
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
                core: I18n.t('deutscheleibrenten.shared')
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
    <b-tabs expanded v-model="active_tab" v-if="translations.main">
        <b-tab-item :label="translations.main.files_title_new">
            <component-form
                :cloud-module="cloudModule"
                :cloud-id="cloudId"
                :active="active"
                @upload-complete="switchToList"
                :translations-path="translationsPath"
                :translations-file-types-path="translationsFileTypesPath"
                :accepted-file-extensions="acceptedFileExtensions"
            />
        </b-tab-item>
        <b-tab-item :label="translations.main.files_title_list">
            <component-list
                :cloud-module="cloudModule"
                :cloud-id="cloudId"
                :active="active"
                :translations-path="translationsPath"
                :translations-file-types-path="translationsFileTypesPath"
            />
        </b-tab-item>
    </b-tabs>
</template>
