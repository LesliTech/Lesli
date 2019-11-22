'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_9 = require('./chunk-96ce35a2.js');

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
var script = {
  name: 'BCheckboxButton',
  props: {
    value: [String, Number, Boolean, Function, Object, Array],
    nativeValue: [String, Number, Boolean, Function, Object, Array],
    disabled: Boolean,
    required: Boolean,
    expanded: Boolean,
    name: String,
    size: String,
    type: {
      type: String,
      default: 'is-primary'
    }
  },
  data: function data() {
    return {
      newValue: this.value,
      isFocused: false
    };
  },
  computed: {
    computedValue: {
      get: function get() {
        return this.newValue;
      },
      set: function set(value) {
        this.newValue = value;
        this.$emit('input', value);
      }
    },
    checked: function checked() {
      if (Array.isArray(this.newValue)) {
        return this.newValue.indexOf(this.nativeValue) >= 0;
      }

      return this.newValue === this.nativeValue;
    }
  },
  watch: {
    /**
     * When v-model change, set internal value.
     */
    value: function value(_value) {
      this.newValue = _value;
    }
  },
  methods: {
    focus: function focus() {
      // MacOS FireFox and Safari do not focus when clicked
      this.$refs.input.focus();
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:{ 'is-expanded': _vm.expanded }},[_c('label',{ref:"label",staticClass:"b-checkbox checkbox button",class:[_vm.checked ? _vm.type : null, _vm.size, {
            'is-disabled': _vm.disabled,
            'is-focused': _vm.isFocused
        }],attrs:{"disabled":_vm.disabled},on:{"click":_vm.focus,"keydown":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.$refs.label.click();}}},[_vm._t("default"),_vm._v(" "),_c('input',{directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"input",attrs:{"type":"checkbox","disabled":_vm.disabled,"required":_vm.required,"name":_vm.name},domProps:{"value":_vm.nativeValue,"checked":Array.isArray(_vm.computedValue)?_vm._i(_vm.computedValue,_vm.nativeValue)>-1:(_vm.computedValue)},on:{"click":function($event){$event.stopPropagation();},"focus":function($event){_vm.isFocused = true;},"blur":function($event){_vm.isFocused = false;},"change":function($event){var $$a=_vm.computedValue,$$el=$event.target,$$c=$$el.checked?(true):(false);if(Array.isArray($$a)){var $$v=_vm.nativeValue,$$i=_vm._i($$a,$$v);if($$el.checked){$$i<0&&(_vm.computedValue=$$a.concat([$$v]));}else{$$i>-1&&(_vm.computedValue=$$a.slice(0,$$i).concat($$a.slice($$i+1)));}}else{_vm.computedValue=$$c;}}}})],2)])};
var __vue_staticRenderFns__ = [];

  /* style */
  const __vue_inject_styles__ = undefined;
  /* scoped */
  const __vue_scope_id__ = undefined;
  /* module identifier */
  const __vue_module_identifier__ = undefined;
  /* functional template */
  const __vue_is_functional_template__ = false;
  /* style inject */
  
  /* style inject SSR */
  

  
  var CheckboxButton = __chunk_6.__vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_9.Checkbox);
    __chunk_6.registerComponent(Vue, CheckboxButton);
  }
};
__chunk_6.use(Plugin);

exports.default = Plugin;
