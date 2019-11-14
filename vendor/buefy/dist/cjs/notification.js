'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

require('./chunk-a535ca7c.js');
require('./chunk-f920b094.js');
var __chunk_3 = require('./chunk-98a92ff2.js');
require('./chunk-ef3fcce1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var Vue = _interopDefault(require('vue'));
var __chunk_19 = require('./chunk-845068dc.js');
var __chunk_20 = require('./chunk-fa58a866.js');

//
var script = {
  name: 'BNotification',
  mixins: [__chunk_19.MessageMixin],
  props: {
    position: String,
    ariaCloseLabel: String
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":"fade"}},[_c('article',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"notification",class:[_vm.type, _vm.position]},[(_vm.closable)?_c('button',{staticClass:"delete",attrs:{"type":"button","aria-label":_vm.ariaCloseLabel},on:{"click":_vm.close}}):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media"},[(_vm.icon && _vm.hasIcon)?_c('div',{staticClass:"media-left"},[_c('b-icon',{attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"both":"","size":"is-large","aria-hidden":""}})],1):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media-content"},[(_vm.message)?_c('p',{staticClass:"text",domProps:{"innerHTML":_vm._s(_vm.message)}}):_vm._t("default")],2)])])])};
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
  

  
  var Notification = __chunk_6.__vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

//
var script$1 = {
  name: 'BNotificationNotice',
  mixins: [__chunk_20.NoticeMixin],
  props: {
    indefinite: {
      type: Boolean,
      default: false
    }
  },
  data: function data() {
    return {
      newDuration: this.duration || __chunk_3.config.defaultNotificationDuration
    };
  }
};

/* script */
const __vue_script__$1 = script$1;

/* template */
var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('b-notification',_vm._b({on:{"close":_vm.close}},'b-notification',_vm.$options.propsData,false))};
var __vue_staticRenderFns__$1 = [];

  /* style */
  const __vue_inject_styles__$1 = undefined;
  /* scoped */
  const __vue_scope_id__$1 = undefined;
  /* module identifier */
  const __vue_module_identifier__$1 = undefined;
  /* functional template */
  const __vue_is_functional_template__$1 = false;
  /* style inject */
  
  /* style inject SSR */
  

  
  var NotificationNotice = __chunk_6.__vue_normalize__(
    { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
    __vue_inject_styles__$1,
    __vue_script__$1,
    __vue_scope_id__$1,
    __vue_is_functional_template__$1,
    __vue_module_identifier__$1,
    undefined,
    undefined
  );

var NotificationProgrammatic = {
  open: function open(params) {
    var message;
    var parent;
    if (typeof params === 'string') message = params;
    var defaultParam = {
      message: message,
      position: __chunk_3.config.defaultNotificationPosition || 'is-top-right'
    };

    if (params.parent) {
      parent = params.parent;
      delete params.parent;
    }

    var propsData = Object.assign(defaultParam, typeof params === 'string' ? {} : params);
    var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : Vue;
    var NotificationNoticeComponent = vm.extend(NotificationNotice);
    return new NotificationNoticeComponent({
      parent: parent,
      el: document.createElement('div'),
      propsData: propsData
    });
  }
};
var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, Notification);
    __chunk_6.registerComponentProgrammatic(Vue, 'notification', NotificationProgrammatic);
  }
};
__chunk_6.use(Plugin);

exports.NotificationProgrammatic = NotificationProgrammatic;
exports.default = Plugin;
