<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, watch } from "vue"


// · defining props
const props = defineProps({
    size: {
        type: Number,
        default: 5
    },
    icon: {
        type: Boolean,
        default: false
    }
})


// · defining variables
const translations = {
    shared: I18n.t('core.shared')
}

</script>
<template>
    <div class="lesli-loading has-text-centered">
        <p>
            <span class="loading-animation">
                <hr/><hr/><hr/><hr/>
            </span>
            <span 
                v-if="!icon"
                :class="['is-size-'+size, 'ml-3']">
                {{ translations.shared.view_text_loading }}...
            </span>
        </p>
    </div>
</template>
