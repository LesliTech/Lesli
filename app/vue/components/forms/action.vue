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



// · Component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudOwnerId: {
            required: true
        }
    },
    data() {
        return {
            action: {
                instructions: ""
            }
        }
    },
    methods: {
        
        postAction(e) {

            if (e) { e.preventDefault() }

            // add owner id
            this.action[`cloud_${this.cloudModule.replace('/','_')}s_id`] = this.cloudOwnerId

            this.http.post(`/${this.cloudModule}/comments`, {
                action: this.comment
            }).then(result => {
                if (result.successful) {
                    this.action.content = ""
                }
                this.bus.$emit("post:components/forms/action")
                console.log(result)
            }).catch(error => {
                console.log(error)
            })

        }

    }

}
</script>
<template>
    <section class="section">
        <div class="card">
            <div class="card-content">
                <form @submit="postAction">
                    <input class="input" type="text" v-model="action.instructions" placeholder="Add new action...">
                </form>
            </div>
        </div>
    </section>
</template>
