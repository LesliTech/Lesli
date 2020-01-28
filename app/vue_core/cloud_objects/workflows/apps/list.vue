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

@dev      Carlos Hermosilla
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Component list
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        }
    },
    
    data() {
        return {
            workflows: []
        }
    },
    
    mounted() {
        this.setCloudParams()
        this.getTicketWorkflows()
    },

    methods: {
        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },

        getTicketWorkflows() {
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
        
        showWorkflow(workflow) {
            this.$router.push(`/${workflow.id}`)
        }

    }
}
</script>
<template>
    <section class="section">
        <component-layout-empty-data v-if="workflows.length == 0" />
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
<style>
    table tr:hover {
        cursor: pointer;
    }
</style>
