<script>
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
            files: [],
            module_name: {
                slash: null,
                underscore: null
            },
            object_name: {
                singular: null,
                plural: null
            }
        }
    },
    mounted() {
        this.getFiles()
        this.parseCloudModule()
        console.log("files works")
    },
    methods: {
        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },
        getFiles() {
            if(this.cloudId){
                let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/files`
                this.http.get(url).then(result => {
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
            console.log(this.cloudId)
            this.getFiles()
        }
    }
}
</script>
<template>
    <section>
        {{ this.cloudModule }}
        {{ this.cloudId }}
        <ul class="menu-list">
            <li class="field" v-for="file in files" :key="file.id">
                <a :href="`/${module_name.slash}/${object_name.plural}/${cloudId}/files/${file.id}`">
                    {{ file.name }}
                </a>
            </li>
        </ul>
    </section>
</template>
