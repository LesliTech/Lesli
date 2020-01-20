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
import componentStateName from '../components/state-name.vue'

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
        translationsShowPath: {
            type: String,
            required: true
        }
    },

    components: {
        'component-state-name': componentStateName
    },
    
    data() {
        return {
            translations: {},
            state: null,
            state_id: null,
            modal:{
                active: false
            }
        }
    },

    mounted() {
        // · setStateId() calls getState()
        this.setTranslations()
        this.setStateId()
    },

    methods: {

        setTranslations(){
            this.translations = {
                shared: I18n.t(this.translationsSharedPath),
                show: I18n.t(this.translationsShowPath)
            }
        },
        
        setStateId(){
            if (this.$route.params.id) {
                this.state_id = this.$route.params.id
                this.getState()
            }
        },

        getState() {
            this.http.get(`/${this.cloudModule}/${this.cloudObject}_states/${this.state_id}.json`).then(result => {
                if (result.successful) {
                    this.state = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteState(){
            this.modal.active = false
            this.http.delete(`/${this.cloudModule}/${this.cloudObject}_states/${this.state_id}`).then(result => {
                if(result.successful){
                    this.alert(this.translations.show.messages.delete.successful, 'success')
                    this.$router.push('/')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    computed: {
        defaultState(){
            return this.state.initial || this.state.final
        }
    }
}
</script>
<template>
    <section v-if="state">
        <b-modal 
            :active.sync="modal.active"
            has-modal-card
            trap-focus
            aria-role="dialog"
            aria-modal
        >
            <div class="card">
                <div class="card-header is-danger">
                    <h2 class="card-header-title">
                        {{ translations.show.modal.title }}
                    </h2>
                </div>
                <div class="card-content">
                    {{ translations.show.modal.body }}
                </div>
                <div class="card-footer has-text-right">
                    <button class="card-footer-item button is-danger" @click="deleteState">
                        {{ translations.show.modal.actions.delete }}
                    </button>
                    <button class="card-footer-item button is-secondary" @click="modal.active=false">
                        {{ translations.show.modal.actions.cancel }}
                    </button>
                </div>
            </div>
        </b-modal>
        <div class="card">
            <div class="card-header">
                <h2 class="card-header-title">
                    {{ translations.shared.name }}
                </h2>
                <div class="card-header-icon">
                    <router-link v-if="!defaultState" :to="`/${state_id}/edit`">
                        <i class="fas fa-edit"></i>
                        {{ translations.shared.actions.edit }}
                    </router-link>
                    <router-link :to="`/`">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-undo"></i>
                        {{ translations.shared.actions.return }}
                    </router-link>
                </div>
            </div>
            <div class="card-content">
                <div class="columns">
                    <div class="column">
                        <p>
                            <span class="has-text-weight-bold">
                                {{ `${translations.shared.fields.name}:` }}
                            </span>
                            <component-state-name 
                                :name="state.name"
                                :translations-shared-path="translationsSharedPath"
                            />
                        </p>
                    </div>
                </div>
                <div class="columns">
                    <div class="column">
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
                    <div class="column">
                        <div class="field">
                            <div class="actions has-text-right">
                                <button  v-if="! defaultState" class="button is-danger" @click="modal.active = true">
                                    {{ translations.shared.actions.delete }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section v-else class="has-text-centered">
        <b-icon
            type="is-primary"
            icon="spinner"
            size="is-large"
            custom-class="fa-spin"
        >
        </b-icon>
    </section>
</template>
