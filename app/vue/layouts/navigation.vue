<script>
export default {
    data() {
        return {
            id: null
        }
    },
    mounted() {
        if (this.$route && this.$route.params.id) {
            this.id = this.$route.params.id
        }
    },
    methods: {
        showActions() {
            this.bus.$emit("show:/module/app/actions")
        },
        showFiles() {
            console.log('emiting....')
            this.bus.$emit("show:/module/app/files")
        }
    },
    watch: {
        '$route.params.id': function (id) {
            this.id = id
        }
    }
}
</script>
<template>
    <nav class="module-navigation navbar is-transparent">
        <div class="navbar-menu">
            <div class="navbar-start">
                <slot name="right"></slot>
            </div>
            <div class="navbar-end">
                <slot name="left"></slot>
                <a class="navbar-item" v-if="id" @click="showActions">Actions</a>
                <a class="navbar-item" v-if="id" @click="showFiles()">Files</a>
                <a class="navbar-item" v-if="id" @click="showActions">Activities</a>
            </div>
        </div>
    </nav>
</template>
