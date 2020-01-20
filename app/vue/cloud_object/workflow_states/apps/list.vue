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
        }
    },

    components: {
        'component-state-name': componentStateName
    },

    data() {
        return {
            translations: {},
            states: null
        }
    },
    mounted() {
        this.setTranslations()
        this.getStates()
    },
    methods: {

        setTranslations(){
            this.translations = {
                shared: I18n.t(this.translationsSharedPath)
            }
        },

        getStates() {
            this.http.get(`/${this.cloudModule}/${this.cloudObject}_states.json`).then(result => {
                if (result.successful) {
                    this.states = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        showState(state) {
            this.$router.push(`/${state.id}`)
        }

    }
}
</script>
<template>
    <section v-if="states" class="section">
        <b-table :data="states" @click="showState" :hoverable="true">
            <template v-slot="props">
                <b-table-column field="id" :label="translations.shared.fields.id" width="40" centered numeric>
                    {{props.row.id}}
                </b-table-column>
                <b-table-column field="name" :label="translations.shared.fields.name">
                    <component-state-name 
                        :name="props.row.name"
                        :translations-shared-path="translationsSharedPath"
                    />
                </b-table-column>
                <b-table-column field="created_at" :label="translations.shared.fields.created_at">
                    {{ date.toLocalFormat(props.row.created_at, true) }}
                </b-table-column>
                <b-table-column field="updated_at" :label="translations.shared.fields.updated_at">
                    {{ date.toLocalFormat(props.row.updated_at, true) }}
                </b-table-column>
            </template>
        </b-table>
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
<style>
    table tr:hover {
        cursor: pointer;
    }
</style>
