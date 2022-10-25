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
export default {
    props: {
        title: {
            type: String,
            required: true
        },
        open: {
            default: false
        },
        size: {
            type: String,
            default: "small",
            validator: (val) => ["small", "medium", "large"].includes(val)
        },
        closePanel() {

            // here we can emit an event when clossing if needed

        }
    },
    data() {
        return {
            isOpen: false
        }
    },
    watch: {
        open: function(value) {
            this.isOpen = value
        },
        isOpen: function(isOpen) {
            this.$emit('update:open', isOpen)
        }
    }
}
</script>
<template>
    <b-sidebar
        :class="['panel-container', 'application-panel', size]"
        :open.sync="isOpen"
        :right="true"
        :fullheight="true"
        :overlay="true"
        :can-cancel="['escape', 'outside']"
        :on-cancel="closePanel">
        <div class="panel-title is-size-5">
            <h4>{{ title }}</h4>
            <span class="icon is-large hover" @click="open = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>
        <slot></slot>
    </b-sidebar>
</template>
<style>
.panel-container {
    z-index: 100;
    position: absolute;
    width: 100%;
    top: 0%;
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
}
</style>
