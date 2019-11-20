/*! Buefy v0.8.6 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (global = global || self, factory(global.Dropdown = {}));
}(this, function (exports) { 'use strict';

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
    var DEFAULT_CLOSE_OPTIONS = ['escape', 'outside'];
    var script = {
      name: 'BDropdown',
      directives: {
        trapFocus: directive
      },
      props: {
        value: {
          type: [String, Number, Boolean, Object, Array, Function],
          default: null
        },
        disabled: Boolean,
        hoverable: Boolean,
        inline: Boolean,
        position: {
          type: String,
          validator: function validator(value) {
            return ['is-top-right', 'is-top-left', 'is-bottom-left'].indexOf(value) > -1;
          }
        },
        mobileModal: {
          type: Boolean,
          default: function _default() {
            return config$1.defaultDropdownMobileModal;
          }
        },
        ariaRole: {
          type: String,
          default: ''
        },
        animation: {
          type: String,
          default: 'fade'
        },
        multiple: Boolean,
        trapFocus: {
          type: Boolean,
          default: config$1.defaultTrapFocus
        },
        closeOnClick: {
          type: Boolean,
          default: true
        },
        canClose: {
          type: [Array, Boolean],
          default: true
        },
        expanded: Boolean
      },
      data: function data() {
        return {
          selected: this.value,
          isActive: false,
          isHoverable: this.hoverable,
          _isDropdown: true // Used internally by DropdownItem

        };
      },
      computed: {
        rootClasses: function rootClasses() {
          return [this.position, {
            'is-disabled': this.disabled,
            'is-hoverable': this.hoverable,
            'is-inline': this.inline,
            'is-active': this.isActive || this.inline,
            'is-mobile-modal': this.isMobileModal,
            'is-expanded': this.expanded
          }];
        },
        isMobileModal: function isMobileModal() {
          return this.mobileModal && !this.inline && !this.hoverable;
        },
        cancelOptions: function cancelOptions() {
          return typeof this.canClose === 'boolean' ? this.canClose ? DEFAULT_CLOSE_OPTIONS : [] : this.canClose;
        },
        ariaRoleMenu: function ariaRoleMenu() {
          return this.ariaRole === 'menu' || this.ariaRole === 'list' ? this.ariaRole : null;
        }
      },
      watch: {
        /**
        * When v-model is changed set the new selected item.
        */
        value: function value(_value) {
          this.selected = _value;
        },

        /**
        * Emit event when isActive value is changed.
        */
        isActive: function isActive(value) {
          this.$emit('active-change', value);
        }
      },
      methods: {
        /**
        * Click listener from DropdownItem.
        *   1. Set new selected item.
        *   2. Emit input event to update the user v-model.
        *   3. Close the dropdown.
        */
        selectItem: function selectItem(value) {
          var _this = this;

          if (this.multiple) {
            if (this.selected) {
              var index = this.selected.indexOf(value);

              if (index === -1) {
                this.selected.push(value);
              } else {
                this.selected.splice(index, 1);
              }
            } else {
              this.selected = [value];
            }

            this.$emit('change', this.selected);
          } else {
            if (this.selected !== value) {
              this.selected = value;
              this.$emit('change', this.selected);
            }
          }

          this.$emit('input', this.selected);

          if (!this.multiple) {
            this.isActive = !this.closeOnClick;

            if (this.hoverable && this.closeOnClick) {
              this.isHoverable = false; // Timeout for the animation complete before destroying

              setTimeout(function () {
                _this.isHoverable = true;
              }, 250);
            }
          }
        },

        /**
        * White-listed items to not close when clicked.
        */
        isInWhiteList: function isInWhiteList(el) {
          if (el === this.$refs.dropdownMenu) return true;
          if (el === this.$refs.trigger) return true; // All chidren from dropdown

          if (this.$refs.dropdownMenu !== undefined) {
            var children = this.$refs.dropdownMenu.querySelectorAll('*');
            var _iteratorNormalCompletion = true;
            var _didIteratorError = false;
            var _iteratorError = undefined;

            try {
              for (var _iterator = children[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
                var child = _step.value;

                if (el === child) {
                  return true;
                }
              }
            } catch (err) {
              _didIteratorError = true;
              _iteratorError = err;
            } finally {
              try {
                if (!_iteratorNormalCompletion && _iterator.return != null) {
                  _iterator.return();
                }
              } finally {
                if (_didIteratorError) {
                  throw _iteratorError;
                }
              }
            }
          } // All children from trigger


          if (this.$refs.trigger !== undefined) {
            var _children = this.$refs.trigger.querySelectorAll('*');

            var _iteratorNormalCompletion2 = true;
            var _didIteratorError2 = false;
            var _iteratorError2 = undefined;

            try {
              for (var _iterator2 = _children[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
                var _child = _step2.value;

                if (el === _child) {
                  return true;
                }
              }
            } catch (err) {
              _didIteratorError2 = true;
              _iteratorError2 = err;
            } finally {
              try {
                if (!_iteratorNormalCompletion2 && _iterator2.return != null) {
                  _iterator2.return();
                }
              } finally {
                if (_didIteratorError2) {
                  throw _iteratorError2;
                }
              }
            }
          }

          return false;
        },

        /**
        * Close dropdown if clicked outside.
        */
        clickedOutside: function clickedOutside(event) {
          if (this.cancelOptions.indexOf('outside') < 0) return;
          if (this.inline) return;
          if (!this.isInWhiteList(event.target)) this.isActive = false;
        },

        /**
         * Keypress event that is bound to the document
         */
        keyPress: function keyPress(event) {
          // Esc key
          if (this.isActive && event.keyCode === 27) {
            if (this.cancelOptions.indexOf('escape') < 0) return;
            this.isActive = false;
          }
        },

        /**
        * Toggle dropdown if it's not disabled.
        */
        toggle: function toggle() {
          var _this2 = this;

          if (this.disabled) return;

          if (!this.isActive) {
            // if not active, toggle after clickOutside event
            // this fixes toggling programmatic
            this.$nextTick(function () {
              var value = !_this2.isActive;
              _this2.isActive = value; // Vue 2.6.x ???

              setTimeout(function () {
                return _this2.isActive = value;
              });
            });
          } else {
            this.isActive = !this.isActive;
          }
        }
      },
      created: function created() {
        if (typeof window !== 'undefined') {
          document.addEventListener('click', this.clickedOutside);
          document.addEventListener('keyup', this.keyPress);
        }
      },
      beforeDestroy: function beforeDestroy() {
        if (typeof window !== 'undefined') {
          document.removeEventListener('click', this.clickedOutside);
          document.removeEventListener('keyup', this.keyPress);
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
    var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"dropdown",class:_vm.rootClasses},[(!_vm.inline)?_c('div',{ref:"trigger",staticClass:"dropdown-trigger",attrs:{"role":"button","aria-haspopup":"true"},on:{"click":_vm.toggle}},[_vm._t("trigger")],2):_vm._e(),_vm._v(" "),_c('transition',{attrs:{"name":_vm.animation}},[(_vm.isMobileModal)?_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"background",attrs:{"aria-hidden":!_vm.isActive}}):_vm._e()]),_vm._v(" "),_c('transition',{attrs:{"name":_vm.animation}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:((!_vm.disabled && (_vm.isActive || _vm.isHoverable)) || _vm.inline),expression:"(!disabled && (isActive || isHoverable)) || inline"},{name:"trap-focus",rawName:"v-trap-focus",value:(_vm.trapFocus),expression:"trapFocus"}],ref:"dropdownMenu",staticClass:"dropdown-menu",attrs:{"aria-hidden":!_vm.isActive}},[_c('div',{staticClass:"dropdown-content",attrs:{"role":_vm.ariaRoleMenu}},[_vm._t("default")],2)])])],1)};
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
      

      
      var Dropdown = normalizeComponent_1(
        { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
        __vue_inject_styles__,
        __vue_script__,
        __vue_scope_id__,
        __vue_is_functional_template__,
        __vue_module_identifier__,
        undefined,
        undefined
      );

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
    //
    //
    //
    //
    //
    //
    //
    //
    var script$1 = {
      name: 'BDropdownItem',
      props: {
        value: {
          type: [String, Number, Boolean, Object, Array, Function],
          default: null
        },
        separator: Boolean,
        disabled: Boolean,
        custom: Boolean,
        focusable: {
          type: Boolean,
          default: true
        },
        paddingless: Boolean,
        hasLink: Boolean,
        ariaRole: {
          type: String,
          default: ''
        }
      },
      computed: {
        anchorClasses: function anchorClasses() {
          return {
            'is-disabled': this.$parent.disabled || this.disabled,
            'is-paddingless': this.paddingless,
            'is-active': this.isActive
          };
        },
        itemClasses: function itemClasses() {
          return {
            'dropdown-item': !this.hasLink,
            'is-disabled': this.disabled,
            'is-paddingless': this.paddingless,
            'is-active': this.isActive,
            'has-link': this.hasLink
          };
        },
        ariaRoleItem: function ariaRoleItem() {
          return this.ariaRole === 'menuitem' || this.ariaRole === 'listitem' ? this.ariaRole : null;
        },

        /**
        * Check if item can be clickable.
        */
        isClickable: function isClickable() {
          return !this.$parent.disabled && !this.separator && !this.disabled && !this.custom;
        },
        isActive: function isActive() {
          if (this.$parent.selected === null) return false;
          if (this.$parent.multiple) return this.$parent.selected.indexOf(this.value) >= 0;
          return this.value === this.$parent.selected;
        }
      },
      methods: {
        /**
        * Click listener, select the item.
        */
        selectItem: function selectItem() {
          if (!this.isClickable) return;
          this.$parent.selectItem(this.value);
          this.$emit('click');
        }
      },
      created: function created() {
        if (!this.$parent.$data._isDropdown) {
          this.$destroy();
          throw new Error('You should wrap bDropdownItem on a bDropdown');
        }
      }
    };

    /* script */
    const __vue_script__$1 = script$1;

    /* template */
    var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (_vm.separator)?_c('hr',{staticClass:"dropdown-divider"}):(!_vm.custom && !_vm.hasLink)?_c('a',{staticClass:"dropdown-item",class:_vm.anchorClasses,attrs:{"role":_vm.ariaRoleItem,"tabindex":_vm.focusable ? 0 : null},on:{"click":_vm.selectItem}},[_vm._t("default")],2):_c('div',{class:_vm.itemClasses,attrs:{"role":_vm.ariaRoleItem,"tabindex":_vm.focusable ? 0 : null},on:{"click":_vm.selectItem}},[_vm._t("default")],2)};
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
      

      
      var DropdownItem = normalizeComponent_1(
        { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
        __vue_inject_styles__$1,
        __vue_script__$1,
        __vue_scope_id__$1,
        __vue_is_functional_template__$1,
        __vue_module_identifier__$1,
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
        registerComponent(Vue, Dropdown);
        registerComponent(Vue, DropdownItem);
      }
    };
    use(Plugin);

    exports.default = Plugin;

    Object.defineProperty(exports, '__esModule', { value: true });

}));
