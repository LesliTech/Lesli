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
        }
    },

    components: {
        'vue-dropzone': VueDropzone
    },

    data(){
        return {
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
        this.setDropzoneOptions()
        this.getBackendData()
    },

    methods: {

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
            let url = `/${this.module_name.slash}/options/${this.object_name.singular}/files`

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

        cleanDropzone(){
            this.submitting_form = false
            this.notification.alert('Files uploaded successfully', 'success')
            this.$refs['dropzone'].removeAllFiles(true);
            this.$emit('upload-complete')
            this.bus.publish(`post:/${this.module_name.slash}/${this.object_name.plural}/files-complete`)
        },

        filePosted(file, response){
            this.bus.publish(`post:/crm/${this.object_name.plural}/files`, response.data)
        }
    },

    watch: {
        active(){
            if(this.file_options.file_types == 0){
                this.getBackendData()
            }
        }
    }
}
</script>
<template>
    <form @submit="postFiles">
        <div class="columns is-marginless has-border-bottom">
            <div class="column is-2">
                <strong>Type</strong><sup class="has-text-danger">*</sup>
            </div>
            <div class="column is-10">
                <b-field>
                    <b-select expanded placeholder="Select a document type" v-model="file_type" required>
                        <option v-for="file_type in file_options.file_types" :key="file_type.value" :value="file_type.value">
                            {{file_type.text}}
                        </option>
                    </b-select>
                </b-field>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-2">
                <strong>File(s)</strong><sup class="has-text-danger">*</sup>
            </div>
            <div class="column is-10">
                <b-field>
                    <vue-dropzone
                        ref="dropzone"
                        v-if="dropzone_options.url"
                        id="files-dropzone"
                        :options="dropzone_options"
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
                    Saving
                </span>
                <span v-else>
                    Save
                </span>
            </b-button>
        </div>
    </form>
</template>
