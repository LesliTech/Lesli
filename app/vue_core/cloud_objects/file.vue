<script>
/*
Lesli

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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Import core components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentForm from './files/form.vue'


// · 
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
        'component-form-file': componentForm
    },
    data() {
        return {
            show: false,
            files: []
        }
    },
    mounted() {
        this.getFiles()
        this.initListeners()

        
    },
    methods: {
        initListeners(){
            this.bus.subscribe("show:/module/app/files", () => this.show = !this.show )
            this.bus.subscribe(`post:/${this.cloudModule}/files`, () => this.getFiles() )
        },

        getFiles() {
            if(this.cloudId){
                this.http.get(`/${this.cloudModule}s/${this.cloudId}/files`).then(result => {
                    if (result.successful) {
                        this.files = result.data
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    },
    watch: {
        cloudId(){
            this.getFiles()
        }
    }
}
</script>
<template>
    <section>
        <div :class="[{ 'is-active': show }, 'quickview']">
            <header class="quickview-header" @click="show = false">
                <p class="title">Files</p>
                <i class="fas fa-chevron-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <component-form-file class="box" :cloudModule="cloudModule" :cloudId="cloudId"/>
                        <ul class="menu-list">
                            <li class="field" v-for="file in files" :key="file.id">
                                <a :href="`/${cloudModule}s/${cloudId}/files/${file.id}`">
                                    {{ file.name }}
                                </a>
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
    .menu-list{
        word-wrap: break-word;
    }
</style>
