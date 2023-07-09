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


// · 
const emit = defineEmits(['update:open', 'open']);


// · 
const props = defineProps({
    open: {
        type: Boolean,
        default: false
    },
    title: {
        type: String,
        required: false
    },
    overlay: {
        type: Boolean,
        required: false,
        default: true
    }
})


const isOpen = ref(false)


// · 
watch(() => props.open, value => isOpen.value = value)


// · 
function close() {
    emit('update:open', false)
    emit('open', false)
}

</script>
<template>
    <section class="lesli-panel">
        <Transition>
            <div 
                v-if="isOpen" 
                :class="[{ 'lesli-panel-background': props.overlay }]"
                @click="close">
            </div>
        </Transition>
        <Transition>
            <div v-show="isOpen" class="lesli-panel-content box p-0">
                <div class="lesli-panel-header is-flex px-4">
                    <div class="is-flex-grow-1">
                        <h4>
                            <slot name="header"></slot>
                            {{ props.title }}
                        </h4>
                    </div>
                    <div class="hover" @click="close">
                        <span class="material-icons md-24">
                            arrow_forward_ios
                        </span>
                    </div>
                </div>
                <slot></slot>
            </div>
        </Transition>
    </section>
</template>
