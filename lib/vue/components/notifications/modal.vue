<script>
export default {
    props: {
        active: {
            type: Boolean,
            default: false
        },
        title: {
            type: String,
            default: ''
        }
    },

    data(){
        return {
            modal_active: false
        }
    },

    watch: {
        modal_active(){
            if(this.active != this.modal_active){
                this.$emit('update:active', this.modal_active)
            }
        },

        active(){
            if(this.active != this.modal_active){
                this.modal_active = this.active
            }
        }
    }
}
</script>
<template>
    <b-modal
        :active.sync="modal_active"
        :can-cancel="false"
        has-modal-card
        trap-focus
        :destroy-on-hide="false"
        aria-role="dialog"
        aria-modal
    >
        <div class="modal-card" style="width: auto">
            <header class="modal-card-head">
                <p class="modal-card-title">{{title}}</p>
            </header>
            <section class="modal-card-body">
                <slot name="modal-body">
                </slot>
            </section>
            <footer class="modal-card-foot">
                <slot name="modal-footer">
                </slot>
            </footer>
        </div>
    </b-modal>
</template>
