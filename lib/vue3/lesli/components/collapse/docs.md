# Collapse

This is a lesli component. Its function is to 
make an easy implementation of collapse lists cards.

## Props

- loading:
    An indicator when data is loading
    @values true, false
- open:
    An indicator when the collapse card
    is open
    @values true, false
- title:
    The title to show on card's header
    @values any string

## Use examples:
```
<lesli-data-collapse
    v-for="(item) of your_item_list"
    :key="a unique key"
    :open="item.isOpen"
    @open="()=>{
            if(store.openIndex==index){
                store.openIndex = null
            }
            else{
                store.openIndex = index
            }
        }"
    :title="item.title">
    <!-- content for the lesli-collapse-body slot -->
    <div class="card-content">
        <p {{ Show anithing you wnat from your item }}</p>
    </div>
</lesli-data-collapse>

```
```

<lesli-data-collapse
    v-for="(faq, index) of store.faqs.filter(
        _faq => (
            store.filters.query=='' || 
            _faq.question.includes(store.filters.query) ||
                _faq.answer.includes(store.filters.query)
        )
    )"
    :key="index"
    :open="store.openIndex == index"
    @open="()=>{
            if(store.openIndex==index){
                store.openIndex = null
            }
            else{
                store.openIndex = index
            }
        }"
    :title="faq.question">
        <!-- content for the lesli-collapse-body slot -->
        <div class="card-content">
        <p class="mt-4 is-size-5 is-uppercase has-text-weight-bold">{{ store.translations.mitwerken.faqs.column_question }}</p>
        <p  class="mt-2 is-size-6">{{faq.question}}</p>
        
        <p class="mt-4  is-size-5 is-uppercase has-text-weight-bold">{{ store.translations.mitwerken.faqs.column_answer }}</p>
        <p class="mt-2 mb-4 is-size-6 box">{{faq.answer!='' ? faq.answer : 'No answer provided' }}</p>

        <label class="b-checkbox checkbox is-disabled">
            <input disabled v-model="faq.mitwerker" type="checkbox">
            <span class="check"> </span>
            <span class="control-label">Mitwerker</span>
            
        </label>
        <label class="b-checkbox checkbox is-disabled">
            <input disabled v-model="faq.principal" type="checkbox">
            <span class="check"> </span>
            <span class="control-label">Principal</span>
        </label>
        <div class="field has-addons mt-4">
            <button @click="url.go(`${store.main_route}/${faq.id}`)" class="button mr-2">
                <span class="icon is-small">
                    <i class="fas fa-edit" size="is-small"/>
                </span>
                <span>{{ store.translations.core.shared.view_btn_edit }}</span>
            </button>
            <button @click="store.deleteFaq(faq.id)" class="button is-danger" :disabled="store.deleting">
                <span class="icon is-small" v-if="store.deleting">
                    <i class="fas fa-spin fa-circle-notch" size="is-small"/>
                </span> 
                <span class="icon is-small" v-else>
                    <i class="fas fa-trash-alt" size="is-small"/> 
                </span>
                <span v-if="store.deleting">{{ store.translations.core.shared.view_btn_deleting }}</span> 
                <span v-else>{{ store.translations.core.shared.view_btn_delete }}</span>
            </button>
        </div>   
    </div>
</lesli-data-collapse>
        
```
