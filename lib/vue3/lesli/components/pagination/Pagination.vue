<script setup>
/*
Copyright (c) 2022, all rights reserved.

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


// · import vue tools
import { ref, reactive, onMounted, watch, computed } from "vue"


// · defining emits
const emit = defineEmits(['paginate']);


// · defining props
const props = defineProps({
    pagination: {
        type: Object,
        required: true
    }
})


// · pagination details
const previousPage = ref(0)
const currentPage = ref(0)
const nextPage = ref(0)
const lastPage = ref(0)


// · look for changes in pagination 
watch(() => props.pagination, (val) => {

    currentPage.value = props.pagination.current_page
    lastPage.value = props.pagination.total_pages

    if (currentPage.value > 1) {
        previousPage.value = currentPage.value - 1
    }

    if (currentPage.value < lastPage.value) {
        nextPage.value = currentPage.value + 1
    }

    // if first page we enable to navigate to the last page
    if (currentPage.value >= lastPage.value) {
        nextPage.value = 1
    }

    // if last page we enable to navigate to the first page
    if (currentPage.value <= 1) {
        previousPage.value = lastPage.value
    }

})


// · emit the page selected
function paginate(page) {
    emit('paginate', page)
}


</script>
<template>
    <nav class="pagination" role="navigation" aria-label="pagination">
        <ul class="pagination-list">
            <li>
                <a class="pagination-link" @click.stop="paginate(1)" aria-label="Goto page 1">
                    1
                </a>
            </li>
            <li>
                <span class="pagination-ellipsis">&hellip;</span>
            </li>
            <li>
                <a class="pagination-link" @click.stop="paginate(previousPage)" aria-label="Goto page 45">
                    {{ previousPage }}
                </a>
            </li>
            <li>
                <a class="pagination-link is-current" aria-label="Page 46" aria-current="page">
                    {{ currentPage }}
                </a>
            </li>
            <li>
                <a class="pagination-link" @click.stop="paginate(nextPage)" aria-label="Page 46">
                    {{ nextPage }}
                </a>
            </li>
            <li>
                <span class="pagination-ellipsis">&hellip;</span>
            </li>
            <li>
                <a class="pagination-link" @click.stop="paginate(lastPage)" aria-label="Goto page 86">
                    {{ lastPage }}
                </a>
            </li>
        </ul>
        <a  :class="['pagination-previous', {'is-disabled': previousPage <= 1}]" 
            @click.stop="paginate(previousPage)">
            Previous
        </a>
        <a  :class="['pagination-previous', {'is-disabled': nextPage >= lastPage}]" 
            @click.stop="paginate(nextPage)">
            Next page
        </a>
    </nav>
</template>
