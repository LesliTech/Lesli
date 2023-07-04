<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, watch, computed, useSlots, provide } from "vue"


// · defining props
const props = defineProps({
    label: {
        type: String,
        required: false
    },
    icon: {
        type: String,
        required: false
    }
})


// · 
const open = ref(false)


</script>
<template>
    <li :class="['lesli-navigation-list', {'active': open}]">
        <a @click.stop="open = !open" class="lesli-navigation-list-label">
            <span v-if="props.icon" :class="[props.icon, 'icono']"></span>
            <span class="text">{{ props.label }}</span>
            <span class="chevron">
                <span v-if="!open" class="material-icons md-24">
                    chevron_right
                </span>
                <span v-if="open" class="material-icons md-24">
                    expand_more
                </span>
            </span>
        </a>
        <ul>
            <slot></slot>
        </ul>
    </li>
</template>
