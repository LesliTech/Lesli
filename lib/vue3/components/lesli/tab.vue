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
import { ref, reactive, onMounted, watch, computed } from "vue"


// · defining props
const props = defineProps({
    loading: {
        type: Boolean,
        default: false
    },
    columns: {
        type: Array,
        required: true
    },
    data: {
        type: Array,
        required: true
    }
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
    <div class="tabs">
        <ul>
            <li class="is-active">
                <a>
                    <span class="icon is-small"><i class="fas fa-image" aria-hidden="true"></i></span>
                    <span>Pictures</span>
                </a>
            </li>
            <li>
                <a>
                    <span class="icon is-small"><i class="fas fa-music" aria-hidden="true"></i></span>
                    <span>Music</span>
                </a>
            </li>
            <li>
                <a>
                    <span class="icon is-small"><i class="fas fa-film" aria-hidden="true"></i></span>
                    <span>Videos</span>
                </a>
            </li>
            <li>
                <a>
                    <span class="icon is-small"><i class="far fa-file-alt" aria-hidden="true"></i></span>
                    <span>Documents</span>
                </a>
            </li>
        </ul>
    </div>
</template>
