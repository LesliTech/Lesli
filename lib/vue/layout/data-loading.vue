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
    data() {
        return {
            translations: {
                shared: I18n.t('deutscheleibrenten.shared')
            },
        }
    },
    props: {
        size: {
            default: "4"
        },
        iconOnly: {
            default: false
        }
    }
}
</script>
<template>
    <div class="component-data-loading has-text-centered">
        <span v-if="iconOnly" class="loading-animation">
            <hr/><hr/><hr/><hr/>
        </span>
        <p v-if="!iconOnly">
            <span class="loading-animation">
                <hr/><hr/><hr/><hr/>
            </span>
            <span :class="'is-size-'+size">{{ translations.shared.text_loading }}...</span>
        </p>
    </div>
</template>
