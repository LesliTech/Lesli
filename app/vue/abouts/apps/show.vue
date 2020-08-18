<script>
export default {
    mounted(){
        console.log('mounted')
    }
}
</script>
<template>
    <section class="application-component">
        <nav class="navbar component-header">
            <div class="navbar-menu">
                <div class="navbar-start">
                    <div class="navbar-item">
                        <h4 class="is-size-3">
                            System Requirements
                        </h4>
                    </div>
                </div>
            </div>
        </nav>
        <div class="card">
            <div class="card-content">
                <b-menu>
                    <b-menu-list label="List of Supported Browsers">
                        <b-menu-item icon="account" href="https://www.microsoft.com/de-DE/edge" target="_download_explorer">
                            <template slot="label">
                                <i class="fab fa-edge"></i>
                                Microsoft Edge >= 84.0.522.61
                            </template>
                        </b-menu-item>
                        <b-menu-item icon="account" href="https://www.mozilla.org/de/firefox/new/" target="_download_explorer">
                            <template slot="label">
                                <i class="fab fa-firefox-browser"></i>
                                Mozilla Firefox >= 79.0
                            </template>
                        </b-menu-item>
                        <b-menu-item icon="account" href="https://www.google.com/intl/de-419/chrome/" target="_download_explorer">
                            <template slot="label">
                                <i class="fab fa-chrome"></i>
                                Google Chrome >= 84.0.4147.125
                            </template>
                        </b-menu-item>
                        <b-menu-item icon="account" href="https://support.apple.com/downloads/safari" target="_download_explorer">
                            <template slot="label">
                                <i class="fab fa-safari"></i>
                                Safari >= 13.1.2
                            </template>
                        </b-menu-item>
                    </b-menu-list>
                </b-menu>
            </div>
        </div>
        <hr>
    </section>
</template>
