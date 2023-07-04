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
import { ref, reactive, onMounted, watch, computed } from "vue"

// · defining emits
const emit = defineEmits(['open']);

/**
 * The only true button.
 * @displayName lesli-collapse
 */

// · defining props
const props = defineProps({
    loading: {
        /**
         * An indicator when data is loading
         * @values true, false
         */
        type: Boolean,
        default: false
    },
    open: {
        /**
         * An indicator when the collapse card
         * is open
         * @values true, false
         */
        type: Boolean,
        default: false
    },
    title: {/**
         * The title to show on card's header
         * @values any string
         */
        type: String,
        default: 'Collapse Title'
    }
})

</script>
<template>
    <div class="collapse card">
        <div 
            v-on:click="emit('open')"
            class="card-header"
            style="cursor: pointer"
            role="button">
            <p class="card-header-title">
                {{ props.title }}
            </p>
            <a class="card-header-icon">
                <span class="icon">
                    <span class="material-icons" v-if="props.open">arrow_upward</span>
                    <span class="material-icons" v-if="!props.open">arrow_downward</span>
                </span>
            </a>
        </div>
        <div v-show="open" class="card-content">
            <slot></slot>
        </div>
    </div>
</template>
