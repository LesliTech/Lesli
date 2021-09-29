<script>
/*

Copyright (c) 2020, all rights reserved.

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


// · 
export default {

}
</script>
<template>
    <section>
        <b-sidebar
            class="application-panel-engines"
            :open.sync="data.global.show_panel_engines"
            :right="true"
            :overlay="false"
            :fullheight="true">
            <div class="panel-title">
                <slot name="header"></slot>
            </div>
            <div class="panel-content">
                <div class="links">
                    <slot></slot>
                </div>
            </div>
            <div class="panel-footer">
                <slot name="footer"></slot>
            </div>
        </b-sidebar>
    </section>
</template>
