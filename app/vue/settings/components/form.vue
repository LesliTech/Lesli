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
@description Allows the user to either view, or edit a Settings and save it in the 
    database using HTTP. This component is intended to be used in conjunction with the main apps:
    *new*, *show* and *edit*

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


export default {
    
    // @component_prop Settings [Object] The object representation of the settings.
    //      If this component is being used by the *new* app, all the object properties are empty
    // @component_prop viewType [String] Either 'new', 'edit' or 'show'. Represents the main app that
    //      imported this component
    props: {
        Settings: {
            required: true
        },

        viewType: {
            type: String,
            required: true
        }
    },

    components: {

    },
    
    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    // @data_variable settings [Object] An object representing a Settings, with
    //      the same params as the associated rails model
    data() {
        return {
            main_route: '/settings',
            settings: null
        }
    },

    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
        this.setSettingsId()
        this.copySettingsProp()
    },

    methods: {

        // @return [void]
        // @description Retrieves the id of the Settings and stores it in the data variable settings_id
        // @example
        //      console.log(this.settings_id) // will display null
        //      this.setSettingsId()
        //      console.log(this.settings_id) // will display a number, like 5
        setSettingsId(){
            this.settings_id = this.$route.params.id
        },

        // @return [void]
        // @description Copies the content of the prop Settings into the data variable settings.
        //      This is done to allow this component to modify the Settings's attributes without directly
        //      modifying the received prop
        // @example
        //      console.log(this.settings) // will display null
        //      this.copySettingsProp()
        //      console.log(this.settings_id) // will display an exact copy of the Settings prop
        copySettingsProp(){
            this.settings = {... this.Settings}
        },

        // @return [void]
        // @description Catches the submit event of the HTML form, and prevents its default behavior. Depending on the
        //      value of the *viewType* variable, executes a method that sends and HTTP post or put to the lesli API
        //  @example
        //      this.submitSettings() // will trigger a post if viewMode is 'new' or a put if viewMode is 'edit'
        submitSettings(event){
            if (event) { event.preventDefault() }

            if(this.viewType == 'new'){
                this.postSettings()
            }else if(this.viewType == 'edit'){
                this.putSettings()
            }
        },

        // @return [void]
        // @description Connects to the backend using HTTP to create a new Settings under the current user's
        //       account. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.settings.id)  // will display null since this will be a new record
        //      this.postSettings()            // will create a new record and redirect to it's show app
        postSettings() {
            let form_data = {
                settings: this.settings
            }
            let url = `${this.main_route}.json`

            this.http.post(url, form_data).then(result => {
                if (result.successful) {
                    this.alert('Settings created successfully', 'success')
                    this.$router.push(`/${result.data.id}`)
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })

        },

        // @return [void]
        // @description Connects to the backend using HTTP to update an existing Settings under the current user's
        //      account. The id of the Settings is provided in the *id* route param. If the HTTP request fails,
        //      an error message is shown
        // @example
        //      this.putSettings() // will update the record and redirect to it's show app
        putSettings() {
            let form_data = {
                settings: this.settings
            }
            let url = `${this.main_route}/${this.settings_id}.json`

            this.http.put(url, form_data).then(result => {
                if (result.successful) {
                    this.alert('Settings updated successfully', 'success')
                    this.$router.push(`/${this.settings.id}`)
                }else{
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })

        },

        // @return [void]
        // @description Connects to the backend using HTTP to delete an existing Settings under the current user's
        //      account. The id of the Settings is provided in the *id* route param. If the HTTP request fails,
        //      an error message is shown
        // @example
        //      this.deleteSettings() // will delete the record and redirect to the list app
        deleteSettings() {
            let url = `${this.main_route}/${this.settings_id}`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.alert('Settings deleted successfully', 'success')
                    this.$router.push('/')
                }else{
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <div class="card" v-if="settings">
        <!--------------------------------------- START CARD HEADER --------------------------------------->
        <div class="card-header">
            <h2 class="card-header-title">
                Settings
            </h2>
            <div class="card-header-icon">
                <router-link v-if="viewType == 'edit'" :to="`/${settings.id}`">
                    <i class="fas fa-eye"></i>
                    Show Settings
                </router-link>
                <router-link v-if="viewType == 'show'" :to="`/${settings.id}/edit`">
                    <i class="fas fa-eye"></i>
                    Edit Settings
                </router-link>
                <router-link to="/">
                    &nbsp;&nbsp;&nbsp;
                    <i class="fas fa-undo"></i>
                    Return
                </router-link>
            </div>
        </div>
        <!---------------------------------------  END CARD HEADER  --------------------------------------->

        <!--------------------------------------- START CARD CONTENT--------------------------------------->
        <div class="card-content">
            <form @submit="submitSettings">

                <!---------------------------------- START SUBMIT BUTTON ---------------------------------->
                <b-field v-if="viewType == 'new' || viewType == 'edit'">
                    <b-button type="is-primary" native-type="submit">
                        <span v-if="viewType == 'new'">
                            Create Settings
                        </span>
                        <span v-else>
                            Update Settings
                        </span>
                    </b-button>
                </b-field>
                <!----------------------------------  END SUBMIT BUTTON  ---------------------------------->
                
                <!---------------------------------- START DELETE BUTTON ---------------------------------->
                <b-field v-if="viewType == 'show'">
                    <b-button type="is-danger" @click="deleteSettings">
                        <span v-if="viewType == 'new'">
                            Create Settings
                        </span>
                        <span v-else>
                            Delete Settings
                        </span>
                    </b-button>
                </b-field>
                <!----------------------------------  END DELETE BUTTON  ---------------------------------->
            </form>
        </div>
        <!---------------------------------------  END CARD CONTENT --------------------------------------->
    </div>
</template>
