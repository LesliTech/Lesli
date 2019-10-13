/*! Buefy v0.8.2 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (global = global || self, factory(global.Menu = {}));
}(this, function (exports) { 'use strict';

    //
    //
    //
    //
    //
    //
    var script = {
      name: 'BMenu'
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
    var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"menu"},[_vm._t("default")],2)};
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
      

      
      var Menu = normalizeComponent_1(
        { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
        __vue_inject_styles__,
        __vue_script__,
        __vue_scope_id__,
        __vue_is_functional_template__,
        __vue_module_identifier__,
        undefined,
        undefined
      );

    var script$1 = {
      name: 'BMenuList',
      functional: true,
      props: {
        label: String,
        icon: String,
        iconPack: String
      },
      render: function render(createElement, context) {
        var vlabel = null;
        var slots = context.slots();

        if (context.props.label || slots.label) {
          vlabel = createElement('p', {
            attrs: {
              'class': 'menu-label'
            }
          }, context.props.label ? context.props.icon ? [createElement('b-icon', {
            props: {
              'icon': context.props.icon,
              'pack': context.props.iconPack,
              'size': 'is-small'
            }
          }), createElement('span', {}, context.props.label)] : context.props.label : slots.label);
        }

        var vnode = createElement('ul', {
          attrs: {
            'class': 'menu-list'
          }
        }, slots.default);
        return vlabel ? [vlabel, vnode] : vnode;
      }
    };

    /* script */
    const __vue_script__$1 = script$1;

    /* template */

      /* style */
      const __vue_inject_styles__$1 = undefined;
      /* scoped */
      const __vue_scope_id__$1 = undefined;
      /* module identifier */
      const __vue_module_identifier__$1 = undefined;
      /* functional template */
      const __vue_is_functional_template__$1 = undefined;
      /* style inject */
      
      /* style inject SSR */
      

      
      var MenuList = normalizeComponent_1(
        {},
        __vue_inject_styles__$1,
        __vue_script__$1,
        __vue_scope_id__$1,
        __vue_is_functional_template__$1,
        __vue_module_identifier__$1,
        undefined,
        undefined
      );

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
    var script$2 = {
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

    /* script */
    const __vue_script__$2 = script$2;

    /* template */
    var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{staticClass:"icon",class:[_vm.newType, _vm.size]},[(!_vm.useIconComponent)?_c('i',{class:[_vm.newPack, _vm.newIcon, _vm.newCustomSize, _vm.customClass]}):_c(_vm.useIconComponent,{tag:"component",class:[_vm.customClass],attrs:{"icon":[_vm.newPack, _vm.newIcon],"size":_vm.newCustomSize}})],1)};
    var __vue_staticRenderFns__$1 = [];

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
      

      
      var Icon = normalizeComponent_1(
        { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
        __vue_inject_styles__$2,
        __vue_script__$2,
        __vue_scope_id__$2,
        __vue_is_functional_template__$2,
        __vue_module_identifier__$2,
        undefined,
        undefined
      );

    var script$3 = {
      name: 'BMenuItem',
      components: _defineProperty({}, Icon.name, Icon),
      inheritAttrs: false,
      props: {
        label: String,
        active: Boolean,
        expanded: Boolean,
        disabled: Boolean,
        iconPack: String,
        icon: String,
        animation: {
          type: String,
          default: 'fade'
        },
        tag: {
          type: String,
          default: 'a',
          validator: function validator(value) {
            return ['a', 'router-link', 'nuxt-link', 'n-link', 'NuxtLink', 'NLink'].indexOf(value) >= 0;
          }
        }
      },
      data: function data() {
        return {
          newActive: this.active,
          newExpanded: this.expanded
        };
      },
      watch: {
        active: function active(value) {
          this.newActive = value;
        },
        expanded: function expanded(value) {
          this.newExpanded = value;
        }
      },
      methods: {
        onClick: function onClick(event) {
          if (this.disabled) return;
          this.reset(this.$parent);
          this.newExpanded = true;
          this.$emit('update:expanded', this.newActive);
          this.newActive = true;
          this.$emit('update:active', this.newActive);
          this.$emit('click', event);
        },
        reset: function reset(parent) {
          var _this = this;

          var items = parent.$children.filter(function (c) {
            return c.name === _this.name;
          });
          items.forEach(function (item) {
            if (item !== _this) {
              _this.reset(item);

              item.newExpanded = false;
              item.$emit('update:expanded', item.newActive);
              item.newActive = false;
              item.$emit('update:active', item.newActive);
            }
          });
        }
      }
    };

    /* script */
    const __vue_script__$3 = script$3;

    /* template */
    var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('li',[_c(_vm.tag,_vm._b({tag:"component",class:{
                'is-active': _vm.newActive,
                'is-disabled': _vm.disabled
            },on:{"click":function($event){_vm.onClick($event);}}},'component',_vm.$attrs,false),[(_vm.icon)?_c('b-icon',{attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":"is-small"}}):_vm._e(),_vm._v(" "),(_vm.label)?_c('span',[_vm._v(_vm._s(_vm.label))]):_vm._t("label",null,{expanded:_vm.newExpanded,active:_vm.newActive})],2),_vm._v(" "),(_vm.$slots.default)?[_c('transition',{attrs:{"name":_vm.animation}},[_c('ul',{directives:[{name:"show",rawName:"v-show",value:(_vm.newExpanded),expression:"newExpanded"}]},[_vm._t("default")],2)])]:_vm._e()],2)};
    var __vue_staticRenderFns__$2 = [];

      /* style */
      const __vue_inject_styles__$3 = undefined;
      /* scoped */
      const __vue_scope_id__$3 = undefined;
      /* module identifier */
      const __vue_module_identifier__$3 = undefined;
      /* functional template */
      const __vue_is_functional_template__$3 = false;
      /* style inject */
      
      /* style inject SSR */
      

      
      var MenuItem = normalizeComponent_1(
        { render: __vue_render__$2, staticRenderFns: __vue_staticRenderFns__$2 },
        __vue_inject_styles__$3,
        __vue_script__$3,
        __vue_scope_id__$3,
        __vue_is_functional_template__$3,
        __vue_module_identifier__$3,
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
        registerComponent(Vue, Menu);
        registerComponent(Vue, MenuList);
        registerComponent(Vue, MenuItem);
      }
    };
    use(Plugin);

    exports.Menu = Menu;
    exports.MenuItem = MenuItem;
    exports.MenuList = MenuList;
    exports.default = Plugin;

    Object.defineProperty(exports, '__esModule', { value: true });

}));
