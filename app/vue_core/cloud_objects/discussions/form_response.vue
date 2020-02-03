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
                content: ''
            }
        }
    },

    mounted(){
        this.parseCloudModule()
    },

    methods: {

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        postDiscussion(e) {

            if (e) { e.preventDefault() }

            this.discussion[`cloud_${this.module_name.underscore}_${this.object_name.singular}_discussions_id`] = this.discussionId

            let request_data = {}
            request_data[`${this.object_name.singular}_discussion`] = this.discussion

            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions`
            this.http.post(url, request_data).then(result => {
                if (result.successful) {
                    this.discussion.content = ''
                }
                this.bus.$emit('post:components/forms/discussion')
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
