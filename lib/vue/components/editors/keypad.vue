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
}

function accept(event) {
    event.preventDefault();
    active.value = false
    emit('update:active', active.value)
}

function clear(event) {
    event.preventDefault();
    texto.value = ""
}

function backspace(event) {
    event.preventDefault();
    texto.value = texto.value.slice(0, -1);
}

onMounted(() => {
    active.value = props.active
})

watch(() => props.active, () => active.value = props.active)

watch(() => texto.value, () => emit('update:modelValue', texto.value))

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
                        <button @click="accept">
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
                        <button @click="clear">
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
                        <button @click="backspace">
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
