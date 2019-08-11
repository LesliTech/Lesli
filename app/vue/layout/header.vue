<script>
export default {

    data() {
        return {
            chatbotIntent:''
        }
    },

    methods: {

        emitSidenavShow() {
            this.bus.$emit('lesli.layout.sidenav.show')
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
        <b-navbar toggleable="sm">

            <!-- Assistant controls -->
            <b-collapse is-nav class="assistant" id="1">
                <button type="button" class="btn btn-link" @click="emitSidenavShow">
                    <i class="fas fa-bars"></i>
                </button>
                <b-button size="sm" type="submit" >
                    <i class="fas fa-microphone"></i>
                </b-button>
                <form v-on:submit.prevent="emitChatbotIntent()">
                    <input v-model="chatbotIntent" type="text" placeholder="Hello, how can I help you today? :)">
                </form>
            </b-collapse>

            <!-- Brand container -->
            <b-navbar-brand href="/">
                <img alt="LesliCloud logo" src="/assets/brand/leslicloud-logo.svg" />
            </b-navbar-brand>

            <!-- User navigation -->
            <b-collapse is-nav id="navigation_user">
                <b-navbar-nav class="ml-auto">
                    <b-nav-item-dropdown right> 
                        <template slot="button-content">
                            <i class="fas fa-bell"></i>
                        </template>
                        <b-dropdown-item href="#"></b-dropdown-item>
                        <b-dropdown-item href="#"></b-dropdown-item>
                    </b-nav-item-dropdown>
                    <b-nav-item-dropdown right> 
                        <template slot="button-content">
                            <img src="https://placekitten.com/g/30/30" alt="BV">
                        </template>
                        <b-dropdown-item href="#">Profile</b-dropdown-item>
                    </b-nav-item-dropdown>
                    <b-nav-item href="urlTo('login', 'auth')">
                        <i class="fas fa-sign-out-alt"></i>
                    </b-nav-item>
                </b-navbar-nav>
            </b-collapse>
        </b-navbar>
    </header>
</template>
