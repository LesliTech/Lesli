    <script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/
export default {
    props: {
        title: {
            default: null
        },
        subtitle: {
            default: null
        },
        buttons: {
            default: true
        },
        titleButtonCreate: {
            default: "Create"
        }
    },
    data() {
        return {
            loading: false
        }
    },
    methods: {
        clickButtonReload() {
            this.loading = true
            setTimeout(() => { this.loading = false }, 1000);
            this.$emit("clickButtonReload");
        }
    }
}
</script>
<template>
    <nav class="navbar component-header">
        <div class="navbar-menu">
            <div class="navbar-start">
                <div class="navbar-item">
                    <h3 v-if="title" class="is-size-3">
                        {{ title }}
                    </h3>
                    <h4 v-if="subtitle" class="is-size-4">
                        {{ subtitle }}
                    </h4>
                </div>
            </div>
            <div class="navbar-end">
                <div class="navbar-item">
                    <slot></slot>
                    <div class="buttons" v-if="buttons">
                        <button class="button" @click="clickButtonReload">
                            <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                            <span>Reload</span>
                        </button>

                        <router-link v-if="this.$route.path=='/'" class="button" tag="button" to="/new">
                            <b-icon icon="plus" size="is-small" />
                            <span>{{ titleButtonCreate }}</span>
                        </router-link>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</template>
