<script>
export default {
    name: "Grid"
}
</script>
<template>
    <table class="row">
        <tbody draggable="true">
            <tr draggable="true">
                <th class="small-12 large-4 columns first" draggable="true">
                    <table draggable="true">
                        <tbody draggable="true">
                            <tr draggable="true">
                                <th contenteditable="true" draggable="true">One</th>
                            </tr>
                        </tbody>
                    </table>
                    </th>
                    <th class="small-12 large-4 columns">
                    <table>
                        <tbody>
                            <tr>
                                <th contenteditable="true">Two</th>
                            </tr>
                        </tbody>
                    </table>
                    </th>
                    <th class="small-12 large-4 columns last">
                    <table>
                        <tbody>
                            <tr>
                                <th contenteditable="true">Three</th>
                            </tr>
                        </tbody>
                    </table>
                </th>
            </tr>
        </tbody>
    </table>
</template>
