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
const emit = defineEmits(['search']);


// · defining props
const props = defineProps({
    searchPlaceholder: {
        type: String,
        default: "Search..."
    },
    initialValue: {
        type: String,
        default: null
    },
    pagination: {
        type: Object,
        required: false
    }
})


// · define variables
const timer = reactive(setTimeout)
const text = ref("")


// · Methods
function search() {
    clearTimeout(timer.value)
    timer.value = setTimeout(() => emit("search", text.value), 800)
}

function setInitialValue(){
    if(this.initialValue){
        //this.text = this.initialValue
    }
}

function clearSearch(){
    text.value = ''
    emit("search", text.value)
}


// · Initializing
onMounted(() => {

})

</script>
<template>
    <div class="component-toolbar">
        <div class="field is-grouped lesli-toolbar">
            <div class="control is-expanded has-icons-right has-icons-left">
                <input 
                    type="text" 
                    name="search" 
                    class="input is-shadowless"
                    v-model="text" 
                    :placeholder="searchPlaceholder" 
                    @input="search()">
                <span class="icon is-small is-left">
                    <span class="material-icons">
                        search
                    </span>
                </span>
                <span class="icon is-right">
                    <a class="delete" @click="clearSearch"></a>
                </span>
            </div>
            <slot></slot>
            <div class="select" v-if="props.pagination">
                <select>
                    <option>10</option>
                    <option>20</option>
                </select>
            </div>
        </div>
    </div>
</template>
