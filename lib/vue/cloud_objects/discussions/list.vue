<script>
/*

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/


// · Import core cloud object components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentDiscussionFormResponse from './form_response.vue'


// · 
export default {
    components: {
        'component-discussion-form-response': componentDiscussionFormResponse
    },
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudId: {
            required: true
        }
    },
    data() {
        return {
            discussions: [],
            search: '',
            loading: false,
            translations: {
                core: I18n.t('core.shared')
            }
        }
    },
    mounted() {
        this.mountListeners()
        this.parseCloudModule()
        this.getDiscussions()
    },
    methods: {

        mountListeners(){
            this.bus.subscribe("post:components/forms/discussion", () =>  this.getDiscussions() )
        },

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        getDiscussions() {
            if(this.cloudId){
                let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions.json`
                this.loading = true

                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.discussions = result.data
                    }
                }).catch(error => {
                    console.log(error)
                }).finally(()=>{
                    this.loading = false
                })
            }
        },

        showResponseForm(discussion){
            this.$set(discussion, 'show_response_form', true)
            this.$nextTick(()=>{
                this.$set(discussion, 'focus', true)
            })
        },

        hideResponseForm(discussion){
            this.$set(discussion, 'focus', false)
            this.$set(discussion, 'show_response_form', false)
        },

        extractInitials(user_name){
            user_name = user_name.split(' ')
            if(user_name.length > 2){
                user_name = user_name.slice(0, 2)
            }

            return user_name.map((word)=>{
                if(word.length > 0){
                    return word[0].toUpperCase()
                }

                return ''
            }).join('')
        },

        clearSearch(event){
            if(event){
                event.preventDefault()
            }
            
            this.search = ''
        },

        confirmCommentDeletion(discussion, type) {
            window.scrollTo(0,0)
            this.$buefy.dialog.confirm({
                title: this.translations.core.messages_danger_discussions_delete_confirmation_title,
                message: this.translations.core.messages_danger_discussions_delete_confirmation_body,
                confirmText: this.translations.core.messages_danger_discussions_delete_confirmation_accept_button,
                cancelText: this.translations.core.messages_danger_discussions_delete_confirmation_cancel_button,
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteComment(discussion, type)
            })
        },

        deleteComment(discussion, type){
            if(type == 'discussion'){
                discussion = discussion.data
            }

            let discussion_id = discussion.id
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions/${discussion_id}`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.alert(this.translations.core.messages_info_discussion_destroyed, 'success')
                    this.bus.publish(`delete:/${this.module_name.slash}/${this.object_name.plural}/discussions`, discussion)
                    this.getDiscussions()
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
    },

    computed: {
        filteredDiscussions(){
            let search_field = this.search.toLowerCase()

            if(search_field){
                return this.discussions.filter((discussion)=>{
                    return discussion.data.email.toLowerCase().includes(search_field) ||
                        (
                            discussion.data.user_name &&
                            discussion.data.user_name.toLowerCase().includes(search_field)
                        ) ||
                        discussion.data.content.toLowerCase().includes(search_field) ||
                        (discussion.responses.filter((response)=>{
                            return response.email.toLowerCase().includes(search_field) ||
                                response.user_name && response.user_name.toLowerCase().includes(search_field) ||
                                response.content.toLowerCase().includes(search_field)
                        }).length > 0)
                })
            }

            return this.discussions
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
    <section class="card is-shadowless">
        <div class="card-content">
            <div class="columns">
                <div class="column is-7 is-paddingless">
                    <b-field>
                        <b-input
                            :placeholder="translations.core.view_placeholder_discussions_search_text"
                            v-model="search"
                            type="text"
                            icon="search"
                            icon-right="close-circle"
                            icon-right-clickable
                            @icon-right-click="clearSearch">
                        </b-input>
                    </b-field>
                </div>
                <div class="column is-5 has-text-right is-paddingless">
                    <b-button @click="getDiscussions" :disabled="loading">
                        &nbsp;
                        <b-icon v-if="loading" size="is-small" icon="sync" custom-class="fa-spin">
                        </b-icon>
                        <b-icon v-else size="is-small" icon="sync">
                        </b-icon>
                        &nbsp;
                    </b-button>
                </div>
            </div>
            <br>
            <component-data-loading v-if="loading">
            </component-data-loading>
            <div class="scrollable columns is-multiline" v-else>
                <div
                    class="column is-12 is-paddingless"
                    v-for="discussion in filteredDiscussions"
                    :key="discussion.data.id"
                >
                    <div class="media">
                        <div class="media-left">
                            <figure class="image is-32x32">
                                <span class="discussion-avatar">
                                    {{extractInitials(discussion.data.user_name)}}
                                </span>
                            </figure>
                        </div>
                        <div class="media-content">
                            <div class="content">
                                <p class="is-marginless">
                                    <strong>{{ discussion.data.user_name || discussion.data.email }}</strong>
                                    <small>{{ discussion.data.created_at }}</small>
                                    <a
                                        v-if="discussion.data.editable"
                                        role="button"
                                        class="has-text-danger"
                                        @click="confirmCommentDeletion(discussion, 'discussion')"
                                    >
                                        <small>({{translations.core.view_text_delete}})</small>
                                    </a>
                                </p>
                                <div>
                                    <b v-if="discussion.data.response_to">{{discussion.data.response_to}}</b>
                                    <span v-html="discussion.data.content"></span>
                                </div>
                                <div class="has-text-right">
                                    <a 
                                        v-if="! discussion.data.show_response_form"
                                        href="javascript:void(0);"
                                        @click="showResponseForm(discussion.data)"
                                    >
                                        <small>{{translations.core.view_text_discussions_respond}}</small>
                                    </a>
                                    <a 
                                        v-else
                                        href="javascript:void(0);"
                                        @click="hideResponseForm(discussion.data)"
                                    ><small>{{translations.core.view_btn_cancel}}</small></a>
                                    <component-discussion-form-response
                                        v-if="discussion.data.show_response_form"
                                        :focus="discussion.data.focus"
                                        :cloud-module="cloudModule"
                                        :cloud-id="cloudId"
                                        :discussion-id="discussion.data.id"
                                    />
                                </div>
                                <div>
                                    <div v-for="response in discussion.responses" :key="response.id">
                                        <div class="media">
                                            <div class="media-left">
                                                <figure class="image is-32x32">
                                                    <span class="discussion-avatar">
                                                        {{extractInitials(response.user_name)}}
                                                    </span>
                                                </figure>
                                            </div>
                                            <div class="media-content">
                                                <div class="content">
                                                    <p class="is-marginless">
                                                        <strong>{{ response.user_name || response.email }}</strong>
                                                        <small>{{ response.created_at }}</small>
                                                        <a
                                                            v-if="response.editable"
                                                            class="has-text-danger is-small"
                                                            @click="confirmCommentDeletion(response, 'response')"
                                                            role="button"
                                                        >
                                                            <small>({{translations.core.view_text_delete}})</small>
                                                        </a>
                                                    </p>
                                                    <div>
                                                        <span class="has-text-weight-bold" v-if="response.response_to">
                                                            @{{response.response_to}}
                                                        </span>
                                                        <span v-html="response.content"></span>
                                                    </div>
                                                    <div class="has-text-right">
                                                        <a 
                                                            v-if="! response.show_response_form"
                                                            href="javascript:void(0);"
                                                            @click="showResponseForm(response)"
                                                        ><small>{{translations.core.view_text_discussions_respond}}</small></a>
                                                        <a 
                                                            v-else
                                                            href="javascript:void(0);"
                                                            @click="hideResponseForm(response)"
                                                        ><small>{{translations.core.view_btn_cancel}}</small></a>
                                                        <component-discussion-form-response
                                                            v-if="response.show_response_form"
                                                            :focus="response.focus"
                                                            :cloud-module="cloudModule"
                                                            :cloud-id="cloudId"
                                                            :discussion-id="response.id"
                                                        />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
<style scoped>
.discussion-avatar {
    width: 100%;
    height: 100;
    height: 100%;
    display: flex;
    border-radius: 50%;
    background: skyblue;
    justify-content: center;
    text-transform: uppercase;
    align-items: center;
    font-size: 0.7rem;
}

.scrollable {
    max-height: 30rem;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: thin;
    scrollbar-color: #cccccc #ffffff;
    padding-right: 0.62rem;
}
</style>
