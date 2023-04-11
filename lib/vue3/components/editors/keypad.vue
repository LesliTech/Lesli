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
import { ref, reactive, onMounted, watch, getCurrentInstance } from "vue"


// · defining props
const props = defineProps({
    modelValue: {
        type: String,
        required: false,
    },
    active: {
        type: Boolean,
        required: false,
        default: false
    }
})

const emit = defineEmits(['update:modelValue', 'update:active'])

const texto = ref("")

const active = ref(false)

function addValue(event) {
    event.preventDefault();

    texto.value += event.target.innerHTML 

    emit('update:modelValue', texto.value)
}

function accept() {
    active.value = false
    emit('update:active', active.value)
}

onMounted(() => {
    active.value = props.active
})

watch(() => props.active, () => active.value = props.active)

</script>
<template>
    <div v-if="active" class="component-keypad">
        <table class="table is-fullwidth">
            <tbody>
                <tr>
                    <td><button @click="addValue">1</button></td>
                    <td><button @click="addValue">2</button></td>
                    <td><button @click="addValue">3</button></td>
                    <td rowspan="2" class="keypad-action-accept">
                        <button @click="accept()">
                            <span class="material-icons">
                                done
                            </span>
                        </button>
                    </td>
                </tr>
                <tr>
                    <td><button @click="addValue">4</button></td>
                    <td><button @click="addValue">5</button></td>
                    <td><button @click="addValue">6</button></td>
                </tr>
                <tr>
                    <td><button @click="addValue">7</button></td>
                    <td><button @click="addValue">8</button></td>
                    <td><button @click="addValue">9</button></td>
                    <td class="keypad-action-clear">
                        <button @click="addValue">
                            <span class="material-icons">
                                clear
                            </span>
                        </button>
                    </td>
                </tr>
                <tr>
                    <td><button @click="addValue">,</button></td>
                    <td><button @click="addValue">0</button></td>
                    <td><button @click="addValue">.</button></td>
                    <td class="keypad-action-backspace">
                        <button>
                            <span class="material-icons">
                                backspace
                            </span>
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>
