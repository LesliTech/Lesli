<script>
export default {
    title: "Callout",
    code: "foundation-callout",
    props: {
        content: {
            type: String,
            default: "message"
        }
    }
}
</script>
<template>
    <table class="callout">
        <tbody>
            <tr>
                <th class="callout-inner success">
                    <p>{{ content }}</p>
                </th>
                <th class="expander"></th>
            </tr>
        </tbody>
    </table>
</template>
