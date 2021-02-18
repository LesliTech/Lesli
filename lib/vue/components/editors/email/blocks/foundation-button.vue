<script>
export default {
    title: "Button",
    code: "foundation-button",
    props: {
        value: {
            type: String,
            default: "Button"
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
    <table class="button">
        <tbody>
            <tr>
                <td>
                    <table>
                        <tbody>
                            <tr>
                                <td>
                                    <a 
                                        href="#" 
                                        @blur="emitValue" 
                                        @input="emitValue"
                                        contenteditable="true">
                                        {{ value }}
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
</template>
