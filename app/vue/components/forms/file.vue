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
                name: "test",
                file: null
            }
        }
    },
    methods: {
        
        postFile(e) {

            if (e) { e.preventDefault() }

            // add owner id
            this.file[`cloud_${this.cloudModule.replace('/','_')}s_id`] = this.cloudId

            console.log(JSON.stringify(this.file))

            let request_data = {}
            request_data[`${this.cloudModule.split('/')[1]}_file`] = this.file

            let formData = new FormData();
            formData.append('ticket_file[name]', this.file.name);
            formData.append('ticket_file[file]', this.file.file);
            formData.append('ticket_file[cloud_help_tickets_id]', 1);

            this.http.post(`/${this.cloudModule}/files`, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(result => {
                if (result.successful) {
                    this.file.name = ""
                }
                this.bus.$emit(`post:/${this.cloudModule}/files`)
            }).catch(error => {
                console.log(error)
            })

        },
        handleFileUpload(test, files) {
            console.log(test)
            console.log(files[0])
            this.file.file = files[0];
        }

    }

}
</script>
<template>
    <div class="card">
        {{ file }}
        <div class="card-content">
            <form @submit="postFile">
                <b-field class="file">
                    <b-upload v-model="file.file">
                        <a class="button is-primary">
                            <b-icon icon="upload"></b-icon>
                            <span>Click to upload</span>
                        </a>
                    </b-upload>
                </b-field>
                <input type="file" v-on:change="handleFileUpload($event.target.name, $event.target.files)">
                <input class="input" type="text" v-model="file.name" placeholder="Add new file...">
            </form>
        </div>
    </div>
</template>
