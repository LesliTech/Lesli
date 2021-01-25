<script>
export default {
    data() {
        return {
            endpoint: "/administration/account/integrations",
            integration: {},
            id: null,
        }
    },
    mounted() {
        this.id = this.$route.params.id
        this.getIntegration()
    },
    methods: {

        getIntegration() {
            this.http.get(`${this.endpoint}/${this.id}.json`).then(result => {
                this.integration = result.data
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="integration.name"></component-header>
        <div class="card">
            <div class="card-content" v-if="integration.session">
                <p>Token: {{ integration.session.session_token }}</p>
                <p>Usage count: {{ integration.session.usage_count }}</p>
            </div>
        </div>
    </section>
</template>
