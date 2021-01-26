<script>
/*

Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/
export default {
    data() {
        return {
            url: null,
            file: {}
        }
    },
    methods: {

        processFile(event) {
            this.file = event.target.files[0]
            this.url = URL.createObjectURL(this.file)

            this.postFile()
        },
        postFile() {

            const formData = new FormData();
            formData.append("account_file[name]", "company_logo")
            formData.append("account_file[file_type]", "png")
            formData.append("account_file[attachment]", this.file)

            this.http.post("/administration/account/files.json", formData).then(result => {
                console.log(result)
                this.msg.info("Image uploaded successfully")
            })

        }

    }

}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <div id="preview">
                <img v-if="url" :src="url" />
            </div>
            <div class="file">
                <label class="file-label">
                    <input class="file-input" type="file" @change="processFile">
                    <span class="file-cta">
                        <span class="file-icon">
                            <i class="fas fa-upload"></i>
                        </span>
                        <span class="file-label">
                            Choose a file…
                        </span>
                    </span>
                </label>
            </div>
        </div>
    </div>
</template>
<style scoped>
    .card .card-content {
        max-width: 450px;
    }
</style>
