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
            filters: {
                showDiscussion: true,
                showActivityLog: true,
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
        * @description This action is used to fetch the list of discussion
        */
        fetchDiscussions(url) {
            this.loading = true

            if (!url) url = this.url[this.cloudModule](`${this.cloudObject}/:id/discussions`, this.cloudObjectId)

            this.http.get(url).then(result => {
                this.discussions = result
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
                console.log(error)
                this.msg.success(I18n.t("core.shared").messages_danger_creating_discussion)
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
                console.log(error)
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
