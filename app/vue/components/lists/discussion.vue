<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/
import componentDiscussionResponse from "../forms/discussion_response.vue"

export default {
    components: {
        'component-discussion-response': componentDiscussionResponse
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
            discussions: []
        }
    },
    mounted() {
        this.getDiscussions()
        this.initListener()
    },
    methods: {

        initListener(){
            this.bus.subscribe("post:components/forms/discussion", () =>  this.getDiscussions() )
        },

        getDiscussions() {
            if(this.cloudId){
                this.http.get(`/${this.cloudModule}s/${this.cloudId}/discussions.json`).then(result => {
                    if (result.successful) {
                        this.discussions = result.data
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        showResponseForm(discussion){
            this.$set(discussion, "show_response_form", true)
            this.$nextTick(()=>{
                this.$set(discussion, "focus", true)
            })
        },

        hideResponseForm(discussion){
            this.$set(discussion, "focus", false)
            this.$set(discussion, "show_response_form", false)
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
        <div class="box" v-for="discussion in discussions" :key="discussion.data.id">
            <div class="media">
                <div class="media-left">
                    <figure class="image is-64x64">
                        <img class="is-rounded" src="https://bulma.io/images/placeholders/64x64.png" alt="Image">
                    </figure>
                </div>
                <div class="media-content">
                    <div class="content">
                        <p>
                            <strong>{{ discussion.data.email }}</strong>
                            <small>{{ date.toLocalFormat(discussion.data.created_at, false, true) }}</small>
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
                            ><small>Respond</small></a>
                            <a 
                                v-else
                                href="javascript:void(0);"
                                @click="hideResponseForm(discussion.data)"
                            ><small>Cancel</small></a>
                            <component-discussion-response
                                v-if="discussion.data.show_response_form"
                                :focus="discussion.data.focus"
                                :cloud-module="cloudModule"
                                :cloud-id="cloudId"
                                :discussion-id="discussion.data.id"
                            />
                            <div v-for="response in discussion.responses" :key="response.id">
                                <div class="media">
                                    <div class="media-left">
                                        <figure class="image is-48x48">
                                            <img class="is-rounded" src="https://bulma.io/images/placeholders/48x48.png" alt="Image">
                                        </figure>
                                    </div>
                                    <div class="media-content">
                                        <div class="content">
                                            <p>
                                                <strong>{{ response.email }}</strong>
                                                <small>{{ date.toLocalFormat(response.created_at, false, true) }}</small>
                                            </p>
                                            <div>
                                                <span class="has-text-weight-bold" v-if="response.response_to">
                                                    {{response.response_to}}
                                                </span>
                                                <span v-html="response.content"></span>
                                            </div>
                                            <div class="has-text-right">
                                                <a 
                                                    v-if="! response.show_response_form"
                                                    href="javascript:void(0);"
                                                    @click="showResponseForm(response)"
                                                ><small>Respond</small></a>
                                                <a 
                                                    v-else
                                                    href="javascript:void(0);"
                                                    @click="hideResponseForm(response)"
                                                ><small>Cancel</small></a>
                                                <component-discussion-response
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
    </section>
</template>
