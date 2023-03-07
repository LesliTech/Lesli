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
import { ref, watch, onMounted } from "vue"


// · defining emits
const emit = defineEmits(['submit']);


// · defining props
const props = defineProps({})

</script>
<template>
    <form class="lesli-form" @submit.prevent="emit('submit')">
        <fieldset>
            <slot></slot>
        </fieldset>
    </form>
</template>
