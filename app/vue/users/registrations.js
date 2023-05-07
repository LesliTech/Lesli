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
import componentLesliSelect from "Lesli/lesli/components/select/Select.vue"

// · 
import application from "Lesli/public"


// · 
application({

    data(){
        return {
            translations: {},
            password_uppercase: 0,
            password_symbol: 0,
            password_number: 0,
            telephone_code: "+49",
            telephone_codes: null,
            sign_up: {
                email: null,
                password: '',
                password_confirmation: '',
                first_name: null,
                last_name: null,
                telephone: null,
            },
            progress_bar_active: false,
            notification: {
                show: false,
                message: '',
                type: 'is-danger'
            }
            
        }
    },
    components: {
        lesliSelect: componentLesliSelect
    },
    mounted() {
        this.$refs.email.focus()
    },
    methods: {

        /**
         * @param {*} event that triggers the function
         * @description this function is triggered when the user submits the form to sign up
         */
        postRegistration(event) {

            this.notification.show = false;

            event.preventDefault();

            const user = this.validateFields()

            this.http.post(this.url.to(), user).then(response => {

                setTimeout(() => { this.url.go("/login") }, 5000)
                
            }).catch((err)=>{
                this.showNotification(err.message)
            })

        },

        typing() {
            this.notification.message= ""
            this.notification.show= false
            this.notification.type= "default"
            this.verifyPasswords()
        },

        showNotification(message,type = "danger") {
            this.notification.message = message
            this.notification.type = type
            this.notification.show = true
        },

        /**
         * @description validates the password strength
         */
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

        },

        /**
         * @description this function validates if the fields are correct
         * @returns object with the user to be registered
         */
        validateFields() {
            
            // · copy object without reference
            const user = JSON.parse(JSON.stringify(this.sign_up))

            if (user.password_confirmation == "") {
                user.password_confirmation = user.password
            }


            return user
        }

    }
})