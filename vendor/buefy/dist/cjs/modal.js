'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

require('./chunk-a535ca7c.js');
require('./chunk-f920b094.js');
require('./chunk-98a92ff2.js');
var __chunk_6 = require('./chunk-13e039f5.js');
require('./chunk-68185b37.js');
var Vue = _interopDefault(require('vue'));
var __chunk_17 = require('./chunk-7f391163.js');

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
    var ModalComponent = vm.extend(__chunk_17.Modal);
    return new ModalComponent({
      parent: parent,
      el: document.createElement('div'),
      propsData: propsData
    });
  }
};
var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_17.Modal);
    __chunk_6.registerComponentProgrammatic(Vue, 'modal', ModalProgrammatic);
  }
};
__chunk_6.use(Plugin);

exports.ModalProgrammatic = ModalProgrammatic;
exports.default = Plugin;
