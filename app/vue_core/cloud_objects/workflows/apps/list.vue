<script>
/*
Copyright (c) 2020, Lesli Technologies, S. A.

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

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description App that retrieves and shows, and allows the user to edit/update a
    Property specified by the id in the route.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/

export default {

    // @component_prop CloudModule [String] The cloud module that imported this component.
    //      For example, 'house/property'
    props: {
        cloudModule: {
            type: String,
            required: true
        }
    },
    
    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable workflows [Array] A list of workflows to be displayed to the user
    data() {
        return {
            workflows: []
        }
    },
    
    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
        this.setCloudParams()
        this.getWorkflows()
    },

    methods: {

        // @return [void]
        // @description Parses the prop *cloudModule* separates the *module* *name* from the
        //      *cloud_object* name. The only important value is the *module* *name*
        // @example
        //      this.setCloudParams()
        //      console.log(this.module_name) //will display something similar to 'house'
        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
        },

        // @return [void]
        // @description Connects to the backend using HTTP and retrieves a list of workflows associated to
        //      the current user's account. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.workflows) // will display null
        //      this.getWorkflows()
        //      console.log(this.workflows) // will display an array of objects, each representing a workflows.
        getWorkflows() {
            this.http.get(`/${this.module_name}/workflows.json`).then(result => {
                if (result.successful) {
                    this.workflows = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        // @return [void]
        // @param workflow [Object] The object representation of the selected workflow
        // @description Redirects the router to show the selected workflow
        // @example
        //      this.showWorkflow(this.workflows[1])
        //      // Asume the id of the workflow is 4
        //      // The user will be redirected to the url /house/workflows/4
        showWorkflow(workflow) {
            this.$router.push(`/${workflow.id}`)
        }

    }
}
</script>
<template>
    <section class="section">
        <component-layout-data-empty v-if="workflows.length == 0" />
        <div v-else class="card">
            <div class="card-content">
                <b-table :data="workflows" @click="showWorkflow" :hoverable="true">
                    <template slot-scope="props">
                        <b-table-column field="id" label="Number">
                            {{ props.row.id }}
                        </b-table-column>
                        <b-table-column field="name" label="Name">
                            {{ props.row.name}}
                            <span v-if="props.row.default" class="has-text-weight-bold">
                                (Default)
                            </span>
                        </b-table-column>
                        <b-table-column field="created_at" label="Created at">
                            {{ date.toLocalFormat(props.row.created_at, true) }}
                        </b-table-column>
                        <b-table-column field="updated_at" label="Updated at">
                            {{ date.toLocalFormat(props.row.updated_at, true) }}
                        </b-table-column>
                    </template>
                </b-table>
            </div>
        </div>
    </section>
</template>
