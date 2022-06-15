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
import { ref, reactive, onMounted, watch, computed, getCurrentInstance } from "vue"


// · defining props
const props = defineProps({
    title: {
        type: String,
        default: null
    }
})

</script>
<template>
    <nav class="navbar lesli-header">
        <div class="navbar-brand">
            <div class="navbar-item">
                <h2 v-if="title">{{ title }}</h2>
            </div>
        </div>
        <div class="navbar-menu">
            <div class="navbar-end">
                <div class="navbar-item">
                    <div class="buttons">
                        <slot></slot>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</template>
