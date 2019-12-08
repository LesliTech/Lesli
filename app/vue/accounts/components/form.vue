<script>

import notification from '../../components/forms/notification.vue'
import progressBar from '../../components/forms/progress_bar.vue'

export default {
    data(){
        return {
            translations: I18n.t('accounts.form'),
            account: {
                company_name: ''
            },
            user: {
                name: ''
            },
            progress_bar_active: false,
            notification: {
                show: false,
                message: '',
                type: 'is-danger'
            }
        }
    },
    methods: {
        showNotification(message, type='is-danger'){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        },
        createCompany(event) {
            event.preventDefault();
            let data = {account: this.account, user: this.user};
            this.progress_bar_active = true;
            this.http.post(this.url.to(null,null,'/account'),data).then((response)=>{
                this.progress_bar_active = false;
                if(response.successful){
                    this.url.go('/');
                }else{
                    this.showNotification(response.error.message);
                }
            }).catch((err)=>{
                console.log(err);
            })
        }
    },
    components:{
        'form-notification':notification,
        'progress-bar': progressBar
    }
}
</script>
<template>
    <form @submit="createCompany">
        <progress-bar :active="progress_bar_active"/>
        <form-notification
            :message="notification.message"
            :type="notification.type"
            :show.sync="notification.show">
        </form-notification>
        <div class="field">
            <p class="control has-icons-left">
                <label class="sr-only">
                    {{translations.fields.company_name}}
                </label>
                <input 
                    class="input" 
                    type="text"
                    v-model="account.company_name"
                    required="true"
                    :placeholder="translations.fields.company_name" />
                <span class="icon is-small is-left">
                    <i class="fas fa-building"></i>
                </span>
            </p>
        </div>
        <input class="button is-primary" type="submit" :value="translations.actions.save" />
    </form>
</template>
