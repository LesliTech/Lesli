<script setup>
/*

Copyright (c) 2023, all rights reserved.

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
import { onMounted, inject, ref } from "vue"


// · 
const props = defineProps({
    title: {
        type: String, 
        require: false,
        default: ""
    }
})

</script>
<template>
    <div class="card">
        <div class="card-content p-3">
            <div class="content help">
                <h6 class="title is-6 has-text-centered mb-2">
                    {{ props.title }}
                </h6>
                <slot></slot>
            </div>
        </div>
    </div>
</template>
