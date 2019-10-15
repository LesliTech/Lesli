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

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudOwnerId: {
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
        this.bus.$on("post:components/forms/discussion", () => {
            this.getDiscussions()
        })
    },
    methods: {

        getDiscussions() {
            this.http.get(`/${this.cloudModule}s/${this.cloudOwnerId}/discussions`).then(result => {
                if (result.successful) {
                    this.discussions = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <section class="section">
        <div class="box" v-for="discussion in discussions" :key="discussion.id">
            <div class="media">
                <div class="media-left">
                    <figure class="image is-64x64">
                        <img class="is-rounded" src="https://bulma.io/images/placeholders/128x128.png" alt="Image">
                    </figure>
                </div>
                <div class="media-content">
                    <div class="content">
                        <p>
                            <strong>John Smith</strong>
                            <small>{{ discussion.created_at }}</small>
                        </p>
                        <div v-html="discussion.content"></div>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean efficitur sit amet massa fringilla egestas. Nullam condimentum luctus turpis.</p>
                    </div>
                </div>
                <div class="media-right">
                    <span class="icon is-small">
                        <!-- <i class="fas fa-reply"></i> -->
                    </span>
                </div>
            </div>
        </div>
    </section>
</template>
