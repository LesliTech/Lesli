<script>
/*
Copyright (c) 2020, all rights reserved.

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


// · 
import Quill from "quill"


// · 
export default {
    props: {
        value: {
            type: Object,
            default: function() {
                return {}
            }
        },
        mode: {
            type: String,
            default: 'simple',
            required: false,
            validator: (val) => ['simple', 'full', 'read'].includes(val),
        },

        // DO NOT USE TYPE, USE MODE INSTEAD
        type: {
            type: String,
            default: 'simple',
            required: false,
            validator: (val) => ['simple', 'full', 'read'].includes(val),
        }
    },
    data () {
        return {
            editorContent: null,
            editorInstance: null,
            fullEditorOpts: {
                theme: 'snow',
                readOnly: false,
                placeholder: I18n.t('core.shared.view_placeholder_text_editor'),
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
            },
            simpleEditorOpts: {
                theme: 'snow',
                readOnly: false,
                placeholder: I18n.t('core.shared.view_placeholder_text_editor'),
                modules: {
                    toolbar: [
                        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                        ['bold', 'italic', 'underline', 'strike'],
                        [],
                        [{ 'list': 'ordered' }, { 'list': 'bullet' }, { 'align': [] }],
                        [{ 'color': [] }, { 'background': [] }],
                        [],
                        ['link', 'image'],
                        ['blockquote', 'code-block'],
                        [],
                        ['clean']                                         // remove formatting button
                    ]
                },
            },
            readEditorOpts: {
                theme: 'bubble',
                readOnly: true,
                toolbar2: [],
                modules: {
                    toolbar: []
                },
            }
        }
    },
    mounted () {
        this.initializeEditor()
    },
    methods: {

        initializeEditor () {
            let option_key = `${this.mode || this.type}EditorOpts`;
            let editorOpts = this[option_key]

            // Create the Quill instance
            this.editorInstance = new Quill(this.$refs.editorNode, editorOpts)

            // Set initial content that's going to be picked up by Quill
            if(this.value.delta){
                this.editorInstance.setContents(this.value.delta)
            }else{
                this.editorInstance.setContents(this.value)
            }

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
            this.$emit('input', { 
                delta: this.editorContent, 
                html: this.editorInstance.root.innerHTML 
            })

        },
        setEditorContent () {
            this.editorContent = this.editorInstance.getContents()
        }
    },
    watch: {
        value (newVal) {
            // Only update the content if it's changed from an external source
            // or else it'll act weird when you try to type anything
            if (newVal && newVal.delta !== this.editorContent) {
                this.editorInstance.setContents(newVal.delta)
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
