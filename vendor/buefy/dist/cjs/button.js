'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var __chunk_1 = require('./chunk-9f6a8079.js');
require('./chunk-545f01b1.js');
var __chunk_5 = require('./chunk-60061aa8.js');
var __chunk_6 = require('./chunk-13e039f5.js');

var script = {
  name: 'BButton',
  components: __chunk_1._defineProperty({}, __chunk_5.Icon.name, __chunk_5.Icon),
  inheritAttrs: false,
  props: {
    type: [String, Object],
    size: String,
    label: String,
    iconPack: String,
    iconLeft: String,
    iconRight: String,
    rounded: Boolean,
    loading: Boolean,
    outlined: Boolean,
    inverted: Boolean,
    focused: Boolean,
    active: Boolean,
    hovered: Boolean,
    selected: Boolean,
    nativeType: {
      type: String,
      default: 'button',
      validator: function validator(value) {
        return ['button', 'submit', 'reset'].indexOf(value) >= 0;
      }
    },
    tag: {
      type: String,
      default: 'button',
      validator: function validator(value) {
        return ['button', 'a', 'input', 'router-link', 'nuxt-link', 'n-link', 'NuxtLink', 'NLink'].indexOf(value) >= 0;
      }
    }
  },
  computed: {
    iconSize: function iconSize() {
      if (!this.size || this.size === 'is-medium') {
        return 'is-small';
      } else if (this.size === 'is-large') {
        return 'is-medium';
      }

      return this.size;
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c(_vm.tag,_vm._b({tag:"component",staticClass:"button",class:[_vm.size, _vm.type, {
        'is-rounded': _vm.rounded,
        'is-loading': _vm.loading,
        'is-outlined': _vm.outlined,
        'is-inverted': _vm.inverted,
        'is-focused': _vm.focused,
        'is-active': _vm.active,
        'is-hovered': _vm.hovered,
        'is-selected': _vm.selected
    }],attrs:{"type":_vm.nativeType},on:{"click":function($event){_vm.$emit('click', $event);}}},'component',_vm.$attrs,false),[(_vm.iconLeft)?_c('b-icon',{attrs:{"pack":_vm.iconPack,"icon":_vm.iconLeft,"size":_vm.iconSize}}):_vm._e(),_vm._v(" "),(_vm.label)?_c('span',[_vm._v(_vm._s(_vm.label))]):(_vm.$slots.default)?_c('span',[_vm._t("default")],2):_vm._e(),_vm._v(" "),(_vm.iconRight)?_c('b-icon',{attrs:{"pack":_vm.iconPack,"icon":_vm.iconRight,"size":_vm.iconSize}}):_vm._e()],1)};
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
  

  
  var Button = __chunk_6.__vue_normalize__(
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
    __chunk_6.registerComponent(Vue, Button);
  }
};
__chunk_6.use(Plugin);

exports.Button = Button;
exports.default = Plugin;
