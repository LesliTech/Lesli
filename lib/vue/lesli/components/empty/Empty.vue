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
    text: {
        type: String,
        default: ""
    }
})


// · defining variables
const translations = {
    shared: {
        view_text_no_data_found: I18n.t('core.shared.view_text_no_data_found')
    }
}

</script>
<template>
    <div class="lesli-empty has-text-centered">
        <svg width="184" height="184" viewBox="0 0 184 184" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M145.271 90.6522H142.735V89.528C142.735 83.9793 138.222 79.4655 132.673 79.4655H85.7357C84.255 79.4655 82.1132 78.0942 81.4922 76.7515L76.1878 65.2544C74.1523 60.8499 68.9629 57.5293 64.1128 57.5293H39.7012C34.1524 57.5293 29.6387 62.043 29.6387 67.5918V151.809C29.6387 157.358 34.1524 161.872 39.7012 161.872H53.3459C53.5357 161.883 53.7139 161.932 53.9065 161.932H112.945V153.307H108.831H53.9065C53.7197 153.307 53.6219 153.278 53.5587 153.247C53.527 153.232 53.4897 153.215 53.481 153.206C53.458 153.181 53.412 153.045 53.4609 152.772L63.1985 101.419C63.4027 100.338 64.6849 99.2772 65.7803 99.2772H134.11H142.735H145.271C145.553 99.2772 145.679 99.349 145.697 99.3749C145.714 99.4008 145.766 99.533 145.714 99.809L142.735 115.524L135.979 151.159C135.775 152.24 134.493 153.301 133.395 153.301H121.964V161.926H133.395C138.621 161.926 143.48 157.904 144.455 152.767L154.189 101.413C154.713 98.6648 154.037 95.9163 152.341 93.8693C150.645 91.8281 148.069 90.6522 145.271 90.6522ZM134.11 90.6522H65.7832C60.5593 90.6522 55.7005 94.6743 54.7259 99.8119L44.9883 151.168C44.856 151.864 44.8043 152.56 44.8244 153.247H39.7012C38.922 153.247 38.2637 152.588 38.2637 151.809V67.5918C38.2637 66.8127 38.922 66.1543 39.7012 66.1543H64.1128C65.5934 66.1543 67.7353 67.5257 68.3563 68.8683L73.6607 80.3654C75.6962 84.7699 80.8855 88.0905 85.7357 88.0905H132.673C133.452 88.0905 134.11 88.7489 134.11 89.528V90.6522Z" fill="#BDBDBD"/>
            <path d="M145.7 50.5227L153.201 43.0219C154.805 41.4176 154.739 38.7525 153.054 37.0677C151.369 35.383 148.704 35.3197 147.1 36.9211L139.599 44.422L132.098 36.9211C130.494 35.3169 127.829 35.383 126.144 37.0677C124.459 38.7525 124.396 41.4176 125.997 43.0219L133.498 50.5227L125.997 58.0236C124.393 59.6279 124.459 62.293 126.144 63.9777C127.829 65.6625 130.494 65.7257 132.098 64.1244L139.599 56.6235L147.1 64.1244C148.704 65.7286 151.369 65.6625 153.054 63.9777C154.739 62.293 154.802 59.6279 153.201 58.0236L145.7 50.5227Z" fill="#BDBDBD"/>
        </svg>
        <p v-if="text">{{ text }}</p>
        <p v-else>{{ translations.shared.view_text_no_data_found }}</p>
    </div>
</template>
