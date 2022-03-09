<script>
/*

Copyright (c) 2021, all rights reserved.

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
    title: "Grid",
    code: "foundation-grid",
    props: {
        value: {
            type: String,
            default: "Grid"
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
    <table class="row block-component">
        <tbody>
            <tr>
                <th class="small-12 large-4 columns first">
                    <table>
                        <tbody>
                            <tr>
                                <th contenteditable="true">One</th>
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
