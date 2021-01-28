<script>
export default {
    data() {
        return {
            endpoint: "/administration/account/integrations",
            columns:[{
                field: 'id',
                label: 'ID',
                width: '40',
                numeric: true
            }, {
                field: 'name',
                label: 'Name',
            }, {
                field: 'active',
                label: 'Active',
            }, {
                field: 'usage_count',
                label: 'Usage count',
            }, {
                field: 'last_used_at',
                label: 'Last used at',
            }, {
                field: 'expiration_at',
                label: 'Expiration date',
            }],
            integrations: []
        }
    },

    mounted() {
        this.getIntegrations()
    },

    methods: {

        getIntegrations() {
            this.http.get(this.endpoint.concat(".json")).then(result => {
                if (!result.successful) {
                    return
                }
                this.integrations = result.data
            }).catch(error => {
                console.log(error)
            })
        },

        showIntegration(integration) {
            this.$router.push(`${integration.id}`)
        }

    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="Integrations">
            <router-link to="/new" class="button is-primary">
                Add integration
            </router-link>
        </component-header>
        <div class="card">
            <div class="card-content">
                <b-table 
                    @click="showIntegration"
                    :data="integrations" 
                    :columns="columns">
                </b-table>
            </div>
        </div>
    </section>
</template>
