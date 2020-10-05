<script>
export default {
    data() {
        return {
            endpoint: "/panel/account/integrations",
            columns:[{
                field: 'id',
                label: 'ID',
                width: '40',
                numeric: true
            }, {
                field: 'name',
                label: 'Name',
            }],
            integrations: []
        }
    },

    methods: {

        getIntegrations() {
            this.http.get(this.endpoint).then(result => {
                if (!result.successful) {
                    return
                }
                this.integrations = result.data
            }).catch(error => {
                console.log(error)
            })
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
                <b-table :data="integrations" :columns="columns"></b-table>
            </div>
        </div>
    </section>
</template>
