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
@description App that retrieves and shows list of all the Ticket type associated to 
    the account of the logged user

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    props: {

    },
    
    components: {

    },

    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    // @data_variable workflows [Array] An array of objects, each object represents a 
    //      Ticket type, with the same params as the associated rails model
    data(){
        return {
            main_route: '/help/workflows',
            workflows: null,
            reloading: false
        }
    },

    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
       this.getWorkflows()
    },

    methods: {

        // @return [void]
        // @description Connects to the backend using HTTP and retrieves a list of Ticket type associated to
        //      the current user's account. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.workflows) // will display null
        //      this.getWorkflows()
        //      console.log(this.workflows) // will display an array of objects, each representing a Ticket type.
        getWorkflows() {
            this.http.get(`${this.main_route}.json`).then(result => {
                this.reloading = false
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
        // @param workflow [Object] The object representation of the selected Ticket type
        // @description Redirects the router to show the selected Ticket type
        // @example
        //      this.showWorkflow(this.workflows[1])
        //      // Asume the id of the Ticket type is 4
        //      // The user will be redirected to the url /help/catalog/workflows/4
        showWorkflow(workflow) {
            this.$router.push(`/${workflow.id}`)
        },

        reloadWorkflows(){
            this.reloading = true
            this.getWorkflows()
        }
    },

    computed: {

        // @return [String] The class that is used to give a spinning animation to the icon (if needed)
        // @description When the user clicks the 'reload' button, it changes the value of the *reloading*
        //      data variable. And that is used by this method to change the class of the icon and add it
        //      the spinning animation
        reloadingClass(){
            if(this.reloading){
                return 'fa-spin'
            }

            return ''
        }
    }
}
</script>
<template>
    <section class="section" v-if="workflows">
        <component-layout-data-empty v-if="workflows.length == 0" />
        <div class="card" v-if="workflows.length > 0">
            <div class="card-header">
                <h4 class="card-header-title">
                    Workflows
                </h4>
                <div class="buttons">
                    <button class="button is-white" @click="reloadWorkflows" :disabled="reloading">
                        <b-icon icon="sync" size="is-small" :custom-class="reloadingClass" />
                    </button>
                    &nbsp;&nbsp;&nbsp;
                </div>
            </div>
            <div class="card-content">
                <b-table :data="workflows" @click="showWorkflow" :hoverable="true">
                    <template slot-scope="props">
                        <b-table-column field="id" label="Number" width="40" numeric centered>
                            {{ props.row.id }}
                        </b-table-column>
                        <b-table-column field="name" label="Name">
                            {{ props.row.name }}
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

    <section class="section" v-else>
        <component-layout-data-loading  size="is-medium" />
    </section>
</template>
