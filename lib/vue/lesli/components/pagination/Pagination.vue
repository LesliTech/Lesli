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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { computed } from "vue"


// · defining emits
const emit = defineEmits(['paginate']);


// · defining props
// · Pagination example
// { "page": 1, "pages": 15, "total": 225, "results": 225 } 
const props = defineProps({
    
    pagination: {
        type: Object,
        required: true
    },
    mode: {
        type: String,
        default: 'complete',
        required: false,
        validator: (val) => ['complete', 'simple'].includes(val),
    },
})


// · 
function paginateNext() {
    props.pagination.page++
    emit('paginate', props.pagination.page)
}


// · 
function paginatePrev() {
    props.pagination.page--
    emit('paginate', props.pagination.page)
}


// · 
function paginateLast() {
    props.pagination.page = props.pagination.pages
    emit('paginate', props.pagination.page)
}


// · 
function paginateTo(page) {
    props.pagination.page = page
    emit('paginate', props.pagination.page)
}


// · 
const disableNext = computed(() => props.pagination.page >= props.pagination.pages)
const disablePrev = computed(() => props.pagination.page <= 1)

</script>
<template>
    <nav class="pagination mb-5" role="navigation" aria-label="pagination">
        <ul class="pagination-list" v-if="props.mode==='complete'">
            <template v-if="props.pagination.pages > 1">
                <template v-for="page in 5"> 
                    <li v-if="page < props.pagination.pages">
                        <button 
                            class="button pagination-link" 
                            :class="{'is-current': props.pagination.page == page}"
                            @click.stop="paginateTo(page)">
                            {{ page }}
                        </button>
                    </li>
                </template>
                <li>
                    <span class="pagination-ellipsis">&hellip;</span>
                </li>
                <li>
                    <button 
                        class="button pagination-link" 
                        :class="{'is-current': props.pagination.page == props.pagination.pages }"
                        :disabled="disableNext"
                        @click.stop="paginateLast()">
                        {{ props.pagination.pages }}
                    </button>
                </li>
            </template>
        </ul>
        
        <button 
            class="button is-primary is-outlined pagination-previous" 
            @click.stop="paginatePrev()"
            :disabled="disablePrev">
            Previous 
        </button>
        <button 
            class="button is-primary is-outlined pagination-previous" 
            @click.stop="paginateNext()"
            :disabled="disableNext">
            Next page 
        </button>
    </nav>
</template>
