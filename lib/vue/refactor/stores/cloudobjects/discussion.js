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


// · This store is needed to make http requests, manage the reactivity 
// · of certain global properties available to child components of the 
// · cloud object.

import { defineStore } from "pinia"

export const useCloudObjectDiscussionStore = defineStore("cloudObjectDiscussion", {
    state: () => {
        return {
            discussions: [],
            activityLogs: [],
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
            stringToFind: null,
            isBuilderEngine: null,
            currentUserId: lesli.current_user.id,
            index: {
                pagination: {},
                records: []
            },
            pagination: {
                page: 1,
                pages: 1,
                total: 0,
                results: 0
            },
            filters: {
                per_page: 10,
                showDiscussion: true,
                showActivityLog: false,
            }
        }
    },
    getters: {
        /**
         * 
         * @param {*} state has the state of the store
         * @returns {Array} merged array of discussions and activity logs
         */
        mergedArray: (state) => {
            // · Array of elements to be displayed in the discussion section
            const elements = [] 

            // · Verify length of the discussion array
            if (state.discussions.length > 0) {
                // · Add the discussion array to the merged array
                elements.push(...state.discussions.map(discussion => {
                    // · Return the discussion object with a similar structure to the activity log
                    return {
                        type: "discussion",
                        responses: discussion.responses,
                        ...discussion.data
                    }
                })) 
            }

            // · Verify length of the activity log array
            if (state.activityLogs.length > 0) {
                // · Add the activity log array to the merged array
                elements.push(...state.activityLogs.map(activityLog => {
                    // · Return the activity log object with a similar structure to the discussion
                    return {
                        type: "activityLog",
                        ...activityLog
                    }
                }))
            }

            return elements.sort((a, b) => {
                return a.created_at < b.created_at ? 1 : -1
            }, 0)
        }
    },
    actions: {

        /**
        * @param {number} page number to which I want to go.
        * @description Sets a new page number, applying query parameters to fetch data once again.
        */
        paginateDiscussions(page){
            this.pagination.page = page
            this.fetchDiscussions()
        },

        /**
        * @description This action is used to fetch the list of discussion
        */
        fetchDiscussions(url) {
            this.loading = true

            if (!url) url = this.url[this.cloudModule](`${this.cloudObject}/:id/discussions`, this.cloudObjectId)

            this.http.get(url.paginate(this.pagination.page, this.filters.per_page)).then(result => {
                this.pagination = result.pagination
                this.discussions = result.records
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_getting_discussions)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * 
         * @param {string} stringToFind String to search for
         * @description This action is used to search for a string in the cloud object's discussions and activity logs 
         */
        search(stringToFind) {
            
            // · It's necessary to set the string to find in the state
            // · if the filters change and the toolbar is not empty
            // · the search will be performed again
            this.stringToFind = stringToFind

            if (this.filters.showDiscussion) {
                const discussionsUrl = this.url[this.cloudModule](`${this.cloudObject}/:id/discussions`, this.cloudObjectId).search(this.stringToFind)
                this.fetchDiscussions(discussionsUrl)
            }
            
            if (this.filters.showActivityLog) {
                const activityLogsUrl = this.url[this.cloudModule](`${this.cloudObject}/:id/activities`, this.cloudObjectId).search(this.stringToFind)
                this.fetchActivityLogs(activityLogsUrl)
            } 
        },

        /**
         * @description This action is used to create a discussion
         * @param {Object} payload contains the data of the discussion
         */
        createDiscussion(payload) {

            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/discussions`, {
                id: this.cloudObjectId,
            })

            this.http.post(url, payload
            ).then(() => {
                this.msg.success(I18n.t("core.shared").messages_success_creating_discussion)
                this.fetchDiscussions()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_creating_discussion)
            })
        },

        /**
         * @description This action is used to delete a discussion.
         */
        deleteDiscussion(discussionId) {
            
            if (!discussionId) return

            const url = this.url[this.cloudModule](`${this.cloudObject}/:id/discussions/:discussionId`, {
                id: this.cloudObjectId,
                discussionId: discussionId,
            })

            this.http.delete(url).then(() => {
                this.msg.success(I18n.t("core.shared").messages_success_deleting_discussion)
                this.fetchDiscussions()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_deleting_discussion)
            })
        },

        /**
         * @description This action is used to get the activity logs of the cloud object.
         * @param {String} url to fetch the activity logs
         */
        fetchActivityLogs(url) {
            this.loading = true

            if (!url) url = this.url[this.cloudModule](`${this.cloudObject}/:id/activities`, this.cloudObjectId)

            this.http.get(url).then(result => {
                this.activityLogs = result
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_getting_activity_logs)
            }).finally(() => {
                this.loading = false
            })
        }
    }
})
