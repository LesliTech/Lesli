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
            <b-step-item icon="building">
                <div class="card">
                    <div class="card-content">
                        <h1><strong>Welcome to Lesli configuration wizard</strong></h1>
                        <br />
                        <p>Here you will be able to set information about your account and other configuration</p>
                    </div>
                </div>
            </b-step-item>
            <b-step-item icon="account-key"></b-step-item>
            <b-step-item icon="account-key"></b-step-item>
        </b-steps>

    </section>
</template>


