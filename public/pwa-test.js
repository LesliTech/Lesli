if ('serviceWorker' in navigator) {
    navigator.serviceWorker
    .register('/service-worker.js', {scope: './'})
    .then(function(registration) {
        console.log("Service Worker Registered")
    }).catch(function(error) {
        console.log("Service Worker Failed to Register", error)
    })

}


function notifyMe() {

    // Let's check if the browser supports notifications
    if (!("Notification" in window)) {
        alert("This browser does not support desktop notification");
    }

    // Let's check whether notification permissions have already been granted
    else if (Notification.permission === "granted") {
        // If it's okay let's create a notification
        var notification = new Notification("Hi there!");
        console.log(notification)
    }

    // Otherwise, we need to ask the user for permission
    else if (Notification.permission !== "denied") {
        Notification.requestPermission().then(function (permission) {
        // If the user accepts, let's create a notification
        if (permission === "granted") {
            var notification = new Notification("Hi there!");
        }
        });
    }

    // At last, if the user has denied notifications, and you
    // want to be respectful there is no need to bother them any more.

    console.log("notifications", Notification.permission)

}


setTimeout(() => { notifyMe() }, 2000)
