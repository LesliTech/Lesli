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
            type: [String, Number],
            required: true
        },
    },

    data() {
        return {
            loading: true,
            webpushes: [],
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
            vapid: false
        }
    },
    mounted(){
        this.getWebpushes()
        this.registerServiceWorker()
    },

    methods: {

        initVapid() {
            if (typeof vapid !== 'undefined') {
                this.vapid = vapid // defined on show view file
            }
        },

        getWebpushes() {
            this.loading = true;
            this.http.get(this.url.admin("profile/webpushes")).then(result => {
                this.webpushes = result.data;
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false;
            })
        },

        testNotification() {
            this.http.post(this.url.bell("notifications"), {
                notification: {
                    subject: 'test'
                }
            }).then(result => {

            })
        },

        registerServiceWorker() {

            if (!this.vapid) {
                return
            }

            // Check if web browser supports service workers
            if (!navigator.serviceWorker) {
                this.msg.dialog.error('Error', 'your browser does not support real time notifications')
                return 
            }

            navigator.serviceWorker.getRegistration('/').then(function(registration) {
                if (registration) {
                    //registration.update();
                    //registration.unregister();
                }
            });

            // register service worker app
            navigator.serviceWorker.register('/leslisw.js').then(function(registration) {

                // force the update of the current service worker
                registration.update();
            })

            // listen for service worker status change to ready
            navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {

                // request pushManager registration using vapid to authenticate the server
                return serviceWorkerRegistration.pushManager.subscribe({
                    userVisibleOnly: true,
                    applicationServerKey: this.vapid
                })

            }).then((sub) => {

                sub = JSON.parse(JSON.stringify(sub))

                // register webpush serice of the current web browser
                return this.http.post(this.url.admin('profile/webpushes'), {
                    profile_webpush: {
                        endpoint: sub.endpoint,
                        p256dh_key: sub.keys.p256dh,
                        auth_key: sub.keys.auth
                    }
                })

            }).then(result => {
                
                // ask for privileges to use push notifications
                this.prepareDesktopNotification()

            }).catch(exception => {
                console.log(exception)
                Honeybadger.notify(exception)
            })

        },

        prepareDesktopNotification() {

            if (!("Notification" in window)) {
                this.msg.dialog.error('Error', 'your browser does not support real time notifications')
                return
            }

            // Let's check whether notification permissions have already been granted
            if (Notification.permission === "granted") {
                // If it's okay let's create a notification
                return
            }

            // Otherwise, we need to ask the user for permission
            if (Notification.permission !== "denied") {
                Notification.requestPermission().then(function (permission) {
                    console.log(permission)
                })
            }

        }
        
    }
}
</script>

<template>
    <div class="card">
        <div class="card-content">
            <div class="box">
                <div class="box">
                    <button @click="registerServiceWorker()" class="button">activate notifications for this browser</button>
                </div>
            </div>
            <b-table
                :data="webpushes"
                :hoverable="true"
                v-if="!loading && webpushes.length > 0">
                <template v-slot="empty">
                    <component-data-loading v-if="loading"></component-data-loading>
                    <component-data-empty></component-data-empty>
                </template>
                <template v-slot="props">
                    <b-table-column label="ID">
                        {{ props.row.id }}
                    </b-table-column>
                    <b-table-column label="user_agent" field="lower(user_agent)">
                        {{ props.row.user_agent }}
                    </b-table-column>
                    <b-table-column label="created_at" field="lower(created_at)">
                        {{ props.row.created_at_date }}
                    </b-table-column>
                    <b-table-column label="Active" class="has-text-center">
                    </b-table-column>
                    <b-table-column label="Options" class="has-text-center">
                        <button class="button is-primary" @click="testNotification()">test</button>
                    </b-table-column>
                </template>
            </b-table>
        </div>
    </div>
</template>
