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

export default {
    props: {
        right: {
            default: true
        },
        open: {
            default: false
        },
        size: {
            type: String,
            required: false,
            validator: (val) => ["small", "medium", "large"].includes(val),
            default: "normal",
        },
        canCancel: {
            default: ['escape', 'outside']
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
        type="is-light"
        :can-cancel="canCancel"
        :class="[size]"
        :fullheight="true"
        :fullwidth="false"
        :overlay="false"
        :right="right"
        :open.sync="isOpen">
        <slot></slot>
    </b-sidebar>
</template>

<style>
.small .sidebar-content {
    width: 40%;
    max-width: 40%;
}

.medium .sidebar-content {
    width: 60%;
    max-width: 60%;
}

.large .sidebar-content {
    width: 70%;
    max-width: 70%;
}
</style>
