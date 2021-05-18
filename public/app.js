/*

Copyright (c) 2021, all rights reserved.

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


// application.js
// Register the serviceWorker script at /serviceworker.js from your server if supported
if (navigator.serviceWorker) {

    navigator.serviceWorker.register('/sw.js').then(function(reg) {
        console.log('Service worker change, registered the service worker');
    })

    // application.js
    // When serviceWorker is supported, installed, and activated,
    // subscribe the pushManager property with the vapidPublicKey
    navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {

        console.log("service worker ready")

        // Get authentication token from rails
        let token = ''
        let meta = document.querySelector('meta[name="csrf-token"]')
        if (meta) { token = meta.getAttribute('content') }

        serviceWorkerRegistration.pushManager.subscribe({
            userVisibleOnly: true,
            applicationServerKey: vapid // registered on data partial
        }).then(function(sub) {

            console.log([sub.endpoint, sub.keys, JSON.stringify(sub), JSON.parse(JSON.stringify(sub))])

            sub = JSON.parse(JSON.stringify(sub))

            /*
            fetch("/administration/profile/webpushes", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": token
                },
                body: JSON.stringify({
                    profile_webpush: {
                        endpoint: sub.endpoint,
                        p256dh_key: sub.keys.p256dh,
                        auth_key: sub.keys.auth
                    }
                })
            }).then(result => {

            })
            //*/

        })


    }).catch(error => {
        console.log(error)
    })

} else {

    // Otherwise, no push notifications :(
    console.error('Service worker is not supported in this browser');

}
