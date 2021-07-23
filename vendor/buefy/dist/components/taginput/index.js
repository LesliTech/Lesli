/*! Buefy v0.8.20 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = global || self, factory(global.Taginput = {}));
}(this, function (exports) { 'use strict';

  function _typeof(obj) {
    "@babel/helpers - typeof";

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
      var symbols = Object.getOwnPropertySymbols(object);
      if (enumerableOnly) symbols = symbols.filter(function (sym) {
        return Object.getOwnPropertyDescriptor(object, sym).enumerable;
      });
      keys.push.apply(keys, symbols);
    }

    return keys;
  }

  function _objectSpread2(target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i] != null ? arguments[i] : {};

      if (i % 2) {
        ownKeys(Object(source), true).forEach(function (key) {
          _defineProperty(target, key, source[key]);
        });
      } else if (Object.getOwnPropertyDescriptors) {
        Object.defineProperties(target, Object.getOwnPropertyDescriptors(source));
      } else {
        ownKeys(Object(source)).forEach(function (key) {
          Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key));
        });
      }
    }

    return target;
  }

  function _toArray(arr) {
    return _arrayWithHoles(arr) || _iterableToArray(arr) || _nonIterableRest();
  }

  function _arrayWithHoles(arr) {
    if (Array.isArray(arr)) return arr;
  }

  function _iterableToArray(iter) {
    if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter);
  }

  function _nonIterableRest() {
    throw new TypeError("Invalid attempt to destructure non-iterable instance");
  }

  /**
   * Get value of an object property/path even if it's nested
   */

  function getValueByPath(obj, path) {
    var value = path.split('.').reduce(function (o, i) {
      return o ? o[i] : null;
    }, obj);
    return value;
  }
  /**
   * Merge function to replace Object.assign with deep merging possibility
   */

  var isObject = function isObject(item) {
    return _typeof(item) === 'object' && !Array.isArray(item);
  };

  var mergeFn = function mergeFn(target, source) {
    var deep = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

    if (deep || !Object.assign) {
      var isDeep = function isDeep(prop) {
        return isObject(source[prop]) && target !== null && target.hasOwnProperty(prop) && isObject(target[prop]);
      };

      var replaced = Object.getOwnPropertyNames(source).map(function (prop) {
        return _defineProperty({}, prop, isDeep(prop) ? mergeFn(target[prop], source[prop], deep) : source[prop]);
      }).reduce(function (a, b) {
        return _objectSpread2({}, a, {}, b);
      }, {});
      return _objectSpread2({}, target, {}, replaced);
    } else {
      return Object.assign(target, source);
    }
  };

  var merge = mergeFn;
  function removeElement(el) {
    if (typeof el.remove !== 'undefined') {
      el.remove();
    } else if (typeof el.parentNode !== 'undefined' && el.parentNode !== null) {
      el.parentNode.removeChild(el);
    }
  }
  function createAbsoluteElement(el) {
    var root = document.createElement('div');
    root.style.position = 'absolute';
    root.style.left = '0px';
    root.style.top = '0px';
    var wrapper = document.createElement('div');
    root.appendChild(wrapper);
    wrapper.appendChild(el);
    document.body.appendChild(root);
    return root;
  }

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
  var script = {
    name: 'BTag',
    props: {
      attached: Boolean,
      closable: Boolean,
      type: String,
      size: String,
      rounded: Boolean,
      disabled: Boolean,
      ellipsis: Boolean,
      tabstop: {
        type: Boolean,
        default: true
      },
      ariaCloseLabel: String,
      closeType: String
    },
    methods: {
      /**
      * Emit close event when delete button is clicked
      * or delete key is pressed.
      */
      close: function close(event) {
        if (this.disabled) return;
        this.$emit('close', event);
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
  var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (_vm.attached && _vm.closable)?_c('div',{staticClass:"tags has-addons"},[_c('span',{staticClass:"tag",class:[_vm.type, _vm.size, { 'is-rounded': _vm.rounded }]},[_c('span',{class:{ 'has-ellipsis': _vm.ellipsis }},[_vm._t("default")],2)]),_vm._v(" "),_c('a',{staticClass:"tag is-delete",class:[_vm.size, _vm.closeType, { 'is-rounded': _vm.rounded }],attrs:{"role":"button","aria-label":_vm.ariaCloseLabel,"tabindex":_vm.tabstop ? 0 : false,"disabled":_vm.disabled},on:{"click":_vm.close,"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"delete",[8,46],$event.key,["Backspace","Delete","Del"])){ return null; }$event.preventDefault();return _vm.close($event)}}})]):_c('span',{staticClass:"tag",class:[_vm.type, _vm.size, { 'is-rounded': _vm.rounded }]},[_c('span',{class:{ 'has-ellipsis': _vm.ellipsis }},[_vm._t("default")],2),_vm._v(" "),(_vm.closable)?_c('a',{staticClass:"delete is-small",class:_vm.closeType,attrs:{"role":"button","aria-label":_vm.ariaCloseLabel,"disabled":_vm.disabled,"tabindex":_vm.tabstop ? 0 : false},on:{"click":_vm.close,"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"delete",[8,46],$event.key,["Backspace","Delete","Del"])){ return null; }$event.preventDefault();return _vm.close($event)}}}):_vm._e()])};
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
    

    
    var Tag = normalizeComponent_1(
      { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
      __vue_inject_styles__,
      __vue_script__,
      __vue_scope_id__,
      __vue_is_functional_template__,
      __vue_module_identifier__,
      undefined,
      undefined
    );

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
    defaultTimeCreator: null,
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
    defaultDatepickerMobileModal: true,
    defaultTrapFocus: false,
    defaultButtonRounded: false,
    defaultCarouselInterval: 3500,
    defaultTabsAnimated: true,
    defaultLinkTags: ['a', 'button', 'input', 'router-link', 'nuxt-link', 'n-link', 'RouterLink', 'NuxtLink', 'NLink'],
    customIconPacks: null
  }; // TODO defaultTrapFocus to true in the next breaking change

  var FormElementMixin = {
    props: {
      size: String,
      expanded: Boolean,
      loading: Boolean,
      rounded: Boolean,
      icon: String,
      iconPack: String,
      // Native options to use in HTML5 validation
      autocomplete: String,
      maxlength: [Number, String],
      useHtml5Validation: {
        type: Boolean,
        default: function _default() {
          return config.defaultUseHtml5Validation;
        }
      },
      validationMessage: String
    },
    data: function data() {
      return {
        isValid: true,
        isFocused: false,
        newIconPack: this.iconPack || config.defaultIconPack
      };
    },
    computed: {
      /**
       * Find parent Field, max 3 levels deep.
       */
      parentField: function parentField() {
        var parent = this.$parent;

        for (var i = 0; i < 3; i++) {
          if (parent && !parent.$data._isField) {
            parent = parent.$parent;
          }
        }

        return parent;
      },

      /**
       * Get the type prop from parent if it's a Field.
       */
      statusType: function statusType() {
        if (!this.parentField) return;
        if (!this.parentField.newType) return;

        if (typeof this.parentField.newType === 'string') {
          return this.parentField.newType;
        } else {
          for (var key in this.parentField.newType) {
            if (this.parentField.newType[key]) {
              return key;
            }
          }
        }
      },

      /**
       * Get the message prop from parent if it's a Field.
       */
      statusMessage: function statusMessage() {
        if (!this.parentField) return;
        return this.parentField.newMessage || this.parentField.$slots.message;
      },

      /**
       * Fix icon size for inputs, large was too big
       */
      iconSize: function iconSize() {
        switch (this.size) {
          case 'is-small':
            return this.size;

          case 'is-medium':
            return;

          case 'is-large':
            return this.newIconPack === 'mdi' ? 'is-medium' : '';
        }
      }
    },
    methods: {
      /**
       * Focus method that work dynamically depending on the component.
       */
      focus: function focus() {
        var _this = this;

        if (this.$data._elementRef === undefined) return;
        this.$nextTick(function () {
          var el = _this.$el.querySelector(_this.$data._elementRef);

          if (el) el.focus();
        });
      },
      onBlur: function onBlur($event) {
        this.isFocused = false;
        this.$emit('blur', $event);
        this.checkHtml5Validity();
      },
      onFocus: function onFocus($event) {
        this.isFocused = true;
        this.$emit('focus', $event);
      },
      getElement: function getElement() {
        return this.$el.querySelector(this.$data._elementRef);
      },
      setInvalid: function setInvalid() {
        var type = 'is-danger';
        var message = this.validationMessage || this.getElement().validationMessage;
        this.setValidity(type, message);
      },
      setValidity: function setValidity(type, message) {
        var _this2 = this;

        this.$nextTick(function () {
          if (_this2.parentField) {
            // Set type only if not defined
            if (!_this2.parentField.type) {
              _this2.parentField.newType = type;
            } // Set message only if not defined


            if (!_this2.parentField.message) {
              _this2.parentField.newMessage = message;
            }
          }
        });
      },

      /**
       * Check HTML5 validation, set isValid property.
       * If validation fail, send 'is-danger' type,
       * and error message to parent if it's a Field.
       */
      checkHtml5Validity: function checkHtml5Validity() {
        if (!this.useHtml5Validation) return;
        if (this.$refs[this.$data._elementRef] === undefined) return;
        if (this.getElement() === null) return;

        if (!this.getElement().checkValidity()) {
          this.setInvalid();
          this.isValid = false;
        } else {
          this.setValidity(null, null);
          this.isValid = true;
        }

        return this.isValid;
      }
    }
  };

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
    var faIconPrefix = config && config.defaultIconComponent ? '' : 'fa-';
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
        'menu-up': 'caret-up',
        'close-circle': 'times-circle'
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

    if (config && config.customIconPacks) {
      icons = merge(icons, config.customIconPacks, true);
    }

    return icons;
  };

  var script$1 = {
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
        return this.pack || config.defaultIconPack;
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

        var _splitType = splitType,
            _splitType2 = _toArray(_splitType),
            type = _splitType2.slice(1);

        return "has-text-".concat(type.join('-'));
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
        return this.component || config.defaultIconComponent;
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

  /* script */
  const __vue_script__$1 = script$1;

  /* template */
  var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{staticClass:"icon",class:[_vm.newType, _vm.size]},[(!_vm.useIconComponent)?_c('i',{class:[_vm.newPack, _vm.newIcon, _vm.newCustomSize, _vm.customClass]}):_c(_vm.useIconComponent,{tag:"component",class:[_vm.customClass],attrs:{"icon":[_vm.newPack, _vm.newIcon],"size":_vm.newCustomSize}})],1)};
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
    

    
    var Icon = normalizeComponent_1(
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
    name: 'BInput',
    components: _defineProperty({}, Icon.name, Icon),
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: [Number, String],
      type: {
        type: String,
        default: 'text'
      },
      passwordReveal: Boolean,
      iconClickable: Boolean,
      hasCounter: {
        type: Boolean,
        default: function _default() {
          return config.defaultInputHasCounter;
        }
      },
      customClass: {
        type: String,
        default: ''
      },
      iconRight: String,
      iconRightClickable: Boolean
    },
    data: function data() {
      return {
        newValue: this.value,
        newType: this.type,
        newAutocomplete: this.autocomplete || config.defaultInputAutocomplete,
        isPasswordVisible: false,
        _elementRef: this.type === 'textarea' ? 'textarea' : 'input'
      };
    },
    computed: {
      computedValue: {
        get: function get() {
          return this.newValue;
        },
        set: function set(value) {
          this.newValue = value;
          this.$emit('input', value);
          !this.isValid && this.checkHtml5Validity();
        }
      },
      rootClasses: function rootClasses() {
        return [this.iconPosition, this.size, {
          'is-expanded': this.expanded,
          'is-loading': this.loading,
          'is-clearfix': !this.hasMessage
        }];
      },
      inputClasses: function inputClasses() {
        return [this.statusType, this.size, {
          'is-rounded': this.rounded
        }];
      },
      hasIconRight: function hasIconRight() {
        return this.passwordReveal || this.loading || this.statusTypeIcon || this.iconRight;
      },
      rightIcon: function rightIcon() {
        if (this.passwordReveal) {
          return this.passwordVisibleIcon;
        } else if (this.iconRight) {
          return this.iconRight;
        }

        return this.statusTypeIcon;
      },
      rightIconType: function rightIconType() {
        if (this.passwordReveal) {
          return 'is-primary';
        } else if (this.iconRight) {
          return null;
        }

        return this.statusType;
      },

      /**
      * Position of the icon or if it's both sides.
      */
      iconPosition: function iconPosition() {
        if (this.icon && this.hasIconRight) {
          return 'has-icons-left has-icons-right';
        } else if (!this.icon && this.hasIconRight) {
          return 'has-icons-right';
        } else if (this.icon) {
          return 'has-icons-left';
        }
      },

      /**
      * Icon name (MDI) based on the type.
      */
      statusTypeIcon: function statusTypeIcon() {
        switch (this.statusType) {
          case 'is-success':
            return 'check';

          case 'is-danger':
            return 'alert-circle';

          case 'is-info':
            return 'information';

          case 'is-warning':
            return 'alert';
        }
      },

      /**
      * Check if have any message prop from parent if it's a Field.
      */
      hasMessage: function hasMessage() {
        return !!this.statusMessage;
      },

      /**
      * Current password-reveal icon name.
      */
      passwordVisibleIcon: function passwordVisibleIcon() {
        return !this.isPasswordVisible ? 'eye' : 'eye-off';
      },

      /**
      * Get value length
      */
      valueLength: function valueLength() {
        if (typeof this.computedValue === 'string') {
          return this.computedValue.length;
        } else if (typeof this.computedValue === 'number') {
          return this.computedValue.toString().length;
        }

        return 0;
      }
    },
    watch: {
      /**
      * When v-model is changed:
      *   1. Set internal value.
      */
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      /**
      * Toggle the visibility of a password-reveal input
      * by changing the type and focus the input right away.
      */
      togglePasswordVisibility: function togglePasswordVisibility() {
        var _this = this;

        this.isPasswordVisible = !this.isPasswordVisible;
        this.newType = this.isPasswordVisible ? 'text' : 'password';
        this.$nextTick(function () {
          _this.$refs[_this.$data._elementRef].focus();
        });
      },

      /**
      * Input's 'input' event listener, 'nextTick' is used to prevent event firing
      * before ui update, helps when using masks (Cleavejs and potentially others).
      */
      onInput: function onInput(event) {
        var _this2 = this;

        this.$nextTick(function () {
          if (event.target) {
            _this2.computedValue = event.target.value;
          }
        });
      },
      iconClick: function iconClick(emit, event) {
        var _this3 = this;

        this.$emit(emit, event);
        this.$nextTick(function () {
          _this3.$refs[_this3.$data._elementRef].focus();
        });
      },
      rightIconClick: function rightIconClick(event) {
        if (this.passwordReveal) {
          this.togglePasswordVisibility();
        } else if (this.iconRightClickable) {
          this.iconClick('icon-right-click', event);
        }
      }
    }
  };

  /* script */
  const __vue_script__$2 = script$2;

  /* template */
  var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:_vm.rootClasses},[(_vm.type !== 'textarea')?_c('input',_vm._b({ref:"input",staticClass:"input",class:[_vm.inputClasses, _vm.customClass],attrs:{"type":_vm.newType,"autocomplete":_vm.newAutocomplete,"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'input',_vm.$attrs,false)):_c('textarea',_vm._b({ref:"textarea",staticClass:"textarea",class:[_vm.inputClasses, _vm.customClass],attrs:{"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'textarea',_vm.$attrs,false)),_vm._v(" "),(_vm.icon)?_c('b-icon',{staticClass:"is-left",class:{'is-clickable': _vm.iconClickable},attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":_vm.iconSize},nativeOn:{"click":function($event){_vm.iconClick('icon-click', $event);}}}):_vm._e(),_vm._v(" "),(!_vm.loading && _vm.hasIconRight)?_c('b-icon',{staticClass:"is-right",class:{ 'is-clickable': _vm.passwordReveal || _vm.iconRightClickable },attrs:{"icon":_vm.rightIcon,"pack":_vm.iconPack,"size":_vm.iconSize,"type":_vm.rightIconType,"both":""},nativeOn:{"click":function($event){return _vm.rightIconClick($event)}}}):_vm._e(),_vm._v(" "),(_vm.maxlength && _vm.hasCounter && _vm.type !== 'number')?_c('small',{staticClass:"help counter",class:{ 'is-invisible': !_vm.isFocused }},[_vm._v("\r\n            "+_vm._s(_vm.valueLength)+" / "+_vm._s(_vm.maxlength)+"\r\n        ")]):_vm._e()],1)};
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
    

    
    var Input = normalizeComponent_1(
      { render: __vue_render__$2, staticRenderFns: __vue_staticRenderFns__$2 },
      __vue_inject_styles__$2,
      __vue_script__$2,
      __vue_scope_id__$2,
      __vue_is_functional_template__$2,
      __vue_module_identifier__$2,
      undefined,
      undefined
    );

  var script$3 = {
    name: 'BAutocomplete',
    components: _defineProperty({}, Input.name, Input),
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: [Number, String],
      data: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      field: {
        type: String,
        default: 'value'
      },
      keepFirst: Boolean,
      clearOnSelect: Boolean,
      openOnFocus: Boolean,
      customFormatter: Function,
      checkInfiniteScroll: Boolean,
      keepOpen: Boolean,
      clearable: Boolean,
      maxHeight: [String, Number],
      dropdownPosition: {
        type: String,
        default: 'auto'
      },
      iconRight: String,
      iconRightClickable: Boolean,
      appendToBody: Boolean
    },
    data: function data() {
      return {
        selected: null,
        hovered: null,
        isActive: false,
        newValue: this.value,
        newAutocomplete: this.autocomplete || 'off',
        isListInViewportVertically: true,
        hasFocus: false,
        style: {},
        _isAutocomplete: true,
        _elementRef: 'input',
        _bodyEl: undefined // Used to append to body

      };
    },
    computed: {
      /**
       * White-listed items to not close when clicked.
       * Add input, dropdown and all children.
       */
      whiteList: function whiteList() {
        var whiteList = [];
        whiteList.push(this.$refs.input.$el.querySelector('input'));
        whiteList.push(this.$refs.dropdown); // Add all chidren from dropdown

        if (this.$refs.dropdown !== undefined) {
          var children = this.$refs.dropdown.querySelectorAll('*');
          var _iteratorNormalCompletion = true;
          var _didIteratorError = false;
          var _iteratorError = undefined;

          try {
            for (var _iterator = children[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
              var child = _step.value;
              whiteList.push(child);
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
        }

        if (this.$parent.$data._isTaginput) {
          // Add taginput container
          whiteList.push(this.$parent.$el); // Add .tag and .delete

          var tagInputChildren = this.$parent.$el.querySelectorAll('*');
          var _iteratorNormalCompletion2 = true;
          var _didIteratorError2 = false;
          var _iteratorError2 = undefined;

          try {
            for (var _iterator2 = tagInputChildren[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
              var tagInputChild = _step2.value;
              whiteList.push(tagInputChild);
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

        return whiteList;
      },

      /**
       * Check if exists default slot
       */
      hasDefaultSlot: function hasDefaultSlot() {
        return !!this.$scopedSlots.default;
      },

      /**
       * Check if exists "empty" slot
       */
      hasEmptySlot: function hasEmptySlot() {
        return !!this.$slots.empty;
      },

      /**
       * Check if exists "header" slot
       */
      hasHeaderSlot: function hasHeaderSlot() {
        return !!this.$slots.header;
      },

      /**
       * Check if exists "footer" slot
       */
      hasFooterSlot: function hasFooterSlot() {
        return !!this.$slots.footer;
      },

      /**
       * Apply dropdownPosition property
       */
      isOpenedTop: function isOpenedTop() {
        return this.dropdownPosition === 'top' || this.dropdownPosition === 'auto' && !this.isListInViewportVertically;
      },
      newIconRight: function newIconRight() {
        if (this.clearable && this.newValue) {
          return 'close-circle';
        }

        return this.iconRight;
      },
      newIconRightClickable: function newIconRightClickable() {
        if (this.clearable) {
          return true;
        }

        return this.iconRightClickable;
      },
      contentStyle: function contentStyle() {
        return {
          maxHeight: this.maxHeight === undefined ? null : isNaN(this.maxHeight) ? this.maxHeight : this.maxHeight + 'px'
        };
      }
    },
    watch: {
      /**
       * When dropdown is toggled, check the visibility to know when
       * to open upwards.
       */
      isActive: function isActive(active) {
        var _this = this;

        if (this.dropdownPosition === 'auto') {
          if (active) {
            this.calcDropdownInViewportVertical();
          } else {
            // Timeout to wait for the animation to finish before recalculating
            setTimeout(function () {
              _this.calcDropdownInViewportVertical();
            }, 100);
          }
        }

        if (active) this.$nextTick(function () {
          return _this.setHovered(null);
        });
      },

      /**
       * When updating input's value
       *   1. Emit changes
       *   2. If value isn't the same as selected, set null
       *   3. Close dropdown if value is clear or else open it
       */
      newValue: function newValue(value) {
        this.$emit('input', value); // Check if selected is invalid

        var currentValue = this.getValue(this.selected);

        if (currentValue && currentValue !== value) {
          this.setSelected(null, false);
        } // Close dropdown if input is clear or else open it


        if (this.hasFocus && (!this.openOnFocus || value)) {
          this.isActive = !!value;
        }
      },

      /**
       * When v-model is changed:
       *   1. Update internal value.
       *   2. If it's invalid, validate again.
       */
      value: function value(_value) {
        this.newValue = _value;
      },

      /**
       * Select first option if "keep-first
       */
      data: function data(value) {
        // Keep first option always pre-selected
        if (this.keepFirst) {
          this.selectFirstOption(value);
        }
      }
    },
    methods: {
      /**
       * Set which option is currently hovered.
       */
      setHovered: function setHovered(option) {
        if (option === undefined) return;
        this.hovered = option;
      },

      /**
       * Set which option is currently selected, update v-model,
       * update input value and close dropdown.
       */
      setSelected: function setSelected(option) {
        var _this2 = this;

        var closeDropdown = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
        var event = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : undefined;
        if (option === undefined) return;
        this.selected = option;
        this.$emit('select', this.selected, event);

        if (this.selected !== null) {
          this.newValue = this.clearOnSelect ? '' : this.getValue(this.selected);
          this.setHovered(null);
        }

        closeDropdown && this.$nextTick(function () {
          _this2.isActive = false;
        });
        this.checkValidity();
      },

      /**
       * Select first option
       */
      selectFirstOption: function selectFirstOption(options) {
        var _this3 = this;

        this.$nextTick(function () {
          if (options.length) {
            // If has visible data or open on focus, keep updating the hovered
            if (_this3.openOnFocus || _this3.newValue !== '' && _this3.hovered !== options[0]) {
              _this3.setHovered(options[0]);
            }
          } else {
            _this3.setHovered(null);
          }
        });
      },

      /**
       * Enter key listener.
       * Select the hovered option.
       */
      enterPressed: function enterPressed(event) {
        if (this.hovered === null) return;
        this.setSelected(this.hovered, !this.keepOpen, event);
      },

      /**
       * Tab key listener.
       * Select hovered option if it exists, close dropdown, then allow
       * native handling to move to next tabbable element.
       */
      tabPressed: function tabPressed(event) {
        if (this.hovered === null) {
          this.isActive = false;
          return;
        }

        this.setSelected(this.hovered, !this.keepOpen, event);
      },

      /**
       * Close dropdown if clicked outside.
       */
      clickedOutside: function clickedOutside(event) {
        if (this.whiteList.indexOf(event.target) < 0) this.isActive = false;
      },

      /**
       * Return display text for the input.
       * If object, get value from path, or else just the value.
       */
      getValue: function getValue(option) {
        if (option === null) return;

        if (typeof this.customFormatter !== 'undefined') {
          return this.customFormatter(option);
        }

        return _typeof(option) === 'object' ? getValueByPath(option, this.field) : option;
      },

      /**
       * Check if the scroll list inside the dropdown
       * reached it's end.
       */
      checkIfReachedTheEndOfScroll: function checkIfReachedTheEndOfScroll(list) {
        if (list.clientHeight !== list.scrollHeight && list.scrollTop + list.clientHeight >= list.scrollHeight) {
          this.$emit('infinite-scroll');
        }
      },

      /**
       * Calculate if the dropdown is vertically visible when activated,
       * otherwise it is openened upwards.
       */
      calcDropdownInViewportVertical: function calcDropdownInViewportVertical() {
        var _this4 = this;

        this.$nextTick(function () {
          /**
          * this.$refs.dropdown may be undefined
          * when Autocomplete is conditional rendered
          */
          if (_this4.$refs.dropdown === undefined) return;

          var rect = _this4.$refs.dropdown.getBoundingClientRect();

          _this4.isListInViewportVertically = rect.top >= 0 && rect.bottom <= (window.innerHeight || document.documentElement.clientHeight);

          if (_this4.appendToBody) {
            _this4.updateAppendToBody();
          }
        });
      },

      /**
       * Arrows keys listener.
       * If dropdown is active, set hovered option, or else just open.
       */
      keyArrows: function keyArrows(direction) {
        var sum = direction === 'down' ? 1 : -1;

        if (this.isActive) {
          var index = this.data.indexOf(this.hovered) + sum;
          index = index > this.data.length - 1 ? this.data.length : index;
          index = index < 0 ? 0 : index;
          this.setHovered(this.data[index]);
          var list = this.$refs.dropdown.querySelector('.dropdown-content');
          var element = list.querySelectorAll('a.dropdown-item:not(.is-disabled)')[index];
          if (!element) return;
          var visMin = list.scrollTop;
          var visMax = list.scrollTop + list.clientHeight - element.clientHeight;

          if (element.offsetTop < visMin) {
            list.scrollTop = element.offsetTop;
          } else if (element.offsetTop >= visMax) {
            list.scrollTop = element.offsetTop - list.clientHeight + element.clientHeight;
          }
        } else {
          this.isActive = true;
        }
      },

      /**
       * Focus listener.
       * If value is the same as selected, select all text.
       */
      focused: function focused(event) {
        if (this.getValue(this.selected) === this.newValue) {
          this.$el.querySelector('input').select();
        }

        if (this.openOnFocus) {
          this.isActive = true;

          if (this.keepFirst) {
            this.selectFirstOption(this.data);
          }
        }

        this.hasFocus = true;
        this.$emit('focus', event);
      },

      /**
      * Blur listener.
      */
      onBlur: function onBlur(event) {
        this.hasFocus = false;
        this.$emit('blur', event);
      },
      onInput: function onInput(event) {
        var currentValue = this.getValue(this.selected);
        if (currentValue && currentValue === this.newValue) return;
        this.$emit('typing', this.newValue);
        this.checkValidity();
      },
      rightIconClick: function rightIconClick(event) {
        if (this.clearable) {
          this.newValue = '';

          if (this.openOnFocus) {
            this.$el.focus();
          }
        } else {
          this.$emit('icon-right-click', event);
        }
      },
      checkValidity: function checkValidity() {
        var _this5 = this;

        if (this.useHtml5Validation) {
          this.$nextTick(function () {
            _this5.checkHtml5Validity();
          });
        }
      },
      updateAppendToBody: function updateAppendToBody() {
        var dropdownMenu = this.$refs.dropdown;
        var trigger = this.$refs.input.$el;

        if (dropdownMenu && trigger) {
          // update wrapper dropdown
          var root = this.$data._bodyEl;
          root.classList.forEach(function (item) {
            return root.classList.remove(item);
          });
          root.classList.add('autocomplete');
          root.classList.add('control');

          if (this.expandend) {
            root.classList.add('is-expandend');
          }

          var rect = trigger.getBoundingClientRect();
          var top = rect.top + window.scrollY;
          var left = rect.left + window.scrollX;

          if (!this.isOpenedTop) {
            top += trigger.clientHeight;
          } else {
            top -= dropdownMenu.clientHeight;
          }

          this.style = {
            position: 'absolute',
            top: "".concat(top, "px"),
            left: "".concat(left, "px"),
            width: "".concat(trigger.clientWidth, "px"),
            maxWidth: "".concat(trigger.clientWidth, "px"),
            zIndex: '99'
          };
        }
      }
    },
    created: function created() {
      if (typeof window !== 'undefined') {
        document.addEventListener('click', this.clickedOutside);
        if (this.dropdownPosition === 'auto') window.addEventListener('resize', this.calcDropdownInViewportVertical);
      }
    },
    mounted: function mounted() {
      var _this6 = this;

      if (this.checkInfiniteScroll && this.$refs.dropdown && this.$refs.dropdown.querySelector('.dropdown-content')) {
        var list = this.$refs.dropdown.querySelector('.dropdown-content');
        list.addEventListener('scroll', function () {
          return _this6.checkIfReachedTheEndOfScroll(list);
        });
      }

      if (this.appendToBody) {
        this.$data._bodyEl = createAbsoluteElement(this.$refs.dropdown);
        this.updateAppendToBody();
      }
    },
    beforeDestroy: function beforeDestroy() {
      if (typeof window !== 'undefined') {
        document.removeEventListener('click', this.clickedOutside);
        if (this.dropdownPosition === 'auto') window.removeEventListener('resize', this.calcDropdownInViewportVertical);
      }

      if (this.checkInfiniteScroll && this.$refs.dropdown && this.$refs.dropdown.querySelector('.dropdown-content')) {
        var list = this.$refs.dropdown.querySelector('.dropdown-content');
        list.removeEventListener('scroll', this.checkIfReachedTheEndOfScroll);
      }

      if (this.appendToBody) {
        removeElement(this.$data._bodyEl);
      }
    }
  };

  /* script */
  const __vue_script__$3 = script$3;

  /* template */
  var __vue_render__$3 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"autocomplete control",class:{'is-expanded': _vm.expanded}},[_c('b-input',_vm._b({ref:"input",attrs:{"type":"text","size":_vm.size,"loading":_vm.loading,"rounded":_vm.rounded,"icon":_vm.icon,"icon-right":_vm.newIconRight,"icon-right-clickable":_vm.newIconRightClickable,"icon-pack":_vm.iconPack,"maxlength":_vm.maxlength,"autocomplete":_vm.newAutocomplete,"use-html5-validation":false},on:{"input":_vm.onInput,"focus":_vm.focused,"blur":_vm.onBlur,"icon-right-click":_vm.rightIconClick,"icon-click":function (event) { return _vm.$emit('icon-click', event); }},nativeOn:{"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"esc",27,$event.key,["Esc","Escape"])){ return null; }$event.preventDefault();_vm.isActive = false;},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"tab",9,$event.key,"Tab")){ return null; }return _vm.tabPressed($event)},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key,"Enter")){ return null; }$event.preventDefault();return _vm.enterPressed($event)},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"up",38,$event.key,["Up","ArrowUp"])){ return null; }$event.preventDefault();_vm.keyArrows('up');},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"down",40,$event.key,["Down","ArrowDown"])){ return null; }$event.preventDefault();_vm.keyArrows('down');}]},model:{value:(_vm.newValue),callback:function ($$v) {_vm.newValue=$$v;},expression:"newValue"}},'b-input',_vm.$attrs,false)),_vm._v(" "),_c('transition',{attrs:{"name":"fade"}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive && (_vm.data.length > 0 || _vm.hasEmptySlot || _vm.hasHeaderSlot)),expression:"isActive && (data.length > 0 || hasEmptySlot || hasHeaderSlot)"}],ref:"dropdown",staticClass:"dropdown-menu",class:{ 'is-opened-top': _vm.isOpenedTop && !_vm.appendToBody },style:(_vm.style)},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"dropdown-content",style:(_vm.contentStyle)},[(_vm.hasHeaderSlot)?_c('div',{staticClass:"dropdown-item"},[_vm._t("header")],2):_vm._e(),_vm._v(" "),_vm._l((_vm.data),function(option,index){return _c('a',{key:index,staticClass:"dropdown-item",class:{ 'is-hovered': option === _vm.hovered },on:{"click":function($event){_vm.setSelected(option, undefined, $event);}}},[(_vm.hasDefaultSlot)?_vm._t("default",null,{option:option,index:index}):_c('span',[_vm._v("\r\n                            "+_vm._s(_vm.getValue(option, true))+"\r\n                        ")])],2)}),_vm._v(" "),(_vm.data.length === 0 && _vm.hasEmptySlot)?_c('div',{staticClass:"dropdown-item is-disabled"},[_vm._t("empty")],2):_vm._e(),_vm._v(" "),(_vm.hasFooterSlot)?_c('div',{staticClass:"dropdown-item"},[_vm._t("footer")],2):_vm._e()],2)])])],1)};
  var __vue_staticRenderFns__$3 = [];

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
    

    
    var Autocomplete = normalizeComponent_1(
      { render: __vue_render__$3, staticRenderFns: __vue_staticRenderFns__$3 },
      __vue_inject_styles__$3,
      __vue_script__$3,
      __vue_scope_id__$3,
      __vue_is_functional_template__$3,
      __vue_module_identifier__$3,
      undefined,
      undefined
    );

  var _components;
  var script$4 = {
    name: 'BTaginput',
    components: (_components = {}, _defineProperty(_components, Autocomplete.name, Autocomplete), _defineProperty(_components, Tag.name, Tag), _components),
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      data: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      type: String,
      rounded: {
        type: Boolean,
        default: false
      },
      attached: {
        type: Boolean,
        default: false
      },
      maxtags: {
        type: [Number, String],
        required: false
      },
      hasCounter: {
        type: Boolean,
        default: function _default() {
          return config.defaultTaginputHasCounter;
        }
      },
      field: {
        type: String,
        default: 'value'
      },
      autocomplete: Boolean,
      nativeAutocomplete: String,
      openOnFocus: Boolean,
      disabled: Boolean,
      ellipsis: Boolean,
      closable: {
        type: Boolean,
        default: true
      },
      confirmKeyCodes: {
        type: Array,
        default: function _default() {
          return [13, 188];
        }
      },
      removeOnKeys: {
        type: Array,
        default: function _default() {
          return [8];
        }
      },
      allowNew: Boolean,
      onPasteSeparators: {
        type: Array,
        default: function _default() {
          return [','];
        }
      },
      beforeAdding: {
        type: Function,
        default: function _default() {
          return true;
        }
      },
      allowDuplicates: {
        type: Boolean,
        default: false
      },
      checkInfiniteScroll: {
        type: Boolean,
        default: false
      },
      appendToBody: Boolean
    },
    data: function data() {
      return {
        tags: Array.isArray(this.value) ? this.value.slice(0) : this.value || [],
        newTag: '',
        _elementRef: 'input',
        _isTaginput: true
      };
    },
    computed: {
      rootClasses: function rootClasses() {
        return {
          'is-expanded': this.expanded
        };
      },
      containerClasses: function containerClasses() {
        return {
          'is-focused': this.isFocused,
          'is-focusable': this.hasInput
        };
      },
      valueLength: function valueLength() {
        return this.newTag.trim().length;
      },
      defaultSlotName: function defaultSlotName() {
        return this.hasDefaultSlot ? 'default' : 'dontrender';
      },
      emptySlotName: function emptySlotName() {
        return this.hasEmptySlot ? 'empty' : 'dontrender';
      },
      headerSlotName: function headerSlotName() {
        return this.hasHeaderSlot ? 'header' : 'dontrender';
      },
      footerSlotName: function footerSlotName() {
        return this.hasFooterSlot ? 'footer' : 'dontrender';
      },
      hasDefaultSlot: function hasDefaultSlot() {
        return !!this.$scopedSlots.default;
      },
      hasEmptySlot: function hasEmptySlot() {
        return !!this.$slots.empty;
      },
      hasHeaderSlot: function hasHeaderSlot() {
        return !!this.$slots.header;
      },
      hasFooterSlot: function hasFooterSlot() {
        return !!this.$slots.footer;
      },

      /**
       * Show the input field if a maxtags hasn't been set or reached.
       */
      hasInput: function hasInput() {
        return this.maxtags == null || this.tagsLength < this.maxtags;
      },
      tagsLength: function tagsLength() {
        return this.tags.length;
      },

      /**
       * If Taginput has onPasteSeparators prop,
       * returning new RegExp used to split pasted string.
       */
      separatorsAsRegExp: function separatorsAsRegExp() {
        var sep = this.onPasteSeparators;
        return sep.length ? new RegExp(sep.map(function (s) {
          return s ? s.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') : null;
        }).join('|'), 'g') : null;
      }
    },
    watch: {
      /**
       * When v-model is changed set internal value.
       */
      value: function value(_value) {
        this.tags = Array.isArray(_value) ? _value.slice(0) : _value || [];
      },
      hasInput: function hasInput() {
        if (!this.hasInput) this.onBlur();
      }
    },
    methods: {
      addTag: function addTag(tag) {
        var tagToAdd = tag || this.newTag.trim();

        if (tagToAdd) {
          if (!this.autocomplete) {
            var reg = this.separatorsAsRegExp;

            if (reg && tagToAdd.match(reg)) {
              tagToAdd.split(reg).map(function (t) {
                return t.trim();
              }).filter(function (t) {
                return t.length !== 0;
              }).map(this.addTag);
              return;
            }
          } // Remove the tag input previously added (if not allowDuplicates).


          if (!this.allowDuplicates) {
            var index = this.tags.indexOf(tagToAdd);

            if (index >= 0) {
              this.tags.splice(index, 1);
              return;
            }
          } // Add the tag input if it is not blank
          // or previously added (if not allowDuplicates).


          var add = !this.allowDuplicates ? this.tags.indexOf(tagToAdd) === -1 : true;

          if (add && this.beforeAdding(tagToAdd)) {
            this.tags.push(tagToAdd);
            this.$emit('input', this.tags);
            this.$emit('add', tagToAdd);
          }
        }

        this.newTag = '';
      },
      getNormalizedTagText: function getNormalizedTagText(tag) {
        if (_typeof(tag) === 'object') {
          return getValueByPath(tag, this.field);
        }

        return tag;
      },
      customOnBlur: function customOnBlur(event) {
        // Add tag on-blur if not select only
        if (!this.autocomplete) this.addTag();
        this.onBlur(event);
      },
      onSelect: function onSelect(option) {
        var _this = this;

        if (!option) return;
        this.addTag(option);
        this.$nextTick(function () {
          _this.newTag = '';
        });
      },
      removeTag: function removeTag(index, event) {
        var tag = this.tags.splice(index, 1)[0];
        this.$emit('input', this.tags);
        this.$emit('remove', tag);
        if (event) event.stopPropagation();

        if (this.openOnFocus && this.$refs.autocomplete) {
          this.$refs.autocomplete.focus();
        }

        return tag;
      },
      removeLastTag: function removeLastTag() {
        if (this.tagsLength > 0) {
          this.removeTag(this.tagsLength - 1);
        }
      },
      keydown: function keydown(event) {
        if (this.removeOnKeys.indexOf(event.keyCode) !== -1 && !this.newTag.length) {
          this.removeLastTag();
        } // Stop if is to accept select only


        if (this.autocomplete && !this.allowNew) return;

        if (this.confirmKeyCodes.indexOf(event.keyCode) >= 0) {
          event.preventDefault();
          this.addTag();
        }
      },
      onTyping: function onTyping(event) {
        this.$emit('typing', event.trim());
      },
      emitInfiniteScroll: function emitInfiniteScroll() {
        this.$emit('infinite-scroll');
      }
    }
  };

  /* script */
  const __vue_script__$4 = script$4;

  /* template */
  var __vue_render__$4 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"taginput control",class:_vm.rootClasses},[_c('div',{staticClass:"taginput-container",class:[_vm.statusType, _vm.size, _vm.containerClasses],attrs:{"disabled":_vm.disabled},on:{"click":function($event){_vm.hasInput && _vm.focus($event);}}},[_vm._t("selected",_vm._l((_vm.tags),function(tag,index){return _c('b-tag',{key:_vm.getNormalizedTagText(tag) + index,attrs:{"type":_vm.type,"size":_vm.size,"rounded":_vm.rounded,"attached":_vm.attached,"tabstop":false,"disabled":_vm.disabled,"ellipsis":_vm.ellipsis,"closable":_vm.closable,"title":_vm.ellipsis && _vm.getNormalizedTagText(tag)},on:{"close":function($event){_vm.removeTag(index, $event);}}},[_vm._t("tag",[_vm._v("\r\n                        "+_vm._s(_vm.getNormalizedTagText(tag))+"\r\n                    ")],{tag:tag})],2)}),{tags:_vm.tags}),_vm._v(" "),(_vm.hasInput)?_c('b-autocomplete',_vm._b({ref:"autocomplete",attrs:{"data":_vm.data,"field":_vm.field,"icon":_vm.icon,"icon-pack":_vm.iconPack,"maxlength":_vm.maxlength,"has-counter":false,"size":_vm.size,"disabled":_vm.disabled,"loading":_vm.loading,"autocomplete":_vm.nativeAutocomplete,"open-on-focus":_vm.openOnFocus,"keep-open":_vm.openOnFocus,"keep-first":!_vm.allowNew,"use-html5-validation":_vm.useHtml5Validation,"check-infinite-scroll":_vm.checkInfiniteScroll,"append-to-body":_vm.appendToBody},on:{"typing":_vm.onTyping,"focus":_vm.onFocus,"blur":_vm.customOnBlur,"select":_vm.onSelect,"infinite-scroll":_vm.emitInfiniteScroll},nativeOn:{"keydown":function($event){return _vm.keydown($event)}},scopedSlots:_vm._u([{key:_vm.defaultSlotName,fn:function(props){return [_vm._t("default",null,{option:props.option,index:props.index})]}}]),model:{value:(_vm.newTag),callback:function ($$v) {_vm.newTag=$$v;},expression:"newTag"}},'b-autocomplete',_vm.$attrs,false),[_c('template',{slot:_vm.headerSlotName},[_vm._t("header")],2),_vm._v(" "),_c('template',{slot:_vm.emptySlotName},[_vm._t("empty")],2),_vm._v(" "),_c('template',{slot:_vm.footerSlotName},[_vm._t("footer")],2)],2):_vm._e()],2),_vm._v(" "),(_vm.hasCounter && (_vm.maxtags || _vm.maxlength))?_c('small',{staticClass:"help counter"},[(_vm.maxlength && _vm.valueLength > 0)?[_vm._v("\r\n                "+_vm._s(_vm.valueLength)+" / "+_vm._s(_vm.maxlength)+"\r\n            ")]:(_vm.maxtags)?[_vm._v("\r\n                "+_vm._s(_vm.tagsLength)+" / "+_vm._s(_vm.maxtags)+"\r\n            ")]:_vm._e()],2):_vm._e()])};
  var __vue_staticRenderFns__$4 = [];

    /* style */
    const __vue_inject_styles__$4 = undefined;
    /* scoped */
    const __vue_scope_id__$4 = undefined;
    /* module identifier */
    const __vue_module_identifier__$4 = undefined;
    /* functional template */
    const __vue_is_functional_template__$4 = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Taginput = normalizeComponent_1(
      { render: __vue_render__$4, staticRenderFns: __vue_staticRenderFns__$4 },
      __vue_inject_styles__$4,
      __vue_script__$4,
      __vue_scope_id__$4,
      __vue_is_functional_template__$4,
      __vue_module_identifier__$4,
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
      registerComponent(Vue, Taginput);
    }
  };
  use(Plugin);

  exports.BTaginput = Taginput;
  exports.default = Plugin;

  Object.defineProperty(exports, '__esModule', { value: true });

}));
