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
    props: {
        user_id: {
            type: Number,
            required: true
        },
    },

    data() {
        return {
            data: [],
            loading: true,
            pagination: {
                total_pages: 0,
                current_page: 1,
                count_total: 0,
                count_results: 0,
            },
            pagination_config: {
                per_page: 10,
                range_before: 3,
                range_after: 3,
            },
        }
    },
    mounted(){
        this.getSessions()
    },

    methods: {
        getSessions() {
            this.loading = true;
            let params = {
                perPage: this.pagination_config.per_page,
                page: this.pagination.current_page
            }
            this.http.get(this.url.admin("users/:id/sessions", { id: this.user_id}), {params}).then(result => {
                if (result.successful) {
                    this.data = result.data.records;
                    this.pagination = result.data.pagination;
                } else {
                    this.msg.error(result.error.message);
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false;
            })
        },

        closeSession(object){
            let object_id = object.id

            this.http.delete(this.url.admin("users/:id/sessions/:session_id", { id: this.user_id, session_id: object_id})).then(result => {
                if (result.successful) {
                    this.msg.success("successfully Closed session")
                    this.getData()
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })

            this.getSessions()
        },

        confirmClosing(object) {
            this.$buefy.dialog.confirm({
                title: "Close session",
                message: `<b> confirm closing session</b>`,
                confirmText: "Close session",
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.closeSession(object)
            })
        },
    },
}
</script>

<template>
    <div class="card">
        <component-data-loading v-if="loading"> </component-data-loading>
        <component-data-empty v-if="!loading && data.length == 0"> </component-data-empty>
        <div class="card-content" v-if="data.length > 0">
            <b-table
                    :data="data"
                    :hoverable="true"
                    v-if="!loading && data.length > 0"
            >
                <template v-slot="props">
                    <b-table-column label="user_remote" field="lower(user_remote)">
                        {{props.row.user_remote}}
                    </b-table-column>
                    <b-table-column label="user_agent" field="lower(user_agent)">
                        {{props.row.user_agent}}
                    </b-table-column>
                    <b-table-column label="session_source" field="lower(session_source)">
                        <b-field v-if="props.row.session_source == 'devise_standar_session'">
                            <b-tag><i class="fas fa-desktop"></i> Computer</b-tag>
                        </b-field>
                        <b-field v-if="props.row.session_source == 'cloud_shared_public'">
                            <b-tag><i class="fas fa-share-alt"></i> Shared Module</b-tag>
                        </b-field>
                    </b-table-column>
                    <b-table-column label="created_at" field="lower(created_at)">
                        {{props.row.created_at_date}}
                    </b-table-column>
                    <b-table-column label="last_used_at" field="lower(last_used_at)">
                        {{props.row.last_used_at_date}}
                    </b-table-column>
                    <b-table-column label="actions" class="has-text-center">
                        <span>
                            <b-button type="is-danger" outlined @click.stop="confirmClosing(props.row)">
                                <b-icon size="is-small" icon="fas fa-sign-out-alt">
                                </b-icon>
                            </b-button>
                        </span>
                    </b-table-column>
                </template>
            </b-table>
            <b-pagination
                    :simple="false"
                    :total="pagination.count_total"
                    :current.sync="pagination.current_page"
                    :range-before="pagination_config.range_before"
                    :range-after="pagination_config.range_after"
                    :per-page="pagination_config.per_page"
                    order="is-centered"
                    icon-prev="chevron-left"
                    icon-next="chevron-right"
                    aria-next-label="Next page"
                    aria-previous-label="Previous page"
                    aria-page-label="Page"
                    aria-current-label="Current page"
            >
            </b-pagination>
        </div>
    </div>
</template>
