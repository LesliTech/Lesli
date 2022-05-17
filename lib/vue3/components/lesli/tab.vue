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
import { ref, reactive, onMounted, watch, computed, useSlots } from "vue"


// · gettings slots
const slots = useSlots().default()

console.log(slots)



// · defining props
const props = defineProps({

})


// · define variables



// prepaer the CSS classes for every column in the header
function tableHeaderClass(column) {
    return {
        'has-text-centered': column.field == 'id'
    }
}

// prepaer the CSS classes for every column in the header
function tableBodyClass(column) {
    return {
        'has-text-centered': column.field == 'id'
    }
}

</script>
<template>
    <div class="lesli-tab">
        <div class="tabs">
            <ul>
                <li v-for="(item, index) in slots">
                    <a>
                        <span v-if="!!item.props.icon" class="icon is-small">
                            <span class="material-icons">
                                {{ item.props.icon }}
                            </span>
                        </span>
                        <span>{{ item.props.title }}</span>
                    </a>
                </li>
            </ul>
        </div>
        <div class="tab-items">
            <slot></slot>
        </div>
    </div>
</template>
