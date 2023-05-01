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
