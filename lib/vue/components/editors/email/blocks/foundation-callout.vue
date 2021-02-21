<script>
export default {
    title: "Callout",
    code: "foundation-callout",
    props: {
        value: {
            type: String,
            default: "I'm in a callout!"
        }
    },
    methods:{
        emitValue(e) {
            this.$emit('input', e.target.innerText)
        }
    }
}
</script>
<template>
    <table class="callout">
        <tbody>
            <tr>
                <th class="callout-inner success">
                    <p
                        @blur="emitValue" 
                        @input="emitValue"
                        contenteditable="true">
                        {{ value }}
                    </p>
                </th>
                <th class="expander"></th>
            </tr>
        </tbody>
    </table>
</template>
