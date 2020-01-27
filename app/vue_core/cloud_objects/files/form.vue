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

    data() {
        return {
            module_name: null,
            object_name: null,
            file: {
                name: "",
                file: null
            }
        }
    },
    
    mounted(){
        this.parseCloudModule()
    },

    methods: {

        parseCloudModule(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },
        
        postFile(e) {

            if (e) { e.preventDefault() }

            let foreign_key = this.cloudModule.replace('/','_')

            let form_data = new FormData()
            form_data.append(`${this.object_name}_file[name]`, this.file.name)
            form_data.append(`${this.object_name}_file[file]`, this.file.file)
            form_data.append(`${this.object_name}_file[cloud_${foreign_key}s_id]`, this.cloudId)

            this.http.post(`/${this.cloudModule}s/${this.cloudId}/files`, form_data, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(result => {
                if (result.successful) {
                    this.file.name = ""
                    this.$refs.file.value = null
                    this.bus.publish(`post:/${this.cloudModule}/files`)
                    this.alert("File successfully uploaded")
                } else {
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })

        },
        handleFileUpload(test, files) {
            this.file.file = files[0]
            this.$refs.input.focus()
        }

    }

}
</script>
<template>
    <div class="box">
        <form @submit="postFile">
            <input class="wrap-file" type="file" ref="file" @change="handleFileUpload($event.target.name, $event.target.files)">
            <input v-model="file.name" class="input" type="text" ref="input" placeholder="Add a name to the file...">
        </form>
    </div>
</template>
<style scoped>
    .wrap-file{
        width: 100%;
    }
</style>
