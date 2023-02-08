<script setup>


// · defining props
const props = defineProps({
    component: Object
})

</script>
<template>
    <div class="box has-text-centered">
        <h2>hello world</h2>
        {{ component }}
    </div>
</template>
