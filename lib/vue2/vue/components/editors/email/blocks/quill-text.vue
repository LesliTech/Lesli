<script>
/*

Copyright (c) 2021, all rights reserved.

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

import componentEditorRichText from "LesliVue/components/editors/richtext.vue"

export default {
    title: "Text",
    code: "quill-text",
    components: {
        "component-editor-richtext": componentEditorRichText
    },
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
            text: {}
        }
    },
    mounted() {
        this.text = this.value
    },
    methods:{
        emitValue(e) {
            this.$emit('input', e.target.innerText)
        }
    },
    watch: {
        value(val) {
            if (val !== this.text) {
                this.text = val
            }
        },
        text(val) {
            this.$emit('input', val)
        }
    }
}
</script>
<template>
    <table class="email-block-quill-text">
        <table>
            <tbody>
                <tr>
                    <th>
                        <component-editor-richtext type="simple" @blur="emitValue" v-model="text">
                        </component-editor-richtext>
                    </th>
                </tr>
            </tbody>
        </table>
    </table>
</template>
<style lang="css" scoped>
    .email-block-quill-text, 
    .email-block-quill-text table {
        width: 100%;
    }
</style>
