/*! Buefy v0.8.6 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports, require('vue')) :
    typeof define === 'function' && define.amd ? define(['exports', 'vue'], factory) :
    (global = global || self, factory(global.Modal = {}, global.Vue));
}(this, function (exports, Vue) { 'use strict';

    Vue = Vue && Vue.hasOwnProperty('default') ? Vue['default'] : Vue;

    var findFocusable = function findFocusable(element) {
      if (!element) {
        return null;
      }

      return element.querySelectorAll("a[href],\n                                     area[href],\n                                     input:not([disabled]),\n                                     select:not([disabled]),\n                                     textarea:not([disabled]),\n                                     button:not([disabled]),\n                                     iframe,\n                                     object,\n                                     embed,\n                                     *[tabindex],\n                                     *[contenteditable]");
    };

    var onKeyDown;

    var bind = function bind(el, _ref) {
      var _ref$value = _ref.value,
          value = _ref$value === void 0 ? true : _ref$value;

      if (value) {
        var focusable = findFocusable(el);

        if (focusable && focusable.length > 0) {
          var firstFocusable = focusable[0];
          var lastFocusable = focusable[focusable.length - 1];

          onKeyDown = function onKeyDown(event) {
            if (event.target === firstFocusable && event.shiftKey && event.key === 'Tab') {
              event.preventDefault();
              lastFocusable.focus();
            } else if (event.target === lastFocusable && !event.shiftKey && event.key === 'Tab') {
              event.preventDefault();
              firstFocusable.focus();
            }
          };

          el.addEventListener('keydown', onKeyDown);
          firstFocusable.focus();
        }
      }
    };

    var unbind = function unbind(el) {
      el.removeEventListener('keydown', onKeyDown);
    };

    var directive = {
      bind: bind,
      unbind: unbind
    };

    function removeElement(el) {
      if (typeof el.remove !== 'undefined') {
        el.remove();
      } else if (typeof el.parentNode !== 'undefined') {
        el.parentNode.removeChild(el);
      }
    }

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

    //
    var script = {
      name: 'BModal',
      directives: {
        trapFocus: directive
      },
      props: {
        active: Boolean,
        component: [Object, Function],
        content: String,
        programmatic: Boolean,
        props: Object,
        events: Object,
        width: {
          type: [String, Number],
          default: 960
        },
        hasModalCard: Boolean,
        animation: {
          type: String,
          default: 'zoom-out'
        },
        canCancel: {
          type: [Array, Boolean],
          default: function _default() {
            return config$1.defaultModalCanCancel;
          }
        },
        onCancel: {
          type: Function,
          default: function _default() {}
        },
        scroll: {
          type: String,
          default: function _default() {
            return config$1.defaultModalScroll ? config$1.defaultModalScroll : 'clip';
          },
          validator: function validator(value) {
            return ['clip', 'keep'].indexOf(value) >= 0;
          }
        },
        fullScreen: Boolean,
        trapFocus: {
          type: Boolean,
          default: config$1.defaultTrapFocus
        },
        customClass: String,
        ariaRole: {
          type: String,
          validator: function validator(value) {
            return ['dialog', 'alertdialog'].indexOf(value) >= 0;
          }
        },
        ariaModal: Boolean
      },
      data: function data() {
        return {
          isActive: this.active || false,
          savedScrollTop: null,
          newWidth: typeof this.width === 'number' ? this.width + 'px' : this.width,
          animating: true
        };
      },
      computed: {
        cancelOptions: function cancelOptions() {
          return typeof this.canCancel === 'boolean' ? this.canCancel ? config$1.defaultModalCanCancel : [] : this.canCancel;
        },
        showX: function showX() {
          return this.cancelOptions.indexOf('x') >= 0;
        },
        customStyle: function customStyle() {
          if (!this.fullScreen) {
            return {
              maxWidth: this.newWidth
            };
          }

          return null;
        }
      },
      watch: {
        active: function active(value) {
          this.isActive = value;
        },
        isActive: function isActive() {
          this.handleScroll();
        }
      },
      methods: {
        handleScroll: function handleScroll() {
          if (typeof window === 'undefined') return;

          if (this.scroll === 'clip') {
            if (this.isActive) {
              document.documentElement.classList.add('is-clipped');
            } else {
              document.documentElement.classList.remove('is-clipped');
            }

            return;
          }

          this.savedScrollTop = !this.savedScrollTop ? document.documentElement.scrollTop : this.savedScrollTop;

          if (this.isActive) {
            document.body.classList.add('is-noscroll');
          } else {
            document.body.classList.remove('is-noscroll');
          }

          if (this.isActive) {
            document.body.style.top = "-".concat(this.savedScrollTop, "px");
            return;
          }

          document.documentElement.scrollTop = this.savedScrollTop;
          document.body.style.top = null;
          this.savedScrollTop = null;
        },

        /**
        * Close the Modal if canCancel and call the onCancel prop (function).
        */
        cancel: function cancel(method) {
          if (this.cancelOptions.indexOf(method) < 0) return;
          this.onCancel.apply(null, arguments);
          this.close();
        },

        /**
        * Call the onCancel prop (function).
        * Emit events, and destroy modal if it's programmatic.
        */
        close: function close() {
          var _this = this;

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
          if (this.isActive && event.keyCode === 27) this.cancel('escape');
        },

        /**
        * Transition after-enter hook
        */
        afterEnter: function afterEnter() {
          this.animating = false;
        },

        /**
        * Transition before-leave hook
        */
        beforeLeave: function beforeLeave() {
          this.animating = true;
        }
      },
      created: function created() {
        if (typeof window !== 'undefined') {
          document.addEventListener('keyup', this.keyPress);
        }
      },
      beforeMount: function beforeMount() {
        // Insert the Modal component in body tag
        // only if it's programmatic
        this.programmatic && document.body.appendChild(this.$el);
      },
      mounted: function mounted() {
        if (this.programmatic) this.isActive = true;else if (this.isActive) this.handleScroll();
      },
      beforeDestroy: function beforeDestroy() {
        if (typeof window !== 'undefined') {
          document.removeEventListener('keyup', this.keyPress); // reset scroll

          document.documentElement.classList.remove('is-clipped');
          var savedScrollTop = !this.savedScrollTop ? document.documentElement.scrollTop : this.savedScrollTop;
          document.body.classList.remove('is-noscroll');
          document.documentElement.scrollTop = savedScrollTop;
          document.body.style.top = null;
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
    var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":_vm.animation},on:{"after-enter":_vm.afterEnter,"before-leave":_vm.beforeLeave}},[(_vm.isActive)?_c('div',{directives:[{name:"trap-focus",rawName:"v-trap-focus",value:(_vm.trapFocus),expression:"trapFocus"}],staticClass:"modal is-active",class:[{'is-full-screen': _vm.fullScreen}, _vm.customClass],attrs:{"role":_vm.ariaRole,"aria-modal":_vm.ariaModal}},[_c('div',{staticClass:"modal-background",on:{"click":function($event){_vm.cancel('outside');}}}),_vm._v(" "),_c('div',{staticClass:"animation-content",class:{ 'modal-content': !_vm.hasModalCard },style:(_vm.customStyle)},[(_vm.component)?_c(_vm.component,_vm._g(_vm._b({tag:"component",on:{"close":_vm.close}},'component',_vm.props,false),_vm.events)):(_vm.content)?_c('div',{domProps:{"innerHTML":_vm._s(_vm.content)}}):_vm._t("default"),_vm._v(" "),(_vm.showX && !_vm.animating)?_c('button',{staticClass:"modal-close is-large",attrs:{"type":"button"},on:{"click":function($event){_vm.cancel('x');}}}):_vm._e()],2)]):_vm._e()])};
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
      

      
      var Modal = normalizeComponent_1(
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
    var registerComponentProgrammatic = function registerComponentProgrammatic(Vue, property, component) {
      if (!Vue.prototype.$buefy) Vue.prototype.$buefy = {};
      Vue.prototype.$buefy[property] = component;
    };

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
        registerComponent(Vue, Modal);
        registerComponentProgrammatic(Vue, 'modal', ModalProgrammatic);
      }
    };
    use(Plugin);

    exports.ModalProgrammatic = ModalProgrammatic;
    exports.default = Plugin;

    Object.defineProperty(exports, '__esModule', { value: true });

}));
