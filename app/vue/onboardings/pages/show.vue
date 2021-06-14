<script>
export default {
    data() {
        return {
            isComponentModalActive: true
        }
    },
    mounted() {
        console.log("works")
    }
}
</script>
<template>
    <section class="application-component">

        <b-steps type="is-info" icon-pack="fas">
            <b-step-item icon="building"></b-step-item>
            <b-step-item icon="account-key"></b-step-item>
            <b-step-item icon="account-key"></b-step-item>
        </b-steps>

    </section>
</template>


