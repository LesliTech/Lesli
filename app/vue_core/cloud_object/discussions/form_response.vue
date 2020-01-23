<script>
export default {
    props: {
        focus: {
            required: true
        },
        cloudModule: {
            type: String,
            required: true
        },
        cloudId: {
            required: true
        },
        discussionId: {
            required: true
        }
    },

    data() {
        return {
            module_name: null,
            object_name: null,
            discussion: {
                content: ""
            }
        }
    },

    mounted(){
        this.parseCloudModule()
    },

    methods: {

        parseCloudModule(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },

        postDiscussion(e) {

            if (e) { e.preventDefault() }

            // converts a string like 'help/ticket' to 'help_ticket'
            let module_prefix = this.cloudModule.replace('/','_')

            // add object id, i.e. 'cloud_help_tickets_id
            this.discussion[`cloud_${module_prefix}s_id`] = this.cloudId

            // add comment id, i.e. 'cloud_help_ticket_discussions_id
            this.discussion[`cloud_${module_prefix}_discussions_id`] = this.discussionId

            let request_data = {}
            request_data[`${this.object_name}_discussion`] = this.discussion

            this.http.post(`/${this.cloudModule}s/${this.cloudId}/discussions`, request_data).then(result => {
                if (result.successful) {
                    this.discussion.content = ""
                }
                this.bus.$emit("post:components/forms/discussion")
            }).catch(error => {
                console.log(error)
            })

        }
    },
    watch: {
        focus(){
            if(this.focus){
                this.$refs.input.focus()
            }
        }
    }
}
</script>
<template>
    <section>
        <form @submit="postDiscussion">
            <div class="field is-expanded is-floating-label has-addons" size="is-small">
                <label class="label"> Add a response </label>
                <div class="control is-clearfix is-expanded is-small">
                    <input class="input" type="input" autocomplete="on" ref="input" v-model="discussion.content"/>
                </div>
                <p class="control">
                    <button class="button is-primary" type="submit" :disabled="discussion.content == ''">
                        Respond
                    </button>
                </p>
            </div>
        </form>
    </section>
</template>
