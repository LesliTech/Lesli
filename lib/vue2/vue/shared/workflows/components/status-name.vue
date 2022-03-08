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
        name: {
            type: String,
            default: ''
        },
        translationsPath: {
            type: String,
            default: null
        }
    },

    data() {
        return {
            translations: {
                core: I18n.t('core.shared')
            },
        }
    },

    mounted(){
        if(this.translationsPath){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        }
    },

    methods: {
        translateStatus(status_name){
            let translated_status = this.object_utils.translateEnum(this.translations.main, 'status', status_name, null)
            if(! translated_status){
                translated_status = this.object_utils.translateEnum(this.translations.main, 'column_enum_status', status_name, null)
            }
            if(! translated_status){
                translated_status = this.object_utils.translateEnum(this.translations.core, 'column_enum_status', status_name)
            }

            return translated_status
        }
    }
}
</script>
<template>
    <span>
        {{translateStatus(name)}}
    </span>
</template>
