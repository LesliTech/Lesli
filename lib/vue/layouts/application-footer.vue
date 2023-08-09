<script>
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



// ·
export default {
    props: {
        title: String
    },
    components: {
    },
    data() {
        return {
            timer: null,
            command: "",
            command_show: false, 
            componentId: ""
        }
    },
    mounted() {
        
    },
    methods: {
        executeCommand() {

            this.postCommand().then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })

            return 

            this.componentId = null
            if (this.command == "tasks") {
                this.componentId = 'component-driver-events'
                this.command_show = true
            }
        },
        postCommand() {
            return fetch("http://localhost:8080/api/command/intent", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    "intent": this.command
                })
            })
        }
    },
    watch: {
        command() {
            if (this.command == "") {
                this.command_show = false
                return 
            }
            clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                this.executeCommand()
            }, 800);
        }
    },
    computed: {
    }
}
</script>
<template>    
    <footer class="application-footer">
        <div class="application-commands" v-if="command_show">
        </div>
        <nav class="navbar" aria-label="main navigation" role="navigation">
            <div class="navbar-menu">
                <div class="navbar-start">
                    <p class="navbar-item">
                        <!-- we'll use this input later for command execution -->
                        <input 
                            type="text" 
                            class="input is-shadowless" 
                            v-model="command"
                            :placeholder="title"
                        />
                    </p>
                </div>
                <div class="navbar-end">
                    <slot name="navbar-end"></slot>
                </div>
            </div>
        </nav>
    </footer>
</template>
