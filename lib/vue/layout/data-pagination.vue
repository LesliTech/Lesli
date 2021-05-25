<script>
export default {
    props: {
        pagination: {
            default() {
                return {
                    count_total: 0,
                    current_page: 1,
                    per_page: 10
                }
            }
        },
        simple: {
            default: false
        }
    },
    data() {
        return {
            total: 200,
            current: 10,
            perPage: 10,
            rangeBefore: 3,
            rangeAfter: 3,
            prevIcon: 'chevron-left',
            nextIcon: 'chevron-right'
        }
    }
}
</script>
<template>
    <div class="component-data-pagination">
        <b-pagination
            class="mt-5"
            :simple="simple"
            :total="pagination.count_total"
            :per-page="pagination.perPage"
            :current.sync="pagination.current_page"
            :range-before="rangeBefore"
            :range-after="rangeAfter"
            :order="(simple === false ? 'is-centered' : 'is-right')"
            icon-prev="chevron-left"
            icon-next="chevron-right"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-current-label="Current page"
            aria-page-label="Page">
        </b-pagination>
    </div>
</template>
