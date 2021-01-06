'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var __chunk_1 = require('./chunk-14c82365.js');
require('./helpers.js');
var __chunk_2 = require('./chunk-0e70abe7.js');
require('./chunk-dbd288d9.js');
var __chunk_5 = require('./chunk-13e039f5.js');
require('./chunk-b7119999.js');
require('./chunk-c029a04e.js');
var __chunk_26 = require('./chunk-967788e2.js');

var script = {
  name: 'BTabs',
  mixins: [__chunk_26.TabbedMixin('tab')],
  props: {
    expanded: {
      type: Boolean,
      default: function _default() {
        return __chunk_2.config.defaultTabsExpanded;
      }
    },
    type: {
      type: [String, Object],
      default: function _default() {
        return __chunk_2.config.defaultTabsType;
      }
    },
    animated: {
      type: Boolean,
      default: function _default() {
        return __chunk_2.config.defaultTabsAnimated;
      }
    },
    multiline: Boolean
  },
  computed: {
    mainClasses: function mainClasses() {
      return __chunk_1._defineProperty({
        'is-fullwidth': this.expanded,
        'is-vertical': this.vertical,
        'is-multiline': this.multiline
      }, this.position, this.position && this.vertical);
    },
    navClasses: function navClasses() {
      var _ref2;

      return [this.type, this.size, (_ref2 = {}, __chunk_1._defineProperty(_ref2, this.position, this.position && !this.vertical), __chunk_1._defineProperty(_ref2, 'is-fullwidth', this.expanded), __chunk_1._defineProperty(_ref2, 'is-toggle-rounded is-toggle', this.type === 'is-toggle-rounded'), _ref2)];
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-tabs",class:_vm.mainClasses},[_c('nav',{staticClass:"tabs",class:_vm.navClasses},[_c('ul',_vm._l((_vm.items),function(childItem){return _c('li',{directives:[{name:"show",rawName:"v-show",value:(childItem.visible),expression:"childItem.visible"}],key:childItem.value,class:[ childItem.headerClass, { 'is-active': childItem.isActive,
                                                   'is-disabled': childItem.disabled }]},[(childItem.$scopedSlots.header)?_c('b-slot-component',{attrs:{"component":childItem,"name":"header","tag":"a"},nativeOn:{"click":function($event){return _vm.childClick(childItem)}}}):_c('a',{on:{"click":function($event){return _vm.childClick(childItem)}}},[(childItem.icon)?_c('b-icon',{attrs:{"icon":childItem.icon,"pack":childItem.iconPack,"size":_vm.size}}):_vm._e(),_c('span',[_vm._v(_vm._s(childItem.label))])],1)],1)}),0)]),_c('section',{staticClass:"tab-content",class:{'is-transitioning': _vm.isTransitioning}},[_vm._t("default")],2)])};
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
  

  
  var Tabs = __chunk_5.__vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

var script$1 = {
  name: 'BTabItem',
  mixins: [__chunk_26.TabbedChildMixin('tab')],
  props: {
    disabled: Boolean
  },
  data: function data() {
    return {
      elementClass: 'tab-item'
    };
  }
};

/* script */
const __vue_script__$1 = script$1;

/* template */

  /* style */
  const __vue_inject_styles__$1 = undefined;
  /* scoped */
  const __vue_scope_id__$1 = undefined;
  /* module identifier */
  const __vue_module_identifier__$1 = undefined;
  /* functional template */
  const __vue_is_functional_template__$1 = undefined;
  /* style inject */
  
  /* style inject SSR */
  

  
  var TabItem = __chunk_5.__vue_normalize__(
    {},
    __vue_inject_styles__$1,
    __vue_script__$1,
    __vue_scope_id__$1,
    __vue_is_functional_template__$1,
    __vue_module_identifier__$1,
    undefined,
    undefined
  );

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, Tabs);
    __chunk_5.registerComponent(Vue, TabItem);
  }
};
__chunk_5.use(Plugin);

exports.BTabItem = TabItem;
exports.BTabs = Tabs;
exports.default = Plugin;
