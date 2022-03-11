<script>
export default {
    props: {
        component: Object
    }
}
</script>
<template>
    <div class="is-flex is-flex-direction-column is-justify-content-center">
        <h2><b>¡Welcome!</b></h2>
        <p>{{ lesli.current_user.full_name }}</p>
    </div>
</template>
<style lang="css" scoped>
    div {
        padding: 1rem 0;
        text-align: center;
        background-color: white;
    }
</style>
