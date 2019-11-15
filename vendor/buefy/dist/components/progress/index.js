/*! Buefy v0.8.6 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (global = global || self, factory(global.Progress = {}));
}(this, function (exports) { 'use strict';

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
      name: 'BProgress',
      props: {
        type: {
          type: [String, Object],
          default: 'is-darkgrey'
        },
        size: String,
        value: {
          type: Number,
          default: undefined
        },
        max: {
          type: Number,
          default: 100
        },
        showValue: {
          type: Boolean,
          default: false
        },
        format: {
          type: String,
          default: 'raw',
          validator: function validator(value) {
            return ['raw', 'percent'].indexOf(value) >= 0;
          }
        },
        precision: {
          type: Number,
          default: 2
        },
        keepTrailingZeroes: {
          type: Boolean,
          default: false
        }
      },
      computed: {
        isIndeterminate: function isIndeterminate() {
          return this.value === undefined || this.value === null;
        },
        newType: function newType() {
          return [this.size, this.type];
        },
        newValue: function newValue() {
          if (this.value === undefined || this.value === null || isNaN(this.value)) {
            return undefined;
          }

          if (this.format === 'percent') {
            var _val = this.toFixed(this.value * this.max / 100);

            return "".concat(_val, "%");
          }

          var val = this.toFixed(this.value);
          return val;
        }
      },
      watch: {
        value: function value(_value) {
          this.setValue(_value);
        }
      },
      methods: {
        /**
        * When value is changed back to undefined, value of native progress get reset to 0.
        * Need to add and remove the value attribute to have the indeterminate or not.
        */
        setValue: function setValue(value) {
          if (this.isIndeterminate) {
            this.$refs.progress.removeAttribute('value');
          } else {
            this.$refs.progress.setAttribute('value', value);
          }
        },
        // Custom function that imitate the javascript toFixed method with improved rounding
        toFixed: function toFixed(num) {
          var fixed = (+"".concat(Math.round(+"".concat(num, "e").concat(this.precision)), "e").concat(-this.precision)).toFixed(this.precision);

          if (!this.keepTrailingZeroes) {
            fixed = fixed.replace(/\.?0+$/, '');
          }

          return fixed;
        }
      },
      mounted: function mounted() {
        this.setValue(this.value);
      }
    };

    function normalizeComponent(template, style, script, scopeId, isFunctionalTemplate, moduleIdentifier
    /* server only */
    , shadowMode, createInjector, createInjectorSSR, createInjectorShadow) {
      if (typeof shadowMode !== 'boolean') {
        createInjectorSSR = createInjector;
        createInjector = shadowMode;
        shadowMode = false;
      } // Vue.extend constructor export interop.


      var options = typeof script === 'function' ? script.options : script; // render functions

      if (template && template.render) {
        options.render = template.render;
        options.staticRenderFns = template.staticRenderFns;
        options._compiled = true; // functional template

        if (isFunctionalTemplate) {
          options.functional = true;
        }
      } // scopedId


      if (scopeId) {
        options._scopeId = scopeId;
      }

      var hook;

      if (moduleIdentifier) {
        // server build
        hook = function hook(context) {
          // 2.3 injection
          context = context || // cached call
          this.$vnode && this.$vnode.ssrContext || // stateful
          this.parent && this.parent.$vnode && this.parent.$vnode.ssrContext; // functional
          // 2.2 with runInNewContext: true

          if (!context && typeof __VUE_SSR_CONTEXT__ !== 'undefined') {
            context = __VUE_SSR_CONTEXT__;
          } // inject component styles


          if (style) {
            style.call(this, createInjectorSSR(context));
          } // register component module identifier for async chunk inference


          if (context && context._registeredComponents) {
            context._registeredComponents.add(moduleIdentifier);
          }
        }; // used by ssr in case component is cached and beforeCreate
        // never gets called


        options._ssrRegister = hook;
      } else if (style) {
        hook = shadowMode ? function () {
          style.call(this, createInjectorShadow(this.$root.$options.shadowRoot));
        } : function (context) {
          style.call(this, createInjector(context));
        };
      }

      if (hook) {
        if (options.functional) {
          // register for functional component in vue file
          var originalRender = options.render;

          options.render = function renderWithStyleInjection(h, context) {
            hook.call(context);
            return originalRender(h, context);
          };
        } else {
          // inject component registration as beforeCreate hook
          var existing = options.beforeCreate;
          options.beforeCreate = existing ? [].concat(existing, hook) : [hook];
        }
      }

      return script;
    }

    var normalizeComponent_1 = normalizeComponent;

    /* script */
    const __vue_script__ = script;

    /* template */
    var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"progress-wrapper"},[_c('progress',{ref:"progress",staticClass:"progress",class:_vm.newType,attrs:{"max":_vm.max}},[_vm._v(_vm._s(_vm.newValue))]),_vm._v(" "),(_vm.showValue)?_c('p',{staticClass:"progress-value"},[_vm._t("default",[_vm._v(_vm._s(_vm.newValue))])],2):_vm._e()])};
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
      

      
      var Progress = normalizeComponent_1(
        { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
        __vue_inject_styles__,
        __vue_script__,
        __vue_scope_id__,
        __vue_is_functional_template__,
        __vue_module_identifier__,
        undefined,
        undefined
      );

    var use = function use(plugin) {
      if (typeof window !== 'undefined' && window.Vue) {
        window.Vue.use(plugin);
      }
    };
    var registerComponent = function registerComponent(Vue, component) {
      Vue.component(component.name, component);
    };

    var Plugin = {
      install: function install(Vue) {
        registerComponent(Vue, Progress);
      }
    };
    use(Plugin);

    exports.default = Plugin;

    Object.defineProperty(exports, '__esModule', { value: true });

}));
