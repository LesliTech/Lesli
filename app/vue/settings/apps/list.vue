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

@author   [AUTHOR_NAME_GOES_HERE]
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description App that retrieves and shows list of all the Settings associated to 
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
    // @data_variable settings [Array] An array of objects, each object represents a 
    //      Settings, with the same params as the associated rails model
    data(){
        return {
            main_route: '/settings',
            settings: null
        }
    },

    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
       this.getSettings()
    },

    methods: {

        // @return [void]
        // @description Connects to the backend using HTTP and retrieves a list of Settings associated to
        //      the current user's account. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.settings) // will display null
        //      this.getSettings()
        //      console.log(this.settings) // will display an array of objects, each representing a Settings.
        getSettings() {
            this.http.get(`${this.main_route}.json`).then(result => {
                if (result.successful) {
                    this.settings = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        // @return [void]
        // @param settings [Object] The object representation of the selected Settings
        // @description Redirects the router to show the selected Settings
        // @example
        //      this.showSettings(this.settings[1])
        //      // Asume the id of the Settings is 4
        //      // The user will be redirected to the url /settings/4
        showSettings(settings) {
            this.$router.push(`/${settings.id}`)
        }

    }
}
</script>
<template>
    <section class="section" v-if="settings">
        <b-table :data="settings" @click="showSettings" :hoverable="true">
            <template slot-scope="props">
                <b-table-column field="id" label="ID" width="40" numeric centered>
                    {{ props.row.id }}
                </b-table-column>

                <!------------ ------------------------------------------ ------------>
                <!------------ Add other table rows here as you need them ------------>
                <!------------ ------------------------------------------ ------------>

            </template>
        </b-table>
    </section>
</template>
