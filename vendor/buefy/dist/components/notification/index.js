/*! Buefy v0.8.2 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports, require('vue')) :
  typeof define === 'function' && define.amd ? define(['exports', 'vue'], factory) :
  (global = global || self, factory(global.Notification = {}, global.Vue));
}(this, function (exports, Vue) { 'use strict';

  Vue = Vue && Vue.hasOwnProperty('default') ? Vue['default'] : Vue;

  function _defineProperty(obj, key, value) {
    if (key in obj) {
      Object.defineProperty(obj, key, {
        value: value,
        enumerable: true,
        configurable: true,
        writable: true
      });
    } else {
      obj[key] = value;
    }

    return obj;
  }

  var config = {
    defaultContainerElement: null,
    defaultIconPack: 'mdi',
    defaultIconComponent: null,
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
    defaultDatepickerShowWeekNumber: false
  };
  var config$1 = config;

  //
  var script = {
    name: 'BIcon',
    props: {
      type: [String, Object],
      pack: String,
      icon: String,
      size: String,
      customSize: String,
      customClass: String,
      both: Boolean // This is used internally to show both MDI and FA icon

    },
    computed: {
      /**
      * Internal icon name based on the pack.
      * If pack is 'fa', gets the equivalent FA icon name of the MDI,
      * internal icons are always MDI.
      */
      newIcon: function newIcon() {
        return this.newPack === 'mdi' ? "".concat(this.newPack, "-").concat(this.icon) : this.addFAPrefix(this.getEquivalentIconOf(this.icon));
      },
      newPack: function newPack() {
        return this.pack || config$1.defaultIconPack;
      },
      newType: function newType() {
        if (!this.type) return;
        var splitType = [];

        if (typeof this.type === 'string') {
          splitType = this.type.split('-');
        } else {
          for (var key in this.type) {
            if (this.type[key]) {
              splitType = key.split('-');
              break;
            }
          }
        }

        if (splitType.length <= 1) return;
        return "has-text-".concat(splitType[1]);
      },
      newCustomSize: function newCustomSize() {
        return this.customSize || this.customSizeByPack;
      },
      customSizeByPack: function customSizeByPack() {
        var defaultSize = this.newPack === 'mdi' ? 'mdi-24px' : this.addFAPrefix('lg');
        var mediumSize = this.newPack === 'mdi' ? 'mdi-36px' : this.addFAPrefix('2x');
        var largeSize = this.newPack === 'mdi' ? 'mdi-48px' : this.addFAPrefix('3x');

        switch (this.size) {
          case 'is-small':
            return;

          case 'is-medium':
            return mediumSize;

          case 'is-large':
            return largeSize;

          default:
            return defaultSize;
        }
      },
      useIconComponent: function useIconComponent() {
        return config$1.defaultIconComponent;
      }
    },
    methods: {
      addFAPrefix: function addFAPrefix(value) {
        if (this.useIconComponent) {
          return value;
        }

        return "fa-".concat(value);
      },

      /**
      * Equivalent FA icon name of the MDI.
      */
      getEquivalentIconOf: function getEquivalentIconOf(value) {
        // Only transform the class if the both prop is set to true
        if (!this.both) {
          return value;
        }

        switch (value) {
          case 'check':
            return 'check';

          case 'information':
            return 'info-circle';

          case 'check-circle':
            return 'check-circle';

          case 'alert':
            return 'exclamation-triangle';

          case 'alert-circle':
            return 'exclamation-circle';

          case 'arrow-up':
            return 'arrow-up';

          case 'chevron-right':
            return 'angle-right';

          case 'chevron-left':
            return 'angle-left';

          case 'chevron-down':
            return 'angle-down';

          case 'eye':
            return 'eye';

          case 'eye-off':
            return 'eye-slash';

          case 'menu-down':
            return 'caret-down';

          case 'menu-up':
            return 'caret-up';

          default:
            return value;
        }
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
  var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{staticClass:"icon",class:[_vm.newType, _vm.size]},[(!_vm.useIconComponent)?_c('i',{class:[_vm.newPack, _vm.newIcon, _vm.newCustomSize, _vm.customClass]}):_c(_vm.useIconComponent,{tag:"component",class:[_vm.customClass],attrs:{"icon":[_vm.newPack, _vm.newIcon],"size":_vm.newCustomSize}})],1)};
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
    

    
    var Icon = normalizeComponent_1(
      { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
      __vue_inject_styles__,
      __vue_script__,
      __vue_scope_id__,
      __vue_is_functional_template__,
      __vue_module_identifier__,
      undefined,
      undefined
    );

  var MessageMixin = {
    components: _defineProperty({}, Icon.name, Icon),
    props: {
      active: {
        type: Boolean,
        default: true
      },
      title: String,
      closable: {
        type: Boolean,
        default: true
      },
      message: String,
      type: String,
      hasIcon: Boolean,
      size: String,
      iconPack: String,
      iconSize: String,
      autoClose: {
        type: Boolean,
        default: false
      },
      duration: {
        type: Number,
        default: 2000
      }
    },
    data: function data() {
      return {
        isActive: this.active
      };
    },
    watch: {
      active: function active(value) {
        this.isActive = value;
      },
      isActive: function isActive(value) {
        if (value) {
          this.setAutoClose();
        } else {
          if (this.timer) {
            clearTimeout(this.timer);
          }
        }
      }
    },
    computed: {
      /**
       * Icon name (MDI) based on type.
       */
      icon: function icon() {
        switch (this.type) {
          case 'is-info':
            return 'information';

          case 'is-success':
            return 'check-circle';

          case 'is-warning':
            return 'alert';

          case 'is-danger':
            return 'alert-circle';

          default:
            return null;
        }
      }
    },
    methods: {
      /**
       * Close the Message and emit events.
       */
      close: function close() {
        this.isActive = false;
        this.$emit('close');
        this.$emit('update:active', false);
      },

      /**
       * Set timer to auto close message
       */
      setAutoClose: function setAutoClose() {
        var _this = this;

        if (this.autoClose) {
          this.timer = setTimeout(function () {
            if (_this.isActive) {
              _this.close();
            }
          }, this.duration);
        }
      }
    },
    mounted: function mounted() {
      this.setAutoClose();
    }
  };

  //
  var script$1 = {
    name: 'BNotification',
    mixins: [MessageMixin],
    props: {
      position: String,
      ariaCloseLabel: String
    }
  };

  /* script */
  const __vue_script__$1 = script$1;

  /* template */
  var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":"fade"}},[_c('article',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"notification",class:[_vm.type, _vm.position]},[(_vm.closable)?_c('button',{staticClass:"delete",attrs:{"type":"button","aria-label":_vm.ariaCloseLabel},on:{"click":_vm.close}}):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media"},[(_vm.icon && _vm.hasIcon)?_c('div',{staticClass:"media-left"},[_c('b-icon',{attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"both":"","size":"is-large","aria-hidden":""}})],1):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media-content"},[(_vm.message)?_c('p',{staticClass:"text",domProps:{"innerHTML":_vm._s(_vm.message)}}):_vm._t("default")],2)])])])};
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
    

    
    var Notification = normalizeComponent_1(
      { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
      __vue_inject_styles__$1,
      __vue_script__$1,
      __vue_scope_id__$1,
      __vue_is_functional_template__$1,
      __vue_module_identifier__$1,
      undefined,
      undefined
    );

  /**
   * Get value of an object property/path even if it's nested
   */
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
        this.parentTop = document.querySelector('.notices.is-top');
        this.parentBottom = document.querySelector('.notices.is-bottom');
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
  var script$2 = {
    name: 'BNotificationNotice',
    mixins: [NoticeMixin],
    props: {
      indefinite: {
        type: Boolean,
        default: false
      }
    },
    data: function data() {
      return {
        newDuration: this.duration || config$1.defaultNotificationDuration
      };
    }
  };

  /* script */
  const __vue_script__$2 = script$2;

  /* template */
  var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('b-notification',_vm._b({on:{"close":_vm.close}},'b-notification',_vm.$options.propsData,false))};
  var __vue_staticRenderFns__$2 = [];

    /* style */
    const __vue_inject_styles__$2 = undefined;
    /* scoped */
    const __vue_scope_id__$2 = undefined;
    /* module identifier */
    const __vue_module_identifier__$2 = undefined;
    /* functional template */
    const __vue_is_functional_template__$2 = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var NotificationNotice = normalizeComponent_1(
      { render: __vue_render__$2, staticRenderFns: __vue_staticRenderFns__$2 },
      __vue_inject_styles__$2,
      __vue_script__$2,
      __vue_scope_id__$2,
      __vue_is_functional_template__$2,
      __vue_module_identifier__$2,
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

  var NotificationProgrammatic = {
    open: function open(params) {
      var message;
      var parent;
      if (typeof params === 'string') message = params;
      var defaultParam = {
        message: message,
        position: config$1.defaultNotificationPosition || 'is-top-right'
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
      registerComponent(Vue, Notification);
      registerComponentProgrammatic(Vue, 'notification', NotificationProgrammatic);
    }
  };
  use(Plugin);

  exports.Notification = Notification;
  exports.NotificationProgrammatic = NotificationProgrammatic;
  exports.default = Plugin;

  Object.defineProperty(exports, '__esModule', { value: true });

}));
