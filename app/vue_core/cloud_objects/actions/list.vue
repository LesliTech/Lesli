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

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


import componentActionForm from './actions/form.vue'


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
    components: {
        'component-form-action': componentActionForm
    },
    data() {
        return {
            show: false,
            actions: []
        }
    },
    mounted() {
        this.getActions()
        this.mountListeners()
    },
    methods: {

        mountListeners(){
            this.bus.subscribe(`post:/${this.cloudModule}/actions`, () => {
                this.getActions()
            })
            this.bus.subscribe("show:/module/app/actions", () => this.show = !this.show )
        },

        getActions() {
            if(this.cloudId){
                this.http.get(`/${this.cloudModule}s/${this.cloudId}/actions`).then(result => {
                    if (result.successful) {
                        this.actions = result.data
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        patchAction(action) {
            let form_data =  { ticket_action: action }
            this.http.patch(`/${this.cloudModule}s/${this.cloudId}/actions/${ action.id }`, form_data).then(result => {
                if (result.successful) {
                    if (action.complete == true) {
                        this.alert('Task marked as completed!')
                    }else{
                        this.alert('Task marked as not completed!')
                    }
                }
            }).catch(error => {
                console.log(error)
            })
        }

    },
    watch: {
        cloudId(){
            this.getActions()
        }
    }
}
</script>
<template>
    <section>
        <div :class="[{ 'is-active': show }, 'quickview']">
            <header class="quickview-header" @click="show = false">
                <p class="title">Actions</p>
                <i class="fas fa-chevron-right clickable"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <component-form-action class="box" :cloudModule="cloudModule" :cloudId="cloudId"/>
                        <ul class="menu-list">
                            <li class="field" v-for="action in actions" :key="action.id">
                                <input
                                    :id="`action-${action.id}`"
                                    class="is-checkradio"
                                    type="checkbox"
                                    v-model="action.complete"
                                    @change="patchAction(action)"
                                >
                                <label :for="`action-${action.id}`">{{ action.instructions }}</label>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <footer class="quickview-footer">
            </footer>
        </div>
    </section>
</template>
<style scoped>
    .clickable{
        cursor: pointer;
    }
</style>
