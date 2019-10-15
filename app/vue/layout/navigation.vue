<script>
export default {
    
}
</script>
<template>
    <nav class="module-navigation navbar is-transparent">
        <div class="navbar-menu">
            <div class="navbar-start">
                <slot></slot>
            </div>
            <div class="navbar-end">
                <router-link class="navbar-item" to="/1/show">Details</router-link>
                <router-link class="navbar-item" to="/1/edit">Edit</router-link>
                <router-link class="navbar-item" to="/1/discussion">Discussion</router-link>
                <a href="" class="navbar-item">Actions</a>
                <a href="" class="navbar-item">Files</a>
                <a href="" class="navbar-item">Logs</a>
            </div>
        </div>
    </nav>
</template>
