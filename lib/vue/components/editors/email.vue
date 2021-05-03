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



/*
IMPORTANT: The use of @input on block components make text writing going backwards
*/


// ·
import draggable from "vuedraggable";


// ·
import blockFoundationGrid from "./email/blocks/foundation-grid.vue"
import blockFoundationMenu from "./email/blocks/foundation-menu.vue"
import blockFoundationButton from "./email/blocks/foundation-button.vue"
import blockFoundationSpacer from "./email/blocks/foundation-spacer.vue"
import blockFoundationCallout from "./email/blocks/foundation-callout.vue"
import blockQuillText from "./email/blocks/quill-text.vue"
//import blockFoundationWrapper from "./email/blocks/foundation-wrapper.vue"


// ·
export default {
    props: {
        value: {
            type: Object,
            default: function() {
                return {
                    blocks: []
                }
            }

        }
    },
    components: {
        draggable
    },
    data() {
        return {
            components: {
                // "foundation-grid": blockFoundationGrid,
                // "foundation-menu": blockFoundationMenu,
                // "foundation-button": blockFoundationButton,
                "foundation-spacer": blockFoundationSpacer,
                // "foundation-callout": blockFoundationCallout,
                "quill-text": blockQuillText
            },
            components_email: { blocks:[] },
            dragging: false,
            selected: 1
        };
    },
    methods: {
        addEmailComponent(componentCode) {
            this.components_email.blocks.push({
                code: componentCode,
                title: "title"
            })
        },
        emitValue() {

            // rails only accept hash parameters, it is not possible to send arrays
            this.$emit('input', this.components_email)

        }
    },
    watch: {
        value(value) {
            this.components_email = (value  || { blocks:[] })
        }
    }
};
</script>
<template>
    <section class="lesli-editor-email">
        <div class="columns">
            <div class="column is-10">
                <section class="email-preview">
                    <draggable
                        :list="components_email.blocks"
                        class="list-group"
                        ghost-class="ghost"
                        @onUpdate="emitValue"
                        @start="dragging = true"
                        @end="dragging = false">
                        <div
                            class="list-group-item"
                            v-for="(element, i) in components_email.blocks"
                            :key="element.code+'-'+i" >
                            <component
                                v-model="element.content"
                                @input="emitValue"
                                v-bind:is="components[element.code]">
                            </component>
                        </div>
                    </draggable>
                </section>
            </div>
            <div class="column is-2 email-component-list">
                <div class="pt-2">
                    <button
                        class="button is-fullwidth mb-2"
                        v-for="component in components"
                        :key="component.code"
                        @click="addEmailComponent(component.code)">
                        {{ component.title }}
                    </button>
                </div>
            </div>
        </div>
    </section>
</template>
