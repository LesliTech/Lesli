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


// · 
import app from "LesliVue/public"

// · 
app({
    data(){
        return {
            translations: {},
            password_uppercase: 0,
            password_symbol: 0,
            password_number: 0,
            sign_up: {
                email: '',
                password: '',
                password_confirmation: ''
            },
            progress_bar_active: false,
            notification: {
                show: false,
                message: '',
                type: 'is-danger'
            }
        }
    },
    mounted() {
        this.$refs.email.focus()
    },
    methods: {

        postRegistration(event) {

            this.notification.show = false;

            event.preventDefault();

            if (this.sign_up.password != this.sign_up.password_confirmation) {
                this.showNotification("Password and password confirmation do not match");
                return
            }

            let data = { user: this.sign_up }

            this.http.post(this.url.to(), data).then(response => {

                if (!response.successful) {
                    this.showNotification(response.error.message)
                    return 
                }

                this.showNotification(this.translations.registration.notifications.success, 'is-success')
                setTimeout(() => { this.url.go("/login") }, 5000)

            }).catch((err)=>{
                console.log(err)
            })

        },

        typing() {
            this.notification.message= ""
            this.notification.show= false
            this.notification.type= "default"
            this.verifyPasswords()
        },

        showNotification(message,type = "is-danger") {
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        },

        verifyPasswords() {

            this.password_uppercase = 0
            this.password_number = 0
            this.password_symbol = 0
            
            if (this.sign_up.password.length <= 0) {
                return
            }

            if (this.sign_up.password.search(/[A-Z]/) < 0) {
                this.password_uppercase = 1
            } else {
                this.password_uppercase = 2
            }

            if (this.sign_up.password.search(/[0-9]/) < 0) {
                this.password_number = 1
            } else {
                this.password_number = 2
            }

            if (this.sign_up.password.search(/[!#$%&]/) < 0) {
                this.password_symbol = 1
            } else {
                this.password_symbol = 2
            }

        }

    }

})
