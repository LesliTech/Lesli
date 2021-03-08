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



// · Import modules, components and apps
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
//import VueTrix from "vue-trix"



// · Component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    components: {
        //'component-trix-editor': VueTrix
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
            submitting_form: false,
            discussion: {
                content: ''
            },
            translations: {
                core: I18n.t('core.shared')
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
        
        postDiscussion(event) {
            if(event){
                event.preventDefault()
            }

            let form_data = {}
            form_data[`${this.object_name.singular}_discussion`] = this.discussion
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/discussions.json`
            this.submitting_form = true

            this.http.post(url, form_data).then(result => {
                if (result.successful) {
                    this.discussion.content = ''
                }
                this.bus.$emit('post:components/forms/discussion')
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting_form = false
            })

        }

    }

}
</script>
<template>
    <form @submit="postDiscussion">
        <fieldset :disabled="submitting_form">
            <b-field grouped>
                <b-input 
                    required :placeholder="translations.core.view_placeholder_discussions_add_comment" 
                    ref="input-comment" 
                    v-model="discussion.content" 
                    expanded
                >
                </b-input>
                <p class="control">
                    <b-button type="is-primary" native-type="submit">
                        <span v-if="submitting_form">
                            <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                            &nbsp;
                            {{translations.core.view_btn_saving}}
                        </span>
                        <span v-else>
                            {{translations.core.view_btn_save}}
                        </span>
                    </b-button>
                </p>
            </b-field>
        </fieldset>
    </form>
</template>
