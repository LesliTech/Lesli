import './chunk-40949afc.js';
import { r as removeElement } from './chunk-d3a97e18.js';
import { _ as __vue_normalize__, r as registerComponent, a as registerComponentProgrammatic, u as use } from './chunk-cca88db8.js';
import Vue from 'vue';
import { H as HTMLElement } from './chunk-b9bdb0e4.js';

//
var script = {
  name: 'BLoading',
  props: {
    active: Boolean,
    programmatic: Boolean,
    container: [Object, Function, HTMLElement],
    isFullPage: {
      type: Boolean,
      default: true
    },
    animation: {
      type: String,
      default: 'fade'
    },
    canCancel: {
      type: Boolean,
      default: false
    },
    onCancel: {
      type: Function,
      default: function _default() {}
    }
  },
  data: function data() {
    return {
      isActive: this.active || false
    };
  },
  watch: {
    active: function active(value) {
      this.isActive = value;
    }
  },
  methods: {
    /**
    * Close the Modal if canCancel.
    */
    cancel: function cancel() {
      if (!this.canCancel || !this.isActive) return;
      this.close();
    },

    /**
    * Emit events, and destroy modal if it's programmatic.
    */
    close: function close() {
      var _this = this;

      this.onCancel.apply(null, arguments);
      this.$emit('close');
      this.$emit('update:active', false); // Timeout for the animation complete before destroying

      if (this.programmatic) {
        this.isActive = false;
        setTimeout(function () {
          _this.$destroy();

          removeElement(_this.$el);
        }, 150);
      }
    },

    /**
    * Keypress event that is bound to the document.
    */
    keyPress: function keyPress(event) {
      // Esc key
      if (event.keyCode === 27) this.cancel();
    }
  },
  created: function created() {
    if (typeof window !== 'undefined') {
      document.addEventListener('keyup', this.keyPress);
    }
  },
  beforeMount: function beforeMount() {
    // Insert the Loading component in body tag
    // only if it's programmatic
    if (this.programmatic) {
      if (!this.container) {
        document.body.appendChild(this.$el);
      } else {
        this.isFullPage = false;
        this.container.appendChild(this.$el);
      }
    }
  },
  mounted: function mounted() {
    if (this.programmatic) this.isActive = true;
  },
  beforeDestroy: function beforeDestroy() {
    if (typeof window !== 'undefined') {
      document.removeEventListener('keyup', this.keyPress);
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":_vm.animation}},[(_vm.isActive)?_c('div',{staticClass:"loading-overlay is-active",class:{ 'is-full-page': _vm.isFullPage }},[_c('div',{staticClass:"loading-background",on:{"click":_vm.cancel}}),_vm._v(" "),_vm._t("default",[_c('div',{staticClass:"loading-icon"})])],2):_vm._e()])};
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
  

  
  var Loading = __vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

var LoadingProgrammatic = {
  open: function open(params) {
    var defaultParam = {
      programmatic: true
    };
    var propsData = Object.assign(defaultParam, params);
    var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : Vue;
    var LoadingComponent = vm.extend(Loading);
    return new LoadingComponent({
      el: document.createElement('div'),
      propsData: propsData
    });
  }
};
var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Loading);
    registerComponentProgrammatic(Vue, 'loading', LoadingProgrammatic);
  }
};
use(Plugin);

export default Plugin;
export { LoadingProgrammatic };
