<script>
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
   },
   computed: {
      notificationClass(){
         return `notification ${this.type}`;
      }
   }
}
</script>
<template>
   <transition name="fade">
      <div v-if="show" :class="notificationClass">
         <button type="button" class="delete" @click="dismissNotification"></button>
         {{message}}
      </div>
   </transition>
</template>