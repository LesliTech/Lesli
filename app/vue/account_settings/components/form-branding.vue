<script>
/*

Copyright (c) 2021, all rights reserved.

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
export default {
    data() {
        return {
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        settings: I18n.t("core.account/settings"),
                    }
                }
            },
            image: {
                url: null,
                alt: null,
            },
            file: {}
        }
    },
    mounted() {
        if (this.lesli.company.logo) {
            this.image.url = this.lesli.company.logo
            this.image.alt = this.lesli.company.name
        }
    },
    methods: {

        processFile(event) {
            this.file = event.target.files[0]
            this.image.url = URL.createObjectURL(this.file)

            this.postFile()
        },
        setAltImg(event) {
            event.target.classList.add("error")
            event.target.src = "/images/icons/image.svg"
        },
        postFile() {

            const formData = new FormData();
            formData.append("account_file[name]", "company_logo")
            formData.append("account_file[file_type]", "png")
            formData.append("account_file[attachment]", this.file)

            this.http.post(this.url.admin("account/files"), formData).then(result => {
                this.msg.success(this.translations.core.account.settings.messages_success_image_uploaded_successfully)
            })

        },
        deleteFiles() {
            this.http.delete(this.url.admin("account/resources/company_logo")).then(result => {
                this.msg.info(this.translations.core.account.settings.messages_info_image_removed_successfully)
            })
        }

    }

}
</script>
<template>
    <div class="box settings-branding">
        <div class="main-logo">
            <label class="label">{{ translations.core.account.settings.view_text_main_logo }}</label>
            <div id="preview" class="has-text-centered">
                <!-- <img class="company-logo-uploaded" v-if="image.url" :alt="image.alt" :src="image.url" @error="setAltImg"/> -->
            </div>
            <div class="field file">
                <label class="upload control is-expanded">
                    <a class="button is-primary is-fullwidth is-justify-content-center">
                        <span class="file-icon">
                            <i class="fas fa-upload"></i>
                        </span>
                        <span>{{ translations.core.account.settings.view_btn_click_to_upload }}</span>
                    </a>
                    <input class="file-input" type="file" @change="processFile">
                </label>
            </div>
            <div class="field">
                <button @click="deleteFiles()" class="button is-danger is-outlined is-fullwidth is-justify-content-center">
                    <span>{{ translations.core.shared.view_btn_delete }}</span>
                    <span class="icon is-small">
                        <i class="fas fa-times"></i>
                    </span>
                </button>
            </div>
        </div>
    </div>
</template>
<style scoped>
    .card .card-content {
        max-width: 450px;
    }
</style>
