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


// · 
const emit = defineEmits(['update:open', 'open']);


// · 
const props = defineProps({
    open: {
        type: Boolean,
        default: false
    }
})


const isOpen = ref(false)


// · 
watch(() => props.open, value => isOpen.value = value)


// · 
function close() {
    console.log("closing")
    emit('update:open', false)
    emit('open', false)
}

</script>
<template>
    <section class="lesli-panel">
        <Transition>
            <div 
                v-if="isOpen" 
                class="lesli-panel-background"
                @click="close">
            </div>
        </Transition>
        <Transition>
            <div v-show="isOpen" class="lesli-panel-content box p-0">
                <div class="lesli-panel-header is-flex py-3 px-4">
                    <div class="is-flex-grow-1">
                        <h4>
                            <slot name="header"></slot>
                        </h4>
                    </div>
                    <div>
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
