'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

require('./chunk-59b91990.js');
require('./chunk-545f01b1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var Vue = _interopDefault(require('vue'));
var __chunk_14 = require('./chunk-e5de6583.js');

var ModalProgrammatic = {
  open: function open(params) {
    var content;
    var parent;
    if (typeof params === 'string') content = params;
    var defaultParam = {
      programmatic: true,
      content: content
    };

    if (params.parent) {
      parent = params.parent;
      delete params.parent;
    }

    var propsData = Object.assign(defaultParam, params);
    var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : Vue;
    var ModalComponent = vm.extend(__chunk_14.Modal);
    return new ModalComponent({
      parent: parent,
      el: document.createElement('div'),
      propsData: propsData
    });
  }
};
var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_14.Modal);
    __chunk_6.registerComponentProgrammatic(Vue, 'modal', ModalProgrammatic);
  }
};
__chunk_6.use(Plugin);

exports.Modal = __chunk_14.Modal;
exports.ModalProgrammatic = ModalProgrammatic;
exports.default = Plugin;
