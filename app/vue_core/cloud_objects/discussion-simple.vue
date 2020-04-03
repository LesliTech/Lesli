<script>
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },

        cloudId: {
            required: true
        }
    },

    data(){
        return {
            module_name: null,
            object_name: null,
            loading: false,
            search: '',
            discussion: {
                content: ''   
            },
            pagination: {
                current_page: 1,
                range_before: 3,
                range_after: 3,
                per_page: 6
            },
            discussions: []
        }
    },

    mounted(){
        this.parseCloudModule()
        this.getDiscussions()
    },

    methods: {
        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        getDiscussions() {
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions.json`
            this.loading = true

            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.discussions = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postDiscussion(event) {
            if(event){
                event.preventDefault() 
            }

            let form_data = {}
            form_data[`${this.object_name.singular}_discussion`] = this.discussion
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions`

            this.http.post(url, form_data).then(result => {
                if (result.successful) {
                    this.notification.alert('Comment added successfully', 'success')
                    this.clearContentInput()
                    this.discussions.unshift({
                        data: result.data,
                        responses: []
                    })
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })

        },

        clearContentInput(event){
            if(event){
                event.preventDefault()
            }
            
            this.discussion.content = ''
        },

        clearSearch(event){
            if(event){
                event.preventDefault()
            }
            
            this.search = ''
        },
        
        confirmCommentDeletion(comment) {
            this.$buefy.dialog.confirm({
                title: 'Deleting comment',
                message: 'Are you sure you want to <b>delete</b> this comment? This action cannot be undone.',
                confirmText: 'Delete Comment',
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteComment(comment)
            })
        },

        putComment(comment){
            let form_data = {}
            form_data[`${this.object_name.singular}_discussion`] = {
                content: comment.data.new_content
            }
            let comment_id = comment.data.id
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions/${comment_id}`

            this.http.put(url, form_data).then(result => {
                if (result.successful) {
                    this.$set(comment.data, 'content', comment.data.new_content)
                    this.$set(comment.data, 'editable', false)
                    this.alert('Comment updated successfully', 'success')
                    
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteComment(comment){
            let comment_id = comment.data.id
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions/${comment_id}`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.alert('Comment deleted successfully', 'success')
                    this.discussions = this.discussions.filter((discussion)=>{
                        return discussion.data.id != comment.data.id
                    })
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        showCommentEditForm(comment){
            this.editable_comment = comment
            this.$set(comment.data, 'new_content', comment.data.content)
            this.$set(comment.data, 'editable', true)
            this.$nextTick(()=>{
                this.$refs[`comment-input-${comment.data.id}`].focus()
            })
        }
    },

    computed: {
        filteredDiscussions(){
            let search_field = this.search.toLowerCase()
            this.pagination.current_page = 1
            return this.discussions.filter((discussion)=>{
                return discussion.data.email.toLowerCase().includes(search_field) ||
                    (
                        discussion.data.employee_name &&
                        discussion.data.employee_name.toLowerCase().includes(search_field)
                    ) ||
                    discussion.data.content.toLowerCase().includes(search_field)
            })
        },

        currentDiscussionPage(){
            if(this.filteredDiscussions.length <= this.pagination.per_page){
                return this.filteredDiscussions
            }else{
                let data = this.filteredDiscussions.slice(
                    (this.pagination.current_page - 1) * this.pagination.per_page,
                    (this.pagination.current_page) * this.pagination.per_page
                )
                return data
            }
        }
    },

    watch: {
        cloudId(){
            this.getDiscussions()
        }
    }
}
</script>
<template>
    <section>
        <form @submit="postDiscussion">
            <b-field grouped>
                <b-input required placeholder="Add a new comment" ref="input-comment" v-model="discussion.content" expanded>
                </b-input>
                <p class="control">
                    <b-button type="is-primary" native-type="submit">Save</b-button>
                </p>
            </b-field>
        </form>
        <br>
        <div class="columns">
            <div class="column is-6">
                <b-field>
                    <b-input placeholder="Search for a comment"
                        v-model="search"
                        type="text"
                        icon="search"
                        icon-right="close-circle"
                        icon-right-clickable
                        @icon-right-click="clearSearch">
                    </b-input>
                </b-field>
            </div>
        </div>
        <component-data-loading v-if="loading" />
        <component-data-empty v-if="!loading && discussions.length == 0" />
        <b-table v-if="discussions.length > 0" :data="currentDiscussionPage">
            <template slot-scope="props">
                <b-table-column field="created_at" label="Creation date" sortable>
                    {{ props.row.data.created_at }}
                </b-table-column>

                <b-table-column field="user_name" label="Employee">
                    <span v-if="props.row.data.user_name">
                        {{props.row.data.user_name}}
                    </span>
                    <span v-else>
                        {{props.row.data.email}}
                    </span>
                </b-table-column>

                <b-table-column field="content" label="Comment">
                    <span v-if="props.row.data.editable">
                        <b-field>
                            <b-input
                                type="textarea"
                                size="is-small"
                                v-model="props.row.data.new_content"
                                :ref="`comment-input-${props.row.data.id}`"
                            >
                            </b-input>
                        </b-field>
                    </span>
                    <span v-else>
                        {{ props.row.data.content }}
                    </span>
                </b-table-column>

                <b-table-column field="actions" label="Actions" class="has-text-right">
                    <span v-if="props.row.data.editable">
                        <b-button outlined @click="putComment(props.row)">
                            <b-icon size="is-small" icon="check" />
                        </b-button>
                        <b-button type="is-danger" outlined @click="() => $set(props.row.data, 'editable', false)">
                            <b-icon size="is-small" icon="times" />
                        </b-button>
                    </span>
                    <span v-else>
                        <b-button outlined @click="showCommentEditForm(props.row)">
                            <b-icon size="is-small" icon="edit" />
                        </b-button>
                        <b-button type="is-danger" outlined @click="confirmCommentDeletion(props.row)">
                            <b-icon size="is-small" icon="trash-alt" />
                        </b-button>
                    </span>
                </b-table-column>
            </template>
        </b-table>
        <hr>
        <b-pagination
            :simple="false"
            :total="filteredDiscussions.length"
            :current.sync="pagination.current_page"
            :range-before="pagination.range_before"
            :range-after="pagination.range_after"
            :per-page="pagination.per_page"
            order="is-centered"
            icon-prev="chevron-left"
            icon-next="chevron-right"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-page-label="Page"
            aria-current-label="Current page"
        >
        </b-pagination>
    </section>
</template>
