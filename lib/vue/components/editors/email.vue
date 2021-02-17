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


// · 
import draggable from "vuedraggable";


// · 
import blockFoundationGrid from "./email/blocks/foundation-grid.vue"
import blockFoundationMenu from "./email/blocks/foundation-menu.vue"
import blockFoundationButton from "./email/blocks/foundation-button.vue"
import blockFoundationSpacer from "./email/blocks/foundation-spacer.vue"
import blockFoundationCallout from "./email/blocks/foundation-callout.vue"
import blockFoundationWrapper from "./email/blocks/foundation-wrapper.vue"


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
            components: [
                blockFoundationGrid,
                blockFoundationMenu,
                blockFoundationButton,
                blockFoundationSpacer,
                blockFoundationCallout,
                blockFoundationWrapper
            ],
            components_email: [],
            dragging: false,
            selected: 1
        };
    },
    methods: {
        addEmailComponent(i) {
            this.components_email.push(this.components[parseInt(i.target.value)])
        }
    },
    watch: {
        value(val) {

        },
        components_email(val) {
            this.$emit('input', { components:val.map(c => c.name) })
        }
    }
};
</script>
<template>
    <section class="lesli-editor-email">
        <div class="columns">
            <div class="column is-3 email-component-list">
                <div class="control has-icons-left">
                    <div class="select is-fullwidth email-component-selector">
                        <select v-model="selected" v-on:change="addEmailComponent">
                            <option value="1">Add email component</option>
                            <option :value="i" v-for="(comp, i) in components" :key="i">
                                {{ comp.name }}
                            </option>
                        </select>
                    </div>
                    <span class="icon is-small is-left has-text-info">
                        <i class="fas fa-cube"></i>
                    </span>
                </div>
                <draggable
                    :list="components_email"
                    class="list-group"
                    ghost-class="ghost"
                    @start="dragging = true"
                    @end="dragging = false"
                    >
                    <div
                        class="list-group-item"
                        v-for="element in components_email"
                        :key="element.name">
                        <span class="icon">
                            <i class="fas fa-arrows-alt"></i>
                        </span>
                        <span>{{ element.name }}</span>
                    </div>
                </draggable>
            </div>
            <div class="column is-9">
                <section class="email-preview">
                    <component v-for="(comp, i) in components_email" :key="i" v-bind:is="comp"></component>
                </section>
            </div>
        </div>
    </section>
</template>
