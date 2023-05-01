<script>
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
