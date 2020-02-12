<script>
export default {
    methods: {
        publishManageChatbox(close=false) {
            this.bus.publish("/cloud/layout/chatbox#manageChatbox", close)
        }
    }
}
</script>
<template>
    <div class="chat-header" @click="publishManageChatbox()">
        <nav class="navbar" role="navigation" aria-label="main navigation">
            <div class="navbar-brand">
                <a class="navbar-item">
                    Lesli
                </a>
            </div>
            <div class="navbar-menu">
                <div class="navbar-start">
                </div>
                <div class="navbar-end">
                    <div class="navbar-item">
                        <div class="buttons">
                            <a class="button is-white" @click="publishManageChatbox()">
                                <i class="fas fa-minus"></i>
                            </a>
                            <a class="button is-white" @click="publishManageChatbox(true)">
                                <i class="fas fa-times"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    </div>
</template>
