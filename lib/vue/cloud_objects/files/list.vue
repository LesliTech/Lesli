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

        translations: {
            required: true
        }
    },

    data(){
        return {
            loading: false,
            files: null,
            main_route: null,
            module_name: null,
            object_name: null,
            pagination: {
                current_page: 1,
                range_before: 3,
                range_after: 3,
                per_page: 10
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
        this.getBackendData()
        this.setSubscriptions()
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`post:${this.main_route}/files-complete`, ()=>{
                if(this.files){
                    this.getFiles()
                }
            })

            this.bus.subscribe(`delete:${this.main_route}/files`, (deleted_file)=>{
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

            if(this.module_name.slash == '/'){
                this.main_route = `/${this.object_name.plural}`
            }else{
                this.main_route = `/${this.module_name.slash}/${this.object_name.plural}`
            }
        },

        getBackendData(){
            if(this.active){
                this.getFiles()
            }
        },

        getFiles() {
            let url = `${this.main_route}/${this.cloudId}/files.json`
            this.loading = true

            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.files = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        confirmFileDeletion(comment) {
            window.scrollTo(0,0)
            this.$buefy.dialog.confirm({
                title: this.translations.core.messages_danger_files_delete_confirmation_title,
                message: this.translations.core.messages_danger_files_delete_confirmation_body,
                confirmText: this.translations.core.messages_danger_files_delete_confirmation_accept_button,
                cancelText: this.translations.core.messages_danger_files_delete_confirmation_cancel_button,
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteFile(comment)
            })
        },

        deleteFile(deleted_file){
            let file_id = deleted_file.id
            let url = `${this.main_route}/${this.cloudId}/files/${file_id}.json`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.core.messages_info_file_destroyed)
                    this.bus.publish(`delete:${this.main_route}/files`, deleted_file)

                    // We trigger a reload in the activities when a file is uploaded
                    if(this.data.reload){
                        this.data.reload.activities = true
                    }
                }else{
                    this.msg.error(result.error.message)
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
                    `${this.main_route}/${this.cloudId}/resources/files-zip-download?ids=${file_ids}`
                )
            }
        }
    },

    beforeDestroy(){
        this.bus.$off(`post:${this.main_route}/files-complete`)
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
    <section>
        <div class="columns">
            <div class="column is-6">
                <b-checkbox v-model="all_files_selected">
                    {{translations.core.view_text_files_select_all}}
                </b-checkbox>
            </div>
            <div class="column is-6 has-text-right">
                <a :disabled="selectedFiles" class="button is-outlined is-primary" role="button" @click="downloadSelectedFiles">
                    <b-icon size="is-small" icon="download" />
                    &nbsp;
                    {{translations.core.view_btn_files_download_selected}}
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

                <b-table-column field="name" :label="translations.core.column_files_name" sortable>
                    {{ props.row.name }}
                </b-table-column>

                <b-table-column field="file_type" :label="translations.core.column_files_file_type" sortable>
                    {{
                        object_utils.translateEnum(translations.file_types, 'enum_file_type', props.row.file_type, null) ||
                        object_utils.translateEnum(translations.file_types, 'column_enum_file_type', props.row.file_type)
                    }}
                </b-table-column>

                <b-table-column field="created_at_raw" :label="translations.core.column_created_at" sortable>
                    {{ props.row.created_at }}
                </b-table-column>

                <b-table-column field="actions" :label="translations.core.view_table_header_actions" class="has-text-right">
                    <a
                        :href="`${main_route}/${cloudId}/files/${props.row.id}`"
                        target="_blank"
                        class="button is-outlined"
                    >
                        <b-icon size="is-small" icon="eye" />
                    </a>
                    <a
                        :href="`${main_route}/${cloudId}/files/${props.row.id}?download=true`"
                        download
                        class="button is-outlined"
                    >
                        <b-icon size="is-small" icon="download" />
                    </a>
                    <b-button v-if="props.row.editable" type="is-danger" outlined @click="confirmFileDeletion(props.row)">
                        <b-icon size="is-small" icon="trash-alt" />
                    </b-button>
                </b-table-column>
            </template>
        </b-table>
    </section>
</template>
