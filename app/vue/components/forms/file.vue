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
        cloudId: {
            required: true
        }
    },
    data() {
        return {
            file: {
                name: "",
                file: null
            }
        }
    },
    methods: {
        
        postFile(e) {

            if (e) { e.preventDefault() }

            let foreign_key = this.cloudModule.replace('/','_')
            let field_key = this.cloudModule.split('/')[1]

            let formData = new FormData();
            formData.append(`${field_key}_file[cloud_${foreign_key}s_id]`, this.cloudId)
            formData.append(`${field_key}_file[name]`, this.file.name)
            formData.append(`${field_key}_file[file]`, this.file.file)

            this.http.post(`/${this.cloudModule}/files`, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(result => {
                if (result.successful) {
                    this.file.name = ""
                }
                this.bus.publish(`post:/${this.cloudModule}/files`)
            }).catch(error => {
                console.log(error)
            })

        },
        handleFileUpload(test, files) {
            this.file.file = files[0];
        }

    }

}
</script>
<template>
    <div class="box">
        <form @submit="postFile">
            <input type="file" @change="handleFileUpload($event.target.name, $event.target.files)">
            <input class="input" type="text" v-model="file.name" placeholder="Add new file...">
        </form>
    </div>
</template>
