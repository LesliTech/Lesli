
<script>
export default {
    data() {
        return {
            shortcuts: {}
        }
    },
    mounted() {
        this.getShortcuts()
    },
    methods: {
        getShortcuts() {
            this.http
            .get(this.url.admin("users/:id/shortcuts", { id: this.lesli.current_user.id }))
            .then(result => { 
                if (!result.successful) {
                    return
                }
                this.shortcuts = result.data
            }).catch(error => { 
                this.msg.error("Error loading shortcuts")
            })
        },
        deleteShortcut(id) {
            this.http.delete(this.url.admin("users/:user_id/shortcuts/:id", { 
                user_id: this.lesli.current_user.id,
                id: id 
            })).then(result => { 
                this.msg.success("Shortcut deleted")
                this.getShortcuts()
            }).catch(error => { 
                this.msg.error("Error deleting shortcuts")
            })
        }
    }
}
</script>
<template>
    <b-table :data="shortcuts.records">
        <template slot-scope="props">
            <b-table-column label="Name">
                {{ props.row.name }}
            </b-table-column>
            <b-table-column label="URL">
                {{ props.row.url }}
            </b-table-column>
            <b-table-column label="Options">
                <div class="buttons">
                    <button class="button is-danger is-outlined" @click="deleteShortcut(props.row.id)">
                        <i class="far fa-trash-alt"></i>
                    </button>
                </div>
            </b-table-column>
        </template>
    </b-table>
</template>
