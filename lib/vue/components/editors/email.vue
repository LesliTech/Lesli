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


// · import foundation email blocks
import foundationGrid from "./email/foundation-grid";


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
            editor: null,
            emailBlocks: {
                grid: foundationGrid
            }
        }
    },
    mounted() {
        setTimeout(() => {

        this.editor = new EditorJS({
            holder: "lesli-editor-email",
            autofocus: true,
            placeholder: "Let`s build an awesome email!",
            data: this.value,
            onChange: async () => {
                const response = await this.editor.save()
                this.$emit("change", response)
                this.$emit("input", response)
            },
            tools: this.emailBlocks,
        })

        }, 800);

    },
    beforeDestroy() {
        if (this.editor) {
            this.editor.destroy();
        }
    },
    watch: {
        value: function(value) {

        }
    }

}
</script>
<template>
    <div class="mailer-email-template">
        <div id="lesli-editor-email"></div>
    </div>
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
