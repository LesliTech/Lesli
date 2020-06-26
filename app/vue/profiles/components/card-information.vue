<script>
export default {
    props: {
        user: {
            default() {
                return {
                    user: {
                        detail_attributes: {}
                    }
                }
            }
        }
    }
}
</script>
<template>
    <div class="box">
        <div class="media" v-if="!user">
            <figure class="media-left">
                <p class="image is-128x128">
                    <b-skeleton circle width="64px" height="64px"></b-skeleton>
                </p>
            </figure>
            <div class="media-content">
                <div class="content">
                    <p>
                        <b-skeleton active></b-skeleton>
                        <b-skeleton height="80px"></b-skeleton>
                    </p>
                </div>
                <nav class="level is-mobile">
                    <div class="level-left">
                        <a class="level-item">
                            <span class="icon is-small">
                                <b-skeleton></b-skeleton>
                            </span>
                        </a>
                        <a class="level-item">
                            <span class="icon is-small">
                                <b-skeleton></b-skeleton>
                            </span>
                        </a>
                    </div>
                </nav>
            </div>
        </div>
        <div class="media" v-if="user">
            <div class="media-left">
                <figure class="image is-128x128">
                    <img class="is-rounded" src="https://bulma.io/images/placeholders/128x128.png" alt="Image">
                </figure>
            </div>
            <div class="media-content">
                <div class="content">
                    <p>
                        <strong if="user.detail_attributes.salutation">
                            {{ user.detail_attributes.salutation }}.
                        </strong>
                        <strong>{{ user.detail_attributes.first_name }}</strong>
                        <strong>{{ user.detail_attributes.last_name }}</strong>
                        <br>
                        {{ user.detail_attributes.title }}
                    </p>
                </div>

                <nav class="level is-mobile">
                    <div class="level-left">
                        <a :href="'mailto:'+user.email" class="level-item" aria-label="reply">
                            <span class="icon is-small mr-2">
                                <i class="fas fa-envelope" aria-hidden="true"></i>
                            </span>
                            {{ user.email }}
                        </a>
                        <a :href="'tel:'+user.detail_attributes.telephone" class="level-item" aria-label="retweet">
                            <span class="icon is-small mr-2">
                                <i class="fas fa-phone-alt" aria-hidden="true"></i>
                            </span>
                            {{ user.detail_attributes.telephone }}
                        </a>
                    </div>
                </nav>
            </div>
        </div>
    </div>
</template>
