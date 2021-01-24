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
            file: {},
            files: []
        }
    },
    methods: {
        deleteDropFile(index) {
            this.files.splice(index, 1);
        }
    }
}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <div class="field">
                <label class="label">Company logo</label>
                <div class="control">
                    <b-field class="file">
                        <b-upload v-model="file" expanded>
                            <a class="button is-primary is-fullwidth is-justify-content-center">
                                <b-icon icon="upload"></b-icon>
                                <span>{{ file.name || "Click to upload"}}</span>
                            </a>
                        </b-upload>
                    </b-field>
                    <b-field>
                        <b-upload v-model="files" multiple drag-drop expanded>
                            <div class="section">
                                <div class="content has-text-centered">
                                    <p>
                                        <b-icon icon="upload" size="is-large"></b-icon>
                                    </p>
                                    <p>Drop your files here or click to upload</p>
                                </div>
                            </div>
                        </b-upload>
                    </b-field>
                    <div class="tags">
                        <span v-for="(file, index) in files" :key="index" class="tag is-primary">
                            {{file.name}}
                            <button class="delete is-small" type="button" @click="deleteDropFile(index)"></button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>
    .card .card-content {
        max-width: 450px;
    }
</style>
