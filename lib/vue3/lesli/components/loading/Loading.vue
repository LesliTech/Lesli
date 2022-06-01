<script setup>
/*
Copyright (c) 2022, all rights reserved.

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


// · import vue tools
import { ref, reactive, onMounted, watch } from "vue"


// · defining props
const props = defineProps({
    size: {
        type: Number,
        default: 5
    },
    icon: {
        type: Boolean,
        default: false
    }
})


// · defining variables
const translations = {
    shared: I18n.t('core.shared')
}

</script>
<template>
    <div class="lesli-data-loading has-text-centered">
        <p>
            <span class="loading-animation">
                <hr/><hr/><hr/><hr/>
            </span>
            <span 
                v-if="!icon"
                :class="['is-size-'+size, 'ml-3']">
                {{ translations.shared.view_text_loading }}...
            </span>
        </p>
    </div>
</template>
