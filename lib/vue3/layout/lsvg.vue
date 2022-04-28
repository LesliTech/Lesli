<script>
export default {
    props: {
        id: {
            required: true,
            type: String
        },
        size: {
            default: "24"
        }
    }
}
</script>
<template>
<svg :width="`${size}px`" :height="`${size}px`"><use :xlink:href="'#icon-' + id" /></svg>
</template>
