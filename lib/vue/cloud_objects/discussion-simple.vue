<script>
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },

        cloudId: {
            required: true
        },

        translationsPath: {
            type: String,
            required: true
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            },
            module_name: null,
            object_name: null,
            loading: false,
            search: '',
            discussion: {
                content: ''   
            },
            sort: {
                icon_size: 'is-small',
                direction: 'desc'
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
        this.setTranslations()
        this.getDiscussions()
    },

    methods: {
        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
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
                    this.alert(this.translations.main.notification_discussion_created, 'success')
                    this.bus.publish(`post:/${this.module_name.slash}/${this.object_name.plural}/discussions`, result.data)
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
                title: this.translations.main.discussions_delete_confirmation_title,
                message: this.translations.main.discussions_delete_confirmation_body,
                confirmText: this.translations.main.discussions_delete_confirmation_accept_button,
                cancelText: this.translations.main.discussions_delete_confirmation_cancel_button,
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteComment(comment)
            })
        },

        putDiscussion(comment){
            let form_data = {}
            form_data[`${this.object_name.singular}_discussion`] = {
                content: comment.data.new_content
            }
            let comment_id = comment.data.id
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions/${comment_id}`

            this.http.put(url, form_data).then(result => {
                if (result.successful) {
                    this.$set(comment.data, 'content', comment.data.new_content)
                    this.$set(comment.data, 'editing', false)
                    this.bus.publish(`put:/${this.module_name.slash}/${this.object_name.plural}/discussions`, result.data)
                    this.alert(this.translations.main.notification_discussion_updated, 'success')
                    
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
                    this.alert(this.translations.main.notification_discussion_destroyed, 'success')
                    this.bus.publish(`delete:/${this.module_name.slash}/${this.object_name.plural}/discussions`, comment.data)
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
            this.$set(comment.data, 'new_content', comment.data.content)
            this.$set(comment.data, 'editing', true)
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
    <section v-if="translations.main">
        <form @submit="postDiscussion">
            <b-field grouped>
                <b-input required :placeholder="translations.main.discussions_input_comment_placeholder" ref="input-comment" v-model="discussion.content" expanded>
                </b-input>
                <p class="control">
                    <b-button type="is-primary" native-type="submit">{{translations.core.btn_save}}</b-button>
                </p>
            </b-field>
        </form>
        <br>
        <div class="columns">
            <div class="column is-7">
                <b-field>
                    <b-input
                        :placeholder="translations.main.discussion_input_search_placehodler"
                        v-model="search"
                        type="text"
                        icon="search"
                        icon-right="close-circle"
                        icon-right-clickable
                        @icon-right-click="clearSearch">
                    </b-input>
                </b-field>
            </div>
            <div class="column is-5 has-text-right">
                <b-button @click="getDiscussions">
                    &nbsp;
                    <b-icon size="is-small" icon="sync">
                    </b-icon>
                    &nbsp;
                </b-button>
            </div>
        </div>
        <component-data-loading v-if="loading" />
        <component-data-empty v-if="!loading && discussions.length == 0" />
        <b-table
            v-if="!loading && discussions.length > 0"
            :data="filteredDiscussions"
            :sort-icon-size="sort.icon_size"
            :default-sort-direction="sort.direction"
            :paginated="true"
            :per-page="pagination.per_page"
            :current-page.sync="pagination.current_page"
            :pagination-simple="false"
            pagination-position="bottom"
        >
            <template slot-scope="props">
                <b-table-column field="data.created_at_raw" :label="translations.core.text_created_at" sortable>
                    {{ props.row.data.created_at }}
                </b-table-column>

                <b-table-column field="data.user_name" :label="translations.core.text_employee" sortable>
                    <span v-if="props.row.data.user_name">
                        {{props.row.data.user_name}}
                    </span>
                    <span v-else>
                        {{props.row.data.email}}
                    </span>
                </b-table-column>

                <b-table-column field="data.content" :label="translations.core.text_comment" sortable>
                    <span v-if="props.row.data.editing">
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

                <b-table-column field="actions" :label="translations.core.text_actions" class="has-text-right">
                    <span v-if="props.row.data.editable">
                        <span v-if="props.row.data.editing">
                            <b-button outlined @click="putDiscussion(props.row)">
                                <b-icon size="is-small" icon="check" />
                            </b-button>
                            <b-button type="is-danger" outlined @click="() => $set(props.row.data, 'editing', false)">
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
                    </span>
                </b-table-column>
            </template>
        </b-table>
    </section>
</template>
