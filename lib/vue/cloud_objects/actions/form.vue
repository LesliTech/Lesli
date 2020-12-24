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



// · Component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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

    data() {
        return {
            module_name: null,
            object_name: null,
            action: {
                instructions: ""
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
        
        postAction(e) {

            if (e) { e.preventDefault() }

            let request_data = {}
            request_data[`${this.object_name.singular}_action`] = this.action
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/actions`

            this.http.post(url, request_data).then(result => {
                if (result.successful) {
                    this.action.instructions = ''
                }
                this.bus.$emit(`post:/${this.cloudModule}/actions`)
            }).catch(error => {
                console.log(error)
            })

        }

    }

}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <form @submit="postAction">
                <input class="input" type="text" v-model="action.instructions" placeholder="Add new action...">
            </form>
        </div>
    </div>
</template>
