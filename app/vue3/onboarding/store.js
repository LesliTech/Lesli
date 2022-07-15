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
import { defineStore } from "pinia";

// ·
export const useOnboarding = defineStore("onboarding", {
    state: () => {
        return {
            view: 0,
            translations: {
                core: {
                    onboardings: I18n.t("core.onboardings"),
                    accounts: I18n.t("core.accounts"),
                    shared:  I18n.t("core.shared"),              
                },
            },
            options: {
                countries: [],
                regions: []
            }
        };
    },
    actions: {
        next() {
            this.view++;
        },
        skip() {
            this.dialog
                .confirmation({
                    title: "Are you sure you want to skip onboarding?",
                    text: "Information you have entered will be saved. We suggest you finish onboarding but you will still be able to use app with default information.",
                    confirmText: "Skip onboarding",
                    cancelText: "Continue",
                })
                .then(({ isConfirmed }) => {
                    if (isConfirmed) {
                        this.url.go();
                    }
                });
        },
        getOptions (){
            this.loading = true
            this.http.get(this.url.admin("account/options")).then(result => {
                this.options = result
            }).catch(error => {
                this.msg.danger("Error while trying to fetch data")
            }).finally(() => {
                this.loading = false
            })
        },
    },
});
