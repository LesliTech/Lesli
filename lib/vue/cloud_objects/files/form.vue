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

        translationsPath: {
            type: String,
            default: 'core.shared'
        },

        acceptedFileExtensions: {
            type: Array,
            default: null
        },

        translationsFileTypesPath: {
            type: String,
            default: null
        }
    },

    components: {
        'vue-dropzone': VueDropzone
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            },
            submitting_form: false,
            module_name: null,
            object_name: null,
            file_options: {
                file_types: []
            },
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
        this.setTranslations()
        this.setDropzoneOptions()
        this.getBackendData()
    },

    methods: {

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))

            if(this.translationsFileTypesPath){
                this.translations.file_types = I18n.t(this.translationsFileTypesPath)
            }
        },

        setDropzoneOptions(){
            this.dropzone_options.url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/files`
            this.dropzone_options.paramName = `${this.object_name.singular}_file[attachment]`
        },

        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        getBackendData(){
            if(this.active){
                this.getFileOptions()
            }
        },

        getFileOptions(){
            let url = `/${this.module_name.slash}/${this.object_name.plural}/files/options`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.file_options = result.data
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postFiles(event){
            if(event){
                event.preventDefault()
            }

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
                this.notification.alert(this.translations.core.notification_error_file_type_not_allowed, 'danger')
                this.$refs['dropzone'].removeFile(file)
            }
        },

        cleanDropzone(){
            this.submitting_form = false
            this.notification.alert(this.translations.main.notification_file_uploaded, 'success')
            this.$refs['dropzone'].removeAllFiles(true)
            this.$emit('upload-complete')
            this.bus.publish(`post:/${this.module_name.slash}/${this.object_name.plural}/files-complete`)
        },

        filePosted(file, result){
            if(result.successful){
                this.bus.publish(`post:/${this.module_name.slash}/${this.object_name.plural}/files`, result.data)
            }else{
                this.notification.alert(result.error.message,'danger')
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
    <form @submit="postFiles" v-if="translations.main">
        <div class="columns is-marginless has-border-bottom">
            <div class="column is-3">
                <strong>{{translations.main.files_input_type_title}}</strong><sup class="has-text-danger">*</sup>
            </div>
            <div class="column is-9">
                <b-field>
                    <b-select expanded :placeholder="translations.core.text_select_option" v-model="file_type" required>
                        <option v-for="file_type in file_options.file_types" :key="file_type.value" :value="file_type.value">
                            <span v-if="translations.file_types">
                                {{translateFileType(file_type.text)}}
                            </span>
                            <span v-else>
                                {{file_type.text}}
                            </span>
                        </option>
                    </b-select>
                </b-field>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-3">
                <strong>{{translations.main.files_input_file_title}}</strong><sup class="has-text-danger">*</sup>
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
                        v-on:vdropzone-success="filePosted"
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
                    {{translations.core.btn_saving}}
                </span>
                <span v-else>
                    {{translations.core.btn_save}}
                </span>
            </b-button>
        </div>
    </form>
</template>
