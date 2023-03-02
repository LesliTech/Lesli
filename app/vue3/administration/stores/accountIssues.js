/*
Copyright (c) 2023, all rights reserved.

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
import { defineStore } from "pinia"


// · 
export const useAccountIssues = defineStore("administration.account.issues", {
    state: () => {
        return {
            options: {
                statuses: []
            },
            issue: {},
            pagination: {
                page: 1,
                per_page: 10
            },
            index: { 
                pagination: {},
                records: []
            },
            loading: false          
        }
    },
    actions: {
        /**
        * @description This action is used to get the options for status
        */
        getOptions(){
            this.loading = true

            this.options = {
                statuses: []
            }

            this.http.get(this.url.admin("account/issues/options")).then((result)=>{
                result["statuses"].forEach((status)=>{
                    this.options["statuses"].push({
                        label: status.text,
                        value: status.value
                    })
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })

        },
        /**
        * @description This action is used to get the list of issues
        */
        fetch(url= this.url.admin("account/issues")) {
            this.loading = true
            this.http.get(url.paginate(this.pagination.page, this.pagination.per_page)).then(result => {
                this.index = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },
        updateStatus(){
            this.http.put(this.url.admin("account/issues/:id", this.issue.id), { account_issue: this.issue }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
        * @description This action is used to get an issue
        */
        getIssue(issue_id) {
            this.loading = true

            this.http.get(this.url.admin("account/issues/:id", issue_id)).then((response) => {
                this.issue = response
            }).catch((error) => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },
        /* @description This action is used to paginate account issues from index
        * @param {String} page The actual page showing.
        */
        paginateIndex(page) {
            this.pagination.page = page
            this.fetch()
        },
  
        /**
         * @description This action is used to sort the results
         */
        sortIndex(column, direction) {
            this.fetch(this.url.admin("account/issues").order(column, direction))
        },
        /**
         * @description This action is used to search
         * @param {string} search_string 
         */
        search(search_string) {
            this.fetch(this.url.admin("account/issues").search(search_string))
        },
    }
})
