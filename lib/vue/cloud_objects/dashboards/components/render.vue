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


// · Import components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


// · component
export default {
    props: {
        dashboardId: {
            required: true
        },
        reload: {
            type: Boolean,
            default: false,
            required: true
        },
        cloudEngine: {
            type: String,
            required: true
        },
        engineNamespace: {
            type: String,
            required: true
        },
        components: {
            required: true
        }
    },

    beforeMount(){
        this.setComponents()
    },

    data() {
        return {
            main_route: `/${this.engineNamespace}/dashboards`,
            dashboard: null
        }
    },

    mounted(){
        this.setMainRoute()
        this.getDashboard()
    },

    methods: {
        setComponents(){
            // We configure the components based on the 'components' prop
            for(let key in this.components){
                this.$options.components[key] = this.components[key]
            }
        },

        setMainRoute(){
            this.main_route = `${this.main_route}/${this.dashboardId}.json`
        },
        
        getDashboard(){
            this.http.get(this.main_route).then((result)=>{
                if (result.successful) {
                    this.dashboard = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {
        reload(){
            if(this.reload){
                this.$emit('update:reload', false)
                this.dashboard = null
                this.getDashboard()
            }
        }
    }
}
</script>
<template>
    <div class="columns is-multiline" v-if="dashboard">
        <div v-for="component in dashboard.components" :key="component.id" :class="['column', `is-${component.layout}`]">
            <component :is="`component-${component.component_id.replace(/\_/g,'-')}`" :dashboard-id="dashboard.id" :component-id="component.id">
            </component>
        </div>
    </div>
    <component-data-loading v-else>
    </component-data-loading>
</template>
