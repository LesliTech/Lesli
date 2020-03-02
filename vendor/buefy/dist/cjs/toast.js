'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-5094d8df.js');
var helpers = require('./helpers.js');
var __chunk_2 = require('./chunk-805257cc.js');
var __chunk_5 = require('./chunk-13e039f5.js');
var __chunk_20 = require('./chunk-fbdc0e2d.js');

//
var script = {
  name: 'BToast',
  mixins: [__chunk_20.NoticeMixin],
  data: function data() {
    return {
      newDuration: this.duration || __chunk_2.config.defaultToastDuration
    };
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"enter-active-class":_vm.transition.enter,"leave-active-class":_vm.transition.leave}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"toast",class:[_vm.type, _vm.position],attrs:{"aria-hidden":!_vm.isActive,"role":"alert"}},[_c('div',{domProps:{"innerHTML":_vm._s(_vm.message)}})])])};
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
  
  /* style inject shadow dom */
  

  
  const __vue_component__ = __chunk_5.__vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    false,
    undefined,
    undefined,
    undefined
  );

var localVueInstance;
var ToastProgrammatic = {
  open: function open(params) {
    var parent;

    if (typeof params === 'string') {
      params = {
        message: params
      };
    }

    var defaultParam = {
      position: __chunk_2.config.defaultToastPosition || 'is-top'
    };

    if (params.parent) {
      parent = params.parent;
      delete params.parent;
    }

    var propsData = helpers.merge(defaultParam, params);
    var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : localVueInstance || __chunk_2.VueInstance;
    var ToastComponent = vm.extend(__vue_component__);
    return new ToastComponent({
      parent: parent,
      el: document.createElement('div'),
      propsData: propsData
    });
  }
};
var Plugin = {
  install: function install(Vue) {
    localVueInstance = Vue;
    __chunk_5.registerComponentProgrammatic(Vue, 'toast', ToastProgrammatic);
  }
};
__chunk_5.use(Plugin);

exports.BToast = __vue_component__;
exports.ToastProgrammatic = ToastProgrammatic;
exports.default = Plugin;
