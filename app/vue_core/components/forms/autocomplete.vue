<script>
export default {
   props: {
      value: {
      },

      endpoint: {
         type: String,
         required: true
      },

      placeholder: {
         type: String,
         default: ''
      },

      keyField: {
         type: String,
         default: 'id'
      },

      textField: {
         type: String,
         default: 'value'
      },

      startingSearch: {
         type: String,
         default: ''
      }
   },

   data() {
      return {
         search: '',
         disable_search: false,
         options: [],
         matching_options: [],
         index: -1
      }
   },

   mounted(){
      this.disable_search = true;
      this.search = this.startingSearch;

      this.$nextTick(()=>{
         this.disable_search = false;
      });
   },
   
   methods: {

      setListeners() {
         this.matching_options = this.$refs.list;
         if(this.matching_options){


            this.children = this.matching_options.querySelectorAll('li');

            this.matching_options.onkeydown = e =>{
               if(e.keyCode == 8){
                  e.preventDefault();
                  if(this.search.length > 0){
                     this.search = this.search.slice(0, -1)
                  }
                  this.$refs.input.focus();
               }
            }

            this.$refs.component.onkeydown = e => {
               if([38, 40, 13].includes(e.keyCode)){
                  e.preventDefault()
               }
               switch (e.keyCode) {
                  case 38:
                     if (this.index >= 0) {
                        this.index--;
                     }
                     if(this.index < 0){
                        this.$refs.input.focus();
                        break;
                     }
                     this.children[this.index].focus();
                     break;
                  case 40:
                     if (this.index < this.children.length - 1) {
                        this.index++;
                     }
                     this.children[this.index].focus();
                     break;
                  case 13:
                     this.children[this.index].click();
                     break;
               }
            };
         }
      },

      loadOptions() {
         let data = {
            params: {
               search: this.search.toLowerCase()
            }
         };

         this.http.get(this.endpoint, data).then((response)=>{
            if(response.successful){
               this.options = response.data;
               this.$nextTick(()=>{
                  this.setListeners();
               })
            }else{
               this.notify(response.error.message, 'danger');
            }
         }).catch((err)=>{
            console.log(err);
         });
      },

      select(e, option) {
         e.preventDefault();

         this.disable_search = true;
         this.options = [];
         this.selected_option = option;
         this.search = option[this.textField];
         this.index = -1;
         this.$refs.input.focus(); 
         this.$emit('input', option[this.keyField]);

         this.$nextTick(()=>{
            this.disable_search = false;
         });
      }
   },

   watch: {
      search(value) {
         if (! this.disable_search) {
            if (value !== '') {
               this.loadOptions();
            } else {
               this.options = [];
            }
         }
      }
   }
};
</script>
<template>
   <div ref="component" class="component w-100">
      <input
         class="input"
         type="text"
         v-model="search"
         autocomplete="off"
         :placeholder="placeholder"
         ref="input"
      />
      <ul class="list-group w-100 autocomplete-wrap" v-show="options.length > 0" ref="list">
         <li
            class="list-group-item list-group-item-action"
            v-for="(option, index) in options"
            :key="option[keyField]"
            @click="select($event, option)"
            :tabindex="index + 1"
         >
            <text-highlight :queries="search">{{ option[textField] }}</text-highlight>
         </li>
      </ul>
   </div>
</template>
<style>
.autocomplete-wrap {
  background-color: #FFFFFF;
  position: absolute;
  z-index: 200;
}
.autocomplete-wrap li {
  padding: 0.25rem;
}
</style>
