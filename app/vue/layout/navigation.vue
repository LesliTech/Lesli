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
                <slot></slot>
            </div>
            <div class="navbar-end">
                <router-link class="navbar-item" v-if="id" :to="`/${ id }/show`">Details</router-link>
                <router-link class="navbar-item" v-if="id" :to="`/${ id }/discussion`">Discussion</router-link>
                <router-link class="navbar-item" v-if="id" :to="`/${ id }/actions`">Actions</router-link>
                <router-link class="navbar-item" v-if="id" :to="`/${ id }/show`">Files</router-link>
                <router-link class="navbar-item" v-if="id" :to="`/${ id }/show`">Logs</router-link>
            </div>
        </div>
    </nav>
</template>
