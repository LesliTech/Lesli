/*! Buefy v0.8.6 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = global || self, factory(global.Steps = {}));
}(this, function (exports) { 'use strict';

  function _typeof(obj) {
    if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
      _typeof = function (obj) {
        return typeof obj;
      };
    } else {
      _typeof = function (obj) {
        return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
      };
    }

    return _typeof(obj);
  }

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

  function ownKeys(object, enumerableOnly) {
    var keys = Object.keys(object);

    if (Object.getOwnPropertySymbols) {
      keys.push.apply(keys, Object.getOwnPropertySymbols(object));
    }

    if (enumerableOnly) keys = keys.filter(function (sym) {
      return Object.getOwnPropertyDescriptor(object, sym).enumerable;
    });
    return keys;
  }

  function _objectSpread2(target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i] != null ? arguments[i] : {};

      if (i % 2) {
        ownKeys(source, true).forEach(function (key) {
          _defineProperty(target, key, source[key]);
        });
      } else if (Object.getOwnPropertyDescriptors) {
        Object.defineProperties(target, Object.getOwnPropertyDescriptors(source));
      } else {
        ownKeys(source).forEach(function (key) {
          Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key));
        });
      }
    }

    return target;
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

  /**
  * Merge function to replace Object.assign with deep merging possibility
  */

  var isObject = function isObject(item) {
    return _typeof(item) === 'object' && !Array.isArray(item);
  };

  var mergeFn = function mergeFn(target, source) {
    var isDeep = function isDeep(prop) {
      return isObject(source[prop]) && target.hasOwnProperty(prop) && isObject(target[prop]);
    };

    var replaced = Object.getOwnPropertyNames(source).map(function (prop) {
      return _defineProperty({}, prop, isDeep(prop) ? mergeFn(target[prop], source[prop]) : source[prop]);
    }).reduce(function (a, b) {
      return _objectSpread2({}, a, {}, b);
    }, {});
    return _objectSpread2({}, target, {}, replaced);
  };

  var merge = mergeFn;

  var mdiIcons = {
    sizes: {
      'default': 'mdi-24px',
      'is-small': null,
      'is-medium': 'mdi-36px',
      'is-large': 'mdi-48px'
    },
    iconPrefix: 'mdi-'
  };

  var faIcons = function faIcons() {
    var faIconPrefix = config$1 && config$1.defaultIconComponent ? '' : 'fa-';
    return {
      sizes: {
        'default': faIconPrefix + 'lg',
        'is-small': null,
        'is-medium': faIconPrefix + '2x',
        'is-large': faIconPrefix + '3x'
      },
      iconPrefix: faIconPrefix,
      internalIcons: {
        'information': 'info-circle',
        'alert': 'exclamation-triangle',
        'alert-circle': 'exclamation-circle',
        'chevron-right': 'angle-right',
        'chevron-left': 'angle-left',
        'chevron-down': 'angle-down',
        'eye-off': 'eye-slash',
        'menu-down': 'caret-down',
        'menu-up': 'caret-up'
      }
    };
  };

  var getIcons = function getIcons() {
    var icons = {
      mdi: mdiIcons,
      fa: faIcons(),
      fas: faIcons(),
      far: faIcons(),
      fad: faIcons(),
      fab: faIcons(),
      fal: faIcons()
    };

    if (config$1 && config$1.customIconPacks) {
      icons = merge(icons, config$1.customIconPacks);
    }

    return icons;
  };

  //
  var script = {
    name: 'BIcon',
    props: {
      type: [String, Object],
      component: String,
      pack: String,
      icon: String,
      size: String,
      customSize: String,
      customClass: String,
      both: Boolean // This is used internally to show both MDI and FA icon

    },
    computed: {
      iconConfig: function iconConfig() {
        var allIcons = getIcons();
        return allIcons[this.newPack];
      },
      iconPrefix: function iconPrefix() {
        if (this.iconConfig && this.iconConfig.iconPrefix) {
          return this.iconConfig.iconPrefix;
        }

        return '';
      },

      /**
      * Internal icon name based on the pack.
      * If pack is 'fa', gets the equivalent FA icon name of the MDI,
      * internal icons are always MDI.
      */
      newIcon: function newIcon() {
        return "".concat(this.iconPrefix).concat(this.getEquivalentIconOf(this.icon));
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
        if (this.iconConfig && this.iconConfig.sizes) {
          if (this.size && this.iconConfig.sizes[this.size] !== undefined) {
            return this.iconConfig.sizes[this.size];
          } else if (this.iconConfig.sizes.default) {
            return this.iconConfig.sizes.default;
          }
        }

        return null;
      },
      useIconComponent: function useIconComponent() {
        return this.component || config$1.defaultIconComponent;
      }
    },
    methods: {
      /**
      * Equivalent icon name of the MDI.
      */
      getEquivalentIconOf: function getEquivalentIconOf(value) {
        // Only transform the class if the both prop is set to true
        if (!this.both) {
          return value;
        }

        if (this.iconConfig && this.iconConfig.internalIcons && this.iconConfig.internalIcons[value]) {
          return this.iconConfig.internalIcons[value];
        }

        return value;
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

  var SlotComponent = {
    name: 'BSlotComponent',
    props: {
      component: {
        type: Object,
        required: true
      },
      name: {
        type: String,
        default: 'default'
      },
      scoped: {
        type: Boolean
      },
      props: {
        type: Object
      },
      tag: {
        type: String,
        default: 'div'
      },
      event: {
        type: String,
        default: 'hook:updated'
      }
    },
    methods: {
      refresh: function refresh() {
        this.$forceUpdate();
      },
      isVueComponent: function isVueComponent() {
        return this.component && this.component._isVue;
      }
    },
    created: function created() {
      if (this.isVueComponent()) {
        this.component.$on(this.event, this.refresh);
      }
    },
    beforeDestroy: function beforeDestroy() {
      if (this.isVueComponent()) {
        this.component.$off(this.event, this.refresh);
      }
    },
    render: function render(createElement) {
      if (this.isVueComponent()) {
        return createElement(this.tag, {}, this.scoped ? this.component.$scopedSlots[this.name](this.props) : this.component.$slots[this.name]);
      }
    }
  };

  var _components;
  var script$1 = {
    name: 'BSteps',
    components: (_components = {}, _defineProperty(_components, Icon.name, Icon), _defineProperty(_components, SlotComponent.name, SlotComponent), _components),
    props: {
      value: Number,
      type: [String, Object],
      size: String,
      animated: {
        type: Boolean,
        default: true
      },
      destroyOnHide: {
        type: Boolean,
        default: false
      },
      iconPack: String,
      iconPrev: {
        type: String,
        default: config$1.defaultIconPrev
      },
      iconNext: {
        type: String,
        default: config$1.defaultIconNext
      },
      hasNavigation: {
        type: Boolean,
        default: true
      },
      ariaNextLabel: String,
      ariaPreviousLabel: String
    },
    data: function data() {
      return {
        activeStep: this.value || 0,
        stepItems: [],
        contentHeight: 0,
        isTransitioning: false,
        _isSteps: true // Used internally by StepItem

      };
    },
    computed: {
      mainClasses: function mainClasses() {
        return [this.type, this.size];
      },
      reversedStepItems: function reversedStepItems() {
        return this.stepItems.slice().reverse();
      },

      /**
       * Check the first visible step index.
       */
      firstVisibleStepIndex: function firstVisibleStepIndex() {
        return this.stepItems.map(function (step, idx) {
          return step.visible;
        }).indexOf(true);
      },

      /**
       * Check if previous button is available.
       */
      hasPrev: function hasPrev() {
        return this.firstVisibleStepIndex >= 0 && this.activeStep > this.firstVisibleStepIndex;
      },

      /**
       * Check the last visible step index.
       */
      lastVisibleStepIndex: function lastVisibleStepIndex() {
        var idx = this.reversedStepItems.map(function (step, idx) {
          return step.visible;
        }).indexOf(true);

        if (idx >= 0) {
          return this.stepItems.length - 1 - idx;
        }

        return idx;
      },

      /**
       * Check if next button is available.
       */
      hasNext: function hasNext() {
        return this.lastVisibleStepIndex >= 0 && this.activeStep < this.lastVisibleStepIndex;
      },
      navigationProps: function navigationProps() {
        return {
          previous: {
            disabled: !this.hasPrev,
            action: this.prev
          },
          next: {
            disabled: !this.hasNext,
            action: this.next
          }
        };
      }
    },
    watch: {
      /**
      * When v-model is changed set the new active step.
      */
      value: function value(_value) {
        this.changeStep(_value);
      },

      /**
      * When step-items are updated, set active one.
      */
      stepItems: function stepItems() {
        if (this.activeStep < this.stepItems.length) {
          this.stepItems[this.activeStep].isActive = true;
        }
      }
    },
    methods: {
      /**
      * Change the active step and emit change event.
      */
      changeStep: function changeStep(newIndex) {
        if (this.activeStep === newIndex) return;

        if (this.activeStep < this.stepItems.length) {
          this.stepItems[this.activeStep].deactivate(this.activeStep, newIndex);
        }

        this.stepItems[newIndex].activate(this.activeStep, newIndex);
        this.activeStep = newIndex;
        this.$emit('change', newIndex);
      },

      /**
          * Return if the step should be clickable or not.
          */
      isItemClickable: function isItemClickable(stepItem, index) {
        if (stepItem.clickable === undefined) {
          return this.activeStep > index;
        }

        return stepItem.clickable;
      },

      /**
      * Step click listener, emit input event and change active step.
      */
      stepClick: function stepClick(value) {
        this.$emit('input', value);
        this.changeStep(value);
      },

      /**
       * Previous button click listener.
       */
      prev: function prev() {
        var _this = this;

        if (!this.hasPrev) return;
        var prevItemIdx = this.reversedStepItems.map(function (step, idx) {
          return _this.stepItems.length - 1 - idx < _this.activeStep && step.visible;
        }).indexOf(true);

        if (prevItemIdx >= 0) {
          prevItemIdx = this.stepItems.length - 1 - prevItemIdx;
        }

        this.$emit('input', prevItemIdx);
        this.changeStep(prevItemIdx);
      },

      /**
       * Previous button click listener.
       */
      next: function next() {
        var _this2 = this;

        if (!this.hasNext) return;
        var nextItemIdx = this.stepItems.map(function (step, idx) {
          return idx > _this2.activeStep && step.visible;
        }).indexOf(true);
        this.$emit('input', nextItemIdx);
        this.changeStep(nextItemIdx);
      }
    },
    mounted: function mounted() {
      if (this.activeStep < this.stepItems.length) {
        this.stepItems[this.activeStep].isActive = true;
      }
    }
  };

  /* script */
  const __vue_script__$1 = script$1;

  /* template */
  var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-steps"},[_c('nav',{staticClass:"steps",class:_vm.mainClasses},[_c('ul',{staticClass:"step-items"},_vm._l((_vm.stepItems),function(stepItem,index){return _c('li',{directives:[{name:"show",rawName:"v-show",value:(stepItem.visible),expression:"stepItem.visible"}],key:index,staticClass:"step-item",class:[stepItem.type || _vm.type, {
                      'is-active': _vm.activeStep === index,
                      'is-previous': _vm.activeStep > index
              }]},[_c('a',{staticClass:"step-link",class:{'is-clickable': _vm.isItemClickable(stepItem, index)},on:{"click":function($event){_vm.isItemClickable(stepItem, index) && _vm.stepClick(index);}}},[_c('div',{staticClass:"step-marker"},[(stepItem.icon)?_c('b-icon',{attrs:{"icon":stepItem.icon,"pack":stepItem.iconPack,"size":_vm.size}}):_vm._e()],1),_vm._v(" "),_c('div',{staticClass:"step-details"},[_c('span',{staticClass:"step-title"},[_vm._v(_vm._s(stepItem.label))])])])])}))]),_vm._v(" "),_c('section',{staticClass:"step-content",class:{'is-transitioning': _vm.isTransitioning}},[_vm._t("default")],2),_vm._v(" "),_vm._t("navigation",[(_vm.hasNavigation)?_c('nav',{staticClass:"step-navigation"},[_c('a',{staticClass:"pagination-previous",attrs:{"role":"button","disabled":_vm.navigationProps.previous.disabled,"aria-label":_vm.ariaPreviousLabel},on:{"click":function($event){$event.preventDefault();_vm.navigationProps.previous.action($event);}}},[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),_c('a',{staticClass:"pagination-next",attrs:{"role":"button","disabled":_vm.navigationProps.next.disabled,"aria-label":_vm.ariaNextLabel},on:{"click":function($event){$event.preventDefault();_vm.navigationProps.next.action($event);}}},[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1)]):_vm._e()],{previous:_vm.navigationProps.previous,next:_vm.navigationProps.next})],2)};
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
    

    
    var Steps = normalizeComponent_1(
      { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
      __vue_inject_styles__$1,
      __vue_script__$1,
      __vue_scope_id__$1,
      __vue_is_functional_template__$1,
      __vue_module_identifier__$1,
      undefined,
      undefined
    );

  var script$2 = {
    name: 'BStepItem',
    props: {
      label: String,
      type: String | Object,
      icon: String,
      iconPack: String,
      clickable: {
        type: Boolean,
        default: undefined
      },
      visible: {
        type: Boolean,
        default: true
      }
    },
    data: function data() {
      return {
        isActive: false,
        transitionName: null
      };
    },
    methods: {
      /**
      * Activate step, alter animation name based on the index.
      */
      activate: function activate(oldIndex, index) {
        this.transitionName = index < oldIndex ? 'slide-next' : 'slide-prev';
        this.isActive = true;
      },

      /**
      * Deactivate step, alter animation name based on the index.
      */
      deactivate: function deactivate(oldIndex, index) {
        this.transitionName = index < oldIndex ? 'slide-next' : 'slide-prev';
        this.isActive = false;
      }
    },
    created: function created() {
      if (!this.$parent.$data._isSteps) {
        this.$destroy();
        throw new Error('You should wrap bStepItem on a bSteps');
      }

      this.$parent.stepItems.push(this);
    },
    beforeDestroy: function beforeDestroy() {
      var index = this.$parent.stepItems.indexOf(this);

      if (index >= 0) {
        this.$parent.stepItems.splice(index, 1);
      }
    },
    render: function render(createElement) {
      var _this = this;

      // if destroy apply v-if
      if (this.$parent.destroyOnHide) {
        if (!this.isActive || !this.visible) {
          return;
        }
      }

      var vnode = createElement('div', {
        directives: [{
          name: 'show',
          value: this.isActive && this.visible
        }],
        attrs: {
          'class': 'step-item'
        }
      }, this.$slots.default); // check animated prop

      if (this.$parent.animated) {
        return createElement('transition', {
          props: {
            'name': this.transitionName
          },
          on: {
            'before-enter': function beforeEnter() {
              _this.$parent.isTransitioning = true;
            },
            'after-enter': function afterEnter() {
              _this.$parent.isTransitioning = false;
            }
          }
        }, [vnode]);
      }

      return vnode;
    }
  };

  /* script */
  const __vue_script__$2 = script$2;

  /* template */

    /* style */
    const __vue_inject_styles__$2 = undefined;
    /* scoped */
    const __vue_scope_id__$2 = undefined;
    /* module identifier */
    const __vue_module_identifier__$2 = undefined;
    /* functional template */
    const __vue_is_functional_template__$2 = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var StepItem = normalizeComponent_1(
      {},
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

  var Plugin = {
    install: function install(Vue) {
      registerComponent(Vue, Steps);
      registerComponent(Vue, StepItem);
    }
  };
  use(Plugin);

  exports.default = Plugin;

  Object.defineProperty(exports, '__esModule', { value: true });

}));
