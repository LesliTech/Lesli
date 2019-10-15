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



// · Import modules, components and apps
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import VueTrix from "vue-trix"



// · Component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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
    components: {
        'component-trix-editor': VueTrix
    },
    data() {
        return {
            show_simple_form: true,
            discussion: {
                content: ""
            }
        }
    },
    methods: {
        
        postDiscussion(e) {

            if (e) { e.preventDefault() }

            // add owner id
            this.discussion[`cloud_${this.cloudModule.replace('/','_')}s_id`] = this.cloudOwnerId

            this.http.post(`/${this.cloudModule}/discussions`, {
                ticket_discussion: this.discussion
            }).then(result => {
                if (result.successful) {
                    this.discussion.content = ""
                }
                this.bus.$emit("post:components/forms/discussion")
                console.log(result)
            }).catch(error => {
                console.log(error)
            })

        }

    }

}
</script>
<template>
    <section class="section">
        <div class="card">
            <div class="card-content">
                <form @submit="postDiscussion">
                    <input v-if="show_simple_form" class="input" type="text" v-model="discussion.content" placeholder="Add a comment...">
                    <component-trix-editor v-if="!show_simple_form" v-model="discussion.content"></component-trix-editor>
                </form>
            </div>
        </div>
    </section>
</template>
