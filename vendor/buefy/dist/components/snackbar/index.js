/*! Buefy v0.8.6 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports, require('vue')) :
    typeof define === 'function' && define.amd ? define(['exports', 'vue'], factory) :
    (global = global || self, factory(global.Snackbar = {}, global.Vue));
}(this, function (exports, Vue) { 'use strict';

    Vue = Vue && Vue.hasOwnProperty('default') ? Vue['default'] : Vue;

    var config = {
      defaultContainerElement: null,
      defaultIconPack: 'mdi',
      defaultIconComponent: null,
      defaultIconPrev: 'chevron-left',
      defaultIconNext: 'chevron-right',
      defaultDialogConfirmText: null,
      defaultDialogCancelText: null,
      defaultSnackbarDuration: 3500,
      defaultSnackbarPosition: null,
      defaultToastDuration: 2000,
      defaultToastPosition: null,
      defaultNotificationDuration: 2000,
      defaultNotificationPosition: null,
      defaultTooltipType: 'is-primary',
      defaultTooltipAnimated: false,
      defaultTooltipDelay: 0,
      defaultInputAutocomplete: 'on',
      defaultDateFormatter: null,
      defaultDateParser: null,
      defaultDateCreator: null,
      defaultDayNames: null,
      defaultMonthNames: null,
      defaultFirstDayOfWeek: null,
      defaultUnselectableDaysOfWeek: null,
      defaultTimeFormatter: null,
      defaultTimeParser: null,
      defaultModalCanCancel: ['escape', 'x', 'outside', 'button'],
      defaultModalScroll: null,
      defaultDatepickerMobileNative: true,
      defaultTimepickerMobileNative: true,
      defaultNoticeQueue: true,
      defaultInputHasCounter: true,
      defaultTaginputHasCounter: true,
      defaultUseHtml5Validation: true,
      defaultDropdownMobileModal: true,
      defaultFieldLabelPosition: null,
      defaultDatepickerYearsRange: [-100, 3],
      defaultDatepickerNearbyMonthDays: true,
      defaultDatepickerNearbySelectableMonthDays: false,
      defaultDatepickerShowWeekNumber: false,
      defaultTrapFocus: false,
      defaultButtonRounded: false,
      customIconPacks: null // TODO defaultTrapFocus to true in the next breaking change

    };
    var config$1 = config;

    function removeElement(el) {
      if (typeof el.remove !== 'undefined') {
        el.remove();
      } else if (typeof el.parentNode !== 'undefined') {
        el.parentNode.removeChild(el);
      }
    }

    var NoticeMixin = {
      props: {
        type: {
          type: String,
          default: 'is-dark'
        },
        message: String,
        duration: Number,
        queue: {
          type: Boolean,
          default: undefined
        },
        position: {
          type: String,
          default: 'is-top',
          validator: function validator(value) {
            return ['is-top-right', 'is-top', 'is-top-left', 'is-bottom-right', 'is-bottom', 'is-bottom-left'].indexOf(value) > -1;
          }
        },
        container: String
      },
      data: function data() {
        return {
          isActive: false,
          parentTop: null,
          parentBottom: null,
          newContainer: this.container || config$1.defaultContainerElement
        };
      },
      computed: {
        correctParent: function correctParent() {
          switch (this.position) {
            case 'is-top-right':
            case 'is-top':
            case 'is-top-left':
              return this.parentTop;

            case 'is-bottom-right':
            case 'is-bottom':
            case 'is-bottom-left':
              return this.parentBottom;
          }
        },
        transition: function transition() {
          switch (this.position) {
            case 'is-top-right':
            case 'is-top':
            case 'is-top-left':
              return {
                enter: 'fadeInDown',
                leave: 'fadeOut'
              };

            case 'is-bottom-right':
            case 'is-bottom':
            case 'is-bottom-left':
              return {
                enter: 'fadeInUp',
                leave: 'fadeOut'
              };
          }
        }
      },
      methods: {
        shouldQueue: function shouldQueue() {
          var queue = this.queue !== undefined ? this.queue : config$1.defaultNoticeQueue;
          if (!queue) return false;
          return this.parentTop.childElementCount > 0 || this.parentBottom.childElementCount > 0;
        },
        close: function close() {
          var _this = this;

          clearTimeout(this.timer);
          this.isActive = false; // Timeout for the animation complete before destroying

          setTimeout(function () {
            _this.$destroy();

            removeElement(_this.$el);
          }, 150);
        },
        showNotice: function showNotice() {
          var _this2 = this;

          if (this.shouldQueue()) {
            // Call recursively if should queue
            setTimeout(function () {
              return _this2.showNotice();
            }, 250);
            return;
          }

          this.correctParent.insertAdjacentElement('afterbegin', this.$el);
          this.isActive = true;

          if (!this.indefinite) {
            this.timer = setTimeout(function () {
              return _this2.close();
            }, this.newDuration);
          }
        },
        setupContainer: function setupContainer() {
          this.parentTop = document.querySelector((this.newContainer ? this.newContainer : 'body') + '>.notices.is-top');
          this.parentBottom = document.querySelector((this.newContainer ? this.newContainer : 'body') + '>.notices.is-bottom');
          if (this.parentTop && this.parentBottom) return;

          if (!this.parentTop) {
            this.parentTop = document.createElement('div');
            this.parentTop.className = 'notices is-top';
          }

          if (!this.parentBottom) {
            this.parentBottom = document.createElement('div');
            this.parentBottom.className = 'notices is-bottom';
          }

          var container = document.querySelector(this.newContainer) || document.body;
          container.appendChild(this.parentTop);
          container.appendChild(this.parentBottom);

          if (this.newContainer) {
            this.parentTop.classList.add('has-custom-container');
            this.parentBottom.classList.add('has-custom-container');
          }
        }
      },
      beforeMount: function beforeMount() {
        this.setupContainer();
      },
      mounted: function mounted() {
        this.showNotice();
      }
    };

    //
    var script = {
      name: 'BSnackbar',
      mixins: [NoticeMixin],
      props: {
        actionText: {
          type: String,
          default: 'OK'
        },
        onAction: {
          type: Function,
          default: function _default() {}
        },
        indefinite: {
          type: Boolean,
          default: false
        }
      },
      data: function data() {
        return {
          newDuration: this.duration || config$1.defaultSnackbarDuration
        };
      },
      methods: {
        /**
        * Click listener.
        * Call action prop before closing (from Mixin).
        */
        action: function action() {
          this.onAction();
          this.close();
        }
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
    var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"enter-active-class":_vm.transition.enter,"leave-active-class":_vm.transition.leave}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"snackbar",class:[_vm.type,_vm.position]},[_c('div',{staticClass:"text",domProps:{"innerHTML":_vm._s(_vm.message)}}),_vm._v(" "),(_vm.actionText)?_c('div',{staticClass:"action",class:_vm.type,on:{"click":_vm.action}},[_c('button',{staticClass:"button"},[_vm._v(_vm._s(_vm.actionText))])]):_vm._e()])])};
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
      

      
      var Snackbar = normalizeComponent_1(
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
    var registerComponentProgrammatic = function registerComponentProgrammatic(Vue, property, component) {
      if (!Vue.prototype.$buefy) Vue.prototype.$buefy = {};
      Vue.prototype.$buefy[property] = component;
    };

    var SnackbarProgrammatic = {
      open: function open(params) {
        var message;
        var parent;
        if (typeof params === 'string') message = params;
        var defaultParam = {
          type: 'is-success',
          position: config$1.defaultSnackbarPosition || 'is-bottom-right',
          message: message
        };

        if (params.parent) {
          parent = params.parent;
          delete params.parent;
        }

        var propsData = Object.assign(defaultParam, params);
        var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : Vue;
        var SnackbarComponent = vm.extend(Snackbar);
        return new SnackbarComponent({
          parent: parent,
          el: document.createElement('div'),
          propsData: propsData
        });
      }
    };
    var Plugin = {
      install: function install(Vue) {
        registerComponentProgrammatic(Vue, 'snackbar', SnackbarProgrammatic);
      }
    };
    use(Plugin);

    exports.SnackbarProgrammatic = SnackbarProgrammatic;
    exports.default = Plugin;

    Object.defineProperty(exports, '__esModule', { value: true });

}));
