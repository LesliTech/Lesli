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
export default {
    data() {
        return {
            translations: {
                shared: I18n.t('deutscheleibrenten.shared')
            },
        }
    },
}
</script>
<template>
    <section class="component-data-empty">
        <div class="card">
            <div class="card-content">
                <div class="image"></div>
                <p>{{ translations.shared.text_no_data_available }}</p>
            </div>
        </div>
    </section>
</template>
