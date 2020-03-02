import './chunk-6ea13200.js';
import { merge } from './helpers.js';
import { V as VueInstance } from './chunk-17222463.js';
import { r as registerComponent, a as registerComponentProgrammatic, u as use } from './chunk-cca88db8.js';
import './chunk-b3471279.js';
import { M as Modal } from './chunk-d8b703f1.js';
export { M as BModal } from './chunk-d8b703f1.js';

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

    var propsData = merge(defaultParam, params);
    var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : localVueInstance || VueInstance;
    var ModalComponent = vm.extend(Modal);
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
    registerComponent(Vue, Modal);
    registerComponentProgrammatic(Vue, 'modal', ModalProgrammatic);
  }
};
use(Plugin);

export default Plugin;
export { ModalProgrammatic };
