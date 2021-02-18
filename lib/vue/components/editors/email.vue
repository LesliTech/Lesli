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
[{
    code: "foundation-grid",
    title: "Grid",
    content: "<h1><b>Mi titulo</b></h1>"
}]
*/


// · 
import draggable from "vuedraggable";


// · 
//import blockFoundationGrid from "./email/blocks/foundation-grid.vue"
//import blockFoundationMenu from "./email/blocks/foundation-menu.vue"
import blockFoundationButton from "./email/blocks/foundation-button.vue"
//import blockFoundationSpacer from "./email/blocks/foundation-spacer.vue"
import blockFoundationCallout from "./email/blocks/foundation-callout.vue"
//import blockFoundationWrapper from "./email/blocks/foundation-wrapper.vue"


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
    components: {
        draggable
    },
    data() {
        return {
            components: {
                "foundation-button": blockFoundationButton,
                "foundation-callout": blockFoundationCallout,
            },
            components_email: [],
            dragging: false,
            selected: 1
        };
    },
    methods: {
        addEmailComponent(i) {

            let componentCode = null

            if (typeof i == 'string') {
                componentCode = i
            }

            if (typeof i == 'object') {
                componentCode = i.target.value
            }

            if (componentCode === null) {
                return
            }

            this.components_email.push({
                code: componentCode,
                title: "title"
            })

        },
        emitValue() {

            let result = this.components_email.map((comp, i) => {
                return {
                    code: comp.code,
                    content: this.$refs[comp.code+'-'+i][0].$el.innerHTML
                }
            })

            // rails only accept hash parameters, it is not possible to send arrays
            this.$emit('input', { content: result })

        }
    },
    watch: {
        value(comps) {

            if (!comps) {
                return 
            }

            comps.content.forEach(comp => {
                this.components_email.push({
                    code: comp.code,
                    title: "hola",
                    content: "666999"
                })
            })
            
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
                        :list="components_email"
                        class="list-group"
                        ghost-class="ghost"
                        @start="dragging = true"
                        @end="dragging = false">
                        <div
                            class="list-group-item"
                            v-for="(element, i) in components_email"
                            :key="element.code+'-'+i" >
                            <component 
                                v-model="element.content"
                                :content="element.content"
                                v-bind:is="components[element.code]">
                            </component>
                        </div>
                    </draggable>
                </section>
            </div>
            <div class="column is-2 email-component-list">
                <div class="control has-icons-left">
                    <div class="select is-fullwidth email-component-selector">
                        <select v-model="selected" v-on:change="addEmailComponent">
                            <option value="1">Add email component</option>
                            <option :value="comp.code" v-for="(comp, i) in components" :key="i">
                                {{ comp.title }}
                            </option>
                        </select>
                    </div>
                    <span class="icon is-small is-left has-text-info">
                        <i class="fas fa-cube"></i>
                    </span>
                </div>
                <button class="button" @click="emitValue">test</button>
            </div>
        </div>
    </section>
</template>
