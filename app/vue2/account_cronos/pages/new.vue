<script>
/**
Copyright (c) 2020, all rights reserved.

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



// ·
export default {
    data() {
        return {
            cron: {}
        }
    },

    methods: {

        postCron() {
            this.http.post(this.url.admin("account/cronos"), {
                account_crono: this.cron
            }).then(result => {
                if (!result.successful) {
                    return this.msg.error("Error creating cron task")
                }
                this.msg.success("Cron task created")
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>

<template>
    <section class="application-component">
        <component-header title="New scheduled tasks"></component-header>
        <div class="box"> 
            <form @submit.prevent="postCron">
                <div class="field is-grouped">
                    
                    <div class="field">
                        <label class="label">Name</label>
                        <div class="control is-clearfix">
                            <input type="text" v-model="cron.name" autocomplete="on" class="input">
                        </div>
                    </div>
                    <div class="field is-expanded">
                        <label class="label">Description</label>
                        <div class="control is-clearfix">
                            <input type="text" v-model="cron.description" autocomplete="on" class="input">
                        </div>
                    </div>
                </div>
                <div class="field is-grouped">
                    <div class="field is-expanded">
                        <label class="label">Minute</label>
                        <div class="control">
                            <b-select
                                placeholder="*"
                                expanded
                                v-model="cron.minute">
                                <option value="*">*</option>
                                <option
                                    v-for="option in 59"
                                    :value="option"
                                    :key="option">
                                    {{ option }}
                                </option>
                            </b-select>
                        </div>
                    </div>
                    <div class="field is-expanded">
                        <label class="label">Hour</label>
                        <div class="control">
                            <b-select
                                placeholder="*"
                                expanded
                                v-model="cron.hour"
                                >
                                <option value="*">*</option>
                                <option
                                    v-for="option in 24"
                                    :value="option"
                                    :key="option">
                                    {{ option }}
                                </option>
                            </b-select>
                        </div>
                    </div>

                    <div class="field is-expanded">
                        <label class="label">Day of month</label>
                        <div class="control">
                            <b-select
                                placeholder="*"
                                expanded
                                v-model="cron.day_of_month">
                                <option value="*">*</option>
                                <option
                                    v-for="option in 31"
                                    :value="option"
                                    :key="option">
                                    {{ option }}
                                </option>
                            </b-select>
                        </div>
                    </div>

                    <div class="field is-expanded">
                        <label class="label">Month</label>
                        <div class="control">
                            <b-select
                                placeholder="*"
                                expanded
                                v-model="cron.month">
                                <option value="*">*</option>
                                <option
                                    v-for="option in 12"
                                    :value="option"
                                    :key="option">
                                    {{ option }}
                                </option>
                            </b-select>
                        </div>
                    </div>

                    <div class="field is-expanded">
                        <label class="label">Day of week</label>
                        <div class="control">
                            <b-select
                                placeholder="*"
                                expanded
                                v-model="cron.day_of_week">
                                <option value="*">*</option>
                                <option
                                    v-for="option in 7"
                                    :value="option"
                                    :key="option">
                                    {{ option }}
                                </option>
                            </b-select>
                        </div>
                    </div>
                </div>

                <div class="field">
                    <div class="control">
                        <button class="button is-link">Submit</button>
                    </div>
                </div>
            </form>
        </div>
    </section>
</template>
