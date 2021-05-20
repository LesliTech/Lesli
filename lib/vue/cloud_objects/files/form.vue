<script>
import VueDropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'

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

        acceptedFileExtensions: {
            type: Array,
            default: null
        },

        translations: {
            required: true
        }
    },

    components: {
        'vue-dropzone': VueDropzone
    },

    data(){
        return {
            main_route: null,
            submitting_form: false,
            module_name: null,
            object_name: null,
            file_options: {
                file_types: []
            },
            upload_successful: true,
            dropzone_options: {
                url: null,
                thumbnailWidth: 150,
                paramName: null,
                autoProcessQueue: false,
                addRemoveLinks: true,
                method: "POST",
                headers: {
                    "X-CSRF-Token": document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute("content")
                }
            },
            file_type: null
        }
    },

    mounted(){
        this.parseCloudModule()
        this.setDropzoneOptions()
        this.getBackendData()
    },

    methods: {
        setDropzoneOptions(){
            this.dropzone_options.url = `${this.main_route}/${this.cloudId}/files`
            this.dropzone_options.paramName = `${this.object_name.singular}_file[attachment]`
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
                this.getFileOptions()
            }
        },

        getFileOptions(){
            let url = `${this.main_route}/files/options`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.file_options = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postFiles(event){
            if(event){
                event.preventDefault()
            }
            this.upload_successful = true

            let dropzone = this.$refs['dropzone']
            this.submitting_form = true
            if(dropzone.getAcceptedFiles().length > 0){
                dropzone.processQueue()
            }else{
                this.submitting_form = false
            }
        },

        attachFileType(file, xhr, formData){
            let data = new FormData();
            let param_name = `${this.object_name.singular}_file`
            formData.append(`${param_name}[file_type]`, this.file_type)
        },

        verifyFileAdded(file){
            if(! this.acceptedFileExtensions){
                return
            }

            let accepted_file_type = false

            for(let i = 0; i < this.acceptedFileExtensions.length; i++){
                let extension = this.acceptedFileExtensions[i]
                if(file.name.toLowerCase().endsWith(extension)){
                    accepted_file_type = true
                    break
                }
            }

            if(! accepted_file_type){
                this.msg.error(this.translations.core.messages_warning_files_extension_not_allowed)
                this.$refs['dropzone'].removeFile(file)
            }
        },

        cleanDropzone(){
            this.submitting_form = false
            if(this.upload_successful){
                this.msg.success(this.translations.core.messages_info_file_created)
            }

            this.$emit('upload-complete')
            this.bus.publish(`post:${this.main_route}/files-complete`)
            this.$refs['dropzone'].removeAllFiles(true)

            // We trigger a reload in the activities when a file is uploaded
            if(this.data.reload){
                this.data.reload.activities = true
            }
        },

        displayUploadError(_file, message){
            this.upload_successful = false
            this.msg.error(message)
        },
    },

    watch: {
        active(){
            if(this.file_options.file_types == 0){
                this.getBackendData()
            }
        },

        cloudId(){
            if(this.cloudId){
                this.dropzone_options.url = null
                this.$nextTick(()=>{
                    this.setDropzoneOptions()
                })
            }
        }
    }
}
</script>
<template>
    <form @submit="postFiles">
        <div class="columns is-marginless has-border-bottom">
            <div class="column is-3">
                <strong>{{translations.core.column_files_file_type}}</strong><sup class="has-text-danger">*</sup>
            </div>
            <div class="column is-9">
                <b-field>
                    <b-select expanded :placeholder="translations.core.view_placeholder_select_option" v-model="file_type" required>
                        <option v-for="file_type in file_options.file_types" :key="file_type.value" :value="file_type.value">
                            {{
                                object_utils.translateEnum(translations.file_types, 'enum_file_type', file_type.text, null) ||
                                object_utils.translateEnum(translations.file_types, 'column_enum_file_type', file_type.text)
                            }}
                        </option>
                    </b-select>
                </b-field>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-3">
                <strong>{{translations.core.column_files_attachment}}</strong><sup class="has-text-danger">*</sup>
            </div>
            <div class="column is-9">
                <b-field>
                    <vue-dropzone
                        :id="`vue-dropzone-${cloudModule}-${cloudId}`"
                        ref="dropzone"
                        v-if="dropzone_options.url"
                        :options="dropzone_options"
                        v-on:vdropzone-file-added="verifyFileAdded"
                        v-on:vdropzone-sending="attachFileType"
                        v-on:vdropzone-error="displayUploadError"
                        v-on:vdropzone-queue-complete="cleanDropzone"
                    ></vue-dropzone>
                </b-field>
            </div>
        </div>

        <br>

        <div class="buttons">
            <b-button type="is-primary" expanded native-type="submit" class="submit-button" :disabled="submitting_form">
                <span v-if="submitting_form">
                    <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                    &nbsp;
                    {{translations.core.view_btn_saving}}
                </span>
                <span v-else>
                    {{translations.core.view_btn_save}}
                </span>
            </b-button>
        </div>
    </form>
</template>
