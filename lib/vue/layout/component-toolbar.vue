<script>
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
    <div class="field is-grouped component-toolbar">
            <div class="control is-expanded has-icons-right">
                <input type="text" :placeholder="searchText" v-model="text" @input="search()" class="input is-shadowless">
                <span class="icon is-right">
                    <a class="delete" @click="clearSearch"></a>
                </span>
            </div>
            <slot></slot>
        </div>
</template>
