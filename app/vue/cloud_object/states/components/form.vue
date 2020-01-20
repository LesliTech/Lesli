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
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudObject: {
            type: String,
            required: true
        },
        translationsSharedPath: {
            type: String,
            required: true
        },
        translationsFormPath: {
            type: String,
            required: true
        }
    },

    data() {
        return {
            translations: null,
            state_id: null,
            state: {}
        }
    },
    
    mounted() {
        this.setTranslations()
        this.setStateId()
    },
    
    methods: {

        setTranslations(){
            this.translations = {
                form: I18n.t(this.translationsFormPath),
                shared: I18n.t(this.translationsSharedPath)
            }
        },

        setStateId(){
            if (this.$route.params.id) {
                this.state_id = this.$route.params.id
                this.getTicketState()
            }
        },

        submitTicketState(event){
            if (event) { event.preventDefault() }
            if(this.state_id){
                this.putTicketState()
            }else{
                this.postTicketState()
            }
        },

        putTicketState() {
            let url = `/${this.cloudModule}/${this.cloudObject}_states/${this.state_id}`
            let data = {}
            data[`${this.cloudObject}_state`] = this.state

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.form.messages.update.successful,'success')
                    this.$router.push(`/${this.state_id}`)
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })

        },

        postTicketState() {
            let url = `/${this.cloudModule}/${this.cloudObject}_states`
            let data = {}
            data[`${this.cloudObject}_state`] = this.state

            this.http.post(url, data).then(result => {
                if (result.successful) {
                    this.alert(this.translations.form.messages.create.successful,'success')
                    this.$router.push(`/${result.data.id}`)
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })

        },

        getTicketState() {
            let url = `/${this.cloudModule}/${this.cloudObject}_states/${this.state_id}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.state = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <section v-if="translations">
        <div class="card">
            <div class="card-header">
                <h2 class="card-header-title">
                    {{translations.shared.name}}
                </h2>
                <div class="card-header-icon">
                    <router-link v-if="state_id" :to="`/${state_id}`">
                        <i class="fas fa-eye"></i>
                        {{translations.shared.actions.show}}
                    </router-link>
                    <router-link :to="`/`">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-undo"></i>
                        {{translations.shared.actions.return}}
                    </router-link>
                </div>
            </div>
            <div class="card-content">
                <form @submit="submitTicketState">
                    <b-field :label="translations.shared.fields.name">
                        <b-input v-model="state.name" required="true"></b-input>
                    </b-field>
                    <div class="columns">
                        <div v-if="state_id" class="column">
                            <div class="field">
                                <small>
                                    <span class="has-text-weight-bold">
                                        {{ `${translations.shared.fields.created_at}:` }}
                                    </span>
                                     {{ date.toLocalFormat(state.created_at, false, true) }}
                                    <br>
                                    <span class="has-text-weight-bold">
                                        {{ `${translations.shared.fields.updated_at}:` }}
                                    </span>
                                     {{ date.toLocalFormat(state.updated_at, false, true) }}
                                </small>
                            </div>
                        </div>
                        <div class="column">
                            <div class="field">
                                <div class="actions has-text-right">
                                    <button class="button is-primary" type="submit">
                                        <span v-if="state_id">{{translations.form.actions.update}}</span>
                                        <span v-else>{{translations.form.actions.create}}</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </section>
</template>
