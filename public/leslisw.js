self.addEventListener("push",(function(i){if(self.Notification&&"granted"===self.Notification.permission){var t={};i.data&&(t=i.data.json());var a=t.title,o=t.body||"",n=t.tag||"lesli";i.waitUntil(self.registration.showNotification(a,{icon:"",body:o,tag:n}))}}));