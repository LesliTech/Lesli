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
import EditorJS from "@editorjs/editorjs";



// · import plugins
import pluginCode from "@editorjs/code";
import pluginLink from "@editorjs/link";
import pluginList from "@editorjs/list";
import pluginTable from "@editorjs/table";
import pluginQuote from "@editorjs/quote";
import pluginImage from "@editorjs/image";
import pluginHeader from "@editorjs/header";
import pluginChecklist from "@editorjs/checklist";
import pluginUnderline from "@editorjs/underline";



// · 
export default {
    props: {
        value: {
            type: Object,
            default: function() {
                return {}
            }
        }
    },
    data() {
        return {
            editor: null
        }
    },
    mounted() {
        this.editor = new EditorJS({
            holder: "editor-html",
            autofocus: true,
            placeholder: "Let`s write an awesome story!",
            onChange: async () => {
                const response = await this.editor.save()
                this.$emit("change", response)
                this.$emit("input", response)
            },
            tools: {
                header: {
                    class: pluginHeader,
                    config: {
                        placeholder: "Enter a header",
                        levels: [1, 2, 3, 4, 5, 6],
                        defaultLevel: 2
                    }
                },
                checklist: {
                    class: pluginChecklist,
                    inlineToolbar: true,
                },
                linkTool: {
                    class: pluginLink,
                    config: {
                        endpoint: "http://localhost:8008/fetchUrl",
                    }
                },
                list: {
                    class: pluginList,
                    inlineToolbar: true,
                },
                table: {
                    class: pluginTable,
                    inlineToolbar: true,
                    config: {
                        rows: 2,
                        cols: 3,
                    },
                },
                image: {
                    class: pluginImage,
                    config: {
                        endpoints: {
                            byFile: "http://localhost:8008/uploadFile", // Your backend file uploader endpoint
                            byUrl: "http://localhost:8008/fetchUrl", // Your endpoint that provides uploading by Url
                        }
                    }
                },
                quote: {
                    class: pluginQuote,
                    inlineToolbar: true,
                    shortcut: "CMD+SHIFT+O",
                    config: {
                        quotePlaceholder: "Enter a quote",
                        captionPlaceholder: "Quote\"s author",
                    },
                },
                code: {
                    class: pluginCode
                },
                underline: {
                    class: pluginUnderline
                }
            },
        });
    },
    beforeDestroy() {
        if (this.editor) {
            this.editor.destroy();
        }
    },

}
</script>
<template>
    <div id="editor-html"></div>
</template>
<style lang="css">
.ce-block__content,
.ce-toolbar__content {
    max-width: unset;
    padding-left: 50px;
}

.codex-editor--narrow .ce-toolbar__actions {
    left: 0;
    top: 9px;
}

.codex-editor--narrow .ce-toolbar__actions .icon.icon--dots {
    height: 15px;
    width: 15px;
}

.codex-editor--narrow .ce-toolbar__plus {
    left: 17px;
    top: -1px !important;
}   

.codex-editor--narrow .ce-toolbar__plus .icon.icon--plus {
    height: 15px;
    width: 15px;
}
</style>
