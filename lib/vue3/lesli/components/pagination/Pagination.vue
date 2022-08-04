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

    currentPage.value = props.pagination.page
    lastPage.value = props.pagination.pages

    previousPage.value = currentPage.value - 1
    nextPage.value = currentPage.value + 1
    return

    if (currentPage.value > 1) {
        previousPage.value = currentPage.value - 1
    }

    if (currentPage.value < lastPage.value) {
        nextPage.value = currentPage.value + 1
    }

    // if first page we enable to navigate to the last page
    if (currentPage.value >= lastPage.value) {
        nextPage.value = lastPage.value
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


// · 
const disableNext = computed(() => nextPage.value > lastPage.value)
const disablePrevious = computed(() => previousPage.value < 1)

</script>
<template>
    <nav class="pagination" role="navigation" aria-label="pagination">
        <ul class="pagination-list">
            <template v-if="props.pagination.pages > 1">
                <li>
                    <button class="button pagination-link" @click.stop="paginate(1)" :disabled="currentPage == 1">
                        1 
                    </button>
                </li>
                <li>
                    <span class="pagination-ellipsis">&hellip;</span>
                </li>
                <li>
                    <button class="button pagination-link" @click.stop="paginate(previousPage)" :disabled="disablePrevious">
                        {{( disablePrevious ? '' : previousPage )}}
                    </button>
                </li>
                <li>
                    <button class="button pagination-link is-current" aria-label="Page 46">
                        {{ currentPage }}
                    </button>
                </li>
                <li>
                    <button class="button pagination-link" @click.stop="paginate(nextPage)" :disabled="disableNext">
                        {{( disableNext ? '' : nextPage )}}
                    </button>
                </li>
                <li>
                    <span class="pagination-ellipsis">&hellip;</span>
                </li>
                <li>
                    <button class="button pagination-link" @click.stop="paginate(lastPage)" :disabled="currentPage == lastPage">
                        {{ lastPage }}
                    </button>
                </li>
            </template>
        </ul>
        
        <button 
            class="button is-primary is-outlined pagination-previous" 
            @click.stop="paginate(previousPage)"
            :disabled="disablePrevious">
            Previous 
        </button>
        <button 
            class="button is-primary is-outlined pagination-previous" 
            @click.stop="paginate(nextPage)"
            :disabled="disableNext">
            Next page 
        </button>
    </nav>
</template>
