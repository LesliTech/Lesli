<script>
export default {
   props: {
      active:{
         type: Boolean,
         default: false
      }
   }
}
</script>
<template>
   <span>
      <progress v-if="active" class="progress is-very-small is-primary" max="100"/>
      <progress v-if="!active" class="progress is-very-small is-primary" max="100" value="0"/>
   </span>
</template>