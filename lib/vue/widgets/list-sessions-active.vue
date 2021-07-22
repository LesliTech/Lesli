<script>
export default {
    props: {
        component: Object
    },
    data() {
        return {
            sessions: {}
        }
    },
    mounted() {
        this.getSessions()
    },
    methods: {

        getSessions() {
            this.http.get(this.url.admin("users/:user_id/sessions", { user_id: 8 })).then(result => {
                if (!result.successful) { return; }
                this.sessions = result.data
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h3 class="card-header-title">{{ component.name }}</h3>
        </div>
        <div class="card-content">
            <b-table 
                :data="sessions.records" 
                :columns="[
                    { field:'user_agent', label: 'devise'},
                    { field:'created_at_date', label: 'date'},
                ]">
            </b-table>
        </div>
    </div>
</template>
