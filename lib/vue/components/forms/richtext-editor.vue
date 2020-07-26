<script>
import Quill from 'quill'

export default {
    props: {
        value: {
            default: '',
            type: String
        }
    },
    data () {
        return {
            editorContent: null,
            editorInstance: null,
            editorOpts: {
                theme: 'snow',
                toolbar2: [
                        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                        [{ 'font': [] }],
                        ['bold', 'italic', 'underline', 'strike'],
                        ['blockquote', 'code-block'],
                        [{ 'list': 'ordered' }, { 'list': 'bullet' }, { 'align': [] }],
                        [{ 'color': [] }, { 'background': [] }],
                        ['clean'],
                        ['link', 'image', 'video'],
                        [{ 'direction': 'rtl' }]
                    ],
                modules: {
                    toolbar: [
                        ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
                        ['blockquote', 'code-block'],

                        [{ 'header': 1 }, { 'header': 2 }],               // custom button values
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        [{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript
                        [{ 'indent': '-1'}, { 'indent': '+1' }],          // outdent/indent
                        [{ 'direction': 'rtl' }],                         // text direction

                        [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown
                        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

                        [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
                        [{ 'font': [] }],
                        [{ 'align': [] }],

                        ['clean']                                         // remove formatting button
                    ]
                },
            }
        }
    },
    mounted () {
        this.initializeEditor()
    },
    methods: {
        initializeEditor () {

            // Set initial content that's going to be picked up by Quill
            this.$refs.editorNode.innerHTML = this.value

            // Create the Quill instance
            this.editorInstance = new Quill(this.$refs.editorNode, this.editorOpts)

            // Setup handler for whenever things change inside Quill
            this.editorInstance.on('text-change', this.onEditorContentChange)

            // Save any initial content to this.editorContent
            this.setEditorContent()

        },
        onEditorContentChange () {

            // Whenever we change anything, update this.editorContent
            this.setEditorContent()

            // Then emit its value as input so we have a working v-model
            // This $emit will be catched up in the watch:value
            // that's why we guard against calling pasteHTML
            // calling that function while we are typing is undesirable
            this.$emit('input', this.editorContent)

        },
        setEditorContent () {
            this.editorContent = this.editorInstance.getText().trim()
            ? this.editorInstance.root.innerHTML : ''
        }
    },
    watch: {
        value (newVal) {
            // Only update the content if it's changed from an external source
            // or else it'll act weird when you try to type anything
            if (newVal !== this.editorContent) {
                this.editorInstance.pasteHTML(newVal)
            }
        }
    },
    beforeDestroy () {
        // Turn off all listeners set on text-change
        this.editorInstance.off('text-change')
    }
}
</script>
<template>
    <div class="component-richtext-editor">
        <div class="editor-node" ref="editorNode"></div>
    </div>
</template>
