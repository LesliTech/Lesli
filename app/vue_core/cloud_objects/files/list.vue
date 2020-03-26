<script>

export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },

        cloudId: {
            required: true
        },

        active: {
            type: Boolean,
            default: true
        }
    },

    data(){
        return {
            loading: false,
            files: null,
            module_name: null,
            object_name: null,
            pagination: {
                current_page: 1,
                range_before: 3,
                range_after: 3,
                per_page: 15
            },
            all_files_selected: false
        }
    },
    
    mounted(){
        this.parseCloudModule()
        this.getBackendData()
        this.setSubscriptions()
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`post:/${this.module_name.slash}/${this.object_name.plural}/files-complete`, ()=>{
                if(this.files){
                    this.getFiles()
                }
            })
        },

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        getBackendData(){
            if(this.active){
                this.getFiles()
            }
        },

        getFiles() {
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/files.json`
            this.loading = true

            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.files = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteFile(deleted_file){
            let file_id = deleted_file.id
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/files/${file_id}`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.alert('File deleted successfully', 'success')
                    this.files = this.files.filter((file)=>{
                        return file.id != deleted_file.id
                    })
                    this.bus.publish(`delete:/${this.module_name.slash}/${this.object_name.plural}/files`, deleted_file)
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        downloadSelectedFiles(){
            let file_ids = []
            this.files.forEach((file)=>{
                if(file.selected){
                    file_ids.push(file.id)
                }
            })
            file_ids = encodeURIComponent(file_ids
            )
            window.open(
                `/${this.module_name.slash}/options/${this.object_name.singular}/${this.cloudId}/files/zip?ids=${file_ids}`
            )
        }
    },

    beforeDestroy(){
        this.bus.$off(`post:/${this.module_name.slash}/${this.object_name.plural}/files-complete`)
    },

    computed: {
        currentFilePage(){
            if(this.files.length <= this.pagination.per_page){
                return this.files
            }else{
                let data = this.files.slice(
                    (this.pagination.current_page - 1) * this.pagination.per_page,
                    (this.pagination.current_page) * this.pagination.per_page
                )
                return data
            }
        },

        selectedFiles(){
            if(! this.files){
                return true
            }
            
            return this.files.filter( file => file.selected).length == 0
        }
    },

    watch: {
        active(){
            if(! this.files){
                this.getBackendData()
            }
        },

        all_files_selected(){
            if(this.files){
                this.files.forEach((file)=>{
                    this.$set(file, 'selected', this.all_files_selected)
                })
            }
        },
        
        cloudId(){
            this.getBackendData()
        }
    }
}
</script>
<template>
    <section>
        <div class="columns">
            <div class="column is-6">
                <b-checkbox v-model="all_files_selected">
                    Select all documents
                </b-checkbox>
            </div>
            <div class="column is-6 has-text-right">
                <a :disabled="selectedFiles" class="button is-outlined is-primary" role="button" @click="downloadSelectedFiles">
                    <b-icon size="is-small" icon="download" />
                    &nbsp;
                    Download selected documents
                </a>
            </div>
        </div>
        <component-data-loading v-if="loading" />
        <component-data-empty v-if="!loading && files && files.length == 0" />
        <b-table v-if="files && files.length > 0" :data="currentFilePage">
            <template slot-scope="props">
                <b-table-column field="checbox" label="">
                    <b-checkbox size="is-small" v-model="props.row.selected" />
                </b-table-column>

                <b-table-column field="created_at" label="Created at">
                    {{ props.row.created_at }}
                </b-table-column>

                <b-table-column field="name" label="Name">
                    <span v-if="props.row.name && props.row.name.includes('.')">
                        {{ props.row.name.substring(0, props.row.name.lastIndexOf('.'))}}
                    </span>
                    <span v-else>
                        {{ props.row.name }}
                    </span>
                </b-table-column>

                <b-table-column field="file_type" label="Type">
                    {{ props.row.file_type }}
                </b-table-column>

                <b-table-column field="actions" label="Actions" class="has-text-right">
                    <a
                        :href="`/${module_name.slash}/${object_name.plural}/${cloudId}/files/${props.row.id}`"
                        target="_blank"
                        class="button is-outlined"
                    >
                        <b-icon size="is-small" icon="eye" />
                    </a>
                    <a
                        :href="`/${module_name.slash}/${object_name.plural}/${cloudId}/files/${props.row.id}?download=true`"
                        download
                        class="button is-outlined"
                    >
                        <b-icon size="is-small" icon="download" />
                    </a>
                    <b-button type="is-danger" outlined @click="deleteFile(props.row)">
                        <b-icon size="is-small" icon="trash-alt" />
                    </b-button>
                </b-table-column>
            </template>
        </b-table>
        <hr>
        <b-pagination
            v-if="files"
            :simple="false"
            :total="files.length"
            :current.sync="pagination.current_page"
            :range-before="pagination.range_before"
            :range-after="pagination.range_after"
            :per-page="pagination.per_page"
            order="is-centered"
            icon-prev="chevron-left"
            icon-next="chevron-right"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-page-label="Page"
            aria-current-label="Current page"
        >
        </b-pagination>
    </section>
</template>
