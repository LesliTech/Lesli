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
                        contenteditable="true">
                        {{ value }}
                    </p>
                </th>
                <th class="expander"></th>
            </tr>
        </tbody>
    </table>
</template>
