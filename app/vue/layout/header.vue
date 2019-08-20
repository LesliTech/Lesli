<script>
export default {

    data() {
        return {
            chatbotIntent:'',
            timer: null
        }
    },

    methods: {

        emitSidenavShow() {
            clearTimeout(this.timer)
            let el = document.getElementsByClassName('sidenav')[0]
            el.classList.toggle('show')
            this.timer = setTimeout(() => el.classList.remove('show'), 4000)
        },

        emitChatbotIntent() {
            this.bus.$emit('lesli.component.chatbox.postIntent', this.chatbotIntent)
            this.chatbotIntent=""
        }

    }

}
</script>
<template>
    <header>

        <!-- User navigation area -->
        <nav class="navbar is-transparent">

            <div id="header-main-navbar" class="navbar-menu">

                <!-- Assistant controls -->
                <div class="navbar-start">

                    <button type="button" class="button is-white" @click="emitSidenavShow">
                        <i class="fas fa-bars"></i>
                    </button>

                    <button type="button" class="button is-white">
                        <i class="fas fa-microphone"></i>
                    </button>

                    <form v-on:submit.prevent="emitChatbotIntent()">
                        <input class="input" v-model="chatbotIntent" type="text" placeholder="Hello, how can I help you today? :)">
                    </form>
                    
                </div>

                <!-- Brand container -->
                <div class="navbar-brand">
                    <a class="navbar-item" href="/">
                        <img alt="LesliCloud logo" src="/assets/brand/leslicloud-logo.svg" />
                    </a>
                </div>

                <!-- User navigation -->
                <div class="navbar-end">
                    <div class="navbar-item">

                        <div class="navbar-item has-dropdown is-hoverable">
                            <a class="navbar-link is-arrowless">
                                <i class="fas fa-bell"></i>
                            </a>
                            <div class="navbar-dropdown is-boxed">
                                <a class="navbar-item" href="https://bulma.io/documentation/overview/start/">
                                    Notification
                                </a>
                            </div>
                        </div>

                        <div class="navbar-item has-dropdown is-hoverable">
                            <a class="navbar-link is-arrowless" href="https://bulma.io/documentation/overview/start/">
                                <figure class="image">
                                    <img class="is-rounded" src="https://placekitten.com/g/30/30" alt="profile thumbnail">
                                </figure>
                            </a>
                            <div class="navbar-dropdown is-boxed">
                                <a class="navbar-item" href="https://bulma.io/documentation/overview/start/">
                                    Profile
                                </a>
                            </div>
                        </div>

                        <a class="navbar-item" href="/logout">
                            <i class="fas fa-sign-out-alt"></i>
                        </a>

                    </div>
                </div>
            </div>
        </nav>

    </header>
</template>
