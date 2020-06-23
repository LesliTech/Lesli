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
        },

        translationsPath: {
            type: String,
            default: 'core.shared'
        },

        translationsFileTypesPath: {
            type: String,
            default: null
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            },
            loading: false,
            files: null,
            module_name: null,
            object_name: null,
            pagination: {
                current_page: 1,
                range_before: 3,
                range_after: 3,
                per_page: 2
            },
            sort: {
                icon_size: 'is-small',
                direction: 'desc'
            },
            all_files_selected: false
        }
    },
    
    mounted(){
        this.parseCloudModule()
        this.setTranslations()
        this.getBackendData()
        this.setSubscriptions()
    },

    methods: {
        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))

            if(this.translationsFileTypesPath){
                this.$set(this.translations, 'file_types', I18n.t(this.translationsFileTypesPath))
            }
        },

        setSubscriptions(){
            this.bus.subscribe(`post:/${this.module_name.slash}/${this.object_name.plural}/files-complete`, ()=>{
                if(this.files){
                    this.getFiles()
                }
            })

            this.bus.subscribe(`delete:/${this.module_name.slash}/${this.object_name.plural}/files`, (deleted_file)=>{
                if(this.files){
                    this.files = this.files.filter((file)=>{
                        return file.id != deleted_file.id
                    })
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
                    this.notification.alert(result.error.message,'danger')
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
                    this.notification.alert(this.translations.main.notification_file_deleted, 'success')
                    this.bus.publish(`delete:/${this.module_name.slash}/${this.object_name.plural}/files`, deleted_file)
                }else{
                    this.notification.alert(result.error.message,'danger')
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
            if(file_ids.length > 0){
                window.open(
                    `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/files/zip?ids=${file_ids}`
                )
            }
        },

        translateFileType(file_type){
            if(this.translations.file_types){
                let new_file_type = this.translations.file_types[`enum_file_type_${file_type}`]
                if(new_file_type){
                    return new_file_type
                }
            }

            return file_type
        }
    },

    beforeDestroy(){
        this.bus.$off(`post:/${this.module_name.slash}/${this.object_name.plural}/files-complete`)
    },

    computed: {
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
    <section v-if="translations.main">
        <div class="columns">
            <div class="column is-6">
                <b-checkbox v-model="all_files_selected">
                    {{translations.main.files_input_select_all_title}}
                </b-checkbox>
            </div>
            <div class="column is-6 has-text-right">
                <a :disabled="selectedFiles" class="button is-outlined is-primary" role="button" @click="downloadSelectedFiles">
                    <b-icon size="is-small" icon="download" />
                    &nbsp;
                    {{translations.main.files_btn_download_selected}}
                </a>
            </div>
        </div>
        <component-data-loading v-if="loading" />
        <component-data-empty v-if="!loading && files && files.length == 0" />
        <b-table
            v-if="!loading && files && files.length > 0"
            :data="files"
            :sort-icon-size="sort.icon_size"
            :default-sort-direction="sort.direction"
            :paginated="true"
            :per-page="pagination.per_page"
            :current-page.sync="pagination.current_page"
            :pagination-simple="false"
            pagination-position="bottom"
        >
            <template slot-scope="props">
                <b-table-column field="checbox" label="">
                    <b-checkbox size="is-small" v-model="props.row.selected" />
                </b-table-column>

                <b-table-column field="name" :label="translations.core.text_name" sortable>
                    {{ props.row.name }}
                </b-table-column>

                <b-table-column field="file_type" :label="translations.core.text_type" sortable>
                    <span v-if="translations.file_types">
                        {{translateFileType(props.row.file_type)}}
                    </span>
                    <span v-else>
                        {{props.row.file_type}}
                    </span>
                </b-table-column>

                <b-table-column field="created_at_raw" :label="translations.core.text_created_at" sortable>
                    {{ props.row.created_at }}
                </b-table-column>

                <b-table-column field="actions" :label="translations.core.text_actions" class="has-text-right">
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
    </section>
</template>
