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
        message:{
            type: String,
            default: ''
        },
        show: {
            type: Boolean,
            default: false
        },
        type: {
            type: String,
            default: 'is-info'
        }
    },
    methods: {
        dismissNotification(){
            this.$emit('update:show',false);
        }
    }
}
</script>
<template>
   <transition name="fade">
      <div v-if="show" :class="['notification', this.type]">
         <button type="button" class="delete" @click="dismissNotification"></button>
         {{message}}
      </div>
   </transition>
</template>
