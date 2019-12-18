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



// · Import modules, components and apps
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import VueTrix from "vue-trix"



// · Component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    components: {
        'component-trix-editor': VueTrix
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
            module_name: null,
            object_name: null,
            show_simple_form: true,
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

            // add owner id
            this.discussion[`cloud_${this.cloudModule.replace('/','_')}s_id`] = this.cloudId

            let form_data = {}
            form_data[`${this.object_name}_discussion`] = this.discussion

            this.http.post(`/${this.cloudModule}s/${this.cloudId}/discussions`, form_data).then(result => {
                if (result.successful) {
                    this.discussion.content = ""
                }
                this.bus.$emit("post:components/forms/discussion")
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
            <h4 class="card-header-title">
                Add new comment
            </h4>
        </div>
        <div class="card-content">
            <form @submit="postDiscussion">
                <input v-if="show_simple_form" class="input" type="text" v-model="discussion.content" placeholder="Add a comment...">
                <component-trix-editor v-if="!show_simple_form" v-model="discussion.content"></component-trix-editor>
            </form>
        </div>
    </div>
</template>
