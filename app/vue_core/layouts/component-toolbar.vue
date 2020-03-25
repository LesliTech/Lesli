<script>
export default {
    props: {
        searchText: {
            default: "Search..."
        }
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
            if (this.text == "") return
            this.timer = setTimeout(() => this.$emit("search", this.text), 800)
        }
    }
}
</script>
<template>
    <div class="field is-grouped component-toolbar">
            <div class="control is-expanded">
                <input type="text" :placeholder="searchText" v-model="text" @input="search()" class="input is-shadowless">
            </div>
            <slot></slot>
        </div>
</template>
