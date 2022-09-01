<script setup>
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

// · import vue tools
import { ref, reactive, onMounted, watch, computed } from "vue"

// · import lesli stores
import { useUser } from "LesliVue/stores/user" 

// · implement stores
const storeUser = useUser()

// · translations
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}


</script>
<template>
<form @submit.prevent="storeUser.setLanguage">
    <div class="field is-horizontal">
            <div class="field-label">
                <label class="label"> Select preferred language </label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control" :for="locale" v-for="locale in storeUser.options.locales" :key="locale">
                        <label class="radio">
                            <input type="radio" :id="locale" :value="locale.value" v-model="storeUser.language" />
                            {{locale.label}}
                        </label>  
                    </div>
                </div>
            </div>
    </div>
    <div class="field is-horizontal">
        <div class="field-label is-normal">
        </div>
        <div class="field-body">
            <div class="field">
                <div class="control">
                    <lesli-button icon="save">
                        {{ translations.shared.view_btn_save }}
                    </lesli-button>                    
                </div>
            </div>
        </div>
    </div>
</form>
</template>
