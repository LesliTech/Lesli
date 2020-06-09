<script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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
