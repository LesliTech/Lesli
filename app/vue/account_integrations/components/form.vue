<script>

export default {
    data(){
        return {
            endpoint: "/administration/account/integrations",
            session: {},
            integration: {
                name: "Zapier"
            }
        }
    },
    methods: {

        postIntegration() {
            this.http.post(this.endpoint,{
                account_integration: this.integration
            }).then(result => {
                if (!result.successful) {
                    this.alert(result.error.message, "danger")
                    return 
                }
                this.alert("Integration created successfully")
                this.url.go(`${this.endpoint}/${result.data.id}`)
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <form @submit.prevent="postIntegration">
        <div class="field">
            <label class="label">Name</label>
                <div class="control">
                <input class="input" type="text" placeholder="" v-model="integration.name">
            </div>
        </div>
        <div class="field is-grouped">
            <div class="control">
                <button class="button is-link">Submit</button>
            </div>
        </div>
    </form>
</template>
