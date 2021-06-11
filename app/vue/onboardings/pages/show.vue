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

        <div class="modal is-active">
            <div class="modal-background"></div>
            <div class="modal-content">
                <b-steps type="is-info">
                    <b-step-item label="Account" icon="account-key"></b-step-item>
                    <b-step-item label="Profile" icon="account-key"></b-step-item>
                    <b-step-item label="Socials" icon="account-key"></b-step-item>
                </b-steps>
            </div>
            <button class="modal-close is-large" aria-label="close"></button>
        </div>

    </section>
</template>


