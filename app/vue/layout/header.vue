<script>
export default {

}
</script>
<template>
    <header>
        <!-- User navigation area -->
        <b-navbar toggleable="sm">

            <!-- Assistant controls -->
            <b-collapse is-nav class="assistant" id="1">
                <button type="button" class="btn btn-link">
                    <i class="fas fa-bars"></i>
                </button>
                <b-button size="sm" type="submit" >
                    <i class="fas fa-microphone"></i>
                </b-button>
                <b-nav-form >
                    <b-form-input
                        size="sm" type="text" 
                        placeholder="How can I help you today?"/>
                </b-nav-form>
            </b-collapse>

            <!-- Brand container -->
            <b-navbar-brand href="/">
                <img alt="LesliCloud logo" src="https://cdn.lesli.tech/leslicloud/brand/leslicloud_isotipo-nomargin.png" />
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
