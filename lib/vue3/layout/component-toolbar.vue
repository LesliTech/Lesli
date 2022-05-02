<script>
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


// ·
export default {
    props: {
        searchText: {
            default: "Search..."
        },

        initialValue: {
            default: null
        }
    },
    mounted(){
        this.setInitialValue()
    },
    data() {
        return {
            timer: null,
            text: ""
        }
    },
    methods: {
        search() {
            clearTimeout(this.timer)
            this.timer = setTimeout(() => this.$emit("search", this.text), 800)
        },
        setInitialValue(){
            if(this.initialValue){
                this.text = this.initialValue
            }
        },
        clearSearch(){
            this.text = ''
            this.$emit("search", this.text)
        }
    }
}
</script>
<template>
    <div class="component-toolbar">
        <div class="field is-grouped component-toolbar">
            <div class="control is-expanded has-icons-right">
                <input type="text" name="search" :placeholder="searchText" v-model="text" @input="search()" class="input is-shadowless">
                <span class="icon is-right">
                    <a class="delete" @click="clearSearch"></a>
                </span>
            </div>
            <div class="select">
                <select>
                    <option>10</option>
                    <option>20</option>
                </select>
            </div>
            <slot></slot>
        </div>
    </div>
</template>
