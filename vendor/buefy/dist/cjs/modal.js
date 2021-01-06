'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-14c82365.js');
var helpers = require('./helpers.js');
var __chunk_2 = require('./chunk-cd0dcc1d.js');
var __chunk_5 = require('./chunk-13e039f5.js');
require('./chunk-ae7e641a.js');
var __chunk_17 = require('./chunk-85f160c1.js');

var localVueInstance;
var ModalProgrammatic = {
  open: function open(params) {
    var parent;

    if (typeof params === 'string') {
      params = {
        content: params
      };
    }

    var defaultParam = {
      programmatic: true
    };

    if (params.parent) {
      parent = params.parent;
      delete params.parent;
    }

    var propsData = helpers.merge(defaultParam, params);
    var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : localVueInstance || __chunk_2.VueInstance;
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
    localVueInstance = Vue;
    __chunk_5.registerComponent(Vue, __chunk_17.Modal);
    __chunk_5.registerComponentProgrammatic(Vue, 'modal', ModalProgrammatic);
  }
};
__chunk_5.use(Plugin);

exports.BModal = __chunk_17.Modal;
exports.ModalProgrammatic = ModalProgrammatic;
exports.default = Plugin;
