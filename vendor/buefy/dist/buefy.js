/*! Buefy v0.8.6 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports, require('vue')) :
  typeof define === 'function' && define.amd ? define(['exports', 'vue'], factory) :
  (global = global || self, factory(global.Buefy = {}, global.Vue));
}(this, function (exports, Vue) { 'use strict';

  Vue = Vue && Vue.hasOwnProperty('default') ? Vue['default'] : Vue;

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

  function _toConsumableArray(arr) {
    return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread();
  }

  function _arrayWithoutHoles(arr) {
    if (Array.isArray(arr)) {
      for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

      return arr2;
    }
  }

  function _iterableToArray(iter) {
    if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter);
  }

  function _nonIterableSpread() {
    throw new TypeError("Invalid attempt to spread non-iterable instance");
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
   * Extension of indexOf method by equality function if specified
   */

  function indexOf(array, obj, fn) {
    if (!array) return -1;
    if (!fn || typeof fn !== 'function') return array.indexOf(obj);

    for (var i = 0; i < array.length; i++) {
      if (fn(array[i], obj)) {
        return i;
      }
    }

    return -1;
  }
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
  /**
   * Mobile detection
   * https://www.abeautifulsite.net/detecting-mobile-devices-with-javascript
   */

  var isMobile = {
    Android: function Android() {
      return typeof window !== 'undefined' && window.navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function BlackBerry() {
      return typeof window !== 'undefined' && window.navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function iOS() {
      return typeof window !== 'undefined' && window.navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function Opera() {
      return typeof window !== 'undefined' && window.navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function Windows() {
      return typeof window !== 'undefined' && window.navigator.userAgent.match(/IEMobile/i);
    },
    any: function any() {
      return isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows();
    }
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
  var setOptions = function setOptions(options) {
    config = options;
  };

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
          return config$1.defaultUseHtml5Validation;
        }
      },
      validationMessage: String
    },
    data: function data() {
      return {
        isValid: true,
        isFocused: false,
        newIconPack: this.iconPack || config$1.defaultIconPack
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
        return this.parentField.newMessage;
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

  var script$1 = {
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
      hasCounter: {
        type: Boolean,
        default: function _default() {
          return config$1.defaultInputHasCounter;
        }
      },
      customClass: {
        type: String,
        default: ''
      }
    },
    data: function data() {
      return {
        newValue: this.value,
        newType: this.type,
        newAutocomplete: this.autocomplete || config$1.defaultInputAutocomplete,
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
        return this.passwordReveal || this.loading || this.statusTypeIcon;
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
          _this.$refs.input.focus();
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
      }
    }
  };

  /* script */
  const __vue_script__$1 = script$1;

  /* template */
  var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:_vm.rootClasses},[(_vm.type !== 'textarea')?_c('input',_vm._b({ref:"input",staticClass:"input",class:[_vm.inputClasses, _vm.customClass],attrs:{"type":_vm.newType,"autocomplete":_vm.newAutocomplete,"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'input',_vm.$attrs,false)):_c('textarea',_vm._b({ref:"textarea",staticClass:"textarea",class:[_vm.inputClasses, _vm.customClass],attrs:{"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'textarea',_vm.$attrs,false)),_vm._v(" "),(_vm.icon)?_c('b-icon',{staticClass:"is-left",attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":_vm.iconSize}}):_vm._e(),_vm._v(" "),(!_vm.loading && (_vm.passwordReveal || _vm.statusTypeIcon))?_c('b-icon',{staticClass:"is-right",class:{ 'is-clickable': _vm.passwordReveal },attrs:{"icon":_vm.passwordReveal ? _vm.passwordVisibleIcon : _vm.statusTypeIcon,"pack":_vm.iconPack,"size":_vm.iconSize,"type":!_vm.passwordReveal ? _vm.statusType : 'is-primary',"both":""},nativeOn:{"click":function($event){_vm.togglePasswordVisibility($event);}}}):_vm._e(),_vm._v(" "),(_vm.maxlength && _vm.hasCounter && _vm.type !== 'number')?_c('small',{staticClass:"help counter",class:{ 'is-invisible': !_vm.isFocused }},[_vm._v("\n        "+_vm._s(_vm.valueLength)+" / "+_vm._s(_vm.maxlength)+"\n    ")]):_vm._e()],1)};
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
    

    
    var Input = normalizeComponent_1(
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
      customFormatter: Function
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
        _isAutocomplete: true,
        _elementRef: 'input'
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
      }
    },
    watch: {
      /**
       * When dropdown is toggled, check the visibility to know when
       * to open upwards.
       */
      isActive: function isActive(active) {
        var _this = this;

        if (active) {
          this.calcDropdownInViewportVertical();
        } else {
          this.$nextTick(function () {
            return _this.setHovered(null);
          }); // Timeout to wait for the animation to finish before recalculating

          setTimeout(function () {
            _this.calcDropdownInViewportVertical();
          }, 100);
        }
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
        !this.isValid && this.$refs.input.checkHtml5Validity();
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
        if (option === undefined) return;
        this.selected = option;
        this.$emit('select', this.selected);

        if (this.selected !== null) {
          this.newValue = this.clearOnSelect ? '' : this.getValue(this.selected);
        }

        closeDropdown && this.$nextTick(function () {
          _this2.isActive = false;
        });
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
      enterPressed: function enterPressed() {
        if (this.hovered === null) return;
        this.setSelected(this.hovered);
      },

      /**
       * Tab key listener.
       * Select hovered option if it exists, close dropdown, then allow
       * native handling to move to next tabbable element.
       */
      tabPressed: function tabPressed() {
        if (this.hovered === null) {
          this.isActive = false;
          return;
        }

        this.setSelected(this.hovered);
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
      }
    },
    created: function created() {
      if (typeof window !== 'undefined') {
        document.addEventListener('click', this.clickedOutside);
        window.addEventListener('resize', this.calcDropdownInViewportVertical);
      }
    },
    beforeDestroy: function beforeDestroy() {
      if (typeof window !== 'undefined') {
        document.removeEventListener('click', this.clickedOutside);
        window.removeEventListener('resize', this.calcDropdownInViewportVertical);
      }
    }
  };

  /* script */
  const __vue_script__$2 = script$2;

  /* template */
  var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"autocomplete control",class:{'is-expanded': _vm.expanded}},[_c('b-input',_vm._b({ref:"input",attrs:{"type":"text","size":_vm.size,"loading":_vm.loading,"rounded":_vm.rounded,"icon":_vm.icon,"icon-pack":_vm.iconPack,"maxlength":_vm.maxlength,"autocomplete":_vm.newAutocomplete,"use-html5-validation":_vm.useHtml5Validation},on:{"input":_vm.onInput,"focus":_vm.focused,"blur":_vm.onBlur},nativeOn:{"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"esc",27,$event.key)){ return null; }$event.preventDefault();_vm.isActive = false;},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"tab",9,$event.key)){ return null; }_vm.tabPressed($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.enterPressed($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"up",38,$event.key)){ return null; }$event.preventDefault();_vm.keyArrows('up');},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"down",40,$event.key)){ return null; }$event.preventDefault();_vm.keyArrows('down');}]},model:{value:(_vm.newValue),callback:function ($$v) {_vm.newValue=$$v;},expression:"newValue"}},'b-input',_vm.$attrs,false)),_vm._v(" "),_c('transition',{attrs:{"name":"fade"}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive && (_vm.data.length > 0 || _vm.hasEmptySlot || _vm.hasHeaderSlot)),expression:"isActive && (data.length > 0 || hasEmptySlot || hasHeaderSlot)"}],ref:"dropdown",staticClass:"dropdown-menu",class:{ 'is-opened-top': !_vm.isListInViewportVertically }},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"dropdown-content"},[(_vm.hasHeaderSlot)?_c('div',{staticClass:"dropdown-item"},[_vm._t("header")],2):_vm._e(),_vm._v(" "),_vm._l((_vm.data),function(option,index){return _c('a',{key:index,staticClass:"dropdown-item",class:{ 'is-hovered': option === _vm.hovered },on:{"click":function($event){_vm.setSelected(option);}}},[(_vm.hasDefaultSlot)?_vm._t("default",null,{option:option,index:index}):_c('span',[_vm._v("\n                        "+_vm._s(_vm.getValue(option, true))+"\n                    ")])],2)}),_vm._v(" "),(_vm.data.length === 0 && _vm.hasEmptySlot)?_c('div',{staticClass:"dropdown-item is-disabled"},[_vm._t("empty")],2):_vm._e(),_vm._v(" "),(_vm.hasFooterSlot)?_c('div',{staticClass:"dropdown-item"},[_vm._t("footer")],2):_vm._e()],2)])])],1)};
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
    

    
    var Autocomplete = normalizeComponent_1(
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

  var Plugin = {
    install: function install(Vue) {
      registerComponent(Vue, Autocomplete);
    }
  };
  use(Plugin);

  var script$3 = {
    name: 'BButton',
    components: _defineProperty({}, Icon.name, Icon),
    inheritAttrs: false,
    props: {
      type: [String, Object],
      size: String,
      label: String,
      iconPack: String,
      iconLeft: String,
      iconRight: String,
      rounded: {
        type: Boolean,
        default: function _default() {
          return config$1.defaultButtonRounded;
        }
      },
      loading: Boolean,
      outlined: Boolean,
      expanded: Boolean,
      inverted: Boolean,
      focused: Boolean,
      active: Boolean,
      hovered: Boolean,
      selected: Boolean,
      nativeType: {
        type: String,
        default: 'button',
        validator: function validator(value) {
          return ['button', 'submit', 'reset'].indexOf(value) >= 0;
        }
      },
      tag: {
        type: String,
        default: 'button',
        validator: function validator(value) {
          return ['button', 'a', 'input', 'router-link', 'nuxt-link', 'n-link', 'NuxtLink', 'NLink'].indexOf(value) >= 0;
        }
      }
    },
    computed: {
      iconSize: function iconSize() {
        if (!this.size || this.size === 'is-medium') {
          return 'is-small';
        } else if (this.size === 'is-large') {
          return 'is-medium';
        }

        return this.size;
      }
    }
  };

  /* script */
  const __vue_script__$3 = script$3;

  /* template */
  var __vue_render__$3 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c(_vm.tag,_vm._b({tag:"component",staticClass:"button",class:[_vm.size, _vm.type, {
          'is-rounded': _vm.rounded,
          'is-loading': _vm.loading,
          'is-outlined': _vm.outlined,
          'is-fullwidth': _vm.expanded,
          'is-inverted': _vm.inverted,
          'is-focused': _vm.focused,
          'is-active': _vm.active,
          'is-hovered': _vm.hovered,
          'is-selected': _vm.selected
      }],attrs:{"type":_vm.nativeType},on:{"click":function($event){_vm.$emit('click', $event);}}},'component',_vm.$attrs,false),[(_vm.iconLeft)?_c('b-icon',{attrs:{"pack":_vm.iconPack,"icon":_vm.iconLeft,"size":_vm.iconSize}}):_vm._e(),_vm._v(" "),(_vm.label)?_c('span',[_vm._v(_vm._s(_vm.label))]):(_vm.$slots.default)?_c('span',[_vm._t("default")],2):_vm._e(),_vm._v(" "),(_vm.iconRight)?_c('b-icon',{attrs:{"pack":_vm.iconPack,"icon":_vm.iconRight,"size":_vm.iconSize}}):_vm._e()],1)};
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
    

    
    var Button = normalizeComponent_1(
      { render: __vue_render__$3, staticRenderFns: __vue_staticRenderFns__$3 },
      __vue_inject_styles__$3,
      __vue_script__$3,
      __vue_scope_id__$3,
      __vue_is_functional_template__$3,
      __vue_module_identifier__$3,
      undefined,
      undefined
    );

  var Plugin$1 = {
    install: function install(Vue) {
      registerComponent(Vue, Button);
    }
  };
  use(Plugin$1);

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
  var script$4 = {
    name: 'BCheckbox',
    props: {
      value: [String, Number, Boolean, Function, Object, Array],
      nativeValue: [String, Number, Boolean, Function, Object, Array],
      indeterminate: Boolean,
      type: String,
      disabled: Boolean,
      required: Boolean,
      name: String,
      size: String,
      trueValue: {
        type: [String, Number, Boolean, Function, Object, Array],
        default: true
      },
      falseValue: {
        type: [String, Number, Boolean, Function, Object, Array],
        default: false
      }
    },
    data: function data() {
      return {
        newValue: this.value
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
        }
      }
    },
    watch: {
      /**
       * When v-model change, set internal value.
       */
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      focus: function focus() {
        // MacOS FireFox and Safari do not focus when clicked
        this.$refs.input.focus();
      }
    }
  };

  /* script */
  const __vue_script__$4 = script$4;

  /* template */
  var __vue_render__$4 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('label',{ref:"label",staticClass:"b-checkbox checkbox",class:[_vm.size, { 'is-disabled': _vm.disabled }],attrs:{"disabled":_vm.disabled},on:{"click":_vm.focus,"keydown":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.$refs.label.click();}}},[_c('input',{directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"input",attrs:{"type":"checkbox","disabled":_vm.disabled,"required":_vm.required,"name":_vm.name,"true-value":_vm.trueValue,"false-value":_vm.falseValue},domProps:{"indeterminate":_vm.indeterminate,"value":_vm.nativeValue,"checked":Array.isArray(_vm.computedValue)?_vm._i(_vm.computedValue,_vm.nativeValue)>-1:_vm._q(_vm.computedValue,_vm.trueValue)},on:{"click":function($event){$event.stopPropagation();},"change":function($event){var $$a=_vm.computedValue,$$el=$event.target,$$c=$$el.checked?(_vm.trueValue):(_vm.falseValue);if(Array.isArray($$a)){var $$v=_vm.nativeValue,$$i=_vm._i($$a,$$v);if($$el.checked){$$i<0&&(_vm.computedValue=$$a.concat([$$v]));}else{$$i>-1&&(_vm.computedValue=$$a.slice(0,$$i).concat($$a.slice($$i+1)));}}else{_vm.computedValue=$$c;}}}}),_vm._v(" "),_c('span',{staticClass:"check",class:_vm.type}),_vm._v(" "),_c('span',{staticClass:"control-label"},[_vm._t("default")],2)])};
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
    

    
    var Checkbox = normalizeComponent_1(
      { render: __vue_render__$4, staticRenderFns: __vue_staticRenderFns__$4 },
      __vue_inject_styles__$4,
      __vue_script__$4,
      __vue_scope_id__$4,
      __vue_is_functional_template__$4,
      __vue_module_identifier__$4,
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
  //
  //
  //
  //
  //
  //
  //
  var script$5 = {
    name: 'BCheckboxButton',
    props: {
      value: [String, Number, Boolean, Function, Object, Array],
      nativeValue: [String, Number, Boolean, Function, Object, Array],
      disabled: Boolean,
      required: Boolean,
      expanded: Boolean,
      name: String,
      size: String,
      type: {
        type: String,
        default: 'is-primary'
      }
    },
    data: function data() {
      return {
        newValue: this.value,
        isFocused: false
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
        }
      },
      checked: function checked() {
        if (Array.isArray(this.newValue)) {
          return this.newValue.indexOf(this.nativeValue) >= 0;
        }

        return this.newValue === this.nativeValue;
      }
    },
    watch: {
      /**
       * When v-model change, set internal value.
       */
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      focus: function focus() {
        // MacOS FireFox and Safari do not focus when clicked
        this.$refs.input.focus();
      }
    }
  };

  /* script */
  const __vue_script__$5 = script$5;

  /* template */
  var __vue_render__$5 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:{ 'is-expanded': _vm.expanded }},[_c('label',{ref:"label",staticClass:"b-checkbox checkbox button",class:[_vm.checked ? _vm.type : null, _vm.size, {
              'is-disabled': _vm.disabled,
              'is-focused': _vm.isFocused
          }],attrs:{"disabled":_vm.disabled},on:{"click":_vm.focus,"keydown":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.$refs.label.click();}}},[_vm._t("default"),_vm._v(" "),_c('input',{directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"input",attrs:{"type":"checkbox","disabled":_vm.disabled,"required":_vm.required,"name":_vm.name},domProps:{"value":_vm.nativeValue,"checked":Array.isArray(_vm.computedValue)?_vm._i(_vm.computedValue,_vm.nativeValue)>-1:(_vm.computedValue)},on:{"click":function($event){$event.stopPropagation();},"focus":function($event){_vm.isFocused = true;},"blur":function($event){_vm.isFocused = false;},"change":function($event){var $$a=_vm.computedValue,$$el=$event.target,$$c=$$el.checked?(true):(false);if(Array.isArray($$a)){var $$v=_vm.nativeValue,$$i=_vm._i($$a,$$v);if($$el.checked){$$i<0&&(_vm.computedValue=$$a.concat([$$v]));}else{$$i>-1&&(_vm.computedValue=$$a.slice(0,$$i).concat($$a.slice($$i+1)));}}else{_vm.computedValue=$$c;}}}})],2)])};
  var __vue_staticRenderFns__$5 = [];

    /* style */
    const __vue_inject_styles__$5 = undefined;
    /* scoped */
    const __vue_scope_id__$5 = undefined;
    /* module identifier */
    const __vue_module_identifier__$5 = undefined;
    /* functional template */
    const __vue_is_functional_template__$5 = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var CheckboxButton = normalizeComponent_1(
      { render: __vue_render__$5, staticRenderFns: __vue_staticRenderFns__$5 },
      __vue_inject_styles__$5,
      __vue_script__$5,
      __vue_scope_id__$5,
      __vue_is_functional_template__$5,
      __vue_module_identifier__$5,
      undefined,
      undefined
    );

  var Plugin$2 = {
    install: function install(Vue) {
      registerComponent(Vue, Checkbox);
      registerComponent(Vue, CheckboxButton);
    }
  };
  use(Plugin$2);

  var script$6 = {
    name: 'BCollapse',
    props: {
      open: {
        type: Boolean,
        default: true
      },
      animation: {
        type: String,
        default: 'fade'
      },
      ariaId: {
        type: String,
        default: ''
      },
      position: {
        type: String,
        default: 'is-top',
        validator: function validator(value) {
          return ['is-top', 'is-bottom'].indexOf(value) > -1;
        }
      }
    },
    data: function data() {
      return {
        isOpen: this.open
      };
    },
    watch: {
      open: function open(value) {
        this.isOpen = value;
      }
    },
    methods: {
      /**
      * Toggle and emit events
      */
      toggle: function toggle() {
        this.isOpen = !this.isOpen;
        this.$emit('update:open', this.isOpen);
        this.$emit(this.isOpen ? 'open' : 'close');
      }
    },
    render: function render(createElement) {
      var trigger = createElement('div', {
        staticClass: 'collapse-trigger',
        on: {
          click: this.toggle
        }
      }, this.$scopedSlots.trigger ? [this.$scopedSlots.trigger({
        open: this.isOpen
      })] : [this.$slots.trigger]);
      var content = createElement('transition', {
        props: {
          name: this.animation
        }
      }, [createElement('div', {
        staticClass: 'collapse-content',
        attrs: {
          'id': this.ariaId,
          'aria-expanded': this.isOpen
        },
        directives: [{
          name: 'show',
          value: this.isOpen
        }]
      }, this.$slots.default)]);
      return createElement('div', {
        staticClass: 'collapse'
      }, this.position === 'is-top' ? [trigger, content] : [content, trigger]);
    }
  };

  /* script */
  const __vue_script__$6 = script$6;

  /* template */

    /* style */
    const __vue_inject_styles__$6 = undefined;
    /* scoped */
    const __vue_scope_id__$6 = undefined;
    /* module identifier */
    const __vue_module_identifier__$6 = undefined;
    /* functional template */
    const __vue_is_functional_template__$6 = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Collapse = normalizeComponent_1(
      {},
      __vue_inject_styles__$6,
      __vue_script__$6,
      __vue_scope_id__$6,
      __vue_is_functional_template__$6,
      __vue_module_identifier__$6,
      undefined,
      undefined
    );

  var Plugin$3 = {
    install: function install(Vue) {
      registerComponent(Vue, Collapse);
    }
  };
  use(Plugin$3);

  var AM = 'AM';
  var PM = 'PM';
  var HOUR_FORMAT_24 = '24';
  var HOUR_FORMAT_12 = '12';

  var defaultTimeFormatter = function defaultTimeFormatter(date, vm) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();
    var period = '';

    if (vm.hourFormat === HOUR_FORMAT_12) {
      period = ' ' + (hours < 12 ? AM : PM);

      if (hours > 12) {
        hours -= 12;
      } else if (hours === 0) {
        hours = 12;
      }
    }

    return vm.pad(hours) + ':' + vm.pad(minutes) + (vm.enableSeconds ? ':' + vm.pad(seconds) : '') + period;
  };

  var defaultTimeParser = function defaultTimeParser(timeString, vm) {
    if (timeString) {
      var am = false;

      if (vm.hourFormat === HOUR_FORMAT_12) {
        var dateString12 = timeString.split(' ');
        timeString = dateString12[0];
        am = dateString12[1] === AM;
      }

      var time = timeString.split(':');
      var hours = parseInt(time[0], 10);
      var minutes = parseInt(time[1], 10);
      var seconds = vm.enableSeconds ? parseInt(time[2], 10) : 0;

      if (isNaN(hours) || hours < 0 || hours > 23 || vm.hourFormat === HOUR_FORMAT_12 && (hours < 1 || hours > 12) || isNaN(minutes) || minutes < 0 || minutes > 59) {
        return null;
      }

      var d = null;

      if (vm.computedValue && !isNaN(vm.computedValue)) {
        d = new Date(vm.computedValue);
      } else {
        d = new Date();
        d.setMilliseconds(0);
      }

      d.setSeconds(seconds);
      d.setMinutes(minutes);

      if (vm.hourFormat === HOUR_FORMAT_12) {
        if (am && hours === 12) {
          hours = 0;
        } else if (!am && hours !== 12) {
          hours += 12;
        }
      }

      d.setHours(hours);
      return new Date(d.getTime());
    }

    return null;
  };

  var TimepickerMixin = {
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: Date,
      inline: Boolean,
      minTime: Date,
      maxTime: Date,
      placeholder: String,
      editable: Boolean,
      disabled: Boolean,
      hourFormat: {
        type: String,
        default: HOUR_FORMAT_24,
        validator: function validator(value) {
          return value === HOUR_FORMAT_24 || value === HOUR_FORMAT_12;
        }
      },
      incrementMinutes: {
        type: Number,
        default: 1
      },
      incrementSeconds: {
        type: Number,
        default: 1
      },
      timeFormatter: {
        type: Function,
        default: function _default(date, vm) {
          if (typeof config$1.defaultTimeFormatter === 'function') {
            return config$1.defaultTimeFormatter(date);
          } else {
            return defaultTimeFormatter(date, vm);
          }
        }
      },
      timeParser: {
        type: Function,
        default: function _default(date, vm) {
          if (typeof config$1.defaultTimeParser === 'function') {
            return config$1.defaultTimeParser(date);
          } else {
            return defaultTimeParser(date, vm);
          }
        }
      },
      mobileNative: {
        type: Boolean,
        default: function _default() {
          return config$1.defaultTimepickerMobileNative;
        }
      },
      position: String,
      unselectableTimes: Array,
      openOnFocus: Boolean,
      enableSeconds: Boolean,
      defaultMinutes: Number,
      defaultSeconds: Number
    },
    data: function data() {
      return {
        dateSelected: this.value,
        hoursSelected: null,
        minutesSelected: null,
        secondsSelected: null,
        meridienSelected: null,
        _elementRef: 'input',
        AM: AM,
        PM: PM,
        HOUR_FORMAT_24: HOUR_FORMAT_24,
        HOUR_FORMAT_12: HOUR_FORMAT_12
      };
    },
    computed: {
      computedValue: {
        get: function get() {
          return this.dateSelected;
        },
        set: function set(value) {
          this.dateSelected = value;
          this.$emit('input', value);
        }
      },
      hours: function hours() {
        var hours = [];
        var numberOfHours = this.isHourFormat24 ? 24 : 12;

        for (var i = 0; i < numberOfHours; i++) {
          var value = i;
          var label = value;

          if (!this.isHourFormat24) {
            value = i + 1;
            label = value;

            if (this.meridienSelected === this.AM) {
              if (value === 12) {
                value = 0;
              }
            } else if (this.meridienSelected === this.PM) {
              if (value !== 12) {
                value += 12;
              }
            }
          }

          hours.push({
            label: this.formatNumber(label),
            value: value
          });
        }

        return hours;
      },
      minutes: function minutes() {
        var minutes = [];

        for (var i = 0; i < 60; i += this.incrementMinutes) {
          minutes.push({
            label: this.formatNumber(i, true),
            value: i
          });
        }

        return minutes;
      },
      seconds: function seconds() {
        var seconds = [];

        for (var i = 0; i < 60; i += this.incrementSeconds) {
          seconds.push({
            label: this.formatNumber(i, true),
            value: i
          });
        }

        return seconds;
      },
      meridiens: function meridiens() {
        return [AM, PM];
      },
      isMobile: function isMobile$1() {
        return this.mobileNative && isMobile.any();
      },
      isHourFormat24: function isHourFormat24() {
        return this.hourFormat === HOUR_FORMAT_24;
      }
    },
    watch: {
      hourFormat: function hourFormat() {
        if (this.hoursSelected !== null) {
          this.meridienSelected = this.hoursSelected >= 12 ? PM : AM;
        }
      },

      /**
       * When v-model is changed:
       *   1. Update internal value.
       *   2. If it's invalid, validate again.
       */
      value: {
        handler: function handler(value) {
          this.updateInternalState(value);
          !this.isValid && this.$refs.input.checkHtml5Validity();
        },
        immediate: true
      }
    },
    methods: {
      onMeridienChange: function onMeridienChange(value) {
        if (this.hoursSelected !== null) {
          if (value === PM) {
            this.hoursSelected += 12;
          } else if (value === AM) {
            this.hoursSelected -= 12;
          }
        }

        this.updateDateSelected(this.hoursSelected, this.minutesSelected, this.enableSeconds ? this.secondsSelected : 0, value);
      },
      onHoursChange: function onHoursChange(value) {
        if (!this.minutesSelected && typeof this.defaultMinutes !== 'undefined') {
          this.minutesSelected = this.defaultMinutes;
        }

        if (!this.secondsSelected && typeof this.defaultSeconds !== 'undefined') {
          this.secondsSelected = this.defaultSeconds;
        }

        this.updateDateSelected(parseInt(value, 10), this.minutesSelected, this.enableSeconds ? this.secondsSelected : 0, this.meridienSelected);
      },
      onMinutesChange: function onMinutesChange(value) {
        if (!this.secondsSelected && this.defaultSeconds) {
          this.secondsSelected = this.defaultSeconds;
        }

        this.updateDateSelected(this.hoursSelected, parseInt(value, 10), this.enableSeconds ? this.secondsSelected : 0, this.meridienSelected);
      },
      onSecondsChange: function onSecondsChange(value) {
        this.updateDateSelected(this.hoursSelected, this.minutesSelected, parseInt(value, 10), this.meridienSelected);
      },
      updateDateSelected: function updateDateSelected(hours, minutes, seconds, meridiens) {
        if (hours != null && minutes != null && (!this.isHourFormat24 && meridiens !== null || this.isHourFormat24)) {
          var time = null;

          if (this.computedValue && !isNaN(this.computedValue)) {
            time = new Date(this.computedValue);
          } else {
            time = new Date();
            time.setMilliseconds(0);
          }

          time.setHours(hours);
          time.setMinutes(minutes);
          time.setSeconds(seconds);
          this.computedValue = new Date(time.getTime());
        }
      },
      updateInternalState: function updateInternalState(value) {
        if (value) {
          this.hoursSelected = value.getHours();
          this.minutesSelected = value.getMinutes();
          this.secondsSelected = value.getSeconds();
          this.meridienSelected = value.getHours() >= 12 ? PM : AM;
        } else {
          this.hoursSelected = null;
          this.minutesSelected = null;
          this.secondsSelected = null;
          this.meridienSelected = AM;
        }

        this.dateSelected = value;
      },
      isHourDisabled: function isHourDisabled(hour) {
        var _this = this;

        var disabled = false;

        if (this.minTime) {
          var minHours = this.minTime.getHours();
          var noMinutesAvailable = this.minutes.every(function (minute) {
            return _this.isMinuteDisabledForHour(hour, minute.value);
          });
          disabled = hour < minHours || noMinutesAvailable;
        }

        if (this.maxTime) {
          if (!disabled) {
            var maxHours = this.maxTime.getHours();
            disabled = hour > maxHours;
          }
        }

        if (this.unselectableTimes) {
          if (!disabled) {
            var unselectable = this.unselectableTimes.filter(function (time) {
              if (_this.enableSeconds && _this.secondsSelected !== null) {
                return time.getHours() === hour && time.getMinutes() === _this.minutesSelected && time.getSeconds() === _this.secondsSelected;
              } else if (_this.minutesSelected !== null) {
                return time.getHours() === hour && time.getMinutes() === _this.minutesSelected;
              } else {
                return time.getHours() === hour;
              }
            });
            disabled = unselectable.length > 0;
          }
        }

        return disabled;
      },
      isMinuteDisabledForHour: function isMinuteDisabledForHour(hour, minute) {
        var disabled = false;

        if (this.minTime) {
          var minHours = this.minTime.getHours();
          var minMinutes = this.minTime.getMinutes();
          disabled = hour === minHours && minute < minMinutes;
        }

        if (this.maxTime) {
          if (!disabled) {
            var maxHours = this.maxTime.getHours();
            var maxMinutes = this.maxTime.getMinutes();
            disabled = hour === maxHours && minute > maxMinutes;
          }
        }

        return disabled;
      },
      isMinuteDisabled: function isMinuteDisabled(minute) {
        var _this2 = this;

        var disabled = false;

        if (this.hoursSelected !== null) {
          if (this.isHourDisabled(this.hoursSelected)) {
            disabled = true;
          } else {
            disabled = this.isMinuteDisabledForHour(this.hoursSelected, minute);
          }

          if (this.unselectableTimes) {
            if (!disabled) {
              var unselectable = this.unselectableTimes.filter(function (time) {
                if (_this2.enableSeconds && _this2.secondsSelected !== null) {
                  return time.getHours() === _this2.hoursSelected && time.getMinutes() === minute && time.getSeconds() === _this2.secondsSelected;
                } else {
                  return time.getHours() === _this2.hoursSelected && time.getMinutes() === minute;
                }
              });
              disabled = unselectable.length > 0;
            }
          }
        }

        return disabled;
      },
      isSecondDisabled: function isSecondDisabled(second) {
        var _this3 = this;

        var disabled = false;

        if (this.minutesSelected !== null) {
          if (this.isMinuteDisabled(this.minutesSelected)) {
            disabled = true;
          } else {
            if (this.minTime) {
              var minHours = this.minTime.getHours();
              var minMinutes = this.minTime.getMinutes();
              var minSeconds = this.minTime.getSeconds();
              disabled = this.hoursSelected === minHours && this.minutesSelected === minMinutes && second < minSeconds;
            }

            if (this.maxTime) {
              if (!disabled) {
                var maxHours = this.maxTime.getHours();
                var maxMinutes = this.maxTime.getMinutes();
                var maxSeconds = this.maxTime.getSeconds();
                disabled = this.hoursSelected === maxHours && this.minutesSelected === maxMinutes && second > maxSeconds;
              }
            }
          }

          if (this.unselectableTimes) {
            if (!disabled) {
              var unselectable = this.unselectableTimes.filter(function (time) {
                return time.getHours() === _this3.hoursSelected && time.getMinutes() === _this3.minutesSelected && time.getSeconds() === second;
              });
              disabled = unselectable.length > 0;
            }
          }
        }

        return disabled;
      },

      /*
      * Parse string into date
      */
      onChange: function onChange(value) {
        var date = this.timeParser(value, this);
        this.updateInternalState(date);

        if (date && !isNaN(date)) {
          this.computedValue = date;
        } else {
          // Force refresh input value when not valid date
          this.computedValue = null;
          this.$refs.input.newValue = this.computedValue;
        }
      },

      /*
      * Toggle timepicker
      */
      toggle: function toggle(active) {
        if (this.$refs.dropdown) {
          this.$refs.dropdown.isActive = typeof active === 'boolean' ? active : !this.$refs.dropdown.isActive;
        }
      },

      /*
      * Close timepicker
      */
      close: function close() {
        this.toggle(false);
      },

      /*
      * Call default onFocus method and show timepicker
      */
      handleOnFocus: function handleOnFocus() {
        this.onFocus();

        if (this.openOnFocus) {
          this.toggle(true);
        }
      },

      /*
      * Format date into string 'HH-MM-SS'
      */
      formatHHMMSS: function formatHHMMSS(value) {
        var date = new Date(value);

        if (value && !isNaN(date)) {
          var hours = date.getHours();
          var minutes = date.getMinutes();
          var seconds = date.getSeconds();
          return this.formatNumber(hours, true) + ':' + this.formatNumber(minutes, true) + ':' + this.formatNumber(seconds, true);
        }

        return '';
      },

      /*
      * Parse time from string
      */
      onChangeNativePicker: function onChangeNativePicker(event) {
        var date = event.target.value;

        if (date) {
          var time = null;

          if (this.computedValue && !isNaN(this.computedValue)) {
            time = new Date(this.computedValue);
          } else {
            time = new Date();
            time.setMilliseconds(0);
          }

          var t = date.split(':');
          time.setHours(parseInt(t[0], 10));
          time.setMinutes(parseInt(t[1], 10));
          time.setSeconds(t[2] ? parseInt(t[2], 10) : 0);
          this.computedValue = new Date(time.getTime());
        } else {
          this.computedValue = null;
        }
      },
      formatNumber: function formatNumber(value, prependZero) {
        return this.isHourFormat24 || prependZero ? this.pad(value) : value;
      },
      pad: function pad(value) {
        return (value < 10 ? '0' : '') + value;
      },

      /*
      * Format date into string
      */
      formatValue: function formatValue(date) {
        if (date && !isNaN(date)) {
          return this.timeFormatter(date, this);
        } else {
          return null;
        }
      },

      /**
       * Keypress event that is bound to the document.
       */
      keyPress: function keyPress(event) {
        // Esc key
        if (this.$refs.dropdown && this.$refs.dropdown.isActive && event.keyCode === 27) {
          this.toggle(false);
        }
      }
    },
    created: function created() {
      if (typeof window !== 'undefined') {
        document.addEventListener('keyup', this.keyPress);
      }
    },
    beforeDestroy: function beforeDestroy() {
      if (typeof window !== 'undefined') {
        document.removeEventListener('keyup', this.keyPress);
      }
    }
  };

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

  //
  var DEFAULT_CLOSE_OPTIONS = ['escape', 'outside'];
  var script$7 = {
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

  /* script */
  const __vue_script__$7 = script$7;

  /* template */
  var __vue_render__$6 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"dropdown",class:_vm.rootClasses},[(!_vm.inline)?_c('div',{ref:"trigger",staticClass:"dropdown-trigger",attrs:{"role":"button","aria-haspopup":"true"},on:{"click":_vm.toggle}},[_vm._t("trigger")],2):_vm._e(),_vm._v(" "),_c('transition',{attrs:{"name":_vm.animation}},[(_vm.isMobileModal)?_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"background",attrs:{"aria-hidden":!_vm.isActive}}):_vm._e()]),_vm._v(" "),_c('transition',{attrs:{"name":_vm.animation}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:((!_vm.disabled && (_vm.isActive || _vm.isHoverable)) || _vm.inline),expression:"(!disabled && (isActive || isHoverable)) || inline"},{name:"trap-focus",rawName:"v-trap-focus",value:(_vm.trapFocus),expression:"trapFocus"}],ref:"dropdownMenu",staticClass:"dropdown-menu",attrs:{"aria-hidden":!_vm.isActive}},[_c('div',{staticClass:"dropdown-content",attrs:{"role":_vm.ariaRoleMenu}},[_vm._t("default")],2)])])],1)};
  var __vue_staticRenderFns__$6 = [];

    /* style */
    const __vue_inject_styles__$7 = undefined;
    /* scoped */
    const __vue_scope_id__$7 = undefined;
    /* module identifier */
    const __vue_module_identifier__$7 = undefined;
    /* functional template */
    const __vue_is_functional_template__$7 = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Dropdown = normalizeComponent_1(
      { render: __vue_render__$6, staticRenderFns: __vue_staticRenderFns__$6 },
      __vue_inject_styles__$7,
      __vue_script__$7,
      __vue_scope_id__$7,
      __vue_is_functional_template__$7,
      __vue_module_identifier__$7,
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
  var script$8 = {
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
  const __vue_script__$8 = script$8;

  /* template */
  var __vue_render__$7 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (_vm.separator)?_c('hr',{staticClass:"dropdown-divider"}):(!_vm.custom && !_vm.hasLink)?_c('a',{staticClass:"dropdown-item",class:_vm.anchorClasses,attrs:{"role":_vm.ariaRoleItem,"tabindex":_vm.focusable ? 0 : null},on:{"click":_vm.selectItem}},[_vm._t("default")],2):_c('div',{class:_vm.itemClasses,attrs:{"role":_vm.ariaRoleItem,"tabindex":_vm.focusable ? 0 : null},on:{"click":_vm.selectItem}},[_vm._t("default")],2)};
  var __vue_staticRenderFns__$7 = [];

    /* style */
    const __vue_inject_styles__$8 = undefined;
    /* scoped */
    const __vue_scope_id__$8 = undefined;
    /* module identifier */
    const __vue_module_identifier__$8 = undefined;
    /* functional template */
    const __vue_is_functional_template__$8 = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var DropdownItem = normalizeComponent_1(
      { render: __vue_render__$7, staticRenderFns: __vue_staticRenderFns__$7 },
      __vue_inject_styles__$8,
      __vue_script__$8,
      __vue_scope_id__$8,
      __vue_is_functional_template__$8,
      __vue_module_identifier__$8,
      undefined,
      undefined
    );

  var script$9 = {
    name: 'BFieldBody',
    props: {
      message: {
        type: String
      },
      type: {
        type: [String, Object]
      }
    },
    render: function render(createElement) {
      var _this = this;

      return createElement('div', {
        attrs: {
          'class': 'field-body'
        }
      }, this.$slots.default.map(function (element) {
        // skip returns and comments
        if (!element.tag) {
          return element;
        }

        if (_this.message) {
          return createElement('b-field', {
            attrs: {
              message: _this.message,
              'type': _this.type
            }
          }, [element]);
        }

        return createElement('b-field', {
          attrs: {
            'type': _this.type
          }
        }, [element]);
      }));
    }
  };

  /* script */
  const __vue_script__$9 = script$9;

  /* template */

    /* style */
    const __vue_inject_styles__$9 = undefined;
    /* scoped */
    const __vue_scope_id__$9 = undefined;
    /* module identifier */
    const __vue_module_identifier__$9 = undefined;
    /* functional template */
    const __vue_is_functional_template__$9 = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var FieldBody = normalizeComponent_1(
      {},
      __vue_inject_styles__$9,
      __vue_script__$9,
      __vue_scope_id__$9,
      __vue_is_functional_template__$9,
      __vue_module_identifier__$9,
      undefined,
      undefined
    );

  var script$a = {
    name: 'BField',
    components: _defineProperty({}, FieldBody.name, FieldBody),
    props: {
      type: [String, Object],
      label: String,
      labelFor: String,
      message: [String, Array, Object],
      grouped: Boolean,
      groupMultiline: Boolean,
      position: String,
      expanded: Boolean,
      horizontal: Boolean,
      addons: {
        type: Boolean,
        default: true
      },
      customClass: String,
      labelPosition: {
        type: String,
        default: function _default() {
          return config$1.defaultFieldLabelPosition;
        }
      }
    },
    data: function data() {
      return {
        newType: this.type,
        newMessage: this.message,
        fieldLabelSize: null,
        _isField: true // Used internally by Input and Select

      };
    },
    computed: {
      rootClasses: function rootClasses() {
        return [this.newPosition, {
          'is-expanded': this.expanded,
          'is-grouped-multiline': this.groupMultiline,
          'is-horizontal': this.horizontal,
          'is-floating-in-label': this.hasLabel && !this.horizontal && this.labelPosition === 'inside',
          'is-floating-label': this.hasLabel && !this.horizontal && this.labelPosition === 'on-border'
        }, this.numberInputClasses];
      },

      /**
      * Correct Bulma class for the side of the addon or group.
      *
      * This is not kept like the others (is-small, etc.),
      * because since 'has-addons' is set automatically it
      * doesn't make sense to teach users what addons are exactly.
      */
      newPosition: function newPosition() {
        if (this.position === undefined) return;
        var position = this.position.split('-');
        if (position.length < 1) return;
        var prefix = this.grouped ? 'is-grouped-' : 'has-addons-';
        if (this.position) return prefix + position[1];
      },

      /**
      * Formatted message in case it's an array
      * (each element is separated by <br> tag)
      */
      formattedMessage: function formattedMessage() {
        if (typeof this.newMessage === 'string') {
          return this.newMessage;
        } else {
          var messages = [];

          if (Array.isArray(this.newMessage)) {
            this.newMessage.forEach(function (message) {
              if (typeof message === 'string') {
                messages.push(message);
              } else {
                for (var key in message) {
                  if (message[key]) {
                    messages.push(key);
                  }
                }
              }
            });
          } else {
            for (var key in this.newMessage) {
              if (this.newMessage[key]) {
                messages.push(key);
              }
            }
          }

          return messages.filter(function (m) {
            if (m) return m;
          }).join(' <br> ');
        }
      },
      hasLabel: function hasLabel() {
        return this.label || this.$slots.label;
      },
      numberInputClasses: function numberInputClasses() {
        if (this.$slots.default) {
          var numberinput = this.$slots.default.filter(function (node) {
            return node.tag && node.tag.toLowerCase().indexOf('numberinput') >= 0;
          })[0];

          if (numberinput) {
            var classes = ['has-numberinput'];
            var controlsPosition = numberinput.componentOptions.propsData.controlsPosition;
            var size = numberinput.componentOptions.propsData.size;

            if (controlsPosition) {
              classes.push("has-numberinput-".concat(controlsPosition));
            }

            if (size) {
              classes.push("has-numberinput-".concat(size));
            }

            return classes;
          }
        }

        return null;
      }
    },
    watch: {
      /**
      * Set internal type when prop change.
      */
      type: function type(value) {
        this.newType = value;
      },

      /**
      * Set internal message when prop change.
      */
      message: function message(value) {
        this.newMessage = value;
      }
    },
    methods: {
      /**
      * Field has addons if there are more than one slot
      * (element / component) in the Field.
      * Or is grouped when prop is set.
      * Is a method to be called when component re-render.
      */
      fieldType: function fieldType() {
        if (this.grouped) return 'is-grouped';
        var renderedNode = 0;

        if (this.$slots.default) {
          renderedNode = this.$slots.default.reduce(function (i, node) {
            return node.tag ? i + 1 : i;
          }, 0);
        }

        if (renderedNode > 1 && this.addons && !this.horizontal) {
          return 'has-addons';
        }
      }
    },
    mounted: function mounted() {
      if (this.horizontal) {
        // Bulma docs: .is-normal for any .input or .button
        var elements = this.$el.querySelectorAll('.input, .select, .button, .textarea, .b-slider');

        if (elements.length > 0) {
          this.fieldLabelSize = 'is-normal';
        }
      }
    }
  };

  /* script */
  const __vue_script__$a = script$a;

  /* template */
  var __vue_render__$8 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"field",class:[_vm.rootClasses, _vm.fieldType()]},[(_vm.horizontal)?_c('div',{staticClass:"field-label",class:[_vm.customClass, _vm.fieldLabelSize]},[(_vm.hasLabel)?_c('label',{staticClass:"label",class:_vm.customClass,attrs:{"for":_vm.labelFor}},[(_vm.$slots.label)?_vm._t("label"):[_vm._v(_vm._s(_vm.label))]],2):_vm._e()]):[(_vm.hasLabel)?_c('label',{staticClass:"label",class:_vm.customClass,attrs:{"for":_vm.labelFor}},[(_vm.$slots.label)?_vm._t("label"):[_vm._v(_vm._s(_vm.label))]],2):_vm._e()],_vm._v(" "),(_vm.horizontal)?_c('b-field-body',{attrs:{"message":_vm.newMessage ? _vm.formattedMessage : '',"type":_vm.newType}},[_vm._t("default")],2):[_vm._t("default")],_vm._v(" "),(_vm.newMessage && !_vm.horizontal)?_c('p',{staticClass:"help",class:_vm.newType,domProps:{"innerHTML":_vm._s(_vm.formattedMessage)}}):_vm._e()],2)};
  var __vue_staticRenderFns__$8 = [];

    /* style */
    const __vue_inject_styles__$a = undefined;
    /* scoped */
    const __vue_scope_id__$a = undefined;
    /* module identifier */
    const __vue_module_identifier__$a = undefined;
    /* functional template */
    const __vue_is_functional_template__$a = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Field = normalizeComponent_1(
      { render: __vue_render__$8, staticRenderFns: __vue_staticRenderFns__$8 },
      __vue_inject_styles__$a,
      __vue_script__$a,
      __vue_scope_id__$a,
      __vue_is_functional_template__$a,
      __vue_module_identifier__$a,
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
  //
  //
  //
  //
  //
  //
  // These should match the variables in clockpicker.scss
  var indicatorSize = 40;
  var paddingInner = 5;
  var script$b = {
    name: 'BClockpickerFace',
    props: {
      pickerSize: Number,
      min: Number,
      max: Number,
      double: Boolean,
      value: Number,
      faceNumbers: Array,
      disabledValues: Function
    },
    data: function data() {
      return {
        isDragging: false,
        inputValue: this.value,
        prevAngle: 720
      };
    },
    computed: {
      /**
      * How many number indicators are shown on the face
      */
      count: function count() {
        return this.max - this.min + 1;
      },

      /**
      * How many number indicators are shown per ring on the face
      */
      countPerRing: function countPerRing() {
        return this.double ? this.count / 2 : this.count;
      },

      /**
      * Radius of the clock face
      */
      radius: function radius() {
        return this.pickerSize / 2;
      },

      /**
      * Radius of the outer ring of number indicators
      */
      outerRadius: function outerRadius() {
        return this.radius - paddingInner - indicatorSize / 2;
      },

      /**
      * Radius of the inner ring of number indicators
      */
      innerRadius: function innerRadius() {
        return Math.max(this.outerRadius * 0.6, this.outerRadius - paddingInner - indicatorSize); // 48px gives enough room for the outer ring of numbers
      },

      /**
      * The angle for each selectable value
      * For hours this ends up being 30 degrees, for minutes 6 degrees
      */
      degreesPerUnit: function degreesPerUnit() {
        return 360 / this.countPerRing;
      },

      /**
      * Used for calculating x/y grid location based on degrees
      */
      degrees: function degrees() {
        return this.degreesPerUnit * Math.PI / 180;
      },

      /**
      * Calculates the angle the clock hand should be rotated for the
      * selected value
      */
      handRotateAngle: function handRotateAngle() {
        var currentAngle = this.prevAngle;

        while (currentAngle < 0) {
          currentAngle += 360;
        }

        var targetAngle = this.calcHandAngle(this.displayedValue);
        var degreesDiff = this.shortestDistanceDegrees(currentAngle, targetAngle);
        var angle = this.prevAngle + degreesDiff;
        return angle;
      },

      /**
      * Determines how long the selector hand is based on if the
      * selected value is located along the outer or inner ring
      */
      handScale: function handScale() {
        return this.calcHandScale(this.displayedValue);
      },
      handStyle: function handStyle() {
        return {
          transform: "rotate(".concat(this.handRotateAngle, "deg) scaleY(").concat(this.handScale, ")"),
          transition: '.3s cubic-bezier(.25,.8,.50,1)'
        };
      },

      /**
      * The value the hand should be pointing at
      */
      displayedValue: function displayedValue() {
        return this.inputValue == null ? this.min : this.inputValue;
      }
    },
    watch: {
      value: function value(_value) {
        if (_value !== this.inputValue) {
          this.prevAngle = this.handRotateAngle;
        }

        this.inputValue = _value;
      }
    },
    methods: {
      isDisabled: function isDisabled(value) {
        return this.disabledValues && this.disabledValues(value);
      },

      /**
      * Calculates the distance between two points
      */
      euclidean: function euclidean(p0, p1) {
        var dx = p1.x - p0.x;
        var dy = p1.y - p0.y;
        return Math.sqrt(dx * dx + dy * dy);
      },
      shortestDistanceDegrees: function shortestDistanceDegrees(start, stop) {
        var modDiff = (stop - start) % 360;
        var shortestDistance = 180 - Math.abs(Math.abs(modDiff) - 180);
        return (modDiff + 360) % 360 < 180 ? shortestDistance * 1 : shortestDistance * -1;
      },

      /**
      * Calculates the angle of the line from the center point
      * to the given point.
      */
      coordToAngle: function coordToAngle(center, p1) {
        var value = 2 * Math.atan2(p1.y - center.y - this.euclidean(center, p1), p1.x - center.x);
        return Math.abs(value * 180 / Math.PI);
      },

      /**
      * Generates the inline style translate() property for a
      * number indicator, which determines it's location on the
      * clock face
      */
      getNumberTranslate: function getNumberTranslate(value) {
        var _this$getNumberCoords = this.getNumberCoords(value),
            x = _this$getNumberCoords.x,
            y = _this$getNumberCoords.y;

        return "translate(".concat(x, "px, ").concat(y, "px)");
      },

      /***
      * Calculates the coordinates on the clock face for a number
      * indicator value
      */
      getNumberCoords: function getNumberCoords(value) {
        var radius = this.isInnerRing(value) ? this.innerRadius : this.outerRadius;
        return {
          x: Math.round(radius * Math.sin((value - this.min) * this.degrees)),
          y: Math.round(-radius * Math.cos((value - this.min) * this.degrees))
        };
      },
      getFaceNumberClasses: function getFaceNumberClasses(num) {
        return {
          'active': num.value === this.displayedValue,
          'disabled': this.isDisabled(num.value)
        };
      },

      /**
      * Determines if a value resides on the inner ring
      */
      isInnerRing: function isInnerRing(value) {
        return this.double && value - this.min >= this.countPerRing;
      },
      calcHandAngle: function calcHandAngle(value) {
        var angle = this.degreesPerUnit * (value - this.min);
        if (this.isInnerRing(value)) angle -= 360;
        return angle;
      },
      calcHandScale: function calcHandScale(value) {
        return this.isInnerRing(value) ? this.innerRadius / this.outerRadius : 1;
      },
      onMouseDown: function onMouseDown(e) {
        e.preventDefault();
        this.isDragging = true;
        this.onDragMove(e);
      },
      onMouseUp: function onMouseUp() {
        this.isDragging = false;

        if (!this.isDisabled(this.inputValue)) {
          this.$emit('change', this.inputValue);
        }
      },
      onDragMove: function onDragMove(e) {
        e.preventDefault();
        if (!this.isDragging && e.type !== 'click') return;

        var _this$$refs$clock$get = this.$refs.clock.getBoundingClientRect(),
            width = _this$$refs$clock$get.width,
            top = _this$$refs$clock$get.top,
            left = _this$$refs$clock$get.left;

        var _ref = 'touches' in e ? e.touches[0] : e,
            clientX = _ref.clientX,
            clientY = _ref.clientY;

        var center = {
          x: width / 2,
          y: -width / 2
        };
        var coords = {
          x: clientX - left,
          y: top - clientY
        };
        var handAngle = Math.round(this.coordToAngle(center, coords) + 360) % 360;
        var insideClick = this.double && this.euclidean(center, coords) < (this.outerRadius + this.innerRadius) / 2 - 16;
        var value = Math.round(handAngle / this.degreesPerUnit) + this.min + (insideClick ? this.countPerRing : 0); // Necessary to fix edge case when selecting left part of max value

        if (handAngle >= 360 - this.degreesPerUnit / 2) {
          value = insideClick ? this.max : this.min;
        }

        this.update(value);
      },
      update: function update(value) {
        if (this.inputValue !== value && !this.isDisabled(value)) {
          this.prevAngle = this.handRotateAngle;
          this.inputValue = value;
          this.$emit('input', value);
        }
      }
    }
  };

  /* script */
  const __vue_script__$b = script$b;

  /* template */
  var __vue_render__$9 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-clockpicker-face",on:{"mousedown":_vm.onMouseDown,"mouseup":_vm.onMouseUp,"mousemove":_vm.onDragMove,"touchstart":_vm.onMouseDown,"touchend":_vm.onMouseUp,"touchmove":_vm.onDragMove}},[_c('div',{ref:"clock",staticClass:"b-clockpicker-face-outer-ring"},[_c('div',{staticClass:"b-clockpicker-face-hand",style:(_vm.handStyle)}),_vm._v(" "),_vm._l((_vm.faceNumbers),function(num,index){return _c('span',{key:index,staticClass:"b-clockpicker-face-number",class:_vm.getFaceNumberClasses(num),style:({ transform: _vm.getNumberTranslate(num.value) })},[_c('span',[_vm._v(_vm._s(num.label))])])})],2)])};
  var __vue_staticRenderFns__$9 = [];

    /* style */
    const __vue_inject_styles__$b = undefined;
    /* scoped */
    const __vue_scope_id__$b = undefined;
    /* module identifier */
    const __vue_module_identifier__$b = undefined;
    /* functional template */
    const __vue_is_functional_template__$b = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var ClockpickerFace = normalizeComponent_1(
      { render: __vue_render__$9, staticRenderFns: __vue_staticRenderFns__$9 },
      __vue_inject_styles__$b,
      __vue_script__$b,
      __vue_scope_id__$b,
      __vue_is_functional_template__$b,
      __vue_module_identifier__$b,
      undefined,
      undefined
    );

  var _components;
  var outerPadding = 12;
  var script$c = {
    name: 'BClockpicker',
    components: (_components = {}, _defineProperty(_components, ClockpickerFace.name, ClockpickerFace), _defineProperty(_components, Input.name, Input), _defineProperty(_components, Field.name, Field), _defineProperty(_components, Icon.name, Icon), _defineProperty(_components, Dropdown.name, Dropdown), _defineProperty(_components, DropdownItem.name, DropdownItem), _components),
    mixins: [TimepickerMixin],
    props: {
      pickerSize: {
        type: Number,
        default: 290
      },
      hourFormat: {
        type: String,
        default: '12',
        validator: function validator(value) {
          return value === '24' || value === '12';
        }
      },
      incrementMinutes: {
        type: Number,
        default: 5
      },
      autoSwitch: {
        type: Boolean,
        default: true
      },
      type: {
        type: String,
        default: 'is-primary'
      },
      hoursLabel: {
        type: String,
        default: function _default() {
          return config$1.defaultClockpickerHoursLabel || 'Hours';
        }
      },
      minutesLabel: {
        type: String,
        default: function _default() {
          return config$1.defaultClockpickerMinutesLabel || 'Min';
        }
      }
    },
    data: function data() {
      return {
        isSelectingHour: true,
        isDragging: false,
        _isClockpicker: true
      };
    },
    computed: {
      hoursDisplay: function hoursDisplay() {
        if (this.hoursSelected == null) return '--';
        if (this.isHourFormat24) return this.pad(this.hoursSelected);
        var display = this.hoursSelected;
        if (this.meridienSelected === this.PM) display -= 12;
        if (display === 0) display = 12;
        return display;
      },
      minutesDisplay: function minutesDisplay() {
        return this.minutesSelected == null ? '--' : this.pad(this.minutesSelected);
      },
      minFaceValue: function minFaceValue() {
        return this.isSelectingHour && !this.isHourFormat24 && this.meridienSelected === this.PM ? 12 : 0;
      },
      maxFaceValue: function maxFaceValue() {
        return this.isSelectingHour ? !this.isHourFormat24 && this.meridienSelected === this.AM ? 11 : 23 : 59;
      },
      faceSize: function faceSize() {
        return this.pickerSize - outerPadding * 2;
      },
      faceDisabledValues: function faceDisabledValues() {
        return this.isSelectingHour ? this.isHourDisabled : this.isMinuteDisabled;
      }
    },
    methods: {
      onClockInput: function onClockInput(value) {
        if (this.isSelectingHour) {
          this.hoursSelected = value;
          this.onHoursChange(value);
        } else {
          this.minutesSelected = value;
          this.onMinutesChange(value);
        }
      },
      onClockChange: function onClockChange(value) {
        if (this.autoSwitch && this.isSelectingHour) {
          this.isSelectingHour = !this.isSelectingHour;
        }
      },
      onMeridienClick: function onMeridienClick(value) {
        if (this.meridienSelected !== value) {
          this.meridienSelected = value;
          this.onMeridienChange(value);
        }
      }
    }
  };

  /* script */
  const __vue_script__$c = script$c;

  /* template */
  var __vue_render__$a = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-clockpicker control",class:[_vm.size, _vm.type, {'is-expanded': _vm.expanded}]},[(!_vm.isMobile || _vm.inline)?_c('b-dropdown',{ref:"dropdown",attrs:{"position":_vm.position,"disabled":_vm.disabled,"inline":_vm.inline}},[(!_vm.inline)?_c('b-input',_vm._b({ref:"input",attrs:{"slot":"trigger","autocomplete":"off","value":_vm.formatValue(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"disabled":_vm.disabled,"readonly":!_vm.editable,"rounded":_vm.rounded,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":function($event){_vm.onBlur() && _vm.checkHtml5Validity();}},nativeOn:{"click":function($event){$event.stopPropagation();_vm.toggle(true);},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.toggle(true);},"change":function($event){_vm.onChangeNativePicker($event);}},slot:"trigger"},'b-input',_vm.$attrs,false)):_vm._e(),_vm._v(" "),_c('div',{staticClass:"card",attrs:{"disabled":_vm.disabled,"custom":""}},[(_vm.inline)?_c('header',{staticClass:"card-header"},[_c('div',{staticClass:"b-clockpicker-header card-header-title"},[_c('div',{staticClass:"b-clockpicker-time"},[_c('span',{staticClass:"b-clockpicker-btn",class:{ active: _vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = true;}}},[_vm._v(_vm._s(_vm.hoursDisplay))]),_vm._v(" "),_c('span',[_vm._v(":")]),_vm._v(" "),_c('span',{staticClass:"b-clockpicker-btn",class:{ active: !_vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = false;}}},[_vm._v(_vm._s(_vm.minutesDisplay))])]),_vm._v(" "),(!_vm.isHourFormat24)?_c('div',{staticClass:"b-clockpicker-period"},[_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.AM },on:{"click":function($event){_vm.onMeridienClick(_vm.AM);}}},[_vm._v("am")]),_vm._v(" "),_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.PM },on:{"click":function($event){_vm.onMeridienClick(_vm.PM);}}},[_vm._v("pm")])]):_vm._e()])]):_vm._e(),_vm._v(" "),_c('div',{staticClass:"card-content"},[_c('div',{staticClass:"b-clockpicker-body",style:({ width: _vm.faceSize + 'px', height: _vm.faceSize + 'px' })},[(!_vm.inline)?_c('div',{staticClass:"b-clockpicker-time"},[_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = true;}}},[_vm._v(_vm._s(_vm.hoursLabel))]),_vm._v(" "),_c('span',{staticClass:"b-clockpicker-btn",class:{ active: !_vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = false;}}},[_vm._v(_vm._s(_vm.minutesLabel))])]):_vm._e(),_vm._v(" "),(!_vm.isHourFormat24 && !_vm.inline)?_c('div',{staticClass:"b-clockpicker-period"},[_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.AM },on:{"click":function($event){_vm.onMeridienClick(_vm.AM);}}},[_vm._v(_vm._s(_vm.AM))]),_vm._v(" "),_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.PM },on:{"click":function($event){_vm.onMeridienClick(_vm.PM);}}},[_vm._v(_vm._s(_vm.PM))])]):_vm._e(),_vm._v(" "),_c('b-clockpicker-face',{attrs:{"picker-size":_vm.faceSize,"min":_vm.minFaceValue,"max":_vm.maxFaceValue,"face-numbers":_vm.isSelectingHour ? _vm.hours : _vm.minutes,"disabled-values":_vm.faceDisabledValues,"double":_vm.isSelectingHour && _vm.isHourFormat24,"value":_vm.isSelectingHour ? _vm.hoursSelected : _vm.minutesSelected},on:{"input":_vm.onClockInput,"change":_vm.onClockChange}})],1)]),_vm._v(" "),(_vm.$slots.default !== undefined && _vm.$slots.default.length)?_c('footer',{staticClass:"b-clockpicker-footer card-footer"},[_vm._t("default")],2):_vm._e()])],1):_c('b-input',_vm._b({ref:"input",attrs:{"type":"time","autocomplete":"off","value":_vm.formatHHMMSS(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"max":_vm.formatHHMMSS(_vm.maxTime),"min":_vm.formatHHMMSS(_vm.minTime),"disabled":_vm.disabled,"readonly":false,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":function($event){_vm.onBlur() && _vm.checkHtml5Validity();}},nativeOn:{"click":function($event){$event.stopPropagation();_vm.toggle(true);},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.toggle(true);},"change":function($event){_vm.onChangeNativePicker($event);}}},'b-input',_vm.$attrs,false))],1)};
  var __vue_staticRenderFns__$a = [];

    /* style */
    const __vue_inject_styles__$c = undefined;
    /* scoped */
    const __vue_scope_id__$c = undefined;
    /* module identifier */
    const __vue_module_identifier__$c = undefined;
    /* functional template */
    const __vue_is_functional_template__$c = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Clockpicker = normalizeComponent_1(
      { render: __vue_render__$a, staticRenderFns: __vue_staticRenderFns__$a },
      __vue_inject_styles__$c,
      __vue_script__$c,
      __vue_scope_id__$c,
      __vue_is_functional_template__$c,
      __vue_module_identifier__$c,
      undefined,
      undefined
    );

  var Plugin$4 = {
    install: function install(Vue) {
      registerComponent(Vue, Clockpicker);
    }
  };
  use(Plugin$4);

  var script$d = {
    name: 'BSelect',
    components: _defineProperty({}, Icon.name, Icon),
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: {
        type: [String, Number, Boolean, Object, Array, Function],
        default: null
      },
      placeholder: String,
      multiple: Boolean,
      nativeSize: [String, Number]
    },
    data: function data() {
      return {
        selected: this.value,
        _elementRef: 'select'
      };
    },
    computed: {
      computedValue: {
        get: function get() {
          return this.selected;
        },
        set: function set(value) {
          this.selected = value;
          this.$emit('input', value);
          !this.isValid && this.checkHtml5Validity();
        }
      },
      spanClasses: function spanClasses() {
        return [this.size, this.statusType, {
          'is-fullwidth': this.expanded,
          'is-loading': this.loading,
          'is-multiple': this.multiple,
          'is-rounded': this.rounded,
          'is-empty': this.selected === null
        }];
      }
    },
    watch: {
      /**
      * When v-model is changed:
      *   1. Set the selected option.
      *   2. If it's invalid, validate again.
      */
      value: function value(_value) {
        this.selected = _value;
        !this.isValid && this.checkHtml5Validity();
      }
    }
  };

  /* script */
  const __vue_script__$d = script$d;

  /* template */
  var __vue_render__$b = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:{ 'is-expanded': _vm.expanded, 'has-icons-left': _vm.icon }},[_c('span',{staticClass:"select",class:_vm.spanClasses},[_c('select',_vm._b({directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"select",attrs:{"multiple":_vm.multiple,"size":_vm.nativeSize},on:{"blur":function($event){_vm.$emit('blur', $event) && _vm.checkHtml5Validity();},"focus":function($event){_vm.$emit('focus', $event);},"change":function($event){var $$selectedVal = Array.prototype.filter.call($event.target.options,function(o){return o.selected}).map(function(o){var val = "_value" in o ? o._value : o.value;return val}); _vm.computedValue=$event.target.multiple ? $$selectedVal : $$selectedVal[0];}}},'select',_vm.$attrs,false),[(_vm.placeholder)?[(_vm.computedValue == null)?_c('option',{attrs:{"disabled":"","hidden":""},domProps:{"value":null}},[_vm._v("\n                    "+_vm._s(_vm.placeholder)+"\n                ")]):_vm._e()]:_vm._e(),_vm._v(" "),_vm._t("default")],2)]),_vm._v(" "),(_vm.icon)?_c('b-icon',{staticClass:"is-left",attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":_vm.iconSize}}):_vm._e()],1)};
  var __vue_staticRenderFns__$b = [];

    /* style */
    const __vue_inject_styles__$d = undefined;
    /* scoped */
    const __vue_scope_id__$d = undefined;
    /* module identifier */
    const __vue_module_identifier__$d = undefined;
    /* functional template */
    const __vue_is_functional_template__$d = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Select = normalizeComponent_1(
      { render: __vue_render__$b, staticRenderFns: __vue_staticRenderFns__$b },
      __vue_inject_styles__$d,
      __vue_script__$d,
      __vue_scope_id__$d,
      __vue_is_functional_template__$d,
      __vue_module_identifier__$d,
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
  var script$e = {
    name: 'BDatepickerTableRow',
    props: {
      selectedDate: {
        type: [Date, Array]
      },
      hoveredDateRange: Array,
      week: {
        type: Array,
        required: true
      },
      month: {
        type: Number,
        required: true
      },
      minDate: Date,
      maxDate: Date,
      disabled: Boolean,
      unselectableDates: Array,
      unselectableDaysOfWeek: Array,
      selectableDates: Array,
      events: Array,
      indicators: String,
      dateCreator: Function,
      nearbyMonthDays: Boolean,
      nearbySelectableMonthDays: Boolean,
      showWeekNumber: {
        type: Boolean,
        default: function _default() {
          return false;
        }
      },
      range: Boolean,
      multiple: Boolean,
      rulesForFirstWeek: {
        type: Number,
        default: function _default() {
          return 4;
        }
      },
      firstDayOfWeek: Number
    },
    methods: {
      firstWeekOffset: function firstWeekOffset(year, dow, doy) {
        // first-week day -- which january is always in the first week (4 for iso, 1 for other)
        var fwd = 7 + dow - doy; // first-week day local weekday -- which local weekday is fwd

        var firstJanuary = new Date(year, 0, fwd);
        var fwdlw = (7 + firstJanuary.getDay() - dow) % 7;
        return -fwdlw + fwd - 1;
      },
      daysInYear: function daysInYear(year) {
        return this.isLeapYear(year) ? 366 : 365;
      },
      isLeapYear: function isLeapYear(year) {
        return year % 4 === 0 && year % 100 !== 0 || year % 400 === 0;
      },
      getSetDayOfYear: function getSetDayOfYear(input) {
        return Math.round((input - new Date(input.getFullYear(), 0, 1)) / 864e5) + 1;
      },
      weeksInYear: function weeksInYear(year, dow, doy) {
        var weekOffset = this.firstWeekOffset(year, dow, doy);
        var weekOffsetNext = this.firstWeekOffset(year + 1, dow, doy);
        return (this.daysInYear(year) - weekOffset + weekOffsetNext) / 7;
      },
      getWeekNumber: function getWeekNumber(mom) {
        var dow = this.firstDayOfWeek; // first day of week
        // Rules for the first week : 1 for the 1st January, 4 for the 4th January

        var doy = this.rulesForFirstWeek;
        var weekOffset = this.firstWeekOffset(mom.getFullYear(), dow, doy);
        var week = Math.floor((this.getSetDayOfYear(mom) - weekOffset - 1) / 7) + 1;
        var resWeek;
        var resYear;

        if (week < 1) {
          resYear = mom.getFullYear() - 1;
          resWeek = week + this.weeksInYear(resYear, dow, doy);
        } else if (week > this.weeksInYear(mom.getFullYear(), dow, doy)) {
          resWeek = week - this.weeksInYear(mom.getFullYear(), dow, doy);
          resYear = mom.getFullYear() + 1;
        } else {
          resYear = mom.getFullYear();
          resWeek = week;
        }

        return resWeek;
      },

      /*
      * Check that selected day is within earliest/latest params and
      * is within this month
      */
      selectableDate: function selectableDate(day) {
        var validity = [];

        if (this.minDate) {
          validity.push(day >= this.minDate);
        }

        if (this.maxDate) {
          validity.push(day <= this.maxDate);
        }

        if (this.nearbyMonthDays && !this.nearbySelectableMonthDays) {
          validity.push(day.getMonth() === this.month);
        }

        if (this.selectableDates) {
          for (var i = 0; i < this.selectableDates.length; i++) {
            var enabledDate = this.selectableDates[i];

            if (day.getDate() === enabledDate.getDate() && day.getFullYear() === enabledDate.getFullYear() && day.getMonth() === enabledDate.getMonth()) {
              return true;
            } else {
              validity.push(false);
            }
          }
        }

        if (this.unselectableDates) {
          for (var _i = 0; _i < this.unselectableDates.length; _i++) {
            var disabledDate = this.unselectableDates[_i];
            validity.push(day.getDate() !== disabledDate.getDate() || day.getFullYear() !== disabledDate.getFullYear() || day.getMonth() !== disabledDate.getMonth());
          }
        }

        if (this.unselectableDaysOfWeek) {
          for (var _i2 = 0; _i2 < this.unselectableDaysOfWeek.length; _i2++) {
            var dayOfWeek = this.unselectableDaysOfWeek[_i2];
            validity.push(day.getDay() !== dayOfWeek);
          }
        }

        return validity.indexOf(false) < 0;
      },

      /*
      * Emit select event with chosen date as payload
      */
      emitChosenDate: function emitChosenDate(day) {
        if (this.disabled) return;

        if (this.selectableDate(day)) {
          this.$emit('select', day);
        }
      },
      eventsDateMatch: function eventsDateMatch(day) {
        if (!this.events || !this.events.length) return false;
        var dayEvents = [];

        for (var i = 0; i < this.events.length; i++) {
          if (this.events[i].date.getDay() === day.getDay()) {
            dayEvents.push(this.events[i]);
          }
        }

        if (!dayEvents.length) {
          return false;
        }

        return dayEvents;
      },

      /*
      * Build classObject for cell using validations
      */
      classObject: function classObject(day) {
        function dateMatch(dateOne, dateTwo, multiple) {
          // if either date is null or undefined, return false
          // if using multiple flag, return false
          if (!dateOne || !dateTwo || multiple) {
            return false;
          }

          if (Array.isArray(dateTwo)) {
            return dateTwo.some(function (date) {
              return dateOne.getDate() === date.getDate() && dateOne.getFullYear() === date.getFullYear() && dateOne.getMonth() === date.getMonth();
            });
          }

          return dateOne.getDate() === dateTwo.getDate() && dateOne.getFullYear() === dateTwo.getFullYear() && dateOne.getMonth() === dateTwo.getMonth();
        }

        function dateWithin(dateOne, dates, multiple) {
          if (!Array.isArray(dates) || multiple) {
            return false;
          }

          return dateOne > dates[0] && dateOne < dates[1];
        }

        return {
          'is-selected': dateMatch(day, this.selectedDate) || dateWithin(day, this.selectedDate, this.multiple),
          'is-first-selected': dateMatch(day, Array.isArray(this.selectedDate) && this.selectedDate[0], this.multiple),
          'is-within-selected': dateWithin(day, this.selectedDate, this.multiple),
          'is-last-selected': dateMatch(day, Array.isArray(this.selectedDate) && this.selectedDate[1], this.multiple),
          'is-within-hovered-range': this.hoveredDateRange && this.hoveredDateRange.length === 2 && (dateMatch(day, this.hoveredDateRange) || dateWithin(day, this.hoveredDateRange)),
          'is-first-hovered': dateMatch(day, Array.isArray(this.hoveredDateRange) && this.hoveredDateRange[0]),
          'is-within-hovered': dateWithin(day, this.hoveredDateRange),
          'is-last-hovered': dateMatch(day, Array.isArray(this.hoveredDateRange) && this.hoveredDateRange[1]),
          'is-today': dateMatch(day, this.dateCreator()),
          'is-selectable': this.selectableDate(day) && !this.disabled,
          'is-unselectable': !this.selectableDate(day) || this.disabled,
          'is-invisible': !this.nearbyMonthDays && day.getMonth() !== this.month,
          'is-nearby': this.nearbySelectableMonthDays && day.getMonth() !== this.month
        };
      },
      setRangeHoverEndDate: function setRangeHoverEndDate(day) {
        if (this.range) {
          this.$emit('rangeHoverEndDate', day);
        }
      }
    }
  };

  /* script */
  const __vue_script__$e = script$e;

  /* template */
  var __vue_render__$c = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"datepicker-row"},[(_vm.showWeekNumber)?_c('a',{staticClass:"datepicker-cell is-week-number"},[_vm._v("\n        "+_vm._s(_vm.getWeekNumber(_vm.week[6]))+"\n    ")]):_vm._e(),_vm._v(" "),_vm._l((_vm.week),function(day,index){return [(_vm.selectableDate(day) && !_vm.disabled)?_c('a',{key:index,staticClass:"datepicker-cell",class:[_vm.classObject(day), {'has-event': _vm.eventsDateMatch(day)}, _vm.indicators],attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.emitChosenDate(day);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(day);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(day);}],"mouseenter":function($event){_vm.setRangeHoverEndDate(day);}}},[_vm._v("\n            "+_vm._s(day.getDate())+"\n            "),(_vm.eventsDateMatch(day))?_c('div',{staticClass:"events"},_vm._l((_vm.eventsDateMatch(day)),function(event,index){return _c('div',{key:index,staticClass:"event",class:event.type})})):_vm._e()]):_c('div',{key:index,staticClass:"datepicker-cell",class:_vm.classObject(day)},[_vm._v("\n            "+_vm._s(day.getDate())+"\n        ")])]})],2)};
  var __vue_staticRenderFns__$c = [];

    /* style */
    const __vue_inject_styles__$e = undefined;
    /* scoped */
    const __vue_scope_id__$e = undefined;
    /* module identifier */
    const __vue_module_identifier__$e = undefined;
    /* functional template */
    const __vue_is_functional_template__$e = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var DatepickerTableRow = normalizeComponent_1(
      { render: __vue_render__$c, staticRenderFns: __vue_staticRenderFns__$c },
      __vue_inject_styles__$e,
      __vue_script__$e,
      __vue_scope_id__$e,
      __vue_is_functional_template__$e,
      __vue_module_identifier__$e,
      undefined,
      undefined
    );

  var isDefined = function isDefined(d) {
    return d !== undefined;
  };

  var script$f = {
    name: 'BDatepickerTable',
    components: _defineProperty({}, DatepickerTableRow.name, DatepickerTableRow),
    props: {
      value: {
        type: [Date, Array]
      },
      dayNames: Array,
      monthNames: Array,
      firstDayOfWeek: Number,
      events: Array,
      indicators: String,
      minDate: Date,
      maxDate: Date,
      focused: Object,
      disabled: Boolean,
      dateCreator: Function,
      unselectableDates: Array,
      unselectableDaysOfWeek: Array,
      selectableDates: Array,
      nearbyMonthDays: Boolean,
      nearbySelectableMonthDays: Boolean,
      showWeekNumber: {
        type: Boolean,
        default: function _default() {
          return false;
        }
      },
      rulesForFirstWeek: {
        type: Number,
        default: function _default() {
          return 4;
        }
      },
      range: Boolean,
      multiple: Boolean
    },
    data: function data() {
      return {
        selectedBeginDate: undefined,
        selectedEndDate: undefined,
        hoveredEndDate: undefined,
        multipleSelectedDates: []
      };
    },
    computed: {
      visibleDayNames: function visibleDayNames() {
        var visibleDayNames = [];
        var index = this.firstDayOfWeek;

        while (visibleDayNames.length < this.dayNames.length) {
          var currentDayName = this.dayNames[index % this.dayNames.length];
          visibleDayNames.push(currentDayName);
          index++;
        }

        if (this.showWeekNumber) visibleDayNames.unshift('');
        return visibleDayNames;
      },
      hasEvents: function hasEvents() {
        return this.events && this.events.length;
      },

      /*
      * Return array of all events in the specified month
      */
      eventsInThisMonth: function eventsInThisMonth() {
        if (!this.events) return [];
        var monthEvents = [];

        for (var i = 0; i < this.events.length; i++) {
          var event = this.events[i];

          if (!event.hasOwnProperty('date')) {
            event = {
              date: event
            };
          }

          if (!event.hasOwnProperty('type')) {
            event.type = 'is-primary';
          }

          if (event.date.getMonth() === this.focused.month && event.date.getFullYear() === this.focused.year) {
            monthEvents.push(event);
          }
        }

        return monthEvents;
      },

      /*
      * Return array of all weeks in the specified month
      */
      weeksInThisMonth: function weeksInThisMonth() {
        var month = this.focused.month;
        var year = this.focused.year;
        var weeksInThisMonth = [];
        var startingDay = 1;

        while (weeksInThisMonth.length < 6) {
          var newWeek = this.weekBuilder(startingDay, month, year);
          weeksInThisMonth.push(newWeek);
          startingDay += 7;
        }

        return weeksInThisMonth;
      },
      hoveredDateRange: function hoveredDateRange() {
        if (!this.range) {
          return [];
        }

        if (!isNaN(this.selectedEndDate)) {
          return [];
        }

        if (this.hoveredEndDate < this.selectedBeginDate) {
          return [this.hoveredEndDate, this.selectedBeginDate].filter(isDefined);
        }

        return [this.selectedBeginDate, this.hoveredEndDate].filter(isDefined);
      }
    },
    methods: {
      /*
      * Emit input event with selected date as payload for v-model in parent
      */
      updateSelectedDate: function updateSelectedDate(date) {
        if (!this.range && !this.multiple) {
          this.$emit('input', date);
        } else if (this.range) {
          this.handleSelectRangeDate(date);
        } else if (this.multiple) {
          this.handleSelectMultipleDates(date);
        }
      },

      /*
      * If both begin and end dates are set, reset the end date and set the begin date.
      * If only begin date is selected, emit an array of the begin date and the new date.
      * If not set, only set the begin date.
      */
      handleSelectRangeDate: function handleSelectRangeDate(date) {
        if (this.selectedBeginDate && this.selectedEndDate) {
          this.selectedBeginDate = date;
          this.selectedEndDate = undefined;
        } else if (this.selectedBeginDate && !this.selectedEndDate) {
          if (this.selectedBeginDate > date) {
            this.selectedEndDate = this.selectedBeginDate;
            this.selectedBeginDate = date;
          } else {
            this.selectedEndDate = date;
          }

          this.$emit('input', [this.selectedBeginDate, this.selectedEndDate]);
        } else {
          this.selectedBeginDate = date;
        }
      },

      /*
      * If selected date already exists list of selected dates, remove it from the list
      * Otherwise, add date to list of selected dates
      */
      handleSelectMultipleDates: function handleSelectMultipleDates(date) {
        if (this.multipleSelectedDates.find(function (selectedDate) {
          return selectedDate.valueOf() === date.valueOf();
        })) {
          this.multipleSelectedDates = this.multipleSelectedDates.filter(function (selectedDate) {
            return selectedDate.valueOf() !== date.valueOf();
          });
        } else {
          this.multipleSelectedDates.push(date);
        }

        this.$emit('input', this.multipleSelectedDates);
      },

      /*
      * Return array of all days in the week that the startingDate is within
      */
      weekBuilder: function weekBuilder(startingDate, month, year) {
        var thisMonth = new Date(year, month);
        var thisWeek = [];
        var dayOfWeek = new Date(year, month, startingDate).getDay();
        var end = dayOfWeek >= this.firstDayOfWeek ? dayOfWeek - this.firstDayOfWeek : 7 - this.firstDayOfWeek + dayOfWeek;
        var daysAgo = 1;

        for (var i = 0; i < end; i++) {
          thisWeek.unshift(new Date(thisMonth.getFullYear(), thisMonth.getMonth(), startingDate - daysAgo));
          daysAgo++;
        }

        thisWeek.push(new Date(year, month, startingDate));
        var daysForward = 1;

        while (thisWeek.length < 7) {
          thisWeek.push(new Date(year, month, startingDate + daysForward));
          daysForward++;
        }

        return thisWeek;
      },
      eventsInThisWeek: function eventsInThisWeek(week) {
        return this.eventsInThisMonth.filter(function (event) {
          var stripped = new Date(Date.parse(event.date));
          stripped.setHours(0, 0, 0, 0);
          var timed = stripped.getTime();
          return week.some(function (weekDate) {
            return weekDate.getTime() === timed;
          });
        });
      },
      setRangeHoverEndDate: function setRangeHoverEndDate(day) {
        this.hoveredEndDate = day;
      }
    }
  };

  /* script */
  const __vue_script__$f = script$f;

  /* template */
  var __vue_render__$d = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('section',{staticClass:"datepicker-table"},[_c('header',{staticClass:"datepicker-header"},_vm._l((_vm.visibleDayNames),function(day,index){return _c('div',{key:index,staticClass:"datepicker-cell"},[_vm._v("\n            "+_vm._s(day)+"\n        ")])})),_vm._v(" "),_c('div',{staticClass:"datepicker-body",class:{'has-events':_vm.hasEvents}},_vm._l((_vm.weeksInThisMonth),function(week,index){return _c('b-datepicker-table-row',{key:index,attrs:{"selected-date":_vm.value,"week":week,"month":_vm.focused.month,"min-date":_vm.minDate,"max-date":_vm.maxDate,"disabled":_vm.disabled,"unselectable-dates":_vm.unselectableDates,"unselectable-days-of-week":_vm.unselectableDaysOfWeek,"selectable-dates":_vm.selectableDates,"events":_vm.eventsInThisWeek(week),"indicators":_vm.indicators,"date-creator":_vm.dateCreator,"nearby-month-days":_vm.nearbyMonthDays,"nearby-selectable-month-days":_vm.nearbySelectableMonthDays,"show-week-number":_vm.showWeekNumber,"first-day-of-week":_vm.firstDayOfWeek,"rules-for-first-week":_vm.rulesForFirstWeek,"range":_vm.range,"hovered-date-range":_vm.hoveredDateRange,"multiple":_vm.multiple},on:{"select":_vm.updateSelectedDate,"rangeHoverEndDate":_vm.setRangeHoverEndDate}})}))])};
  var __vue_staticRenderFns__$d = [];

    /* style */
    const __vue_inject_styles__$f = undefined;
    /* scoped */
    const __vue_scope_id__$f = undefined;
    /* module identifier */
    const __vue_module_identifier__$f = undefined;
    /* functional template */
    const __vue_is_functional_template__$f = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var DatepickerTable = normalizeComponent_1(
      { render: __vue_render__$d, staticRenderFns: __vue_staticRenderFns__$d },
      __vue_inject_styles__$f,
      __vue_script__$f,
      __vue_scope_id__$f,
      __vue_is_functional_template__$f,
      __vue_module_identifier__$f,
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
  var script$g = {
    name: 'BDatepickerMonth',
    props: {
      value: Date,
      monthNames: Array,
      events: Array,
      indicators: String,
      minDate: Date,
      maxDate: Date,
      focused: Object,
      disabled: Boolean,
      dateCreator: Function,
      unselectableDates: Array,
      unselectableDaysOfWeek: Array,
      selectableDates: Array
    },
    computed: {
      hasEvents: function hasEvents() {
        return this.events && this.events.length;
      },

      /*
      * Return array of all events in the specified month
      */
      eventsInThisYear: function eventsInThisYear() {
        if (!this.events) return [];
        var yearEvents = [];

        for (var i = 0; i < this.events.length; i++) {
          var event = this.events[i];

          if (!event.hasOwnProperty('date')) {
            event = {
              date: event
            };
          }

          if (!event.hasOwnProperty('type')) {
            event.type = 'is-primary';
          }

          if (event.date.getFullYear() === this.focused.year) {
            yearEvents.push(event);
          }
        }

        return yearEvents;
      },
      monthDates: function monthDates() {
        var year = this.focused.year;
        var months = [];

        for (var i = 0; i < 12; i++) {
          var d = new Date(year, i, 1);
          d.setHours(0, 0, 0, 0);
          months.push(d);
        }

        return months;
      }
    },
    methods: {
      selectableDate: function selectableDate(day) {
        var validity = [];

        if (this.minDate) {
          validity.push(day >= this.minDate);
        }

        if (this.maxDate) {
          validity.push(day <= this.maxDate);
        }

        validity.push(day.getFullYear() === this.focused.year);

        if (this.selectableDates) {
          for (var i = 0; i < this.selectableDates.length; i++) {
            var enabledDate = this.selectableDates[i];

            if (day.getFullYear() === enabledDate.getFullYear() && day.getMonth() === enabledDate.getMonth()) {
              return true;
            } else {
              validity.push(false);
            }
          }
        }

        if (this.unselectableDates) {
          for (var _i = 0; _i < this.unselectableDates.length; _i++) {
            var disabledDate = this.unselectableDates[_i];
            validity.push(day.getFullYear() !== disabledDate.getFullYear() || day.getMonth() !== disabledDate.getMonth());
          }
        }

        if (this.unselectableDaysOfWeek) {
          for (var _i2 = 0; _i2 < this.unselectableDaysOfWeek.length; _i2++) {
            var dayOfWeek = this.unselectableDaysOfWeek[_i2];
            validity.push(day.getDay() !== dayOfWeek);
          }
        }

        return validity.indexOf(false) < 0;
      },
      eventsDateMatch: function eventsDateMatch(day) {
        if (!this.eventsInThisYear.length) return false;
        var monthEvents = [];

        for (var i = 0; i < this.eventsInThisYear.length; i++) {
          if (this.eventsInThisYear[i].date.getMonth() === day.getMonth()) {
            monthEvents.push(this.events[i]);
          }
        }

        if (!monthEvents.length) {
          return false;
        }

        return monthEvents;
      },

      /*
      * Build classObject for cell using validations
      */
      classObject: function classObject(day) {
        function dateMatch(dateOne, dateTwo) {
          // if either date is null or undefined, return false
          if (!dateOne || !dateTwo) {
            return false;
          }

          return dateOne.getFullYear() === dateTwo.getFullYear() && dateOne.getMonth() === dateTwo.getMonth();
        }

        return {
          'is-selected': dateMatch(day, this.value),
          'is-today': dateMatch(day, this.dateCreator()),
          'is-selectable': this.selectableDate(day) && !this.disabled,
          'is-unselectable': !this.selectableDate(day) || this.disabled
        };
      },

      /*
      * Emit select event with chosen date as payload
      */
      emitChosenDate: function emitChosenDate(day) {
        if (this.disabled) return;

        if (this.selectableDate(day)) {
          this.$emit('input', day);
        }
      }
    }
  };

  /* script */
  const __vue_script__$g = script$g;

  /* template */
  var __vue_render__$e = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('section',{staticClass:"datepicker-table"},[_c('div',{staticClass:"datepicker-body",class:{'has-events':_vm.hasEvents}},[_c('div',{staticClass:"datepicker-months"},[_vm._l((_vm.monthDates),function(date,index){return [(_vm.selectableDate(date) && !_vm.disabled)?_c('a',{key:index,staticClass:"datepicker-cell",class:[
                          _vm.classObject(date),
                          {'has-event': _vm.eventsDateMatch(date)},
                          _vm.indicators
                      ],attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.emitChosenDate(date);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(date);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(date);}]}},[_vm._v("\n                    "+_vm._s(_vm.monthNames[date.getMonth()])+"\n                    "),(_vm.eventsDateMatch(date))?_c('div',{staticClass:"events"},_vm._l((_vm.eventsDateMatch(date)),function(event,index){return _c('div',{key:index,staticClass:"event",class:event.type})})):_vm._e()]):_c('div',{key:index,staticClass:"datepicker-cell",class:_vm.classObject(date)},[_vm._v("\n                    "+_vm._s(_vm.monthNames[date.getMonth()])+"\n                ")])]})],2)])])};
  var __vue_staticRenderFns__$e = [];

    /* style */
    const __vue_inject_styles__$g = undefined;
    /* scoped */
    const __vue_scope_id__$g = undefined;
    /* module identifier */
    const __vue_module_identifier__$g = undefined;
    /* functional template */
    const __vue_is_functional_template__$g = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var DatepickerMonth = normalizeComponent_1(
      { render: __vue_render__$e, staticRenderFns: __vue_staticRenderFns__$e },
      __vue_inject_styles__$g,
      __vue_script__$g,
      __vue_scope_id__$g,
      __vue_is_functional_template__$g,
      __vue_module_identifier__$g,
      undefined,
      undefined
    );

  var _components$1;

  var defaultDateFormatter = function defaultDateFormatter(date, vm) {
    var targetDates = Array.isArray(date) ? date : [date];
    var dates = targetDates.map(function (date) {
      var yyyyMMdd = date.getFullYear() + '/' + (date.getMonth() + 1) + '/' + date.getDate();
      var d = new Date(yyyyMMdd);
      return !vm.isTypeMonth ? d.toLocaleDateString() : d.toLocaleDateString(undefined, {
        year: 'numeric',
        month: '2-digit'
      });
    });
    return !vm.multiple ? dates.join(' - ') : dates.join(', ');
  };

  var defaultDateParser = function defaultDateParser(date, vm) {
    if (!vm.isTypeMonth) return new Date(Date.parse(date));

    if (date) {
      var s = date.split('/');
      var year = s[0].length === 4 ? s[0] : s[1];
      var month = s[0].length === 2 ? s[0] : s[1];

      if (year && month) {
        return new Date(parseInt(year, 10), parseInt(month - 1, 10), 1, 0, 0, 0, 0);
      }
    }

    return null;
  };

  var script$h = {
    name: 'BDatepicker',
    components: (_components$1 = {}, _defineProperty(_components$1, DatepickerTable.name, DatepickerTable), _defineProperty(_components$1, DatepickerMonth.name, DatepickerMonth), _defineProperty(_components$1, Input.name, Input), _defineProperty(_components$1, Field.name, Field), _defineProperty(_components$1, Select.name, Select), _defineProperty(_components$1, Icon.name, Icon), _defineProperty(_components$1, Dropdown.name, Dropdown), _defineProperty(_components$1, DropdownItem.name, DropdownItem), _components$1),
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: {
        type: [Date, Array]
      },
      dayNames: {
        type: Array,
        default: function _default() {
          if (Array.isArray(config$1.defaultDayNames)) {
            return config$1.defaultDayNames;
          } else {
            return ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'S'];
          }
        }
      },
      monthNames: {
        type: Array,
        default: function _default() {
          if (Array.isArray(config$1.defaultMonthNames)) {
            return config$1.defaultMonthNames;
          } else {
            return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
          }
        }
      },
      firstDayOfWeek: {
        type: Number,
        default: function _default() {
          if (typeof config$1.defaultFirstDayOfWeek === 'number') {
            return config$1.defaultFirstDayOfWeek;
          } else {
            return 0;
          }
        }
      },
      inline: Boolean,
      minDate: Date,
      maxDate: Date,
      focusedDate: Date,
      placeholder: String,
      editable: Boolean,
      disabled: Boolean,
      unselectableDates: Array,
      unselectableDaysOfWeek: {
        type: Array,
        default: function _default() {
          return config$1.defaultUnselectableDaysOfWeek;
        }
      },
      selectableDates: Array,
      dateFormatter: {
        type: Function,
        default: function _default(date, vm) {
          if (typeof config$1.defaultDateFormatter === 'function') {
            return config$1.defaultDateFormatter(date);
          } else {
            return defaultDateFormatter(date, vm);
          }
        }
      },
      dateParser: {
        type: Function,
        default: function _default(date, vm) {
          if (typeof config$1.defaultDateParser === 'function') {
            return config$1.defaultDateParser(date);
          } else {
            return defaultDateParser(date, vm);
          }
        }
      },
      dateCreator: {
        type: Function,
        default: function _default() {
          if (typeof config$1.defaultDateCreator === 'function') {
            return config$1.defaultDateCreator();
          } else {
            return new Date();
          }
        }
      },
      mobileNative: {
        type: Boolean,
        default: function _default() {
          return config$1.defaultDatepickerMobileNative;
        }
      },
      position: String,
      events: Array,
      indicators: {
        type: String,
        default: 'dots'
      },
      openOnFocus: Boolean,
      iconPrev: {
        type: String,
        default: config$1.defaultIconPrev
      },
      iconNext: {
        type: String,
        default: config$1.defaultIconNext
      },
      yearsRange: {
        type: Array,
        default: function _default() {
          return config$1.defaultDatepickerYearsRange;
        }
      },
      type: {
        type: String,
        validator: function validator(value) {
          return ['month'].indexOf(value) >= 0;
        }
      },
      nearbyMonthDays: {
        type: Boolean,
        default: function _default() {
          return config$1.defaultDatepickerNearbyMonthDays;
        }
      },
      nearbySelectableMonthDays: {
        type: Boolean,
        default: function _default() {
          return config$1.defaultDatepickerNearbySelectableMonthDays;
        }
      },
      showWeekNumber: {
        type: Boolean,
        default: function _default() {
          return config$1.defaultDatepickerShowWeekNumber;
        }
      },
      rulesForFirstWeek: {
        type: Number,
        default: function _default() {
          return 4;
        }
      },
      range: {
        type: Boolean,
        default: false
      },
      closeOnClick: {
        type: Boolean,
        default: true
      },
      multiple: {
        type: Boolean,
        default: false
      }
    },
    data: function data() {
      var focusedDate = (Array.isArray(this.value) ? this.value[0] : this.value) || this.focusedDate || this.dateCreator();
      return {
        dateSelected: this.value,
        focusedDateData: {
          month: focusedDate.getMonth(),
          year: focusedDate.getFullYear()
        },
        _elementRef: 'input',
        _isDatepicker: true
      };
    },
    computed: {
      computedValue: {
        get: function get() {
          return this.dateSelected;
        },
        set: function set(value) {
          this.updateInternalState(value);
          if (!this.multiple) this.togglePicker(false);
          this.$emit('input', value);
        }
      },

      /*
      * Returns an array of years for the year dropdown. If earliest/latest
      * dates are set by props, range of years will fall within those dates.
      */
      listOfYears: function listOfYears() {
        var latestYear = this.focusedDateData.year + this.yearsRange[1];

        if (this.maxDate && this.maxDate.getFullYear() < latestYear) {
          latestYear = Math.max(this.maxDate.getFullYear(), this.focusedDateData.year);
        }

        var earliestYear = this.focusedDateData.year + this.yearsRange[0];

        if (this.minDate && this.minDate.getFullYear() > earliestYear) {
          earliestYear = Math.min(this.minDate.getFullYear(), this.focusedDateData.year);
        }

        var arrayOfYears = [];

        for (var i = earliestYear; i <= latestYear; i++) {
          arrayOfYears.push(i);
        }

        return arrayOfYears.reverse();
      },
      showPrev: function showPrev() {
        if (!this.minDate) return false;

        if (this.isTypeMonth) {
          return this.focusedDateData.year <= this.minDate.getFullYear();
        }

        var dateToCheck = new Date(this.focusedDateData.year, this.focusedDateData.month);
        var date = new Date(this.minDate.getFullYear(), this.minDate.getMonth());
        return dateToCheck <= date;
      },
      showNext: function showNext() {
        if (!this.maxDate) return false;

        if (this.isTypeMonth) {
          return this.focusedDateData.year >= this.maxDate.getFullYear();
        }

        var dateToCheck = new Date(this.focusedDateData.year, this.focusedDateData.month);
        var date = new Date(this.maxDate.getFullYear(), this.maxDate.getMonth());
        return dateToCheck >= date;
      },
      isMobile: function isMobile$1() {
        return this.mobileNative && isMobile.any();
      },
      isTypeMonth: function isTypeMonth() {
        return this.type === 'month';
      }
    },
    watch: {
      /**
      * When v-model is changed:
      *   1. Update internal value.
      *   2. If it's invalid, validate again.
      */
      value: function value(_value) {
        this.updateInternalState(_value);
        if (!this.multiple) this.togglePicker(false);
        !this.isValid && this.$refs.input.checkHtml5Validity();
      },
      focusedDate: function focusedDate(value) {
        if (value) {
          this.focusedDateData = {
            month: value.getMonth(),
            year: value.getFullYear()
          };
        }
      },

      /*
      * Emit input event on month and/or year change
      */
      'focusedDateData.month': function focusedDateDataMonth(value) {
        this.$emit('change-month', value);
      },
      'focusedDateData.year': function focusedDateDataYear(value) {
        this.$emit('change-year', value);
      }
    },
    methods: {
      /*
      * Parse string into date
      */
      onChange: function onChange(value) {
        var date = this.dateParser(value, this);

        if (date && (!isNaN(date) || Array.isArray(date) && date.length === 2 && !isNaN(date[0]) && !isNaN(date[1]))) {
          this.computedValue = date;
        } else {
          // Force refresh input value when not valid date
          this.computedValue = null;
          this.$refs.input.newValue = this.computedValue;
        }
      },

      /*
      * Format date into string
      */
      formatValue: function formatValue(value) {
        if (Array.isArray(value)) {
          var isArrayWithValidDates = Array.isArray(value) && value.every(function (v) {
            return !isNaN(v);
          });
          return isArrayWithValidDates ? this.dateFormatter(value, this) : null;
        }

        return value && !isNaN(value) ? this.dateFormatter(value, this) : null;
      },

      /*
      * Either decrement month by 1 if not January or decrement year by 1
      * and set month to 11 (December) or decrement year when 'month'
      */
      prev: function prev() {
        if (this.disabled) return;

        if (this.isTypeMonth) {
          this.focusedDateData.year -= 1;
        } else {
          if (this.focusedDateData.month > 0) {
            this.focusedDateData.month -= 1;
          } else {
            this.focusedDateData.month = 11;
            this.focusedDateData.year -= 1;
          }
        }
      },

      /*
      * Either increment month by 1 if not December or increment year by 1
      * and set month to 0 (January) or increment year when 'month'
      */
      next: function next() {
        if (this.disabled) return;

        if (this.isTypeMonth) {
          this.focusedDateData.year += 1;
        } else {
          if (this.focusedDateData.month < 11) {
            this.focusedDateData.month += 1;
          } else {
            this.focusedDateData.month = 0;
            this.focusedDateData.year += 1;
          }
        }
      },
      formatNative: function formatNative(value) {
        return this.isTypeMonth ? this.formatYYYYMM(value) : this.formatYYYYMMDD(value);
      },

      /*
      * Format date into string 'YYYY-MM-DD'
      */
      formatYYYYMMDD: function formatYYYYMMDD(value) {
        var date = new Date(value);

        if (value && !isNaN(date)) {
          var year = date.getFullYear();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          return year + '-' + ((month < 10 ? '0' : '') + month) + '-' + ((day < 10 ? '0' : '') + day);
        }

        return '';
      },

      /*
      * Format date into string 'YYYY-MM'
      */
      formatYYYYMM: function formatYYYYMM(value) {
        var date = new Date(value);

        if (value && !isNaN(date)) {
          var year = date.getFullYear();
          var month = date.getMonth() + 1;
          return year + '-' + ((month < 10 ? '0' : '') + month);
        }

        return '';
      },

      /*
      * Parse date from string
      */
      onChangeNativePicker: function onChangeNativePicker(event) {
        var date = event.target.value;
        this.computedValue = date ? new Date(date + 'T00:00:00') : null;
      },
      updateInternalState: function updateInternalState(value) {
        var currentDate = Array.isArray(value) ? !value.length ? this.dateCreator() : value[0] : !value ? this.dateCreator() : value;
        this.focusedDateData = {
          month: currentDate.getMonth(),
          year: currentDate.getFullYear()
        };
        this.dateSelected = value;
      },

      /*
      * Toggle datepicker
      */
      togglePicker: function togglePicker(active) {
        if (this.$refs.dropdown) {
          if (this.closeOnClick) {
            this.$refs.dropdown.isActive = typeof active === 'boolean' ? active : !this.$refs.dropdown.isActive;
          }
        }
      },

      /*
      * Call default onFocus method and show datepicker
      */
      handleOnFocus: function handleOnFocus(event) {
        this.onFocus(event);

        if (this.openOnFocus) {
          this.togglePicker(true);
        }
      },

      /*
      * Toggle dropdown
      */
      toggle: function toggle() {
        if (this.mobileNative && this.isMobile) {
          var input = this.$refs.input.$refs.input;
          input.focus();
          input.click();
          return;
        }

        this.$refs.dropdown.toggle();
      },

      /*
      * Avoid dropdown toggle when is already visible
      */
      onInputClick: function onInputClick(event) {
        if (this.$refs.dropdown.isActive) {
          event.stopPropagation();
        }
      },

      /**
       * Keypress event that is bound to the document.
       */
      keyPress: function keyPress(event) {
        // Esc key
        if (this.$refs.dropdown && this.$refs.dropdown.isActive && event.keyCode === 27) {
          this.togglePicker(false);
        }
      }
    },
    created: function created() {
      if (typeof window !== 'undefined') {
        document.addEventListener('keyup', this.keyPress);
      }
    },
    beforeDestroy: function beforeDestroy() {
      if (typeof window !== 'undefined') {
        document.removeEventListener('keyup', this.keyPress);
      }
    }
  };

  /* script */
  const __vue_script__$h = script$h;

  /* template */
  var __vue_render__$f = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"datepicker control",class:[_vm.size, {'is-expanded': _vm.expanded}]},[(!_vm.isMobile || _vm.inline)?_c('b-dropdown',{ref:"dropdown",attrs:{"position":_vm.position,"disabled":_vm.disabled,"inline":_vm.inline}},[(!_vm.inline)?_c('b-input',_vm._b({ref:"input",attrs:{"slot":"trigger","autocomplete":"off","value":_vm.formatValue(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"rounded":_vm.rounded,"loading":_vm.loading,"disabled":_vm.disabled,"readonly":!_vm.editable,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":_vm.onBlur},nativeOn:{"click":function($event){_vm.onInputClick($event);},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.togglePicker(true);},"change":function($event){_vm.onChange($event.target.value);}},slot:"trigger"},'b-input',_vm.$attrs,false)):_vm._e(),_vm._v(" "),_c('b-dropdown-item',{attrs:{"disabled":_vm.disabled,"custom":""}},[_c('header',{staticClass:"datepicker-header"},[(_vm.$slots.header !== undefined && _vm.$slots.header.length)?[_vm._t("header")]:_c('div',{staticClass:"pagination field is-centered",class:_vm.size},[_c('a',{directives:[{name:"show",rawName:"v-show",value:(!_vm.showPrev && !_vm.disabled),expression:"!showPrev && !disabled"}],staticClass:"pagination-previous",attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.prev($event);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.prev($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.prev($event);}]}},[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","type":"is-primary is-clickable"}})],1),_vm._v(" "),_c('a',{directives:[{name:"show",rawName:"v-show",value:(!_vm.showNext && !_vm.disabled),expression:"!showNext && !disabled"}],staticClass:"pagination-next",attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.next($event);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.next($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.next($event);}]}},[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","type":"is-primary is-clickable"}})],1),_vm._v(" "),_c('div',{staticClass:"pagination-list"},[_c('b-field',[(!_vm.isTypeMonth)?_c('b-select',{attrs:{"disabled":_vm.disabled,"size":_vm.size},model:{value:(_vm.focusedDateData.month),callback:function ($$v) {_vm.$set(_vm.focusedDateData, "month", $$v);},expression:"focusedDateData.month"}},_vm._l((_vm.monthNames),function(month,index){return _c('option',{key:month,domProps:{"value":index}},[_vm._v("\n                                    "+_vm._s(month)+"\n                                ")])})):_vm._e(),_vm._v(" "),_c('b-select',{attrs:{"disabled":_vm.disabled,"size":_vm.size},model:{value:(_vm.focusedDateData.year),callback:function ($$v) {_vm.$set(_vm.focusedDateData, "year", $$v);},expression:"focusedDateData.year"}},_vm._l((_vm.listOfYears),function(year){return _c('option',{key:year,domProps:{"value":year}},[_vm._v("\n                                    "+_vm._s(year)+"\n                                ")])}))],1)],1)])],2),_vm._v(" "),(!_vm.isTypeMonth)?_c('div',{staticClass:"datepicker-content"},[_c('b-datepicker-table',{attrs:{"day-names":_vm.dayNames,"month-names":_vm.monthNames,"first-day-of-week":_vm.firstDayOfWeek,"rules-for-first-week":_vm.rulesForFirstWeek,"min-date":_vm.minDate,"max-date":_vm.maxDate,"focused":_vm.focusedDateData,"disabled":_vm.disabled,"unselectable-dates":_vm.unselectableDates,"unselectable-days-of-week":_vm.unselectableDaysOfWeek,"selectable-dates":_vm.selectableDates,"events":_vm.events,"indicators":_vm.indicators,"date-creator":_vm.dateCreator,"type-month":_vm.isTypeMonth,"nearby-month-days":_vm.nearbyMonthDays,"nearby-selectable-month-days":_vm.nearbySelectableMonthDays,"show-week-number":_vm.showWeekNumber,"range":_vm.range,"multiple":_vm.multiple},on:{"close":function($event){_vm.togglePicker(false);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}})],1):_c('div',[_c('b-datepicker-month',{attrs:{"month-names":_vm.monthNames,"min-date":_vm.minDate,"max-date":_vm.maxDate,"focused":_vm.focusedDateData,"disabled":_vm.disabled,"unselectable-dates":_vm.unselectableDates,"unselectable-days-of-week":_vm.unselectableDaysOfWeek,"selectable-dates":_vm.selectableDates,"events":_vm.events,"indicators":_vm.indicators,"date-creator":_vm.dateCreator},on:{"close":function($event){_vm.togglePicker(false);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}})],1),_vm._v(" "),(_vm.$slots.default !== undefined && _vm.$slots.default.length)?_c('footer',{staticClass:"datepicker-footer"},[_vm._t("default")],2):_vm._e()])],1):_c('b-input',_vm._b({ref:"input",attrs:{"type":!_vm.isTypeMonth ? 'date' : 'month',"autocomplete":"off","value":_vm.formatNative(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"max":_vm.formatNative(_vm.maxDate),"min":_vm.formatNative(_vm.minDate),"disabled":_vm.disabled,"readonly":false,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.onFocus,"blur":_vm.onBlur},nativeOn:{"change":function($event){_vm.onChangeNativePicker($event);}}},'b-input',_vm.$attrs,false))],1)};
  var __vue_staticRenderFns__$f = [];

    /* style */
    const __vue_inject_styles__$h = undefined;
    /* scoped */
    const __vue_scope_id__$h = undefined;
    /* module identifier */
    const __vue_module_identifier__$h = undefined;
    /* functional template */
    const __vue_is_functional_template__$h = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Datepicker = normalizeComponent_1(
      { render: __vue_render__$f, staticRenderFns: __vue_staticRenderFns__$f },
      __vue_inject_styles__$h,
      __vue_script__$h,
      __vue_scope_id__$h,
      __vue_is_functional_template__$h,
      __vue_module_identifier__$h,
      undefined,
      undefined
    );

  var Plugin$5 = {
    install: function install(Vue) {
      registerComponent(Vue, Datepicker);
    }
  };
  use(Plugin$5);

  var _components$2;
  var script$i = {
    name: 'BTimepicker',
    components: (_components$2 = {}, _defineProperty(_components$2, Input.name, Input), _defineProperty(_components$2, Field.name, Field), _defineProperty(_components$2, Select.name, Select), _defineProperty(_components$2, Icon.name, Icon), _defineProperty(_components$2, Dropdown.name, Dropdown), _defineProperty(_components$2, DropdownItem.name, DropdownItem), _components$2),
    mixins: [TimepickerMixin],
    inheritAttrs: false,
    data: function data() {
      return {
        _isTimepicker: true
      };
    },
    computed: {
      nativeStep: function nativeStep() {
        if (this.enableSeconds) return '1';
      }
    }
  };

  /* script */
  const __vue_script__$i = script$i;

  /* template */
  var __vue_render__$g = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"timepicker control",class:[_vm.size, {'is-expanded': _vm.expanded}]},[(!_vm.isMobile || _vm.inline)?_c('b-dropdown',{ref:"dropdown",attrs:{"position":_vm.position,"disabled":_vm.disabled,"inline":_vm.inline}},[(!_vm.inline)?_c('b-input',_vm._b({ref:"input",attrs:{"slot":"trigger","autocomplete":"off","value":_vm.formatValue(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"disabled":_vm.disabled,"readonly":!_vm.editable,"rounded":_vm.rounded,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":function($event){_vm.onBlur() && _vm.checkHtml5Validity();}},nativeOn:{"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.toggle(true);},"change":function($event){_vm.onChange($event.target.value);}},slot:"trigger"},'b-input',_vm.$attrs,false)):_vm._e(),_vm._v(" "),_c('b-dropdown-item',{attrs:{"disabled":_vm.disabled,"custom":""}},[_c('b-field',{attrs:{"grouped":"","position":"is-centered"}},[_c('b-select',{attrs:{"disabled":_vm.disabled,"placeholder":"00"},nativeOn:{"change":function($event){_vm.onHoursChange($event.target.value);}},model:{value:(_vm.hoursSelected),callback:function ($$v) {_vm.hoursSelected=$$v;},expression:"hoursSelected"}},_vm._l((_vm.hours),function(hour){return _c('option',{key:hour.value,attrs:{"disabled":_vm.isHourDisabled(hour.value)},domProps:{"value":hour.value}},[_vm._v("\n                        "+_vm._s(hour.label)+"\n                    ")])})),_vm._v(" "),_c('span',{staticClass:"control is-colon"},[_vm._v(":")]),_vm._v(" "),_c('b-select',{attrs:{"disabled":_vm.disabled,"placeholder":"00"},nativeOn:{"change":function($event){_vm.onMinutesChange($event.target.value);}},model:{value:(_vm.minutesSelected),callback:function ($$v) {_vm.minutesSelected=$$v;},expression:"minutesSelected"}},_vm._l((_vm.minutes),function(minute){return _c('option',{key:minute.value,attrs:{"disabled":_vm.isMinuteDisabled(minute.value)},domProps:{"value":minute.value}},[_vm._v("\n                        "+_vm._s(minute.label)+"\n                    ")])})),_vm._v(" "),(_vm.enableSeconds)?[_c('span',{staticClass:"control is-colon"},[_vm._v(":")]),_vm._v(" "),_c('b-select',{attrs:{"disabled":_vm.disabled,"placeholder":"00"},nativeOn:{"change":function($event){_vm.onSecondsChange($event.target.value);}},model:{value:(_vm.secondsSelected),callback:function ($$v) {_vm.secondsSelected=$$v;},expression:"secondsSelected"}},_vm._l((_vm.seconds),function(second){return _c('option',{key:second.value,attrs:{"disabled":_vm.isSecondDisabled(second.value)},domProps:{"value":second.value}},[_vm._v("\n                            "+_vm._s(second.label)+"\n                        ")])}))]:_vm._e(),_vm._v(" "),(!_vm.isHourFormat24)?_c('b-select',{attrs:{"disabled":_vm.disabled},nativeOn:{"change":function($event){_vm.onMeridienChange($event.target.value);}},model:{value:(_vm.meridienSelected),callback:function ($$v) {_vm.meridienSelected=$$v;},expression:"meridienSelected"}},_vm._l((_vm.meridiens),function(meridien){return _c('option',{key:meridien,domProps:{"value":meridien}},[_vm._v("\n                        "+_vm._s(meridien)+"\n                    ")])})):_vm._e()],2),_vm._v(" "),(_vm.$slots.default !== undefined && _vm.$slots.default.length)?_c('footer',{staticClass:"timepicker-footer"},[_vm._t("default")],2):_vm._e()],1)],1):_c('b-input',_vm._b({ref:"input",attrs:{"type":"time","step":_vm.nativeStep,"autocomplete":"off","value":_vm.formatHHMMSS(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"max":_vm.formatHHMMSS(_vm.maxTime),"min":_vm.formatHHMMSS(_vm.minTime),"disabled":_vm.disabled,"readonly":false,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":function($event){_vm.onBlur() && _vm.checkHtml5Validity();}},nativeOn:{"change":function($event){_vm.onChange($event.target.value);}}},'b-input',_vm.$attrs,false))],1)};
  var __vue_staticRenderFns__$g = [];

    /* style */
    const __vue_inject_styles__$i = undefined;
    /* scoped */
    const __vue_scope_id__$i = undefined;
    /* module identifier */
    const __vue_module_identifier__$i = undefined;
    /* functional template */
    const __vue_is_functional_template__$i = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Timepicker = normalizeComponent_1(
      { render: __vue_render__$g, staticRenderFns: __vue_staticRenderFns__$g },
      __vue_inject_styles__$i,
      __vue_script__$i,
      __vue_scope_id__$i,
      __vue_is_functional_template__$i,
      __vue_module_identifier__$i,
      undefined,
      undefined
    );

  var _components$3;
  var script$j = {
    name: 'BDatetimepicker',
    components: (_components$3 = {}, _defineProperty(_components$3, Datepicker.name, Datepicker), _defineProperty(_components$3, Timepicker.name, Timepicker), _components$3),
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: {
        type: Date
      },
      editable: {
        type: Boolean,
        default: false
      },
      placeholder: String,
      disabled: Boolean,
      icon: String,
      iconPack: String,
      inline: Boolean,
      openOnFocus: Boolean,
      position: String,
      mobileNative: {
        type: Boolean,
        default: true
      },
      minDatetime: Date,
      maxDatetime: Date,
      datetimeFormatter: {
        type: Function
      },
      datetimeParser: {
        type: Function
      },
      datetimeCreator: {
        type: Function,
        default: function _default(date) {
          if (typeof config$1.defaultDatetimeCreator === 'function') {
            return config$1.defaultDatetimeCreator(date);
          } else {
            return date;
          }
        }
      },
      datepicker: Object,
      timepicker: Object
    },
    data: function data() {
      return {
        newValue: this.value
      };
    },
    computed: {
      computedValue: {
        get: function get() {
          return this.newValue;
        },
        set: function set(value) {
          if (value) {
            var val = new Date(value.getTime());

            if (this.newValue) {
              // restore time part
              if (value.getHours() === 0 && value.getMinutes() === 0 && value.getSeconds() === 0) {
                val.setHours(this.newValue.getHours(), this.newValue.getMinutes(), this.newValue.getSeconds(), 0);
              }
            } else {
              val = this.datetimeCreator(value);
            } // check min and max range


            if (this.minDatetime && val < this.minDatetime) {
              val = this.minDatetime;
            } else if (this.maxDatetime && val > this.maxDatetime) {
              val = this.maxDatetime;
            }

            this.newValue = new Date(val.getTime());
          } else {
            this.newValue = value;
          }

          this.$emit('input', this.newValue);
        }
      },
      isMobile: function isMobile$1() {
        return this.mobileNative && isMobile.any();
      },
      minDate: function minDate() {
        if (!this.minDatetime) return null;
        return new Date(this.minDatetime.getFullYear(), this.minDatetime.getMonth(), this.minDatetime.getDate(), 0, 0, 0, 0);
      },
      maxDate: function maxDate() {
        if (!this.maxDatetime) return null;
        return new Date(this.maxDatetime.getFullYear(), this.maxDatetime.getMonth(), this.maxDatetime.getDate(), 0, 0, 0, 0);
      },
      minTime: function minTime() {
        if (!this.minDatetime) return null;
        if (this.newValue === null || typeof this.newValue === 'undefined') return null;

        if (this.minDatetime.getFullYear() === this.newValue.getFullYear() && this.minDatetime.getMonth() === this.newValue.getMonth() && this.minDatetime.getDate() === this.newValue.getDate()) {
          return this.minDatetime;
        }
      },
      maxTime: function maxTime() {
        if (!this.maxDatetime) return null;
        if (this.newValue === null || typeof this.newValue === 'undefined') return null;

        if (this.maxDatetime.getFullYear() === this.newValue.getFullYear() && this.maxDatetime.getMonth() === this.newValue.getMonth() && this.maxDatetime.getDate() === this.newValue.getDate()) {
          return this.maxDatetime;
        }
      },
      datepickerSize: function datepickerSize() {
        return this.datepicker && this.datepicker.size ? this.datepicker.size : this.size;
      },
      timepickerSize: function timepickerSize() {
        return this.timepicker && this.timepicker.size ? this.timepicker.size : this.size;
      },
      timepickerDisabled: function timepickerDisabled() {
        return this.timepicker && this.timepicker.disabled ? this.timepicker.disabled : this.disabled;
      }
    },
    watch: {
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      defaultDatetimeParser: function defaultDatetimeParser(date) {
        if (typeof this.datetimeParser === 'function') {
          return this.datetimeParser(date);
        } else if (typeof config$1.defaultDatetimeParser === 'function') {
          return config$1.defaultDatetimeParser(date);
        } else {
          return new Date(Date.parse(date));
        }
      },
      defaultDatetimeFormatter: function defaultDatetimeFormatter(date) {
        if (typeof this.datetimeFormatter === 'function') {
          return this.datetimeFormatter(date);
        } else if (typeof config$1.defaultDatetimeParser === 'function') {
          return config$1.defaultDatetimeParser(date);
        } else {
          if (this.$refs.timepicker) {
            var yyyyMMdd = date.getFullYear() + '/' + (date.getMonth() + 1) + '/' + date.getDate();
            var d = new Date(yyyyMMdd);
            return d.toLocaleDateString() + ' ' + this.$refs.timepicker.timeFormatter(date, this.$refs.timepicker);
          }

          return null;
        }
      },

      /*
      * Parse date from string
      */
      onChangeNativePicker: function onChangeNativePicker(event) {
        var date = event.target.value;
        this.computedValue = date ? new Date(date) : null;
      },
      formatNative: function formatNative(value) {
        var date = new Date(value);

        if (value && !isNaN(date)) {
          var year = date.getFullYear();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          var hours = date.getHours();
          var minutes = date.getMinutes();
          var seconds = date.getSeconds();
          return year + '-' + ((month < 10 ? '0' : '') + month) + '-' + ((day < 10 ? '0' : '') + day) + 'T' + ((hours < 10 ? '0' : '') + hours) + ':' + ((minutes < 10 ? '0' : '') + minutes) + ':' + ((seconds < 10 ? '0' : '') + seconds);
        }

        return '';
      },
      toggle: function toggle() {
        this.$refs.datepicker.toggle();
      }
    },
    mounted: function mounted() {
      // $refs attached, it's time to refresh datepicker (input)
      if (this.newValue) {
        this.$refs.datepicker.$forceUpdate();
      }
    }
  };

  /* script */
  const __vue_script__$j = script$j;

  /* template */
  var __vue_render__$h = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (!_vm.isMobile || _vm.inline)?_c('b-datepicker',_vm._b({ref:"datepicker",attrs:{"open-on-focus":_vm.openOnFocus,"position":_vm.position,"loading":_vm.loading,"inline":_vm.inline,"editable":_vm.editable,"close-on-click":false,"date-formatter":_vm.defaultDatetimeFormatter,"date-parser":_vm.defaultDatetimeParser,"min-date":_vm.minDate,"max-date":_vm.maxDate,"icon":_vm.icon,"icon-pack":_vm.iconPack,"size":_vm.datepickerSize,"range":false,"disabled":_vm.disabled,"mobile-native":_vm.mobileNative},on:{"change-month":function($event){_vm.$emit('change-month', $event);},"change-year":function($event){_vm.$emit('change-year', $event);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}},'b-datepicker',_vm.datepicker,false),[_c('nav',{staticClass:"level is-mobile"},[(_vm.$slots.left !== undefined)?_c('div',{staticClass:"level-item has-text-centered"},[_vm._t("left")],2):_vm._e(),_vm._v(" "),_c('div',{staticClass:"level-item has-text-centered"},[_c('b-timepicker',_vm._b({ref:"timepicker",attrs:{"inline":"","editable":_vm.editable,"min-time":_vm.minTime,"max-time":_vm.maxTime,"size":_vm.timepickerSize,"disabled":_vm.timepickerDisabled},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}},'b-timepicker',_vm.timepicker,false))],1),_vm._v(" "),(_vm.$slots.right !== undefined)?_c('div',{staticClass:"level-item has-text-centered"},[_vm._t("right")],2):_vm._e()])]):_c('b-input',_vm._b({ref:"input",attrs:{"type":"datetime-local","autocomplete":"off","value":_vm.formatNative(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"max":_vm.formatNative(_vm.maxDate),"min":_vm.formatNative(_vm.minDate),"disabled":_vm.disabled,"readonly":false,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.onFocus,"blur":_vm.onBlur},nativeOn:{"change":function($event){_vm.onChangeNativePicker($event);}}},'b-input',_vm.$attrs,false))};
  var __vue_staticRenderFns__$h = [];

    /* style */
    const __vue_inject_styles__$j = undefined;
    /* scoped */
    const __vue_scope_id__$j = undefined;
    /* module identifier */
    const __vue_module_identifier__$j = undefined;
    /* functional template */
    const __vue_is_functional_template__$j = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Datetimepicker = normalizeComponent_1(
      { render: __vue_render__$h, staticRenderFns: __vue_staticRenderFns__$h },
      __vue_inject_styles__$j,
      __vue_script__$j,
      __vue_scope_id__$j,
      __vue_is_functional_template__$j,
      __vue_module_identifier__$j,
      undefined,
      undefined
    );

  var Plugin$6 = {
    install: function install(Vue) {
      registerComponent(Vue, Datetimepicker);
    }
  };
  use(Plugin$6);

  //
  var script$k = {
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

  /* script */
  const __vue_script__$k = script$k;

  /* template */
  var __vue_render__$i = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":_vm.animation},on:{"after-enter":_vm.afterEnter,"before-leave":_vm.beforeLeave}},[(_vm.isActive)?_c('div',{directives:[{name:"trap-focus",rawName:"v-trap-focus",value:(_vm.trapFocus),expression:"trapFocus"}],staticClass:"modal is-active",class:[{'is-full-screen': _vm.fullScreen}, _vm.customClass],attrs:{"role":_vm.ariaRole,"aria-modal":_vm.ariaModal}},[_c('div',{staticClass:"modal-background",on:{"click":function($event){_vm.cancel('outside');}}}),_vm._v(" "),_c('div',{staticClass:"animation-content",class:{ 'modal-content': !_vm.hasModalCard },style:(_vm.customStyle)},[(_vm.component)?_c(_vm.component,_vm._g(_vm._b({tag:"component",on:{"close":_vm.close}},'component',_vm.props,false),_vm.events)):(_vm.content)?_c('div',{domProps:{"innerHTML":_vm._s(_vm.content)}}):_vm._t("default"),_vm._v(" "),(_vm.showX && !_vm.animating)?_c('button',{staticClass:"modal-close is-large",attrs:{"type":"button"},on:{"click":function($event){_vm.cancel('x');}}}):_vm._e()],2)]):_vm._e()])};
  var __vue_staticRenderFns__$i = [];

    /* style */
    const __vue_inject_styles__$k = undefined;
    /* scoped */
    const __vue_scope_id__$k = undefined;
    /* module identifier */
    const __vue_module_identifier__$k = undefined;
    /* functional template */
    const __vue_is_functional_template__$k = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Modal = normalizeComponent_1(
      { render: __vue_render__$i, staticRenderFns: __vue_staticRenderFns__$i },
      __vue_inject_styles__$k,
      __vue_script__$k,
      __vue_scope_id__$k,
      __vue_is_functional_template__$k,
      __vue_module_identifier__$k,
      undefined,
      undefined
    );

  var script$l = {
    name: 'BDialog',
    components: _defineProperty({}, Icon.name, Icon),
    directives: {
      trapFocus: directive
    },
    extends: Modal,
    props: {
      title: String,
      message: String,
      icon: String,
      iconPack: String,
      hasIcon: Boolean,
      type: {
        type: String,
        default: 'is-primary'
      },
      size: String,
      confirmText: {
        type: String,
        default: function _default() {
          return config$1.defaultDialogConfirmText ? config$1.defaultDialogConfirmText : 'OK';
        }
      },
      cancelText: {
        type: String,
        default: function _default() {
          return config$1.defaultDialogCancelText ? config$1.defaultDialogCancelText : 'Cancel';
        }
      },
      hasInput: Boolean,
      // Used internally to know if it's prompt
      inputAttrs: {
        type: Object,
        default: function _default() {
          return {};
        }
      },
      onConfirm: {
        type: Function,
        default: function _default() {}
      },
      focusOn: {
        type: String,
        default: 'confirm'
      },
      trapFocus: {
        type: Boolean,
        default: config$1.defaultTrapFocus
      },
      ariaRole: {
        type: String,
        validator: function validator(value) {
          return ['dialog', 'alertdialog'].indexOf(value) >= 0;
        }
      },
      ariaModal: Boolean
    },
    data: function data() {
      var prompt = this.hasInput ? this.inputAttrs.value || '' : '';
      return {
        prompt: prompt,
        isActive: false,
        validationMessage: ''
      };
    },
    computed: {
      /**
      * Icon name (MDI) based on the type.
      */
      iconByType: function iconByType() {
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
      },
      showCancel: function showCancel() {
        return this.cancelOptions.indexOf('button') >= 0;
      }
    },
    methods: {
      /**
      * If it's a prompt Dialog, validate the input.
      * Call the onConfirm prop (function) and close the Dialog.
      */
      confirm: function confirm() {
        var _this = this;

        if (this.$refs.input !== undefined) {
          if (!this.$refs.input.checkValidity()) {
            this.validationMessage = this.$refs.input.validationMessage;
            this.$nextTick(function () {
              return _this.$refs.input.select();
            });
            return;
          }
        }

        this.onConfirm(this.prompt);
        this.close();
      },

      /**
      * Close the Dialog.
      */
      close: function close() {
        var _this2 = this;

        this.isActive = false; // Timeout for the animation complete before destroying

        setTimeout(function () {
          _this2.$destroy();

          removeElement(_this2.$el);
        }, 150);
      }
    },
    beforeMount: function beforeMount() {
      var _this3 = this;

      // Insert the Dialog component in body tag
      if (typeof window !== 'undefined') {
        this.$nextTick(function () {
          document.body.appendChild(_this3.$el);
        });
      }
    },
    mounted: function mounted() {
      var _this4 = this;

      this.isActive = true;

      if (typeof this.inputAttrs.required === 'undefined') {
        this.$set(this.inputAttrs, 'required', true);
      }

      this.$nextTick(function () {
        // Handle which element receives focus
        if (_this4.hasInput) {
          _this4.$refs.input.focus();
        } else if (_this4.focusOn === 'cancel' && _this4.showCancel) {
          _this4.$refs.cancelButton.focus();
        } else {
          _this4.$refs.confirmButton.focus();
        }
      });
    }
  };

  /* script */
  const __vue_script__$l = script$l;

  /* template */
  var __vue_render__$j = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":_vm.animation}},[(_vm.isActive)?_c('div',{directives:[{name:"trap-focus",rawName:"v-trap-focus",value:(_vm.trapFocus),expression:"trapFocus"}],staticClass:"dialog modal is-active",class:_vm.size,attrs:{"role":_vm.ariaRole,"aria-modal":_vm.ariaModal}},[_c('div',{staticClass:"modal-background",on:{"click":function($event){_vm.cancel('outside');}}}),_vm._v(" "),_c('div',{staticClass:"modal-card animation-content"},[(_vm.title)?_c('header',{staticClass:"modal-card-head"},[_c('p',{staticClass:"modal-card-title"},[_vm._v(_vm._s(_vm.title))])]):_vm._e(),_vm._v(" "),_c('section',{staticClass:"modal-card-body",class:{ 'is-titleless': !_vm.title, 'is-flex': _vm.hasIcon }},[_c('div',{staticClass:"media"},[(_vm.hasIcon && (_vm.icon || _vm.iconByType))?_c('div',{staticClass:"media-left"},[_c('b-icon',{attrs:{"icon":_vm.icon ? _vm.icon : _vm.iconByType,"pack":_vm.iconPack,"type":_vm.type,"both":!_vm.icon,"size":"is-large"}})],1):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media-content"},[_c('p',{domProps:{"innerHTML":_vm._s(_vm.message)}}),_vm._v(" "),(_vm.hasInput)?_c('div',{staticClass:"field"},[_c('div',{staticClass:"control"},[_c('input',_vm._b({directives:[{name:"model",rawName:"v-model",value:(_vm.prompt),expression:"prompt"}],ref:"input",staticClass:"input",class:{ 'is-danger': _vm.validationMessage },domProps:{"value":(_vm.prompt)},on:{"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.confirm($event);},"input":function($event){if($event.target.composing){ return; }_vm.prompt=$event.target.value;}}},'input',_vm.inputAttrs,false))]),_vm._v(" "),_c('p',{staticClass:"help is-danger"},[_vm._v(_vm._s(_vm.validationMessage))])]):_vm._e()])])]),_vm._v(" "),_c('footer',{staticClass:"modal-card-foot"},[(_vm.showCancel)?_c('button',{ref:"cancelButton",staticClass:"button",on:{"click":function($event){_vm.cancel('button');}}},[_vm._v("\n                    "+_vm._s(_vm.cancelText)+"\n                ")]):_vm._e(),_vm._v(" "),_c('button',{ref:"confirmButton",staticClass:"button",class:_vm.type,on:{"click":_vm.confirm}},[_vm._v("\n                    "+_vm._s(_vm.confirmText)+"\n                ")])])])]):_vm._e()])};
  var __vue_staticRenderFns__$j = [];

    /* style */
    const __vue_inject_styles__$l = undefined;
    /* scoped */
    const __vue_scope_id__$l = undefined;
    /* module identifier */
    const __vue_module_identifier__$l = undefined;
    /* functional template */
    const __vue_is_functional_template__$l = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Dialog = normalizeComponent_1(
      { render: __vue_render__$j, staticRenderFns: __vue_staticRenderFns__$j },
      __vue_inject_styles__$l,
      __vue_script__$l,
      __vue_scope_id__$l,
      __vue_is_functional_template__$l,
      __vue_module_identifier__$l,
      undefined,
      undefined
    );

  function open(propsData) {
    var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : Vue;
    var DialogComponent = vm.extend(Dialog);
    return new DialogComponent({
      el: document.createElement('div'),
      propsData: propsData
    });
  }

  var DialogProgrammatic = {
    alert: function alert(params) {
      var message;
      if (typeof params === 'string') message = params;
      var defaultParam = {
        canCancel: false,
        message: message
      };
      var propsData = Object.assign(defaultParam, params);
      return open(propsData);
    },
    confirm: function confirm(params) {
      var defaultParam = {};
      var propsData = Object.assign(defaultParam, params);
      return open(propsData);
    },
    prompt: function prompt(params) {
      var defaultParam = {
        hasInput: true,
        confirmText: 'Done'
      };
      var propsData = Object.assign(defaultParam, params);
      return open(propsData);
    }
  };
  var Plugin$7 = {
    install: function install(Vue) {
      registerComponent(Vue, Dialog);
      registerComponentProgrammatic(Vue, 'dialog', DialogProgrammatic);
    }
  };
  use(Plugin$7);

  var Plugin$8 = {
    install: function install(Vue) {
      registerComponent(Vue, Dropdown);
      registerComponent(Vue, DropdownItem);
    }
  };
  use(Plugin$8);

  var Plugin$9 = {
    install: function install(Vue) {
      registerComponent(Vue, Field);
    }
  };
  use(Plugin$9);

  var Plugin$a = {
    install: function install(Vue) {
      registerComponent(Vue, Icon);
    }
  };
  use(Plugin$a);

  var Plugin$b = {
    install: function install(Vue) {
      registerComponent(Vue, Input);
    }
  };
  use(Plugin$b);

  // Polyfills for SSR
  var isSSR = typeof window === 'undefined';
  var HTMLElement = isSSR ? Object : window.HTMLElement;
  var File = isSSR ? Object : window.File;

  //
  var script$m = {
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
  const __vue_script__$m = script$m;

  /* template */
  var __vue_render__$k = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":_vm.animation}},[(_vm.isActive)?_c('div',{staticClass:"loading-overlay is-active",class:{ 'is-full-page': _vm.isFullPage }},[_c('div',{staticClass:"loading-background",on:{"click":_vm.cancel}}),_vm._v(" "),_vm._t("default",[_c('div',{staticClass:"loading-icon"})])],2):_vm._e()])};
  var __vue_staticRenderFns__$k = [];

    /* style */
    const __vue_inject_styles__$m = undefined;
    /* scoped */
    const __vue_scope_id__$m = undefined;
    /* module identifier */
    const __vue_module_identifier__$m = undefined;
    /* functional template */
    const __vue_is_functional_template__$m = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Loading = normalizeComponent_1(
      { render: __vue_render__$k, staticRenderFns: __vue_staticRenderFns__$k },
      __vue_inject_styles__$m,
      __vue_script__$m,
      __vue_scope_id__$m,
      __vue_is_functional_template__$m,
      __vue_module_identifier__$m,
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
  var Plugin$c = {
    install: function install(Vue) {
      registerComponent(Vue, Loading);
      registerComponentProgrammatic(Vue, 'loading', LoadingProgrammatic);
    }
  };
  use(Plugin$c);

  //
  //
  //
  //
  //
  //
  var script$n = {
    name: 'BMenu'
  };

  /* script */
  const __vue_script__$n = script$n;

  /* template */
  var __vue_render__$l = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"menu"},[_vm._t("default")],2)};
  var __vue_staticRenderFns__$l = [];

    /* style */
    const __vue_inject_styles__$n = undefined;
    /* scoped */
    const __vue_scope_id__$n = undefined;
    /* module identifier */
    const __vue_module_identifier__$n = undefined;
    /* functional template */
    const __vue_is_functional_template__$n = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Menu = normalizeComponent_1(
      { render: __vue_render__$l, staticRenderFns: __vue_staticRenderFns__$l },
      __vue_inject_styles__$n,
      __vue_script__$n,
      __vue_scope_id__$n,
      __vue_is_functional_template__$n,
      __vue_module_identifier__$n,
      undefined,
      undefined
    );

  var script$o = {
    name: 'BMenuList',
    functional: true,
    props: {
      label: String,
      icon: String,
      iconPack: String,
      ariaRole: {
        type: String,
        default: ''
      }
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
          'class': 'menu-list',
          'role': context.props.ariaRole === 'menu' ? context.props.ariaRole : null
        }
      }, slots.default);
      return vlabel ? [vlabel, vnode] : vnode;
    }
  };

  /* script */
  const __vue_script__$o = script$o;

  /* template */

    /* style */
    const __vue_inject_styles__$o = undefined;
    /* scoped */
    const __vue_scope_id__$o = undefined;
    /* module identifier */
    const __vue_module_identifier__$o = undefined;
    /* functional template */
    const __vue_is_functional_template__$o = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var MenuList = normalizeComponent_1(
      {},
      __vue_inject_styles__$o,
      __vue_script__$o,
      __vue_scope_id__$o,
      __vue_is_functional_template__$o,
      __vue_module_identifier__$o,
      undefined,
      undefined
    );

  var script$p = {
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
      },
      ariaRole: {
        type: String,
        default: ''
      }
    },
    data: function data() {
      return {
        newActive: this.active,
        newExpanded: this.expanded
      };
    },
    computed: {
      ariaRoleMenu: function ariaRoleMenu() {
        return this.ariaRole === 'menuitem' ? this.ariaRole : null;
      }
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
  const __vue_script__$p = script$p;

  /* template */
  var __vue_render__$m = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('li',{attrs:{"role":_vm.ariaRoleMenu}},[_c(_vm.tag,_vm._b({tag:"component",class:{
              'is-active': _vm.newActive,
              'is-disabled': _vm.disabled
          },on:{"click":function($event){_vm.onClick($event);}},nativeOn:{"click":function($event){_vm.onClick($event);}}},'component',_vm.$attrs,false),[(_vm.icon)?_c('b-icon',{attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":"is-small"}}):_vm._e(),_vm._v(" "),(_vm.label)?_c('span',[_vm._v(_vm._s(_vm.label))]):_vm._t("label",null,{expanded:_vm.newExpanded,active:_vm.newActive})],2),_vm._v(" "),(_vm.$slots.default)?[_c('transition',{attrs:{"name":_vm.animation}},[_c('ul',{directives:[{name:"show",rawName:"v-show",value:(_vm.newExpanded),expression:"newExpanded"}]},[_vm._t("default")],2)])]:_vm._e()],2)};
  var __vue_staticRenderFns__$m = [];

    /* style */
    const __vue_inject_styles__$p = undefined;
    /* scoped */
    const __vue_scope_id__$p = undefined;
    /* module identifier */
    const __vue_module_identifier__$p = undefined;
    /* functional template */
    const __vue_is_functional_template__$p = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var MenuItem = normalizeComponent_1(
      { render: __vue_render__$m, staticRenderFns: __vue_staticRenderFns__$m },
      __vue_inject_styles__$p,
      __vue_script__$p,
      __vue_scope_id__$p,
      __vue_is_functional_template__$p,
      __vue_module_identifier__$p,
      undefined,
      undefined
    );

  var Plugin$d = {
    install: function install(Vue) {
      registerComponent(Vue, Menu);
      registerComponent(Vue, MenuList);
      registerComponent(Vue, MenuItem);
    }
  };
  use(Plugin$d);

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
  var script$q = {
    name: 'BMessage',
    mixins: [MessageMixin],
    props: {
      ariaCloseLabel: String
    },
    data: function data() {
      return {
        newIconSize: this.iconSize || this.size || 'is-large'
      };
    }
  };

  /* script */
  const __vue_script__$q = script$q;

  /* template */
  var __vue_render__$n = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":"fade"}},[(_vm.isActive)?_c('article',{staticClass:"message",class:[_vm.type, _vm.size]},[(_vm.title)?_c('header',{staticClass:"message-header"},[_c('p',[_vm._v(_vm._s(_vm.title))]),_vm._v(" "),(_vm.closable)?_c('button',{staticClass:"delete",attrs:{"type":"button","aria-label":_vm.ariaCloseLabel},on:{"click":_vm.close}}):_vm._e()]):_vm._e(),_vm._v(" "),_c('section',{staticClass:"message-body"},[_c('div',{staticClass:"media"},[(_vm.icon && _vm.hasIcon)?_c('div',{staticClass:"media-left"},[_c('b-icon',{class:_vm.type,attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"both":"","size":_vm.newIconSize}})],1):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media-content"},[_vm._t("default")],2)])])]):_vm._e()])};
  var __vue_staticRenderFns__$n = [];

    /* style */
    const __vue_inject_styles__$q = undefined;
    /* scoped */
    const __vue_scope_id__$q = undefined;
    /* module identifier */
    const __vue_module_identifier__$q = undefined;
    /* functional template */
    const __vue_is_functional_template__$q = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Message = normalizeComponent_1(
      { render: __vue_render__$n, staticRenderFns: __vue_staticRenderFns__$n },
      __vue_inject_styles__$q,
      __vue_script__$q,
      __vue_scope_id__$q,
      __vue_is_functional_template__$q,
      __vue_module_identifier__$q,
      undefined,
      undefined
    );

  var Plugin$e = {
    install: function install(Vue) {
      registerComponent(Vue, Message);
    }
  };
  use(Plugin$e);

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
  var Plugin$f = {
    install: function install(Vue) {
      registerComponent(Vue, Modal);
      registerComponentProgrammatic(Vue, 'modal', ModalProgrammatic);
    }
  };
  use(Plugin$f);

  //
  var script$r = {
    name: 'BNotification',
    mixins: [MessageMixin],
    props: {
      position: String,
      ariaCloseLabel: String
    }
  };

  /* script */
  const __vue_script__$r = script$r;

  /* template */
  var __vue_render__$o = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":"fade"}},[_c('article',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"notification",class:[_vm.type, _vm.position]},[(_vm.closable)?_c('button',{staticClass:"delete",attrs:{"type":"button","aria-label":_vm.ariaCloseLabel},on:{"click":_vm.close}}):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media"},[(_vm.icon && _vm.hasIcon)?_c('div',{staticClass:"media-left"},[_c('b-icon',{attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"both":"","size":"is-large","aria-hidden":""}})],1):_vm._e(),_vm._v(" "),_c('div',{staticClass:"media-content"},[(_vm.message)?_c('p',{staticClass:"text",domProps:{"innerHTML":_vm._s(_vm.message)}}):_vm._t("default")],2)])])])};
  var __vue_staticRenderFns__$o = [];

    /* style */
    const __vue_inject_styles__$r = undefined;
    /* scoped */
    const __vue_scope_id__$r = undefined;
    /* module identifier */
    const __vue_module_identifier__$r = undefined;
    /* functional template */
    const __vue_is_functional_template__$r = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Notification = normalizeComponent_1(
      { render: __vue_render__$o, staticRenderFns: __vue_staticRenderFns__$o },
      __vue_inject_styles__$r,
      __vue_script__$r,
      __vue_scope_id__$r,
      __vue_is_functional_template__$r,
      __vue_module_identifier__$r,
      undefined,
      undefined
    );

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
  var script$s = {
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
  const __vue_script__$s = script$s;

  /* template */
  var __vue_render__$p = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('b-notification',_vm._b({on:{"close":_vm.close}},'b-notification',_vm.$options.propsData,false))};
  var __vue_staticRenderFns__$p = [];

    /* style */
    const __vue_inject_styles__$s = undefined;
    /* scoped */
    const __vue_scope_id__$s = undefined;
    /* module identifier */
    const __vue_module_identifier__$s = undefined;
    /* functional template */
    const __vue_is_functional_template__$s = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var NotificationNotice = normalizeComponent_1(
      { render: __vue_render__$p, staticRenderFns: __vue_staticRenderFns__$p },
      __vue_inject_styles__$s,
      __vue_script__$s,
      __vue_scope_id__$s,
      __vue_is_functional_template__$s,
      __vue_module_identifier__$s,
      undefined,
      undefined
    );

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
  var Plugin$g = {
    install: function install(Vue) {
      registerComponent(Vue, Notification);
      registerComponentProgrammatic(Vue, 'notification', NotificationProgrammatic);
    }
  };
  use(Plugin$g);

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
  var script$t = {
    name: 'NavbarBurger',
    props: {
      isOpened: {
        type: Boolean,
        default: false
      }
    }
  };

  /* script */
  const __vue_script__$t = script$t;

  /* template */
  var __vue_render__$q = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('a',_vm._g({staticClass:"navbar-burger burger",class:{ 'is-active': _vm.isOpened },attrs:{"role":"button","aria-label":"menu","aria-expanded":_vm.isOpened}},_vm.$listeners),[_c('span',{attrs:{"aria-hidden":"true"}}),_vm._v(" "),_c('span',{attrs:{"aria-hidden":"true"}}),_vm._v(" "),_c('span',{attrs:{"aria-hidden":"true"}})])};
  var __vue_staticRenderFns__$q = [];

    /* style */
    const __vue_inject_styles__$t = undefined;
    /* scoped */
    const __vue_scope_id__$t = undefined;
    /* module identifier */
    const __vue_module_identifier__$t = undefined;
    /* functional template */
    const __vue_is_functional_template__$t = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var NavbarBurger = normalizeComponent_1(
      { render: __vue_render__$q, staticRenderFns: __vue_staticRenderFns__$q },
      __vue_inject_styles__$t,
      __vue_script__$t,
      __vue_scope_id__$t,
      __vue_is_functional_template__$t,
      __vue_module_identifier__$t,
      undefined,
      undefined
    );

  var isTouch = typeof window !== 'undefined' && ('ontouchstart' in window || navigator.msMaxTouchPoints > 0);
  var events = isTouch ? ['touchstart', 'click'] : ['click'];
  var instances = [];

  function processArgs(bindingValue) {
    var isFunction = typeof bindingValue === 'function';

    if (!isFunction && _typeof(bindingValue) !== 'object') {
      throw new Error("v-click-outside: Binding value should be a function or an object, typeof ".concat(bindingValue, " given"));
    }

    return {
      handler: isFunction ? bindingValue : bindingValue.handler,
      middleware: bindingValue.middleware || function (isClickOutside) {
        return isClickOutside;
      },
      events: bindingValue.events || events
    };
  }

  function onEvent(_ref) {
    var el = _ref.el,
        event = _ref.event,
        handler = _ref.handler,
        middleware = _ref.middleware;
    var isClickOutside = event.target !== el && !el.contains(event.target);

    if (!isClickOutside) {
      return;
    }

    if (middleware(event, el)) {
      handler(event, el);
    }
  }

  function bind$1(el, _ref2) {
    var value = _ref2.value;

    var _processArgs = processArgs(value),
        _handler = _processArgs.handler,
        middleware = _processArgs.middleware,
        events = _processArgs.events;

    var instance = {
      el: el,
      eventHandlers: events.map(function (eventName) {
        return {
          event: eventName,
          handler: function handler(event) {
            return onEvent({
              event: event,
              el: el,
              handler: _handler,
              middleware: middleware
            });
          }
        };
      })
    };
    instance.eventHandlers.forEach(function (_ref3) {
      var event = _ref3.event,
          handler = _ref3.handler;
      return document.addEventListener(event, handler);
    });
    instances.push(instance);
  }

  function update(el, _ref4) {
    var value = _ref4.value;

    var _processArgs2 = processArgs(value),
        _handler2 = _processArgs2.handler,
        middleware = _processArgs2.middleware,
        events = _processArgs2.events;

    var instance = instances.find(function (instance) {
      return instance.el === el;
    });
    instance.eventHandlers.forEach(function (_ref5) {
      var event = _ref5.event,
          handler = _ref5.handler;
      return document.removeEventListener(event, handler);
    });
    instance.eventHandlers = events.map(function (eventName) {
      return {
        event: eventName,
        handler: function handler(event) {
          return onEvent({
            event: event,
            el: el,
            handler: _handler2,
            middleware: middleware
          });
        }
      };
    });
    instance.eventHandlers.forEach(function (_ref6) {
      var event = _ref6.event,
          handler = _ref6.handler;
      return document.addEventListener(event, handler);
    });
  }

  function unbind$1(el) {
    var instance = instances.find(function (instance) {
      return instance.el === el;
    });
    instance.eventHandlers.forEach(function (_ref7) {
      var event = _ref7.event,
          handler = _ref7.handler;
      return document.removeEventListener(event, handler);
    });
  }

  var directive$1 = {
    bind: bind$1,
    update: update,
    unbind: unbind$1,
    instances: instances
  };

  var FIXED_TOP_CLASS = 'is-fixed-top';
  var BODY_FIXED_TOP_CLASS = 'has-navbar-fixed-top';
  var BODY_SPACED_FIXED_TOP_CLASS = 'has-spaced-navbar-fixed-top';
  var FIXED_BOTTOM_CLASS = 'is-fixed-bottom';
  var BODY_FIXED_BOTTOM_CLASS = 'has-navbar-fixed-bottom';
  var BODY_SPACED_FIXED_BOTTOM_CLASS = 'has-spaced-navbar-fixed-bottom';

  var isFilled = function isFilled(str) {
    return !!str;
  };

  var script$u = {
    name: 'BNavbar',
    components: {
      NavbarBurger: NavbarBurger
    },
    directives: {
      clickOutside: directive$1
    },
    props: {
      type: [String, Object],
      transparent: {
        type: Boolean,
        default: false
      },
      fixedTop: {
        type: Boolean,
        default: false
      },
      fixedBottom: {
        type: Boolean,
        default: false
      },
      isActive: {
        type: Boolean,
        default: false
      },
      wrapperClass: {
        type: String
      },
      closeOnClick: {
        type: Boolean,
        default: true
      },
      mobileBurger: {
        type: Boolean,
        default: true
      },
      spaced: Boolean,
      shadow: Boolean
    },
    data: function data() {
      return {
        internalIsActive: this.isActive
      };
    },
    computed: {
      isOpened: function isOpened() {
        return this.internalIsActive;
      },
      computedClasses: function computedClasses() {
        var _ref;

        return [this.type, (_ref = {}, _defineProperty(_ref, FIXED_TOP_CLASS, this.fixedTop), _defineProperty(_ref, FIXED_BOTTOM_CLASS, this.fixedBottom), _defineProperty(_ref, 'is-spaced', this.spaced), _defineProperty(_ref, 'has-shadow', this.shadow), _defineProperty(_ref, 'is-transparent', this.transparent), _ref)];
      }
    },
    watch: {
      isActive: {
        handler: function handler(isActive) {
          this.internalIsActive = isActive;
        },
        immediate: true
      },
      fixedTop: {
        handler: function handler(isSet) {
          this.checkIfFixedPropertiesAreColliding();
          var className = this.spaced ? BODY_SPACED_FIXED_TOP_CLASS : BODY_FIXED_TOP_CLASS;

          if (isSet) {
            return this.setBodyClass(className);
          }

          this.removeBodyClass(className);
        },
        immediate: true
      },
      fixedBottom: {
        handler: function handler(isSet) {
          this.checkIfFixedPropertiesAreColliding();
          var className = this.spaced ? BODY_SPACED_FIXED_BOTTOM_CLASS : BODY_FIXED_BOTTOM_CLASS;

          if (isSet) {
            return this.setBodyClass(className);
          }

          this.removeBodyClass(className);
        },
        immediate: true
      }
    },
    methods: {
      toggleActive: function toggleActive() {
        this.internalIsActive = !this.internalIsActive;
        this.emitUpdateParentEvent();
      },
      closeMenu: function closeMenu() {
        if (this.closeOnClick) {
          this.internalIsActive = false;
          this.emitUpdateParentEvent();
        }
      },
      emitUpdateParentEvent: function emitUpdateParentEvent() {
        this.$emit('update:isActive', this.internalIsActive);
      },
      setBodyClass: function setBodyClass(className) {
        if (typeof window !== 'undefined') {
          document.body.classList.add(className);
        }
      },
      removeBodyClass: function removeBodyClass(className) {
        if (typeof window !== 'undefined') {
          document.body.classList.remove(className);
        }
      },
      checkIfFixedPropertiesAreColliding: function checkIfFixedPropertiesAreColliding() {
        var areColliding = this.fixedTop && this.fixedBottom;

        if (areColliding) {
          throw new Error('You should choose if the BNavbar is fixed bottom or fixed top, but not both');
        }
      },
      genNavbar: function genNavbar(createElement) {
        var navBarSlots = [this.genNavbarBrandNode(createElement), this.genNavbarSlotsNode(createElement)];

        if (!isFilled(this.wrapperClass)) {
          return this.genNavbarSlots(createElement, navBarSlots);
        } // It wraps the slots into a div with the provided wrapperClass prop


        var navWrapper = createElement('div', {
          class: this.wrapperClass
        }, navBarSlots);
        return this.genNavbarSlots(createElement, [navWrapper]);
      },
      genNavbarSlots: function genNavbarSlots(createElement, slots) {
        return createElement('nav', {
          staticClass: 'navbar',
          class: this.computedClasses,
          attrs: {
            role: 'navigation',
            'aria-label': 'main navigation'
          },
          directives: [{
            name: 'click-outside',
            value: this.closeMenu
          }]
        }, slots);
      },
      genNavbarBrandNode: function genNavbarBrandNode(createElement) {
        return createElement('div', {
          class: 'navbar-brand'
        }, [this.$slots.brand, this.genBurgerNode(createElement)]);
      },
      genBurgerNode: function genBurgerNode(createElement) {
        if (this.mobileBurger) {
          var defaultBurgerNode = createElement('navbar-burger', {
            props: {
              isOpened: this.isOpened
            },
            on: {
              click: this.toggleActive
            }
          });
          var hasBurgerSlot = !!this.$scopedSlots.burger;
          return hasBurgerSlot ? this.$scopedSlots.burger({
            isOpened: this.isOpened,
            toggleActive: this.toggleActive
          }) : defaultBurgerNode;
        }
      },
      genNavbarSlotsNode: function genNavbarSlotsNode(createElement) {
        return createElement('div', {
          staticClass: 'navbar-menu',
          class: {
            'is-active': this.isOpened
          }
        }, [this.genMenuPosition(createElement, 'start'), this.genMenuPosition(createElement, 'end')]);
      },
      genMenuPosition: function genMenuPosition(createElement, positionName) {
        return createElement('div', {
          staticClass: "navbar-".concat(positionName)
        }, this.$slots[positionName]);
      }
    },
    beforeDestroy: function beforeDestroy() {
      this.removeBodyClass(FIXED_BOTTOM_CLASS);
      this.removeBodyClass(FIXED_TOP_CLASS);
    },
    render: function render(createElement, fn) {
      return this.genNavbar(createElement);
    }
  };

  /* script */
  const __vue_script__$u = script$u;

  /* template */

    /* style */
    const __vue_inject_styles__$u = undefined;
    /* scoped */
    const __vue_scope_id__$u = undefined;
    /* module identifier */
    const __vue_module_identifier__$u = undefined;
    /* functional template */
    const __vue_is_functional_template__$u = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Navbar = normalizeComponent_1(
      {},
      __vue_inject_styles__$u,
      __vue_script__$u,
      __vue_scope_id__$u,
      __vue_is_functional_template__$u,
      __vue_module_identifier__$u,
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
  var clickableWhiteList = ['div', 'span'];
  var script$v = {
    name: 'BNavbarItem',
    inheritAttrs: false,
    props: {
      tag: {
        type: String,
        default: 'a'
      },
      active: Boolean
    },
    methods: {
      /**
       * Keypress event that is bound to the document
       */
      keyPress: function keyPress(event) {
        // Esc key
        // TODO: use code instead (because keyCode is actually deprecated)
        // https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/keyCode
        if (event.keyCode === 27) {
          this.$parent.closeMenu();
        }
      },

      /**
       * Close parent if clicked outside.
       */
      handleClickEvent: function handleClickEvent(event) {
        var isOnWhiteList = clickableWhiteList.some(function (item) {
          return item === event.target.localName;
        });

        if (!isOnWhiteList) {
          if (this.$parent.$data._isNavDropdown) {
            this.$parent.closeMenu();
            this.$parent.$parent.closeMenu();
          } else {
            this.$parent.closeMenu();
          }
        }
      }
    },
    mounted: function mounted() {
      if (typeof window !== 'undefined') {
        this.$el.addEventListener('click', this.handleClickEvent);
        document.addEventListener('keyup', this.keyPress);
      }
    },
    beforeDestroy: function beforeDestroy() {
      if (typeof window !== 'undefined') {
        this.$el.removeEventListener('click', this.handleClickEvent);
        document.removeEventListener('keyup', this.keyPress);
      }
    }
  };

  /* script */
  const __vue_script__$v = script$v;

  /* template */
  var __vue_render__$r = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c(_vm.tag,_vm._g(_vm._b({tag:"component",staticClass:"navbar-item",class:{
          'is-active': _vm.active
      }},'component',_vm.$attrs,false),_vm.$listeners),[_vm._t("default")],2)};
  var __vue_staticRenderFns__$r = [];

    /* style */
    const __vue_inject_styles__$v = undefined;
    /* scoped */
    const __vue_scope_id__$v = undefined;
    /* module identifier */
    const __vue_module_identifier__$v = undefined;
    /* functional template */
    const __vue_is_functional_template__$v = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var NavbarItem = normalizeComponent_1(
      { render: __vue_render__$r, staticRenderFns: __vue_staticRenderFns__$r },
      __vue_inject_styles__$v,
      __vue_script__$v,
      __vue_scope_id__$v,
      __vue_is_functional_template__$v,
      __vue_module_identifier__$v,
      undefined,
      undefined
    );

  //
  var script$w = {
    name: 'BNavbarDropdown',
    directives: {
      clickOutside: directive$1
    },
    props: {
      label: String,
      hoverable: Boolean,
      active: Boolean,
      right: Boolean,
      arrowless: Boolean,
      boxed: Boolean
    },
    data: function data() {
      return {
        newActive: this.active,
        _isNavDropdown: true // Used internally by NavbarItem

      };
    },
    watch: {
      active: function active(value) {
        this.newActive = value;
      }
    },
    methods: {
      showMenu: function showMenu() {
        this.newActive = true;
      },

      /**
      * See naming convetion of navbaritem
      */
      closeMenu: function closeMenu() {
        this.newActive = false;
      }
    }
  };

  /* script */
  const __vue_script__$w = script$w;

  /* template */
  var __vue_render__$s = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{directives:[{name:"click-outside",rawName:"v-click-outside",value:(_vm.closeMenu),expression:"closeMenu"}],staticClass:"navbar-item has-dropdown",class:{
          'is-hoverable': _vm.hoverable,
          'is-active': _vm.newActive
      }},[_c('a',{staticClass:"navbar-link",class:{
              'is-arrowless': _vm.arrowless
          },on:{"click":function($event){_vm.newActive = !_vm.newActive;}}},[(_vm.label)?[_vm._v(_vm._s(_vm.label))]:_vm._t("label")],2),_vm._v(" "),_c('div',{staticClass:"navbar-dropdown",class:{
              'is-right': _vm.right,
              'is-boxed': _vm.boxed
          }},[_vm._t("default")],2)])};
  var __vue_staticRenderFns__$s = [];

    /* style */
    const __vue_inject_styles__$w = undefined;
    /* scoped */
    const __vue_scope_id__$w = undefined;
    /* module identifier */
    const __vue_module_identifier__$w = undefined;
    /* functional template */
    const __vue_is_functional_template__$w = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var NavbarDropdown = normalizeComponent_1(
      { render: __vue_render__$s, staticRenderFns: __vue_staticRenderFns__$s },
      __vue_inject_styles__$w,
      __vue_script__$w,
      __vue_scope_id__$w,
      __vue_is_functional_template__$w,
      __vue_module_identifier__$w,
      undefined,
      undefined
    );

  var Plugin$h = {
    install: function install(Vue) {
      registerComponent(Vue, Navbar);
      registerComponent(Vue, NavbarItem);
      registerComponent(Vue, NavbarDropdown);
    }
  };
  use(Plugin$h);

  var _components$4;
  var script$x = {
    name: 'BNumberinput',
    components: (_components$4 = {}, _defineProperty(_components$4, Icon.name, Icon), _defineProperty(_components$4, Input.name, Input), _components$4),
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: Number,
      min: [Number, String],
      max: [Number, String],
      step: [Number, String],
      disabled: Boolean,
      type: {
        type: String,
        default: 'is-primary'
      },
      editable: {
        type: Boolean,
        default: true
      },
      controlsRounded: {
        type: Boolean,
        default: false
      },
      controlsPosition: String
    },
    data: function data() {
      return {
        newValue: !isNaN(this.value) ? this.value : parseFloat(this.min) || 0,
        newStep: this.step || 1,
        _elementRef: 'input'
      };
    },
    computed: {
      computedValue: {
        get: function get() {
          return this.newValue;
        },
        set: function set(value) {
          var newValue = value;

          if (value === '') {
            newValue = parseFloat(this.min) || 0;
          }

          this.newValue = newValue;
          this.$emit('input', newValue);
          !this.isValid && this.$refs.input.checkHtml5Validity();
        }
      },
      fieldClasses: function fieldClasses() {
        return [{
          'has-addons': this.controlsPosition === 'compact'
        }, {
          'is-grouped': this.controlsPosition !== 'compact'
        }, {
          'is-expanded': this.expanded
        }];
      },
      buttonClasses: function buttonClasses() {
        return [this.type, this.size, {
          'is-rounded': this.controlsRounded
        }];
      },
      minNumber: function minNumber() {
        return typeof this.min === 'string' ? parseFloat(this.min) : this.min;
      },
      maxNumber: function maxNumber() {
        return typeof this.max === 'string' ? parseFloat(this.max) : this.max;
      },
      stepNumber: function stepNumber() {
        return typeof this.newStep === 'string' ? parseFloat(this.newStep) : this.newStep;
      },
      disabledMin: function disabledMin() {
        return this.computedValue - this.stepNumber < this.minNumber;
      },
      disabledMax: function disabledMax() {
        return this.computedValue + this.stepNumber > this.maxNumber;
      },
      stepDecimals: function stepDecimals() {
        var step = this.stepNumber.toString();
        var index = step.indexOf('.');

        if (index >= 0) {
          return step.substring(index + 1).length;
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
      decrement: function decrement() {
        if (typeof this.minNumber === 'undefined' || this.computedValue - this.stepNumber >= this.minNumber) {
          var value = this.computedValue - this.stepNumber;
          this.computedValue = parseFloat(value.toFixed(this.stepDecimals));
        }
      },
      increment: function increment() {
        if (typeof this.maxNumber === 'undefined' || this.computedValue + this.stepNumber <= this.maxNumber) {
          var value = this.computedValue + this.stepNumber;
          this.computedValue = parseFloat(value.toFixed(this.stepDecimals));
        }
      },
      onControlClick: function onControlClick(event, inc) {
        // IE 11 -> filter click event
        if (event.detail !== 0 || event.type === 'click') return;
        if (inc) this.increment();else this.decrement();
      },
      onStartLongPress: function onStartLongPress(event, inc) {
        var _this = this;

        if (event.button !== 0 && event.type !== 'touchstart') return;
        this._$intervalTime = new Date();
        clearInterval(this._$intervalRef);
        this._$intervalRef = setInterval(function () {
          if (inc) _this.increment();else _this.decrement();
        }, 250);
      },
      onStopLongPress: function onStopLongPress(inc) {
        if (!this._$intervalRef) return;
        var d = new Date();

        if (d - this._$intervalTime < 250) {
          if (inc) this.increment();else this.decrement();
        }

        clearInterval(this._$intervalRef);
        this._$intervalRef = null;
      }
    }
  };

  /* script */
  const __vue_script__$x = script$x;

  /* template */
  var __vue_render__$t = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-numberinput field",class:_vm.fieldClasses},[_c('p',{staticClass:"control",on:{"mouseup":function($event){_vm.onStopLongPress(false);},"mouseleave":function($event){_vm.onStopLongPress(false);},"touchend":function($event){_vm.onStopLongPress(false);},"touchcancel":function($event){_vm.onStopLongPress(false);}}},[_c('button',{staticClass:"button",class:_vm.buttonClasses,attrs:{"type":"button","disabled":_vm.disabled || _vm.disabledMin},on:{"mousedown":function($event){_vm.onStartLongPress($event, false);},"touchstart":function($event){$event.preventDefault();_vm.onStartLongPress($event, false);},"click":function($event){_vm.onControlClick($event, false);}}},[_c('b-icon',{attrs:{"icon":"minus","pack":_vm.iconPack,"size":_vm.iconSize}})],1)]),_vm._v(" "),_c('b-input',_vm._b({ref:"input",attrs:{"type":"number","step":_vm.newStep,"max":_vm.max,"min":_vm.min,"size":_vm.size,"disabled":_vm.disabled,"readonly":!_vm.editable,"loading":_vm.loading,"rounded":_vm.rounded,"icon":_vm.icon,"icon-pack":_vm.iconPack,"autocomplete":_vm.autocomplete,"expanded":_vm.expanded,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":function($event){_vm.$emit('focus', $event);},"blur":function($event){_vm.$emit('blur', $event);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=_vm._n($$v);},expression:"computedValue"}},'b-input',_vm.$attrs,false)),_vm._v(" "),_c('p',{staticClass:"control",on:{"mouseup":function($event){_vm.onStopLongPress(true);},"mouseleave":function($event){_vm.onStopLongPress(true);},"touchend":function($event){_vm.onStopLongPress(true);},"touchcancel":function($event){_vm.onStopLongPress(true);}}},[_c('button',{staticClass:"button",class:_vm.buttonClasses,attrs:{"type":"button","disabled":_vm.disabled || _vm.disabledMax},on:{"mousedown":function($event){_vm.onStartLongPress($event, true);},"touchstart":function($event){$event.preventDefault();_vm.onStartLongPress($event, true);},"click":function($event){_vm.onControlClick($event, true);}}},[_c('b-icon',{attrs:{"icon":"plus","pack":_vm.iconPack,"size":_vm.iconSize}})],1)])],1)};
  var __vue_staticRenderFns__$t = [];

    /* style */
    const __vue_inject_styles__$x = undefined;
    /* scoped */
    const __vue_scope_id__$x = undefined;
    /* module identifier */
    const __vue_module_identifier__$x = undefined;
    /* functional template */
    const __vue_is_functional_template__$x = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Numberinput = normalizeComponent_1(
      { render: __vue_render__$t, staticRenderFns: __vue_staticRenderFns__$t },
      __vue_inject_styles__$x,
      __vue_script__$x,
      __vue_scope_id__$x,
      __vue_is_functional_template__$x,
      __vue_module_identifier__$x,
      undefined,
      undefined
    );

  var Plugin$i = {
    install: function install(Vue) {
      registerComponent(Vue, Numberinput);
    }
  };
  use(Plugin$i);

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
  var script$y = {
    name: 'BPaginationButton',
    props: {
      page: {
        type: Object,
        required: true
      },
      tag: {
        type: String,
        default: 'a',
        validator: function validator(value) {
          return ['a', 'button', 'input', 'router-link', 'nuxt-link', 'n-link', 'NuxtLink', 'NLink'].indexOf(value) >= 0;
        }
      },
      disabled: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      href: function href() {
        if (this.tag === 'a') {
          return '#';
        }
      },
      isDisabled: function isDisabled() {
        return this.disabled || this.page.disabled;
      }
    }
  };

  /* script */
  const __vue_script__$y = script$y;

  /* template */
  var __vue_render__$u = function () {
  var _obj;
  var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c(_vm.tag,_vm._b({tag:"component",staticClass:"pagination-link",class:( _obj = { 'is-current': _vm.page.isCurrent }, _obj[_vm.page.class] = true, _obj ),attrs:{"role":"button","href":_vm.href,"disabled":_vm.isDisabled,"aria-label":_vm.page['aria-label'],"aria-current":_vm.page.isCurrent},on:{"click":function($event){$event.preventDefault();_vm.page.click($event);}}},'component',_vm.$attrs,false),[_vm._t("default",[_vm._v(_vm._s(_vm.page.number))])],2)};
  var __vue_staticRenderFns__$u = [];

    /* style */
    const __vue_inject_styles__$y = undefined;
    /* scoped */
    const __vue_scope_id__$y = undefined;
    /* module identifier */
    const __vue_module_identifier__$y = undefined;
    /* functional template */
    const __vue_is_functional_template__$y = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var PaginationButton = normalizeComponent_1(
      { render: __vue_render__$u, staticRenderFns: __vue_staticRenderFns__$u },
      __vue_inject_styles__$y,
      __vue_script__$y,
      __vue_scope_id__$y,
      __vue_is_functional_template__$y,
      __vue_module_identifier__$y,
      undefined,
      undefined
    );

  var _components$5;
  var script$z = {
    name: 'BPagination',
    components: (_components$5 = {}, _defineProperty(_components$5, Icon.name, Icon), _defineProperty(_components$5, PaginationButton.name, PaginationButton), _components$5),
    props: {
      total: [Number, String],
      perPage: {
        type: [Number, String],
        default: 20
      },
      current: {
        type: [Number, String],
        default: 1
      },
      rangeBefore: {
        type: [Number, String],
        default: 1
      },
      rangeAfter: {
        type: [Number, String],
        default: 1
      },
      size: String,
      simple: Boolean,
      rounded: Boolean,
      order: String,
      iconPack: String,
      iconPrev: {
        type: String,
        default: config$1.defaultIconPrev
      },
      iconNext: {
        type: String,
        default: config$1.defaultIconNext
      },
      ariaNextLabel: String,
      ariaPreviousLabel: String,
      ariaPageLabel: String,
      ariaCurrentLabel: String
    },
    computed: {
      rootClasses: function rootClasses() {
        return [this.order, this.size, {
          'is-simple': this.simple,
          'is-rounded': this.rounded
        }];
      },
      beforeCurrent: function beforeCurrent() {
        return parseInt(this.rangeBefore);
      },
      afterCurrent: function afterCurrent() {
        return parseInt(this.rangeAfter);
      },

      /**
      * Total page size (count).
      */
      pageCount: function pageCount() {
        return Math.ceil(this.total / this.perPage);
      },

      /**
      * First item of the page (count).
      */
      firstItem: function firstItem() {
        var firstItem = this.current * this.perPage - this.perPage + 1;
        return firstItem >= 0 ? firstItem : 0;
      },

      /**
      * Check if previous button is available.
      */
      hasPrev: function hasPrev() {
        return this.current > 1;
      },

      /**
      * Check if first page button should be visible.
      */
      hasFirst: function hasFirst() {
        return this.current >= 2 + this.beforeCurrent;
      },

      /**
      * Check if first ellipsis should be visible.
      */
      hasFirstEllipsis: function hasFirstEllipsis() {
        return this.current >= this.beforeCurrent + 4;
      },

      /**
      * Check if last page button should be visible.
      */
      hasLast: function hasLast() {
        return this.current <= this.pageCount - (1 + this.afterCurrent);
      },

      /**
      * Check if last ellipsis should be visible.
      */
      hasLastEllipsis: function hasLastEllipsis() {
        return this.current < this.pageCount - (2 + this.afterCurrent);
      },

      /**
      * Check if next button is available.
      */
      hasNext: function hasNext() {
        return this.current < this.pageCount;
      },

      /**
      * Get near pages, 1 before and 1 after the current.
      * Also add the click event to the array.
      */
      pagesInRange: function pagesInRange() {
        if (this.simple) return;
        var left = Math.max(1, this.current - this.beforeCurrent);

        if (left - 1 === 2) {
          left--; // Do not show the ellipsis if there is only one to hide
        }

        var right = Math.min(this.current + this.afterCurrent, this.pageCount);

        if (this.pageCount - right === 2) {
          right++; // Do not show the ellipsis if there is only one to hide
        }

        var pages = [];

        for (var i = left; i <= right; i++) {
          pages.push(this.getPage(i));
        }

        return pages;
      }
    },
    watch: {
      /**
      * If current page is trying to be greater than page count, set to last.
      */
      pageCount: function pageCount(value) {
        if (this.current > value) this.last();
      }
    },
    methods: {
      /**
      * Previous button click listener.
      */
      prev: function prev(event) {
        this.changePage(this.current - 1, event);
      },

      /**
      * Next button click listener.
      */
      next: function next(event) {
        this.changePage(this.current + 1, event);
      },

      /**
      * First button click listener.
      */
      first: function first(event) {
        this.changePage(1, event);
      },

      /**
      * Last button click listener.
      */
      last: function last(event) {
        this.changePage(this.pageCount, event);
      },
      changePage: function changePage(num, event) {
        if (this.current === num || num < 1 || num > this.pageCount) return;
        this.$emit('change', num);
        this.$emit('update:current', num); // Set focus on element to keep tab order

        if (event && event.target) {
          this.$nextTick(function () {
            return event.target.focus();
          });
        }
      },
      getPage: function getPage(num) {
        var _this = this;

        var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
        return {
          number: num,
          isCurrent: this.current === num,
          click: function click(event) {
            return _this.changePage(num, event);
          },
          disabled: options.disabled || false,
          class: options.class || '',
          'aria-label': options['aria-label'] || this.getAriaPageLabel(num, this.current === num)
        };
      },

      /**
      * Get text for aria-label according to page number.
      */
      getAriaPageLabel: function getAriaPageLabel(pageNumber, isCurrent) {
        if (this.ariaPageLabel && (!isCurrent || !this.ariaCurrentLabel)) {
          return this.ariaPageLabel + ' ' + pageNumber + '.';
        } else if (this.ariaPageLabel && isCurrent && this.ariaCurrentLabel) {
          return this.ariaCurrentLabel + ', ' + this.ariaPageLabel + ' ' + pageNumber + '.';
        }

        return null;
      }
    }
  };

  /* script */
  const __vue_script__$z = script$z;

  /* template */
  var __vue_render__$v = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('nav',{staticClass:"pagination",class:_vm.rootClasses},[(_vm.$scopedSlots.previous)?_vm._t("previous",[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],{page:_vm.getPage(_vm.current - 1, {
              disabled: !_vm.hasPrev,
              class: 'pagination-previous',
              'aria-label': _vm.ariaPreviousLabel
      })}):_c('BPaginationButton',{staticClass:"pagination-previous",attrs:{"disabled":!_vm.hasPrev,"page":_vm.getPage(_vm.current - 1)}},[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),(_vm.$scopedSlots.next)?_vm._t("next",[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],{page:_vm.getPage(_vm.current + 1, {
              disabled: !_vm.hasNext,
              class: 'pagination-next',
              'aria-label': _vm.ariaNextLabel
      })}):_c('BPaginationButton',{staticClass:"pagination-next",attrs:{"disabled":!_vm.hasNext,"page":_vm.getPage(_vm.current + 1)}},[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),(_vm.simple)?_c('small',{staticClass:"info"},[(_vm.perPage == 1)?[_vm._v("\n            "+_vm._s(_vm.firstItem)+" / "+_vm._s(_vm.total)+"\n        ")]:[_vm._v("\n            "+_vm._s(_vm.firstItem)+"-"+_vm._s(Math.min(_vm.current * _vm.perPage, _vm.total))+" / "+_vm._s(_vm.total)+"\n        ")]],2):_c('ul',{staticClass:"pagination-list"},[(_vm.hasFirst)?_c('li',[(_vm.$scopedSlots.default)?_vm._t("default",null,{page:_vm.getPage(1)}):_c('BPaginationButton',{attrs:{"page":_vm.getPage(1)}})],2):_vm._e(),_vm._v(" "),(_vm.hasFirstEllipsis)?_c('li',[_c('span',{staticClass:"pagination-ellipsis"},[_vm._v("…")])]):_vm._e(),_vm._v(" "),_vm._l((_vm.pagesInRange),function(page){return _c('li',{key:page.number},[(_vm.$scopedSlots.default)?_vm._t("default",null,{page:page}):_c('BPaginationButton',{attrs:{"page":page}})],2)}),_vm._v(" "),(_vm.hasLastEllipsis)?_c('li',[_c('span',{staticClass:"pagination-ellipsis"},[_vm._v("…")])]):_vm._e(),_vm._v(" "),(_vm.hasLast)?_c('li',[(_vm.$scopedSlots.default)?_vm._t("default",null,{page:_vm.getPage(_vm.pageCount)}):_c('BPaginationButton',{attrs:{"page":_vm.getPage(_vm.pageCount)}})],2):_vm._e()],2)],2)};
  var __vue_staticRenderFns__$v = [];

    /* style */
    const __vue_inject_styles__$z = undefined;
    /* scoped */
    const __vue_scope_id__$z = undefined;
    /* module identifier */
    const __vue_module_identifier__$z = undefined;
    /* functional template */
    const __vue_is_functional_template__$z = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Pagination = normalizeComponent_1(
      { render: __vue_render__$v, staticRenderFns: __vue_staticRenderFns__$v },
      __vue_inject_styles__$z,
      __vue_script__$z,
      __vue_scope_id__$z,
      __vue_is_functional_template__$z,
      __vue_module_identifier__$z,
      undefined,
      undefined
    );

  var Plugin$j = {
    install: function install(Vue) {
      registerComponent(Vue, Pagination);
      registerComponent(Vue, PaginationButton);
    }
  };
  use(Plugin$j);

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
  var script$A = {
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

  /* script */
  const __vue_script__$A = script$A;

  /* template */
  var __vue_render__$w = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"progress-wrapper"},[_c('progress',{ref:"progress",staticClass:"progress",class:_vm.newType,attrs:{"max":_vm.max}},[_vm._v(_vm._s(_vm.newValue))]),_vm._v(" "),(_vm.showValue)?_c('p',{staticClass:"progress-value"},[_vm._t("default",[_vm._v(_vm._s(_vm.newValue))])],2):_vm._e()])};
  var __vue_staticRenderFns__$w = [];

    /* style */
    const __vue_inject_styles__$A = undefined;
    /* scoped */
    const __vue_scope_id__$A = undefined;
    /* module identifier */
    const __vue_module_identifier__$A = undefined;
    /* functional template */
    const __vue_is_functional_template__$A = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Progress = normalizeComponent_1(
      { render: __vue_render__$w, staticRenderFns: __vue_staticRenderFns__$w },
      __vue_inject_styles__$A,
      __vue_script__$A,
      __vue_scope_id__$A,
      __vue_is_functional_template__$A,
      __vue_module_identifier__$A,
      undefined,
      undefined
    );

  var Plugin$k = {
    install: function install(Vue) {
      registerComponent(Vue, Progress);
    }
  };
  use(Plugin$k);

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
  var script$B = {
    name: 'BRadio',
    props: {
      value: [String, Number, Boolean, Function, Object, Array],
      nativeValue: [String, Number, Boolean, Function, Object, Array],
      type: String,
      disabled: Boolean,
      required: Boolean,
      name: String,
      size: String
    },
    data: function data() {
      return {
        newValue: this.value
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
        }
      }
    },
    watch: {
      /**
      * When v-model change, set internal value.
      */
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      focus: function focus() {
        // MacOS FireFox and Safari do not focus when clicked
        this.$refs.input.focus();
      }
    }
  };

  /* script */
  const __vue_script__$B = script$B;

  /* template */
  var __vue_render__$x = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('label',{ref:"label",staticClass:"b-radio radio",class:[_vm.size, { 'is-disabled': _vm.disabled }],attrs:{"disabled":_vm.disabled},on:{"click":_vm.focus,"keydown":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.$refs.label.click();}}},[_c('input',{directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"input",attrs:{"type":"radio","disabled":_vm.disabled,"required":_vm.required,"name":_vm.name},domProps:{"value":_vm.nativeValue,"checked":_vm._q(_vm.computedValue,_vm.nativeValue)},on:{"click":function($event){$event.stopPropagation();},"change":function($event){_vm.computedValue=_vm.nativeValue;}}}),_vm._v(" "),_c('span',{staticClass:"check",class:_vm.type}),_vm._v(" "),_c('span',{staticClass:"control-label"},[_vm._t("default")],2)])};
  var __vue_staticRenderFns__$x = [];

    /* style */
    const __vue_inject_styles__$B = undefined;
    /* scoped */
    const __vue_scope_id__$B = undefined;
    /* module identifier */
    const __vue_module_identifier__$B = undefined;
    /* functional template */
    const __vue_is_functional_template__$B = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Radio = normalizeComponent_1(
      { render: __vue_render__$x, staticRenderFns: __vue_staticRenderFns__$x },
      __vue_inject_styles__$B,
      __vue_script__$B,
      __vue_scope_id__$B,
      __vue_is_functional_template__$B,
      __vue_module_identifier__$B,
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
  //
  //
  //
  //
  //
  //
  //
  var script$C = {
    name: 'BRadioButton',
    props: {
      value: [String, Number, Boolean, Function, Object, Array],
      nativeValue: [String, Number, Boolean, Function, Object, Array],
      type: {
        type: String,
        default: 'is-primary'
      },
      disabled: Boolean,
      required: Boolean,
      expanded: Boolean,
      name: String,
      size: String
    },
    data: function data() {
      return {
        newValue: this.value,
        isFocused: false
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
        }
      }
    },
    watch: {
      /**
      * When v-model change, set internal value.
      */
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      focus: function focus() {
        // MacOS FireFox and Safari do not focus when clicked
        this.$refs.input.focus();
      }
    }
  };

  /* script */
  const __vue_script__$C = script$C;

  /* template */
  var __vue_render__$y = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:{ 'is-expanded': _vm.expanded }},[_c('label',{ref:"label",staticClass:"b-radio radio button",class:[_vm.newValue === _vm.nativeValue ? _vm.type : null, _vm.size, {
              'is-disabled': _vm.disabled,
              'is-focused': _vm.isFocused
          }],attrs:{"disabled":_vm.disabled},on:{"click":_vm.focus,"keydown":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.$refs.label.click();}}},[_vm._t("default"),_vm._v(" "),_c('input',{directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"input",attrs:{"type":"radio","disabled":_vm.disabled,"required":_vm.required,"name":_vm.name},domProps:{"value":_vm.nativeValue,"checked":_vm._q(_vm.computedValue,_vm.nativeValue)},on:{"click":function($event){$event.stopPropagation();},"focus":function($event){_vm.isFocused = true;},"blur":function($event){_vm.isFocused = false;},"change":function($event){_vm.computedValue=_vm.nativeValue;}}})],2)])};
  var __vue_staticRenderFns__$y = [];

    /* style */
    const __vue_inject_styles__$C = undefined;
    /* scoped */
    const __vue_scope_id__$C = undefined;
    /* module identifier */
    const __vue_module_identifier__$C = undefined;
    /* functional template */
    const __vue_is_functional_template__$C = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var RadioButton = normalizeComponent_1(
      { render: __vue_render__$y, staticRenderFns: __vue_staticRenderFns__$y },
      __vue_inject_styles__$C,
      __vue_script__$C,
      __vue_scope_id__$C,
      __vue_is_functional_template__$C,
      __vue_module_identifier__$C,
      undefined,
      undefined
    );

  var Plugin$l = {
    install: function install(Vue) {
      registerComponent(Vue, Radio);
      registerComponent(Vue, RadioButton);
    }
  };
  use(Plugin$l);

  var script$D = {
    name: 'BRate',
    components: _defineProperty({}, Icon.name, Icon),
    props: {
      value: {
        type: Number,
        default: 0
      },
      max: {
        type: Number,
        default: 5
      },
      icon: {
        type: String,
        default: 'star'
      },
      iconPack: String,
      size: String,
      spaced: Boolean,
      rtl: Boolean,
      disabled: Boolean,
      showScore: Boolean,
      showText: Boolean,
      customText: String,
      texts: Array
    },
    data: function data() {
      return {
        newValue: this.value,
        hoverValue: 0
      };
    },
    computed: {
      halfStyle: function halfStyle() {
        return "width:".concat(this.valueDecimal, "%");
      },
      showMe: function showMe() {
        var result = '';

        if (this.showScore) {
          result = this.disabled ? this.value : this.newValue;
          if (result === 0) result = '';
        } else if (this.showText) {
          result = this.texts[Math.ceil(this.newValue) - 1];
        }

        return result;
      },
      valueDecimal: function valueDecimal() {
        return this.value * 100 - Math.floor(this.value) * 100;
      }
    },
    watch: {
      // When v-model is changed set the new value.
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      resetNewValue: function resetNewValue() {
        if (this.disabled) return;
        this.hoverValue = 0;
      },
      previewRate: function previewRate(index, event) {
        if (this.disabled) return;
        this.hoverValue = index;
        event.stopPropagation();
      },
      confirmValue: function confirmValue(index) {
        if (this.disabled) return;
        this.newValue = index;
        this.$emit('change', this.newValue);
        this.$emit('input', this.newValue);
      },
      checkHalf: function checkHalf(index) {
        var showWhenDisabled = this.disabled && this.valueDecimal > 0 && index - 1 < this.value && index > this.value;
        return showWhenDisabled;
      },
      rateClass: function rateClass(index) {
        var output = '';
        var currentValue = this.hoverValue !== 0 ? this.hoverValue : this.newValue;

        if (index <= currentValue) {
          output = 'set-on';
        } else if (this.disabled && Math.ceil(this.value) === index) {
          output = 'set-half';
        }

        return output;
      }
    }
  };

  /* script */
  const __vue_script__$D = script$D;

  /* template */
  var __vue_render__$z = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"rate",class:{ 'is-disabled': _vm.disabled, 'is-spaced': _vm.spaced, 'is-rtl': _vm.rtl }},[_vm._l((_vm.max),function(item,index){return _c('div',{key:index,staticClass:"rate-item",class:_vm.rateClass(item),on:{"mousemove":function($event){_vm.previewRate(item, $event);},"mouseleave":_vm.resetNewValue,"click":function($event){$event.preventDefault();_vm.confirmValue(item);}}},[_c('b-icon',{attrs:{"pack":_vm.iconPack,"icon":_vm.icon,"size":_vm.size}}),_vm._v(" "),(_vm.checkHalf(item))?_c('b-icon',{staticClass:"is-half",style:(_vm.halfStyle),attrs:{"pack":_vm.iconPack,"icon":_vm.icon,"size":_vm.size}}):_vm._e()],1)}),_vm._v(" "),(_vm.showText || _vm.showScore || _vm.customText)?_c('div',{staticClass:"rate-text",class:_vm.size},[_c('span',[_vm._v(_vm._s(_vm.showMe))]),_vm._v(" "),(_vm.customText && !_vm.showText)?_c('span',[_vm._v(_vm._s(_vm.customText))]):_vm._e()]):_vm._e()],2)};
  var __vue_staticRenderFns__$z = [];

    /* style */
    const __vue_inject_styles__$D = undefined;
    /* scoped */
    const __vue_scope_id__$D = undefined;
    /* module identifier */
    const __vue_module_identifier__$D = undefined;
    /* functional template */
    const __vue_is_functional_template__$D = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Rate = normalizeComponent_1(
      { render: __vue_render__$z, staticRenderFns: __vue_staticRenderFns__$z },
      __vue_inject_styles__$D,
      __vue_script__$D,
      __vue_scope_id__$D,
      __vue_is_functional_template__$D,
      __vue_module_identifier__$D,
      undefined,
      undefined
    );

  var Plugin$m = {
    install: function install(Vue) {
      registerComponent(Vue, Rate);
    }
  };
  use(Plugin$m);

  var Plugin$n = {
    install: function install(Vue) {
      registerComponent(Vue, Select);
    }
  };
  use(Plugin$n);

  //
  var script$E = {
    name: 'BTooltip',
    props: {
      active: {
        type: Boolean,
        default: true
      },
      type: String,
      label: String,
      position: {
        type: String,
        default: 'is-top',
        validator: function validator(value) {
          return ['is-top', 'is-bottom', 'is-left', 'is-right'].indexOf(value) > -1;
        }
      },
      always: Boolean,
      animated: Boolean,
      square: Boolean,
      dashed: Boolean,
      multilined: Boolean,
      size: {
        type: String,
        default: 'is-medium'
      },
      delay: Number
    },
    computed: {
      newType: function newType() {
        return this.type || config$1.defaultTooltipType;
      },
      newAnimated: function newAnimated() {
        return this.animated || config$1.defaultTooltipAnimated;
      },
      newDelay: function newDelay() {
        return this.delay || config$1.defaultTooltipDelay;
      }
    }
  };

  /* script */
  const __vue_script__$E = script$E;

  /* template */
  var __vue_render__$A = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{class:[_vm.newType, _vm.position, _vm.size, {
          'b-tooltip': _vm.active,
          'is-square': _vm.square,
          'is-animated': _vm.newAnimated,
          'is-always': _vm.always,
          'is-multiline': _vm.multilined,
          'is-dashed': _vm.dashed
      }],style:({'transition-delay': (_vm.newDelay + "ms")}),attrs:{"data-label":_vm.label}},[_vm._t("default")],2)};
  var __vue_staticRenderFns__$A = [];

    /* style */
    const __vue_inject_styles__$E = undefined;
    /* scoped */
    const __vue_scope_id__$E = undefined;
    /* module identifier */
    const __vue_module_identifier__$E = undefined;
    /* functional template */
    const __vue_is_functional_template__$E = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Tooltip = normalizeComponent_1(
      { render: __vue_render__$A, staticRenderFns: __vue_staticRenderFns__$A },
      __vue_inject_styles__$E,
      __vue_script__$E,
      __vue_scope_id__$E,
      __vue_is_functional_template__$E,
      __vue_module_identifier__$E,
      undefined,
      undefined
    );

  var script$F = {
    name: 'BSliderThumb',
    components: _defineProperty({}, Tooltip.name, Tooltip),
    inheritAttrs: false,
    props: {
      value: {
        type: Number,
        default: 0
      },
      type: {
        type: String,
        default: ''
      },
      tooltip: {
        type: Boolean,
        default: true
      },
      customFormatter: Function
    },
    data: function data() {
      return {
        isFocused: false,
        dragging: false,
        startX: 0,
        startPosition: 0,
        newPosition: null,
        oldValue: this.value
      };
    },
    computed: {
      disabled: function disabled() {
        return this.$parent.disabled;
      },
      max: function max() {
        return this.$parent.max;
      },
      min: function min() {
        return this.$parent.min;
      },
      step: function step() {
        return this.$parent.step;
      },
      precision: function precision() {
        return this.$parent.precision;
      },
      currentPosition: function currentPosition() {
        return "".concat((this.value - this.min) / (this.max - this.min) * 100, "%");
      },
      wrapperStyle: function wrapperStyle() {
        return {
          left: this.currentPosition
        };
      },
      tooltipLabel: function tooltipLabel() {
        return typeof this.customFormatter !== 'undefined' ? this.customFormatter(this.value) : this.value.toString();
      }
    },
    methods: {
      onFocus: function onFocus() {
        this.isFocused = true;
      },
      onBlur: function onBlur() {
        this.isFocused = false;
      },
      onButtonDown: function onButtonDown(event) {
        if (this.disabled) return;
        event.preventDefault();
        this.onDragStart(event);

        if (typeof window !== 'undefined') {
          document.addEventListener('mousemove', this.onDragging);
          document.addEventListener('touchmove', this.onDragging);
          document.addEventListener('mouseup', this.onDragEnd);
          document.addEventListener('touchend', this.onDragEnd);
          document.addEventListener('contextmenu', this.onDragEnd);
        }
      },
      onLeftKeyDown: function onLeftKeyDown() {
        if (this.disabled || this.value === this.min) return;
        this.newPosition = parseFloat(this.currentPosition) - this.step / (this.max - this.min) * 100;
        this.setPosition(this.newPosition);
        this.$parent.emitValue('change');
      },
      onRightKeyDown: function onRightKeyDown() {
        if (this.disabled || this.value === this.max) return;
        this.newPosition = parseFloat(this.currentPosition) + this.step / (this.max - this.min) * 100;
        this.setPosition(this.newPosition);
        this.$parent.emitValue('change');
      },
      onHomeKeyDown: function onHomeKeyDown() {
        if (this.disabled || this.value === this.min) return;
        this.newPosition = 0;
        this.setPosition(this.newPosition);
        this.$parent.emitValue('change');
      },
      onEndKeyDown: function onEndKeyDown() {
        if (this.disabled || this.value === this.max) return;
        this.newPosition = 100;
        this.setPosition(this.newPosition);
        this.$parent.emitValue('change');
      },
      onDragStart: function onDragStart(event) {
        this.dragging = true;
        this.$emit('dragstart');

        if (event.type === 'touchstart') {
          event.clientX = event.touches[0].clientX;
        }

        this.startX = event.clientX;
        this.startPosition = parseFloat(this.currentPosition);
        this.newPosition = this.startPosition;
      },
      onDragging: function onDragging(event) {
        if (this.dragging) {
          if (event.type === 'touchmove') {
            event.clientX = event.touches[0].clientX;
          }

          var diff = (event.clientX - this.startX) / this.$parent.sliderSize * 100;
          this.newPosition = this.startPosition + diff;
          this.setPosition(this.newPosition);
        }
      },
      onDragEnd: function onDragEnd() {
        this.dragging = false;
        this.$emit('dragend');

        if (this.value !== this.oldValue) {
          this.$parent.emitValue('change');
        }

        this.setPosition(this.newPosition);

        if (typeof window !== 'undefined') {
          document.removeEventListener('mousemove', this.onDragging);
          document.removeEventListener('touchmove', this.onDragging);
          document.removeEventListener('mouseup', this.onDragEnd);
          document.removeEventListener('touchend', this.onDragEnd);
          document.removeEventListener('contextmenu', this.onDragEnd);
        }
      },
      setPosition: function setPosition(percent) {
        if (percent === null || isNaN(percent)) return;

        if (percent < 0) {
          percent = 0;
        } else if (percent > 100) {
          percent = 100;
        }

        var stepLength = 100 / ((this.max - this.min) / this.step);
        var steps = Math.round(percent / stepLength);
        var value = steps * stepLength / 100 * (this.max - this.min) + this.min;
        value = parseFloat(value.toFixed(this.precision));
        this.$emit('input', value);

        if (!this.dragging && value !== this.oldValue) {
          this.oldValue = value;
        }
      }
    }
  };

  /* script */
  const __vue_script__$F = script$F;

  /* template */
  var __vue_render__$B = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-slider-thumb-wrapper",class:{ 'is-dragging': _vm.dragging },style:(_vm.wrapperStyle)},[_c('b-tooltip',{attrs:{"label":_vm.tooltipLabel,"type":_vm.type,"always":_vm.dragging || _vm.isFocused,"active":!_vm.disabled && _vm.tooltip}},[_c('div',_vm._b({staticClass:"b-slider-thumb",attrs:{"tabindex":_vm.disabled ? false : 0},on:{"mousedown":_vm.onButtonDown,"touchstart":_vm.onButtonDown,"focus":_vm.onFocus,"blur":_vm.onBlur,"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"left",37,$event.key)){ return null; }if('button' in $event && $event.button !== 0){ return null; }$event.preventDefault();_vm.onLeftKeyDown($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"right",39,$event.key)){ return null; }if('button' in $event && $event.button !== 2){ return null; }$event.preventDefault();_vm.onRightKeyDown($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"down",40,$event.key)){ return null; }$event.preventDefault();_vm.onLeftKeyDown($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"up",38,$event.key)){ return null; }$event.preventDefault();_vm.onRightKeyDown($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"home",undefined,$event.key)){ return null; }$event.preventDefault();_vm.onHomeKeyDown($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"end",undefined,$event.key)){ return null; }$event.preventDefault();_vm.onEndKeyDown($event);}]}},'div',_vm.$attrs,false))])],1)};
  var __vue_staticRenderFns__$B = [];

    /* style */
    const __vue_inject_styles__$F = undefined;
    /* scoped */
    const __vue_scope_id__$F = undefined;
    /* module identifier */
    const __vue_module_identifier__$F = undefined;
    /* functional template */
    const __vue_is_functional_template__$F = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var SliderThumb = normalizeComponent_1(
      { render: __vue_render__$B, staticRenderFns: __vue_staticRenderFns__$B },
      __vue_inject_styles__$F,
      __vue_script__$F,
      __vue_scope_id__$F,
      __vue_is_functional_template__$F,
      __vue_module_identifier__$F,
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
  var script$G = {
    name: 'BSliderTick',
    props: {
      value: {
        type: Number,
        default: 0
      }
    },
    computed: {
      position: function position() {
        var pos = (this.value - this.$parent.min) / (this.$parent.max - this.$parent.min) * 100;
        return pos >= 0 && pos <= 100 ? pos : 0;
      },
      hidden: function hidden() {
        return this.value === this.$parent.min || this.value === this.$parent.max;
      }
    },
    methods: {
      getTickStyle: function getTickStyle(position) {
        return {
          'left': position + '%'
        };
      }
    },
    created: function created() {
      if (!this.$parent.$data._isSlider) {
        this.$destroy();
        throw new Error('You should wrap bSliderTick on a bSlider');
      }
    }
  };

  /* script */
  const __vue_script__$G = script$G;

  /* template */
  var __vue_render__$C = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-slider-tick",class:{ 'is-tick-hidden': _vm.hidden },style:(_vm.getTickStyle(_vm.position))},[(_vm.$slots.default)?_c('span',{staticClass:"b-slider-tick-label"},[_vm._t("default")],2):_vm._e()])};
  var __vue_staticRenderFns__$C = [];

    /* style */
    const __vue_inject_styles__$G = undefined;
    /* scoped */
    const __vue_scope_id__$G = undefined;
    /* module identifier */
    const __vue_module_identifier__$G = undefined;
    /* functional template */
    const __vue_is_functional_template__$G = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var SliderTick = normalizeComponent_1(
      { render: __vue_render__$C, staticRenderFns: __vue_staticRenderFns__$C },
      __vue_inject_styles__$G,
      __vue_script__$G,
      __vue_scope_id__$G,
      __vue_is_functional_template__$G,
      __vue_module_identifier__$G,
      undefined,
      undefined
    );

  var _components$6;
  var script$H = {
    name: 'BSlider',
    components: (_components$6 = {}, _defineProperty(_components$6, SliderThumb.name, SliderThumb), _defineProperty(_components$6, SliderTick.name, SliderTick), _components$6),
    props: {
      value: {
        type: [Number, Array],
        default: 0
      },
      min: {
        type: Number,
        default: 0
      },
      max: {
        type: Number,
        default: 100
      },
      step: {
        type: Number,
        default: 1
      },
      type: {
        type: String,
        default: 'is-primary'
      },
      size: String,
      ticks: {
        type: Boolean,
        default: false
      },
      tooltip: {
        type: Boolean,
        default: true
      },
      tooltipType: String,
      rounded: {
        type: Boolean,
        default: false
      },
      disabled: {
        type: Boolean,
        default: false
      },
      lazy: {
        type: Boolean,
        default: false
      },
      customFormatter: Function,
      ariaLabel: [String, Array]
    },
    data: function data() {
      return {
        value1: null,
        value2: null,
        dragging: false,
        isRange: false,
        _isSlider: true // Used by Thumb and Tick

      };
    },
    computed: {
      newTooltipType: function newTooltipType() {
        return this.tooltipType ? this.tooltipType : this.type;
      },
      tickValues: function tickValues() {
        if (!this.ticks || this.min > this.max || this.step === 0) return [];
        var result = [];

        for (var i = this.min + this.step; i < this.max; i = i + this.step) {
          result.push(i);
        }

        return result;
      },
      minValue: function minValue() {
        return Math.min(this.value1, this.value2);
      },
      maxValue: function maxValue() {
        return Math.max(this.value1, this.value2);
      },
      barSize: function barSize() {
        return this.isRange ? "".concat(100 * (this.maxValue - this.minValue) / (this.max - this.min), "%") : "".concat(100 * (this.value1 - this.min) / (this.max - this.min), "%");
      },
      barStart: function barStart() {
        return this.isRange ? "".concat(100 * (this.minValue - this.min) / (this.max - this.min), "%") : '0%';
      },
      precision: function precision() {
        var precisions = [this.min, this.max, this.step].map(function (item) {
          var decimal = ('' + item).split('.')[1];
          return decimal ? decimal.length : 0;
        });
        return Math.max.apply(Math, _toConsumableArray(precisions));
      },
      barStyle: function barStyle() {
        return {
          width: this.barSize,
          left: this.barStart
        };
      },
      sliderSize: function sliderSize() {
        return this.$refs.slider['clientWidth'];
      },
      rootClasses: function rootClasses() {
        return {
          'is-rounded': this.rounded,
          'is-dragging': this.dragging,
          'is-disabled': this.disabled
        };
      }
    },
    watch: {
      /**
      * When v-model is changed set the new active step.
      */
      value: function value(_value) {
        this.setValues(_value);
      },
      value1: function value1() {
        this.onInternalValueUpdate();
      },
      value2: function value2() {
        this.onInternalValueUpdate();
      },
      min: function min() {
        this.setValues(this.value);
      },
      max: function max() {
        this.setValues(this.value);
      }
    },
    methods: {
      setValues: function setValues(newValue) {
        if (this.min > this.max) {
          return;
        }

        if (Array.isArray(newValue)) {
          this.isRange = true;
          var smallValue = typeof newValue[0] !== 'number' || isNaN(newValue[0]) ? this.min : Math.min(Math.max(this.min, newValue[0]), this.max);
          var largeValue = typeof newValue[1] !== 'number' || isNaN(newValue[1]) ? this.max : Math.max(Math.min(this.max, newValue[1]), this.min);
          this.value1 = this.isThumbReversed ? largeValue : smallValue;
          this.value2 = this.isThumbReversed ? smallValue : largeValue;
        } else {
          this.isRange = false;
          this.value1 = isNaN(newValue) ? this.min : Math.min(this.max, Math.max(this.min, newValue));
          this.value2 = null;
        }
      },
      onInternalValueUpdate: function onInternalValueUpdate() {
        if (this.isRange) {
          this.isThumbReversed = this.value1 > this.value2;
        }

        if (!this.lazy || !this.dragging) {
          this.emitValue('input');
        }

        if (this.dragging) {
          this.emitValue('dragging');
        }
      },
      onSliderClick: function onSliderClick(event) {
        if (this.disabled || this.isTrackClickDisabled) return;
        var sliderOffsetLeft = this.$refs.slider.getBoundingClientRect().left;
        var percent = (event.clientX - sliderOffsetLeft) / this.sliderSize * 100;
        var targetValue = this.min + percent * (this.max - this.min) / 100;
        var diffFirst = Math.abs(targetValue - this.value1);

        if (!this.isRange) {
          if (diffFirst < this.step / 2) return;
          this.$refs.button1.setPosition(percent);
        } else {
          var diffSecond = Math.abs(targetValue - this.value2);

          if (diffFirst <= diffSecond) {
            if (diffFirst < this.step / 2) return;
            this.$refs['button1'].setPosition(percent);
          } else {
            if (diffSecond < this.step / 2) return;
            this.$refs['button2'].setPosition(percent);
          }
        }

        this.emitValue('change');
      },
      onDragStart: function onDragStart() {
        this.dragging = true;
        this.$emit('dragstart');
      },
      onDragEnd: function onDragEnd() {
        var _this = this;

        this.isTrackClickDisabled = true;
        setTimeout(function () {
          // avoid triggering onSliderClick after dragend
          _this.isTrackClickDisabled = false;
        }, 0);
        this.dragging = false;
        this.$emit('dragend');

        if (this.lazy) {
          this.emitValue('input');
        }
      },
      emitValue: function emitValue(type) {
        this.$emit(type, this.isRange ? [this.minValue, this.maxValue] : this.value1);
      }
    },
    created: function created() {
      this.isThumbReversed = false;
      this.isTrackClickDisabled = false;
      this.setValues(this.value);
    }
  };

  /* script */
  const __vue_script__$H = script$H;

  /* template */
  var __vue_render__$D = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-slider",class:[_vm.size, _vm.type, _vm.rootClasses]},[_c('div',{ref:"slider",staticClass:"b-slider-track",on:{"click":_vm.onSliderClick}},[_c('div',{staticClass:"b-slider-fill",style:(_vm.barStyle)}),_vm._v(" "),(_vm.ticks)?_vm._l((_vm.tickValues),function(val,key){return _c('b-slider-tick',{key:key,attrs:{"value":val}})}):_vm._e(),_vm._v(" "),_vm._t("default"),_vm._v(" "),_c('b-slider-thumb',{ref:"button1",attrs:{"type":_vm.newTooltipType,"tooltip":_vm.tooltip,"custom-formatter":_vm.customFormatter,"role":"slider","aria-valuenow":_vm.value1,"aria-valuemin":_vm.min,"aria-valuemax":_vm.max,"aria-orientation":"horizontal","aria-label":Array.isArray(_vm.ariaLabel) ? _vm.ariaLabel[0] : _vm.ariaLabel,"aria-disabled":_vm.disabled},on:{"dragstart":_vm.onDragStart,"dragend":_vm.onDragEnd},model:{value:(_vm.value1),callback:function ($$v) {_vm.value1=$$v;},expression:"value1"}}),_vm._v(" "),(_vm.isRange)?_c('b-slider-thumb',{ref:"button2",attrs:{"type":_vm.newTooltipType,"tooltip":_vm.tooltip,"custom-formatter":_vm.customFormatter,"role":"slider","aria-valuenow":_vm.value2,"aria-valuemin":_vm.min,"aria-valuemax":_vm.max,"aria-orientation":"horizontal","aria-label":Array.isArray(_vm.ariaLabel) ? _vm.ariaLabel[1] : '',"aria-disabled":_vm.disabled},on:{"dragstart":_vm.onDragStart,"dragend":_vm.onDragEnd},model:{value:(_vm.value2),callback:function ($$v) {_vm.value2=$$v;},expression:"value2"}}):_vm._e()],2)])};
  var __vue_staticRenderFns__$D = [];

    /* style */
    const __vue_inject_styles__$H = undefined;
    /* scoped */
    const __vue_scope_id__$H = undefined;
    /* module identifier */
    const __vue_module_identifier__$H = undefined;
    /* functional template */
    const __vue_is_functional_template__$H = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Slider = normalizeComponent_1(
      { render: __vue_render__$D, staticRenderFns: __vue_staticRenderFns__$D },
      __vue_inject_styles__$H,
      __vue_script__$H,
      __vue_scope_id__$H,
      __vue_is_functional_template__$H,
      __vue_module_identifier__$H,
      undefined,
      undefined
    );

  var Plugin$o = {
    install: function install(Vue) {
      registerComponent(Vue, Slider);
      registerComponent(Vue, SliderTick);
    }
  };
  use(Plugin$o);

  //
  var script$I = {
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

  /* script */
  const __vue_script__$I = script$I;

  /* template */
  var __vue_render__$E = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"enter-active-class":_vm.transition.enter,"leave-active-class":_vm.transition.leave}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"snackbar",class:[_vm.type,_vm.position]},[_c('div',{staticClass:"text",domProps:{"innerHTML":_vm._s(_vm.message)}}),_vm._v(" "),(_vm.actionText)?_c('div',{staticClass:"action",class:_vm.type,on:{"click":_vm.action}},[_c('button',{staticClass:"button"},[_vm._v(_vm._s(_vm.actionText))])]):_vm._e()])])};
  var __vue_staticRenderFns__$E = [];

    /* style */
    const __vue_inject_styles__$I = undefined;
    /* scoped */
    const __vue_scope_id__$I = undefined;
    /* module identifier */
    const __vue_module_identifier__$I = undefined;
    /* functional template */
    const __vue_is_functional_template__$I = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Snackbar = normalizeComponent_1(
      { render: __vue_render__$E, staticRenderFns: __vue_staticRenderFns__$E },
      __vue_inject_styles__$I,
      __vue_script__$I,
      __vue_scope_id__$I,
      __vue_is_functional_template__$I,
      __vue_module_identifier__$I,
      undefined,
      undefined
    );

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
  var Plugin$p = {
    install: function install(Vue) {
      registerComponentProgrammatic(Vue, 'snackbar', SnackbarProgrammatic);
    }
  };
  use(Plugin$p);

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

  var _components$7;
  var script$J = {
    name: 'BSteps',
    components: (_components$7 = {}, _defineProperty(_components$7, Icon.name, Icon), _defineProperty(_components$7, SlotComponent.name, SlotComponent), _components$7),
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
  const __vue_script__$J = script$J;

  /* template */
  var __vue_render__$F = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-steps"},[_c('nav',{staticClass:"steps",class:_vm.mainClasses},[_c('ul',{staticClass:"step-items"},_vm._l((_vm.stepItems),function(stepItem,index){return _c('li',{directives:[{name:"show",rawName:"v-show",value:(stepItem.visible),expression:"stepItem.visible"}],key:index,staticClass:"step-item",class:[stepItem.type || _vm.type, {
                      'is-active': _vm.activeStep === index,
                      'is-previous': _vm.activeStep > index
              }]},[_c('a',{staticClass:"step-link",class:{'is-clickable': _vm.isItemClickable(stepItem, index)},on:{"click":function($event){_vm.isItemClickable(stepItem, index) && _vm.stepClick(index);}}},[_c('div',{staticClass:"step-marker"},[(stepItem.icon)?_c('b-icon',{attrs:{"icon":stepItem.icon,"pack":stepItem.iconPack,"size":_vm.size}}):_vm._e()],1),_vm._v(" "),_c('div',{staticClass:"step-details"},[_c('span',{staticClass:"step-title"},[_vm._v(_vm._s(stepItem.label))])])])])}))]),_vm._v(" "),_c('section',{staticClass:"step-content",class:{'is-transitioning': _vm.isTransitioning}},[_vm._t("default")],2),_vm._v(" "),_vm._t("navigation",[(_vm.hasNavigation)?_c('nav',{staticClass:"step-navigation"},[_c('a',{staticClass:"pagination-previous",attrs:{"role":"button","disabled":_vm.navigationProps.previous.disabled,"aria-label":_vm.ariaPreviousLabel},on:{"click":function($event){$event.preventDefault();_vm.navigationProps.previous.action($event);}}},[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),_c('a',{staticClass:"pagination-next",attrs:{"role":"button","disabled":_vm.navigationProps.next.disabled,"aria-label":_vm.ariaNextLabel},on:{"click":function($event){$event.preventDefault();_vm.navigationProps.next.action($event);}}},[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1)]):_vm._e()],{previous:_vm.navigationProps.previous,next:_vm.navigationProps.next})],2)};
  var __vue_staticRenderFns__$F = [];

    /* style */
    const __vue_inject_styles__$J = undefined;
    /* scoped */
    const __vue_scope_id__$J = undefined;
    /* module identifier */
    const __vue_module_identifier__$J = undefined;
    /* functional template */
    const __vue_is_functional_template__$J = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Steps = normalizeComponent_1(
      { render: __vue_render__$F, staticRenderFns: __vue_staticRenderFns__$F },
      __vue_inject_styles__$J,
      __vue_script__$J,
      __vue_scope_id__$J,
      __vue_is_functional_template__$J,
      __vue_module_identifier__$J,
      undefined,
      undefined
    );

  var script$K = {
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
  const __vue_script__$K = script$K;

  /* template */

    /* style */
    const __vue_inject_styles__$K = undefined;
    /* scoped */
    const __vue_scope_id__$K = undefined;
    /* module identifier */
    const __vue_module_identifier__$K = undefined;
    /* functional template */
    const __vue_is_functional_template__$K = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var StepItem = normalizeComponent_1(
      {},
      __vue_inject_styles__$K,
      __vue_script__$K,
      __vue_scope_id__$K,
      __vue_is_functional_template__$K,
      __vue_module_identifier__$K,
      undefined,
      undefined
    );

  var Plugin$q = {
    install: function install(Vue) {
      registerComponent(Vue, Steps);
      registerComponent(Vue, StepItem);
    }
  };
  use(Plugin$q);

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
  var script$L = {
    name: 'BSwitch',
    props: {
      value: [String, Number, Boolean, Function, Object, Array],
      nativeValue: [String, Number, Boolean, Function, Object, Array],
      disabled: Boolean,
      type: String,
      name: String,
      required: Boolean,
      size: String,
      trueValue: {
        type: [String, Number, Boolean, Function, Object, Array],
        default: true
      },
      falseValue: {
        type: [String, Number, Boolean, Function, Object, Array],
        default: false
      },
      rounded: {
        type: Boolean,
        default: true
      },
      outlined: {
        type: Boolean,
        default: false
      }
    },
    data: function data() {
      return {
        newValue: this.value,
        isMouseDown: false
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
        }
      },
      newClass: function newClass() {
        return [this.size, {
          'is-disabled': this.disabled
        }, {
          'is-rounded': this.rounded
        }, {
          'is-outlined': this.outlined
        }];
      }
    },
    watch: {
      /**
      * When v-model change, set internal value.
      */
      value: function value(_value) {
        this.newValue = _value;
      }
    },
    methods: {
      focus: function focus() {
        // MacOS FireFox and Safari do not focus when clicked
        this.$refs.input.focus();
      }
    }
  };

  /* script */
  const __vue_script__$L = script$L;

  /* template */
  var __vue_render__$G = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('label',{ref:"label",staticClass:"switch",class:_vm.newClass,attrs:{"disabled":_vm.disabled},on:{"click":_vm.focus,"keydown":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.$refs.label.click();},"mousedown":function($event){_vm.isMouseDown = true;},"mouseup":function($event){_vm.isMouseDown = false;},"mouseout":function($event){_vm.isMouseDown = false;},"blur":function($event){_vm.isMouseDown = false;}}},[_c('input',{directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"input",attrs:{"type":"checkbox","disabled":_vm.disabled,"name":_vm.name,"required":_vm.required,"true-value":_vm.trueValue,"false-value":_vm.falseValue},domProps:{"value":_vm.nativeValue,"checked":Array.isArray(_vm.computedValue)?_vm._i(_vm.computedValue,_vm.nativeValue)>-1:_vm._q(_vm.computedValue,_vm.trueValue)},on:{"click":function($event){$event.stopPropagation();},"change":function($event){var $$a=_vm.computedValue,$$el=$event.target,$$c=$$el.checked?(_vm.trueValue):(_vm.falseValue);if(Array.isArray($$a)){var $$v=_vm.nativeValue,$$i=_vm._i($$a,$$v);if($$el.checked){$$i<0&&(_vm.computedValue=$$a.concat([$$v]));}else{$$i>-1&&(_vm.computedValue=$$a.slice(0,$$i).concat($$a.slice($$i+1)));}}else{_vm.computedValue=$$c;}}}}),_vm._v(" "),_c('span',{staticClass:"check",class:[{ 'is-elastic': _vm.isMouseDown && !_vm.disabled }, _vm.type]}),_vm._v(" "),_c('span',{staticClass:"control-label"},[_vm._t("default")],2)])};
  var __vue_staticRenderFns__$G = [];

    /* style */
    const __vue_inject_styles__$L = undefined;
    /* scoped */
    const __vue_scope_id__$L = undefined;
    /* module identifier */
    const __vue_module_identifier__$L = undefined;
    /* functional template */
    const __vue_is_functional_template__$L = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Switch = normalizeComponent_1(
      { render: __vue_render__$G, staticRenderFns: __vue_staticRenderFns__$G },
      __vue_inject_styles__$L,
      __vue_script__$L,
      __vue_scope_id__$L,
      __vue_is_functional_template__$L,
      __vue_module_identifier__$L,
      undefined,
      undefined
    );

  var Plugin$r = {
    install: function install(Vue) {
      registerComponent(Vue, Switch);
    }
  };
  use(Plugin$r);

  var _components$8;
  var script$M = {
    name: 'BTableMobileSort',
    components: (_components$8 = {}, _defineProperty(_components$8, Select.name, Select), _defineProperty(_components$8, Icon.name, Icon), _components$8),
    props: {
      currentSortColumn: Object,
      isAsc: Boolean,
      columns: Array,
      placeholder: String,
      iconPack: String,
      sortIcon: {
        type: String,
        default: 'arrow-up'
      },
      sortIconSize: {
        type: String,
        default: 'is-small'
      }
    },
    data: function data() {
      return {
        mobileSort: this.currentSortColumn
      };
    },
    computed: {
      showPlaceholder: function showPlaceholder() {
        var _this = this;

        return !this.columns || !this.columns.some(function (column) {
          return column === _this.mobileSort;
        });
      }
    },
    watch: {
      mobileSort: function mobileSort(column) {
        if (this.currentSortColumn === column) return;
        this.$emit('sort', column);
      },
      currentSortColumn: function currentSortColumn(column) {
        this.mobileSort = column;
      }
    },
    methods: {
      sort: function sort() {
        this.$emit('sort', this.mobileSort);
      }
    }
  };

  /* script */
  const __vue_script__$M = script$M;

  /* template */
  var __vue_render__$H = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"field table-mobile-sort"},[_c('div',{staticClass:"field has-addons"},[_c('b-select',{attrs:{"expanded":""},model:{value:(_vm.mobileSort),callback:function ($$v) {_vm.mobileSort=$$v;},expression:"mobileSort"}},[(_vm.placeholder)?[_c('option',{directives:[{name:"show",rawName:"v-show",value:(_vm.showPlaceholder),expression:"showPlaceholder"}],attrs:{"selected":"","disabled":"","hidden":""},domProps:{"value":{}}},[_vm._v("\n                    "+_vm._s(_vm.placeholder)+"\n                ")])]:_vm._e(),_vm._v(" "),_vm._l((_vm.columns),function(column,index){return (column.sortable)?_c('option',{key:index,domProps:{"value":column}},[_vm._v("\n                "+_vm._s(column.label)+"\n            ")]):_vm._e()})],2),_vm._v(" "),_c('div',{staticClass:"control"},[_c('button',{staticClass:"button is-primary",on:{"click":_vm.sort}},[_c('b-icon',{directives:[{name:"show",rawName:"v-show",value:(_vm.currentSortColumn === _vm.mobileSort),expression:"currentSortColumn === mobileSort"}],class:{ 'is-desc': !_vm.isAsc },attrs:{"icon":_vm.sortIcon,"pack":_vm.iconPack,"size":_vm.sortIconSize,"both":""}})],1)])],1)])};
  var __vue_staticRenderFns__$H = [];

    /* style */
    const __vue_inject_styles__$M = undefined;
    /* scoped */
    const __vue_scope_id__$M = undefined;
    /* module identifier */
    const __vue_module_identifier__$M = undefined;
    /* functional template */
    const __vue_is_functional_template__$M = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var TableMobileSort = normalizeComponent_1(
      { render: __vue_render__$H, staticRenderFns: __vue_staticRenderFns__$H },
      __vue_inject_styles__$M,
      __vue_script__$M,
      __vue_scope_id__$M,
      __vue_is_functional_template__$M,
      __vue_module_identifier__$M,
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
  var script$N = {
    name: 'BTableColumn',
    props: {
      label: String,
      customKey: [String, Number],
      field: String,
      meta: [String, Number, Boolean, Function, Object, Array],
      width: [Number, String],
      numeric: Boolean,
      centered: Boolean,
      searchable: Boolean,
      sortable: Boolean,
      visible: {
        type: Boolean,
        default: true
      },
      customSort: Function,
      internal: Boolean // Used internally by Table

    },
    data: function data() {
      return {
        newKey: this.customKey || this.label
      };
    },
    computed: {
      rootClasses: function rootClasses() {
        return {
          'has-text-right': this.numeric && !this.centered,
          'has-text-centered': this.centered
        };
      }
    },
    methods: {
      addRefToTable: function addRefToTable() {
        var _this = this;

        if (!this.$parent.$data._isTable) {
          this.$destroy();
          throw new Error('You should wrap bTableColumn on a bTable');
        }

        if (this.internal) return; // Since we're using scoped prop the columns gonna be multiplied,
        // this finds when to stop based on the newKey property.

        var repeated = this.$parent.newColumns.some(function (column) {
          return column.newKey === _this.newKey;
        });
        !repeated && this.$parent.newColumns.push(this);
      }
    },
    beforeMount: function beforeMount() {
      this.addRefToTable();
    },
    beforeUpdate: function beforeUpdate() {
      this.addRefToTable();
    },
    beforeDestroy: function beforeDestroy() {
      var index = this.$parent.newColumns.map(function (column) {
        return column.newKey;
      }).indexOf(this.newKey);

      if (index >= 0) {
        this.$parent.newColumns.splice(index, 1);
      }
    }
  };

  /* script */
  const __vue_script__$N = script$N;

  /* template */
  var __vue_render__$I = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (_vm.visible)?_c('td',{class:_vm.rootClasses,attrs:{"data-label":_vm.label}},[_vm._t("default")],2):_vm._e()};
  var __vue_staticRenderFns__$I = [];

    /* style */
    const __vue_inject_styles__$N = undefined;
    /* scoped */
    const __vue_scope_id__$N = undefined;
    /* module identifier */
    const __vue_module_identifier__$N = undefined;
    /* functional template */
    const __vue_is_functional_template__$N = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var TableColumn = normalizeComponent_1(
      { render: __vue_render__$I, staticRenderFns: __vue_staticRenderFns__$I },
      __vue_inject_styles__$N,
      __vue_script__$N,
      __vue_scope_id__$N,
      __vue_is_functional_template__$N,
      __vue_module_identifier__$N,
      undefined,
      undefined
    );

  var _components$9;
  var script$O = {
    name: 'BTable',
    components: (_components$9 = {}, _defineProperty(_components$9, Checkbox.name, Checkbox), _defineProperty(_components$9, Icon.name, Icon), _defineProperty(_components$9, Input.name, Input), _defineProperty(_components$9, Pagination.name, Pagination), _defineProperty(_components$9, SlotComponent.name, SlotComponent), _defineProperty(_components$9, TableMobileSort.name, TableMobileSort), _defineProperty(_components$9, TableColumn.name, TableColumn), _components$9),
    props: {
      data: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      columns: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      bordered: Boolean,
      striped: Boolean,
      narrowed: Boolean,
      hoverable: Boolean,
      loading: Boolean,
      detailed: Boolean,
      checkable: Boolean,
      headerCheckable: {
        type: Boolean,
        default: true
      },
      checkboxPosition: {
        type: String,
        default: 'left',
        validator: function validator(value) {
          return ['left', 'right'].indexOf(value) >= 0;
        }
      },
      selected: Object,
      focusable: Boolean,
      customIsChecked: Function,
      isRowCheckable: {
        type: Function,
        default: function _default() {
          return true;
        }
      },
      checkedRows: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      mobileCards: {
        type: Boolean,
        default: true
      },
      defaultSort: [String, Array],
      defaultSortDirection: {
        type: String,
        default: 'asc'
      },
      sortIcon: {
        type: String,
        default: 'arrow-up'
      },
      sortIconSize: {
        type: String,
        default: 'is-small'
      },
      paginated: Boolean,
      currentPage: {
        type: Number,
        default: 1
      },
      perPage: {
        type: [Number, String],
        default: 20
      },
      showDetailIcon: {
        type: Boolean,
        default: true
      },
      paginationSimple: Boolean,
      paginationSize: String,
      paginationPosition: {
        type: String,
        default: 'bottom',
        validator: function validator(value) {
          return ['bottom', 'top', 'both'].indexOf(value) >= 0;
        }
      },
      backendSorting: Boolean,
      rowClass: {
        type: Function,
        default: function _default() {
          return '';
        }
      },
      openedDetailed: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      hasDetailedVisible: {
        type: Function,
        default: function _default() {
          return true;
        }
      },
      detailKey: {
        type: String,
        default: ''
      },
      customDetailRow: {
        type: Boolean,
        default: false
      },
      backendPagination: Boolean,
      total: {
        type: [Number, String],
        default: 0
      },
      iconPack: String,
      mobileSortPlaceholder: String,
      customRowKey: String,
      draggable: {
        type: Boolean,
        defualt: false
      },
      ariaNextLabel: String,
      ariaPreviousLabel: String,
      ariaPageLabel: String,
      ariaCurrentLabel: String
    },
    data: function data() {
      return {
        getValueByPath: getValueByPath,
        newColumns: _toConsumableArray(this.columns),
        visibleDetailRows: this.openedDetailed,
        newData: this.data,
        newDataTotal: this.backendPagination ? this.total : this.data.length,
        newCheckedRows: _toConsumableArray(this.checkedRows),
        lastCheckedRowIndex: null,
        newCurrentPage: this.currentPage,
        currentSortColumn: {},
        isAsc: true,
        filters: {},
        firstTimeSort: true,
        // Used by first time initSort
        _isTable: true // Used by TableColumn

      };
    },
    computed: {
      /**
      * return if detailed row tabled
      * will be with chevron column & icon or not
      */
      showDetailRowIcon: function showDetailRowIcon() {
        return this.detailed && this.showDetailIcon;
      },
      tableClasses: function tableClasses() {
        return {
          'is-bordered': this.bordered,
          'is-striped': this.striped,
          'is-narrow': this.narrowed,
          'has-mobile-cards': this.mobileCards,
          'is-hoverable': (this.hoverable || this.focusable) && this.visibleData.length
        };
      },

      /**
      * Splitted data based on the pagination.
      */
      visibleData: function visibleData() {
        if (!this.paginated) return this.newData;
        var currentPage = this.newCurrentPage;
        var perPage = this.perPage;

        if (this.newData.length <= perPage) {
          return this.newData;
        } else {
          var start = (currentPage - 1) * perPage;
          var end = parseInt(start, 10) + parseInt(perPage, 10);
          return this.newData.slice(start, end);
        }
      },
      visibleColumns: function visibleColumns() {
        if (!this.newColumns) return this.newColumns;
        return this.newColumns.filter(function (column) {
          return column.visible || column.visible === undefined;
        });
      },

      /**
      * Check if all rows in the page are checked.
      */
      isAllChecked: function isAllChecked() {
        var _this = this;

        var validVisibleData = this.visibleData.filter(function (row) {
          return _this.isRowCheckable(row);
        });
        if (validVisibleData.length === 0) return false;
        var isAllChecked = validVisibleData.some(function (currentVisibleRow) {
          return indexOf(_this.newCheckedRows, currentVisibleRow, _this.customIsChecked) < 0;
        });
        return !isAllChecked;
      },

      /**
      * Check if all rows in the page are checkable.
      */
      isAllUncheckable: function isAllUncheckable() {
        var _this2 = this;

        var validVisibleData = this.visibleData.filter(function (row) {
          return _this2.isRowCheckable(row);
        });
        return validVisibleData.length === 0;
      },

      /**
      * Check if has any sortable column.
      */
      hasSortablenewColumns: function hasSortablenewColumns() {
        return this.newColumns.some(function (column) {
          return column.sortable;
        });
      },

      /**
      * Check if has any searchable column.
      */
      hasSearchablenewColumns: function hasSearchablenewColumns() {
        return this.newColumns.some(function (column) {
          return column.searchable;
        });
      },

      /**
      * Return total column count based if it's checkable or expanded
      */
      columnCount: function columnCount() {
        var count = this.newColumns.length;
        count += this.checkable ? 1 : 0;
        count += this.detailed ? 1 : 0;
        return count;
      }
    },
    watch: {
      /**
      * When data prop change:
      *   1. Update internal value.
      *   2. Reset newColumns (thead), in case it's on a v-for loop.
      *   3. Sort again if it's not backend-sort.
      *   4. Set new total if it's not backend-paginated.
      */
      data: function data(value) {
        var _this3 = this;

        // Save newColumns before resetting
        var newColumns = this.newColumns;
        this.newColumns = [];
        this.newData = value; // Prevent table from being headless, data could change and created hook
        // on column might not trigger

        this.$nextTick(function () {
          if (!_this3.newColumns.length) _this3.newColumns = newColumns;
        });

        if (!this.backendSorting) {
          this.sort(this.currentSortColumn, true);
        }

        if (!this.backendPagination) {
          this.newDataTotal = value.length;
        }
      },

      /**
      * When Pagination total change, update internal total
      * only if it's backend-paginated.
      */
      total: function total(newTotal) {
        if (!this.backendPagination) return;
        this.newDataTotal = newTotal;
      },

      /**
      * When checkedRows prop change, update internal value without
      * mutating original data.
      */
      checkedRows: function checkedRows(rows) {
        this.newCheckedRows = _toConsumableArray(rows);
      },
      columns: function columns(value) {
        this.newColumns = _toConsumableArray(value);
      },
      newColumns: function newColumns(value) {
        this.checkSort();
      },
      filters: {
        handler: function handler(value) {
          var _this4 = this;

          this.newData = this.data.filter(function (row) {
            return _this4.isRowFiltered(row);
          });
        },
        deep: true
      },

      /**
      * When the user wants to control the detailed rows via props.
      * Or wants to open the details of certain row with the router for example.
      */
      openedDetailed: function openedDetailed(expandedRows) {
        this.visibleDetailRows = expandedRows;
      },
      currentPage: function currentPage(newVal) {
        this.newCurrentPage = newVal;
      }
    },
    methods: {
      /**
      * Sort an array by key without mutating original data.
      * Call the user sort function if it was passed.
      */
      sortBy: function sortBy(array, key, fn, isAsc) {
        var sorted = []; // Sorting without mutating original data

        if (fn && typeof fn === 'function') {
          sorted = _toConsumableArray(array).sort(function (a, b) {
            return fn(a, b, isAsc);
          });
        } else {
          sorted = _toConsumableArray(array).sort(function (a, b) {
            // Get nested values from objects
            var newA = getValueByPath(a, key);
            var newB = getValueByPath(b, key); // sort boolean type

            if (typeof newA === 'boolean' && typeof newB === 'boolean') {
              return isAsc ? newA - newB : newB - newA;
            }

            if (!newA && newA !== 0) return 1;
            if (!newB && newB !== 0) return -1;
            if (newA === newB) return 0;
            newA = typeof newA === 'string' ? newA.toUpperCase() : newA;
            newB = typeof newB === 'string' ? newB.toUpperCase() : newB;
            return isAsc ? newA > newB ? 1 : -1 : newA > newB ? -1 : 1;
          });
        }

        return sorted;
      },

      /**
      * Sort the column.
      * Toggle current direction on column if it's sortable
      * and not just updating the prop.
      */
      sort: function sort(column) {
        var updatingData = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
        if (!column || !column.sortable) return;

        if (!updatingData) {
          this.isAsc = column === this.currentSortColumn ? !this.isAsc : this.defaultSortDirection.toLowerCase() !== 'desc';
        }

        if (!this.firstTimeSort) {
          this.$emit('sort', column.field, this.isAsc ? 'asc' : 'desc');
        }

        if (!this.backendSorting) {
          this.newData = this.sortBy(this.newData, column.field, column.customSort, this.isAsc);
        }

        this.currentSortColumn = column;
      },

      /**
      * Check if the row is checked (is added to the array).
      */
      isRowChecked: function isRowChecked(row) {
        return indexOf(this.newCheckedRows, row, this.customIsChecked) >= 0;
      },

      /**
      * Remove a checked row from the array.
      */
      removeCheckedRow: function removeCheckedRow(row) {
        var index = indexOf(this.newCheckedRows, row, this.customIsChecked);

        if (index >= 0) {
          this.newCheckedRows.splice(index, 1);
        }
      },

      /**
      * Header checkbox click listener.
      * Add or remove all rows in current page.
      */
      checkAll: function checkAll() {
        var _this5 = this;

        var isAllChecked = this.isAllChecked;
        this.visibleData.forEach(function (currentRow) {
          _this5.removeCheckedRow(currentRow);

          if (!isAllChecked) {
            if (_this5.isRowCheckable(currentRow)) {
              _this5.newCheckedRows.push(currentRow);
            }
          }
        });
        this.$emit('check', this.newCheckedRows);
        this.$emit('check-all', this.newCheckedRows); // Emit checked rows to update user variable

        this.$emit('update:checkedRows', this.newCheckedRows);
      },

      /**
      * Row checkbox click listener.
      */
      checkRow: function checkRow(row, index, event) {
        var lastIndex = this.lastCheckedRowIndex;
        this.lastCheckedRowIndex = index;

        if (event.shiftKey && lastIndex !== null && index !== lastIndex) {
          this.shiftCheckRow(row, index, lastIndex);
        } else if (!this.isRowChecked(row)) {
          this.newCheckedRows.push(row);
        } else {
          this.removeCheckedRow(row);
        }

        this.$emit('check', this.newCheckedRows, row); // Emit checked rows to update user variable

        this.$emit('update:checkedRows', this.newCheckedRows);
      },

      /**
       * Check row when shift is pressed.
       */
      shiftCheckRow: function shiftCheckRow(row, index, lastCheckedRowIndex) {
        var _this6 = this;

        // Get the subset of the list between the two indicies
        var subset = this.visibleData.slice(Math.min(index, lastCheckedRowIndex), Math.max(index, lastCheckedRowIndex) + 1); // Determine the operation based on the state of the clicked checkbox

        var shouldCheck = !this.isRowChecked(row);
        subset.forEach(function (item) {
          _this6.removeCheckedRow(item);

          if (shouldCheck && _this6.isRowCheckable(item)) {
            _this6.newCheckedRows.push(item);
          }
        });
      },

      /**
      * Row click listener.
      * Emit all necessary events.
      */
      selectRow: function selectRow(row, index) {
        this.$emit('click', row);
        if (this.selected === row) return; // Emit new and old row

        this.$emit('select', row, this.selected); // Emit new row to update user variable

        this.$emit('update:selected', row);
      },

      /**
      * Paginator change listener.
      */
      pageChanged: function pageChanged(page) {
        this.newCurrentPage = page > 0 ? page : 1;
        this.$emit('page-change', this.newCurrentPage);
        this.$emit('update:currentPage', this.newCurrentPage);
      },

      /**
      * Toggle to show/hide details slot
      */
      toggleDetails: function toggleDetails(obj) {
        var found = this.isVisibleDetailRow(obj);

        if (found) {
          this.closeDetailRow(obj);
          this.$emit('details-close', obj);
        } else {
          this.openDetailRow(obj);
          this.$emit('details-open', obj);
        } // Syncs the detailed rows with the parent component


        this.$emit('update:openedDetailed', this.visibleDetailRows);
      },
      openDetailRow: function openDetailRow(obj) {
        var index = this.handleDetailKey(obj);
        this.visibleDetailRows.push(index);
      },
      closeDetailRow: function closeDetailRow(obj) {
        var index = this.handleDetailKey(obj);
        var i = this.visibleDetailRows.indexOf(index);
        this.visibleDetailRows.splice(i, 1);
      },
      isVisibleDetailRow: function isVisibleDetailRow(obj) {
        var index = this.handleDetailKey(obj);
        var result = this.visibleDetailRows.indexOf(index) >= 0;
        return result;
      },
      isActiveDetailRow: function isActiveDetailRow(row) {
        return this.detailed && !this.customDetailRow && this.isVisibleDetailRow(row);
      },
      isActiveCustomDetailRow: function isActiveCustomDetailRow(row) {
        return this.detailed && this.customDetailRow && this.isVisibleDetailRow(row);
      },
      isRowFiltered: function isRowFiltered(row) {
        for (var key in this.filters) {
          // remove key if empty
          if (!this.filters[key]) {
            delete this.filters[key];
            return true;
          }

          if (Number.isInteger(row[key])) {
            if (row[key] !== Number(this.filters[key])) return false;
          } else {
            var re = new RegExp(this.filters[key]);
            if (!row[key].match(re)) return false;
          }
        }

        return true;
      },

      /**
          * When the detailKey is defined we use the object[detailKey] as index.
          * If not, use the object reference by default.
          */
      handleDetailKey: function handleDetailKey(index) {
        var key = this.detailKey;
        return !key.length ? index : index[key];
      },
      checkPredefinedDetailedRows: function checkPredefinedDetailedRows() {
        var defaultExpandedRowsDefined = this.openedDetailed.length > 0;

        if (defaultExpandedRowsDefined && !this.detailKey.length) {
          throw new Error('If you set a predefined opened-detailed, you must provide a unique key using the prop "detail-key"');
        }
      },

      /**
      * Call initSort only first time (For example async data).
      */
      checkSort: function checkSort() {
        if (this.newColumns.length && this.firstTimeSort) {
          this.initSort();
          this.firstTimeSort = false;
        } else if (this.newColumns.length) {
          if (this.currentSortColumn.field) {
            for (var i = 0; i < this.newColumns.length; i++) {
              if (this.newColumns[i].field === this.currentSortColumn.field) {
                this.currentSortColumn = this.newColumns[i];
                break;
              }
            }
          }
        }
      },

      /**
      * Check if footer slot has custom content.
      */
      hasCustomFooterSlot: function hasCustomFooterSlot() {
        if (this.$slots.footer.length > 1) return true;
        var tag = this.$slots.footer[0].tag;
        if (tag !== 'th' && tag !== 'td') return false;
        return true;
      },

      /**
      * Check if bottom-left slot exists.
      */
      hasBottomLeftSlot: function hasBottomLeftSlot() {
        return typeof this.$slots['bottom-left'] !== 'undefined';
      },

      /**
      * Table arrow keys listener, change selection.
      */
      pressedArrow: function pressedArrow(pos) {
        if (!this.visibleData.length) return;
        var index = this.visibleData.indexOf(this.selected) + pos; // Prevent from going up from first and down from last

        index = index < 0 ? 0 : index > this.visibleData.length - 1 ? this.visibleData.length - 1 : index;
        this.selectRow(this.visibleData[index]);
      },

      /**
      * Focus table element if has selected prop.
      */
      focus: function focus() {
        if (!this.focusable) return;
        this.$el.querySelector('table').focus();
      },

      /**
      * Initial sorted column based on the default-sort prop.
      */
      initSort: function initSort() {
        var _this7 = this;

        if (!this.defaultSort) return;
        var sortField = '';
        var sortDirection = this.defaultSortDirection;

        if (Array.isArray(this.defaultSort)) {
          sortField = this.defaultSort[0];

          if (this.defaultSort[1]) {
            sortDirection = this.defaultSort[1];
          }
        } else {
          sortField = this.defaultSort;
        }

        this.newColumns.forEach(function (column) {
          if (column.field === sortField) {
            _this7.isAsc = sortDirection.toLowerCase() !== 'desc';

            _this7.sort(column, true);
          }
        });
      },

      /**
      * Emits drag start event
      */
      handleDragStart: function handleDragStart(event, row, index) {
        this.$emit('dragstart', {
          event: event,
          row: row,
          index: index
        });
      },

      /**
      * Emits drag leave event
      */
      handleDragEnd: function handleDragEnd(event, row, index) {
        this.$emit('dragend', {
          event: event,
          row: row,
          index: index
        });
      },

      /**
      * Emits drop event
      */
      handleDrop: function handleDrop(event, row, index) {
        this.$emit('drop', {
          event: event,
          row: row,
          index: index
        });
      },

      /**
      * Emits drag over event
      */
      handleDragOver: function handleDragOver(event, row, index) {
        this.$emit('dragover', {
          event: event,
          row: row,
          index: index
        });
      },

      /**
      * Emits drag leave event
      */
      handleDragLeave: function handleDragLeave(event, row, index) {
        this.$emit('dragleave', {
          event: event,
          row: row,
          index: index
        });
      }
    },
    mounted: function mounted() {
      this.checkPredefinedDetailedRows();
      this.checkSort();
    }
  };

  /* script */
  const __vue_script__$O = script$O;

  /* template */
  var __vue_render__$J = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-table",class:{ 'is-loading': _vm.loading }},[(_vm.mobileCards && _vm.hasSortablenewColumns)?_c('b-table-mobile-sort',{attrs:{"current-sort-column":_vm.currentSortColumn,"is-asc":_vm.isAsc,"columns":_vm.newColumns,"placeholder":_vm.mobileSortPlaceholder,"icon-pack":_vm.iconPack,"sort-icon":_vm.sortIcon,"sort-icon-size":_vm.sortIconSize},on:{"sort":function (column) { return _vm.sort(column); }}}):_vm._e(),_vm._v(" "),(_vm.paginated && (_vm.paginationPosition === 'top' || _vm.paginationPosition === 'both'))?_c('div',{staticClass:"top level"},[_c('div',{staticClass:"level-left"},[_vm._t("top-left")],2),_vm._v(" "),_c('div',{staticClass:"level-right"},[(_vm.paginated)?_c('div',{staticClass:"level-item"},[_c('b-pagination',{attrs:{"icon-pack":_vm.iconPack,"total":_vm.newDataTotal,"per-page":_vm.perPage,"simple":_vm.paginationSimple,"size":_vm.paginationSize,"current":_vm.newCurrentPage,"aria-next-label":_vm.ariaNextLabel,"aria-previous-label":_vm.ariaPreviousLabel,"aria-page-label":_vm.ariaPageLabel,"aria-current-label":_vm.ariaCurrentLabel},on:{"change":_vm.pageChanged}})],1):_vm._e()])]):_vm._e(),_vm._v(" "),_c('div',{staticClass:"table-wrapper"},[_c('table',{staticClass:"table",class:_vm.tableClasses,attrs:{"tabindex":!_vm.focusable ? false : 0},on:{"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"up",38,$event.key)){ return null; }if($event.target !== $event.currentTarget){ return null; }$event.preventDefault();_vm.pressedArrow(-1);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"down",40,$event.key)){ return null; }if($event.target !== $event.currentTarget){ return null; }$event.preventDefault();_vm.pressedArrow(1);}]}},[(_vm.newColumns.length)?_c('thead',[_c('tr',[(_vm.showDetailRowIcon)?_c('th',{attrs:{"width":"40px"}}):_vm._e(),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'left')?_c('th',{staticClass:"checkbox-cell"},[(_vm.headerCheckable)?[_c('b-checkbox',{attrs:{"value":_vm.isAllChecked,"disabled":_vm.isAllUncheckable},nativeOn:{"change":function($event){_vm.checkAll($event);}}})]:_vm._e()],2):_vm._e(),_vm._v(" "),_vm._l((_vm.visibleColumns),function(column,index){return _c('th',{key:index,class:{
                              'is-current-sort': _vm.currentSortColumn === column,
                              'is-sortable': column.sortable
                          },style:({
                              width: column.width === undefined ? null :
                              (isNaN(column.width) ? column.width : column.width + 'px')
                          }),on:{"click":function($event){$event.stopPropagation();_vm.sort(column);}}},[_c('div',{staticClass:"th-wrap",class:{
                                  'is-numeric': column.numeric,
                                  'is-centered': column.centered
                          }},[(column.$scopedSlots && column.$scopedSlots.header)?[_c('b-slot-component',{attrs:{"component":column,"scoped":true,"name":"header","tag":"span","props":{ column: column, index: index }}})]:(_vm.$scopedSlots.header)?[_vm._t("header",null,{column:column,index:index})]:[_vm._v(_vm._s(column.label))],_vm._v(" "),_c('b-icon',{directives:[{name:"show",rawName:"v-show",value:(_vm.currentSortColumn === column),expression:"currentSortColumn === column"}],class:{ 'is-desc': !_vm.isAsc },attrs:{"icon":_vm.sortIcon,"pack":_vm.iconPack,"both":"","size":_vm.sortIconSize}})],2)])}),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'right')?_c('th',{staticClass:"checkbox-cell"},[(_vm.headerCheckable)?[_c('b-checkbox',{attrs:{"value":_vm.isAllChecked,"disabled":_vm.isAllUncheckable},nativeOn:{"change":function($event){_vm.checkAll($event);}}})]:_vm._e()],2):_vm._e()],2),_vm._v(" "),(_vm.hasSearchablenewColumns)?_c('tr',_vm._l((_vm.visibleColumns),function(column,index){return _c('th',{key:index,style:({
                              width: column.width === undefined ? null
                          : (isNaN(column.width) ? column.width : column.width + 'px') })},[_c('div',{staticClass:"th-wrap"},[(column.searchable)?[_c('b-input',{attrs:{"type":column.numeric ? 'number' : 'text'},model:{value:(_vm.filters[column.field]),callback:function ($$v) {_vm.$set(_vm.filters, column.field, $$v);},expression:"filters[column.field]"}})]:_vm._e()],2)])})):_vm._e()]):_vm._e(),_vm._v(" "),(_vm.visibleData.length)?_c('tbody',[_vm._l((_vm.visibleData),function(row,index){return [_c('tr',{key:_vm.customRowKey ? row[_vm.customRowKey] : index,class:[_vm.rowClass(row, index), {
                              'is-selected': row === _vm.selected,
                              'is-checked': _vm.isRowChecked(row),
                          }],attrs:{"draggable":_vm.draggable},on:{"click":function($event){_vm.selectRow(row);},"dblclick":function($event){_vm.$emit('dblclick', row);},"mouseenter":function($event){_vm.$emit('mouseenter', row);},"mouseleave":function($event){_vm.$emit('mouseleave', row);},"contextmenu":function($event){_vm.$emit('contextmenu', row, $event);},"dragstart":function($event){_vm.handleDragStart($event, row, index);},"dragend":function($event){_vm.handleDragEnd($event, row, index);},"drop":function($event){_vm.handleDrop($event, row, index);},"dragover":function($event){_vm.handleDragOver($event, row, index);},"dragleave":function($event){_vm.handleDragLeave($event, row, index);}}},[(_vm.showDetailRowIcon)?_c('td',{staticClass:"chevron-cell"},[(_vm.hasDetailedVisible(row))?_c('a',{attrs:{"role":"button"},on:{"click":function($event){$event.stopPropagation();_vm.toggleDetails(row);}}},[_c('b-icon',{class:{'is-expanded': _vm.isVisibleDetailRow(row)},attrs:{"icon":"chevron-right","pack":_vm.iconPack,"both":""}})],1):_vm._e()]):_vm._e(),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'left')?_c('td',{staticClass:"checkbox-cell"},[_c('b-checkbox',{attrs:{"disabled":!_vm.isRowCheckable(row),"value":_vm.isRowChecked(row)},nativeOn:{"click":function($event){$event.preventDefault();$event.stopPropagation();_vm.checkRow(row, index, $event);}}})],1):_vm._e(),_vm._v(" "),(_vm.$scopedSlots.default)?_vm._t("default",null,{row:row,index:index}):_vm._l((_vm.newColumns),function(column){return _c('BTableColumn',_vm._b({key:column.field,attrs:{"internal":""}},'BTableColumn',column,false),[(column.renderHtml)?_c('span',{domProps:{"innerHTML":_vm._s(_vm.getValueByPath(row, column.field))}}):[_vm._v("\n                                    "+_vm._s(_vm.getValueByPath(row, column.field))+"\n                                ")]],2)}),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'right')?_c('td',{staticClass:"checkbox-cell"},[_c('b-checkbox',{attrs:{"disabled":!_vm.isRowCheckable(row),"value":_vm.isRowChecked(row)},nativeOn:{"click":function($event){$event.preventDefault();$event.stopPropagation();_vm.checkRow(row, index, $event);}}})],1):_vm._e()],2),_vm._v(" "),(_vm.isActiveDetailRow(row))?_c('tr',{staticClass:"detail"},[_c('td',{attrs:{"colspan":_vm.columnCount}},[_c('div',{staticClass:"detail-container"},[_vm._t("detail",null,{row:row,index:index})],2)])]):_vm._e(),_vm._v(" "),(_vm.isActiveCustomDetailRow(row))?_vm._t("detail",null,{row:row,index:index}):_vm._e()]})],2):_c('tbody',[_c('tr',{staticClass:"is-empty"},[_c('td',{attrs:{"colspan":_vm.columnCount}},[_vm._t("empty")],2)])]),_vm._v(" "),(_vm.$slots.footer !== undefined)?_c('tfoot',[_c('tr',{staticClass:"table-footer"},[(_vm.hasCustomFooterSlot())?_vm._t("footer"):_c('th',{attrs:{"colspan":_vm.columnCount}},[_vm._t("footer")],2)],2)]):_vm._e()])]),_vm._v(" "),((_vm.checkable && _vm.hasBottomLeftSlot()) ||
          (_vm.paginated && (_vm.paginationPosition === 'bottom' || _vm.paginationPosition === 'both')))?_c('div',{staticClass:"level"},[_c('div',{staticClass:"level-left"},[_vm._t("bottom-left")],2),_vm._v(" "),_c('div',{staticClass:"level-right"},[(_vm.paginated)?_c('div',{staticClass:"level-item"},[_c('b-pagination',{attrs:{"icon-pack":_vm.iconPack,"total":_vm.newDataTotal,"per-page":_vm.perPage,"simple":_vm.paginationSimple,"size":_vm.paginationSize,"current":_vm.newCurrentPage,"aria-next-label":_vm.ariaNextLabel,"aria-previous-label":_vm.ariaPreviousLabel,"aria-page-label":_vm.ariaPageLabel,"aria-current-label":_vm.ariaCurrentLabel},on:{"change":_vm.pageChanged}})],1):_vm._e()])]):_vm._e()],1)};
  var __vue_staticRenderFns__$J = [];

    /* style */
    const __vue_inject_styles__$O = undefined;
    /* scoped */
    const __vue_scope_id__$O = undefined;
    /* module identifier */
    const __vue_module_identifier__$O = undefined;
    /* functional template */
    const __vue_is_functional_template__$O = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Table = normalizeComponent_1(
      { render: __vue_render__$J, staticRenderFns: __vue_staticRenderFns__$J },
      __vue_inject_styles__$O,
      __vue_script__$O,
      __vue_scope_id__$O,
      __vue_is_functional_template__$O,
      __vue_module_identifier__$O,
      undefined,
      undefined
    );

  var Plugin$s = {
    install: function install(Vue) {
      registerComponent(Vue, Table);
      registerComponent(Vue, TableColumn);
    }
  };
  use(Plugin$s);

  var _components$a;
  var script$P = {
    name: 'BTabs',
    components: (_components$a = {}, _defineProperty(_components$a, Icon.name, Icon), _defineProperty(_components$a, SlotComponent.name, SlotComponent), _components$a),
    props: {
      value: Number,
      expanded: Boolean,
      type: String,
      size: String,
      position: String,
      animated: {
        type: Boolean,
        default: true
      },
      destroyOnHide: {
        type: Boolean,
        default: false
      },
      vertical: Boolean
    },
    data: function data() {
      return {
        activeTab: this.value || 0,
        tabItems: [],
        contentHeight: 0,
        isTransitioning: false,
        _isTabs: true // Used internally by TabItem

      };
    },
    computed: {
      mainClasses: function mainClasses() {
        return _defineProperty({
          'is-fullwidth': this.expanded,
          'is-vertical': this.vertical
        }, this.position, this.position && this.vertical);
      },
      navClasses: function navClasses() {
        var _ref2;

        return [this.type, this.size, (_ref2 = {}, _defineProperty(_ref2, this.position, this.position && !this.vertical), _defineProperty(_ref2, 'is-fullwidth', this.expanded), _defineProperty(_ref2, 'is-toggle-rounded is-toggle', this.type === 'is-toggle-rounded'), _ref2)];
      }
    },
    watch: {
      /**
      * When v-model is changed set the new active tab.
      */
      value: function value(_value) {
        this.changeTab(_value);
      },

      /**
      * When tab-items are updated, set active one.
      */
      tabItems: function tabItems() {
        if (this.activeTab < this.tabItems.length) {
          this.tabItems[this.activeTab].isActive = true;
        }
      }
    },
    methods: {
      /**
      * Change the active tab and emit change event.
      */
      changeTab: function changeTab(newIndex) {
        if (this.activeTab === newIndex || this.tabItems[newIndex] === undefined) return;

        if (this.activeTab < this.tabItems.length) {
          this.tabItems[this.activeTab].deactivate(this.activeTab, newIndex);
        }

        this.tabItems[newIndex].activate(this.activeTab, newIndex);
        this.activeTab = newIndex;
        this.$emit('change', newIndex);
      },

      /**
      * Tab click listener, emit input event and change active tab.
      */
      tabClick: function tabClick(value) {
        this.$emit('input', value);
        this.changeTab(value);
      }
    },
    mounted: function mounted() {
      if (this.activeTab < this.tabItems.length) {
        this.tabItems[this.activeTab].isActive = true;
      }
    }
  };

  /* script */
  const __vue_script__$P = script$P;

  /* template */
  var __vue_render__$K = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-tabs",class:_vm.mainClasses},[_c('nav',{staticClass:"tabs",class:_vm.navClasses},[_c('ul',_vm._l((_vm.tabItems),function(tabItem,index){return _c('li',{directives:[{name:"show",rawName:"v-show",value:(tabItem.visible),expression:"tabItem.visible"}],key:index,class:{ 'is-active': _vm.activeTab === index, 'is-disabled': tabItem.disabled }},[_c('a',{on:{"click":function($event){_vm.tabClick(index);}}},[(tabItem.$slots.header)?[_c('b-slot-component',{attrs:{"component":tabItem,"name":"header","tag":"span"}})]:[(tabItem.icon)?_c('b-icon',{attrs:{"icon":tabItem.icon,"pack":tabItem.iconPack,"size":_vm.size}}):_vm._e(),_vm._v(" "),_c('span',[_vm._v(_vm._s(tabItem.label))])]],2)])}))]),_vm._v(" "),_c('section',{staticClass:"tab-content",class:{'is-transitioning': _vm.isTransitioning}},[_vm._t("default")],2)])};
  var __vue_staticRenderFns__$K = [];

    /* style */
    const __vue_inject_styles__$P = undefined;
    /* scoped */
    const __vue_scope_id__$P = undefined;
    /* module identifier */
    const __vue_module_identifier__$P = undefined;
    /* functional template */
    const __vue_is_functional_template__$P = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Tabs = normalizeComponent_1(
      { render: __vue_render__$K, staticRenderFns: __vue_staticRenderFns__$K },
      __vue_inject_styles__$P,
      __vue_script__$P,
      __vue_scope_id__$P,
      __vue_is_functional_template__$P,
      __vue_module_identifier__$P,
      undefined,
      undefined
    );

  var script$Q = {
    name: 'BTabItem',
    props: {
      label: String,
      icon: String,
      iconPack: String,
      disabled: Boolean,
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
      * Activate tab, alter animation name based on the index.
      */
      activate: function activate(oldIndex, index) {
        this.transitionName = index < oldIndex ? 'slide-next' : 'slide-prev';
        this.isActive = true;
      },

      /**
      * Deactivate tab, alter animation name based on the index.
      */
      deactivate: function deactivate(oldIndex, index) {
        this.transitionName = index < oldIndex ? 'slide-next' : 'slide-prev';
        this.isActive = false;
      }
    },
    created: function created() {
      if (!this.$parent.$data._isTabs) {
        this.$destroy();
        throw new Error('You should wrap bTabItem on a bTabs');
      }

      this.$parent.tabItems.push(this);
    },
    beforeDestroy: function beforeDestroy() {
      var index = this.$parent.tabItems.indexOf(this);

      if (index >= 0) {
        this.$parent.tabItems.splice(index, 1);
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
        class: 'tab-item'
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
  const __vue_script__$Q = script$Q;

  /* template */

    /* style */
    const __vue_inject_styles__$Q = undefined;
    /* scoped */
    const __vue_scope_id__$Q = undefined;
    /* module identifier */
    const __vue_module_identifier__$Q = undefined;
    /* functional template */
    const __vue_is_functional_template__$Q = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var TabItem = normalizeComponent_1(
      {},
      __vue_inject_styles__$Q,
      __vue_script__$Q,
      __vue_scope_id__$Q,
      __vue_is_functional_template__$Q,
      __vue_module_identifier__$Q,
      undefined,
      undefined
    );

  var Plugin$t = {
    install: function install(Vue) {
      registerComponent(Vue, Tabs);
      registerComponent(Vue, TabItem);
    }
  };
  use(Plugin$t);

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
  var script$R = {
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
      ariaCloseLabel: String
    },
    methods: {
      /**
      * Emit close event when delete button is clicked
      * or delete key is pressed.
      */
      close: function close() {
        if (this.disabled) return;
        this.$emit('close');
      }
    }
  };

  /* script */
  const __vue_script__$R = script$R;

  /* template */
  var __vue_render__$L = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (_vm.attached && _vm.closable)?_c('div',{staticClass:"tags has-addons"},[_c('span',{staticClass:"tag",class:[_vm.type, _vm.size, { 'is-rounded': _vm.rounded }]},[_c('span',{class:{ 'has-ellipsis': _vm.ellipsis }},[_vm._t("default")],2)]),_vm._v(" "),_c('a',{staticClass:"tag is-delete",class:[_vm.size, { 'is-rounded': _vm.rounded }],attrs:{"role":"button","aria-label":_vm.ariaCloseLabel,"tabindex":_vm.tabstop ? 0 : false,"disabled":_vm.disabled},on:{"click":function($event){_vm.close();},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"delete",[8,46],$event.key)){ return null; }$event.preventDefault();_vm.close();}}})]):_c('span',{staticClass:"tag",class:[_vm.type, _vm.size, { 'is-rounded': _vm.rounded }]},[_c('span',{class:{ 'has-ellipsis': _vm.ellipsis }},[_vm._t("default")],2),_vm._v(" "),(_vm.closable)?_c('a',{staticClass:"delete is-small",attrs:{"role":"button","aria-label":_vm.ariaCloseLabel,"disabled":_vm.disabled,"tabindex":_vm.tabstop ? 0 : false},on:{"click":function($event){_vm.close();},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"delete",[8,46],$event.key)){ return null; }$event.preventDefault();_vm.close();}}}):_vm._e()])};
  var __vue_staticRenderFns__$L = [];

    /* style */
    const __vue_inject_styles__$R = undefined;
    /* scoped */
    const __vue_scope_id__$R = undefined;
    /* module identifier */
    const __vue_module_identifier__$R = undefined;
    /* functional template */
    const __vue_is_functional_template__$R = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Tag = normalizeComponent_1(
      { render: __vue_render__$L, staticRenderFns: __vue_staticRenderFns__$L },
      __vue_inject_styles__$R,
      __vue_script__$R,
      __vue_scope_id__$R,
      __vue_is_functional_template__$R,
      __vue_module_identifier__$R,
      undefined,
      undefined
    );

  //
  //
  //
  //
  //
  //
  var script$S = {
    name: 'BTaglist',
    props: {
      attached: Boolean
    }
  };

  /* script */
  const __vue_script__$S = script$S;

  /* template */
  var __vue_render__$M = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"tags",class:{ 'has-addons': _vm.attached }},[_vm._t("default")],2)};
  var __vue_staticRenderFns__$M = [];

    /* style */
    const __vue_inject_styles__$S = undefined;
    /* scoped */
    const __vue_scope_id__$S = undefined;
    /* module identifier */
    const __vue_module_identifier__$S = undefined;
    /* functional template */
    const __vue_is_functional_template__$S = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Taglist = normalizeComponent_1(
      { render: __vue_render__$M, staticRenderFns: __vue_staticRenderFns__$M },
      __vue_inject_styles__$S,
      __vue_script__$S,
      __vue_scope_id__$S,
      __vue_is_functional_template__$S,
      __vue_module_identifier__$S,
      undefined,
      undefined
    );

  var Plugin$u = {
    install: function install(Vue) {
      registerComponent(Vue, Tag);
      registerComponent(Vue, Taglist);
    }
  };
  use(Plugin$u);

  var _components$b;
  var script$T = {
    name: 'BTaginput',
    components: (_components$b = {}, _defineProperty(_components$b, Autocomplete.name, Autocomplete), _defineProperty(_components$b, Tag.name, Tag), _components$b),
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
          return config$1.defaultTaginputHasCounter;
        }
      },
      field: {
        type: String,
        default: 'value'
      },
      autocomplete: Boolean,
      nativeAutocomplete: String,
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
      }
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
        this.tags = _value;
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
      customOnBlur: function customOnBlur($event) {
        // Add tag on-blur if not select only
        if (!this.autocomplete) this.addTag();
        this.onBlur($event);
      },
      onSelect: function onSelect(option) {
        var _this = this;

        if (!option) return;
        this.addTag(option);
        this.$nextTick(function () {
          _this.newTag = '';
        });
      },
      removeTag: function removeTag(index) {
        var tag = this.tags.splice(index, 1)[0];
        this.$emit('input', this.tags);
        this.$emit('remove', tag);
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
      onTyping: function onTyping($event) {
        this.$emit('typing', $event.trim());
      }
    }
  };

  /* script */
  const __vue_script__$T = script$T;

  /* template */
  var __vue_render__$N = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"taginput control",class:_vm.rootClasses},[_c('div',{staticClass:"taginput-container",class:[_vm.statusType, _vm.size, _vm.containerClasses],attrs:{"disabled":_vm.disabled},on:{"click":function($event){_vm.hasInput && _vm.focus($event);}}},[_vm._l((_vm.tags),function(tag,index){return _c('b-tag',{key:index,attrs:{"type":_vm.type,"size":_vm.size,"rounded":_vm.rounded,"attached":_vm.attached,"tabstop":false,"disabled":_vm.disabled,"ellipsis":_vm.ellipsis,"closable":_vm.closable,"title":_vm.ellipsis && _vm.getNormalizedTagText(tag)},on:{"close":function($event){_vm.removeTag(index);}}},[_vm._v("\n            "+_vm._s(_vm.getNormalizedTagText(tag))+"\n        ")])}),_vm._v(" "),(_vm.hasInput)?_c('b-autocomplete',_vm._b({ref:"autocomplete",attrs:{"data":_vm.data,"field":_vm.field,"icon":_vm.icon,"icon-pack":_vm.iconPack,"maxlength":_vm.maxlength,"has-counter":false,"size":_vm.size,"disabled":_vm.disabled,"loading":_vm.loading,"autocomplete":_vm.nativeAutocomplete,"keep-first":!_vm.allowNew,"use-html5-validation":_vm.useHtml5Validation},on:{"typing":_vm.onTyping,"focus":_vm.onFocus,"blur":_vm.customOnBlur,"select":_vm.onSelect},nativeOn:{"keydown":function($event){_vm.keydown($event);}},scopedSlots:_vm._u([{key:_vm.defaultSlotName,fn:function(props){return [_vm._t("default",null,{option:props.option,index:props.index})]}}]),model:{value:(_vm.newTag),callback:function ($$v) {_vm.newTag=$$v;},expression:"newTag"}},'b-autocomplete',_vm.$attrs,false),[_c('template',{slot:_vm.headerSlotName},[_vm._t("header")],2),_vm._v(" "),_c('template',{slot:_vm.emptySlotName},[_vm._t("empty")],2),_vm._v(" "),_c('template',{slot:_vm.footerSlotName},[_vm._t("footer")],2)],2):_vm._e()],2),_vm._v(" "),(_vm.hasCounter && (_vm.maxtags || _vm.maxlength))?_c('small',{staticClass:"help counter"},[(_vm.maxlength && _vm.valueLength > 0)?[_vm._v("\n            "+_vm._s(_vm.valueLength)+" / "+_vm._s(_vm.maxlength)+"\n        ")]:(_vm.maxtags)?[_vm._v("\n            "+_vm._s(_vm.tagsLength)+" / "+_vm._s(_vm.maxtags)+"\n        ")]:_vm._e()],2):_vm._e()])};
  var __vue_staticRenderFns__$N = [];

    /* style */
    const __vue_inject_styles__$T = undefined;
    /* scoped */
    const __vue_scope_id__$T = undefined;
    /* module identifier */
    const __vue_module_identifier__$T = undefined;
    /* functional template */
    const __vue_is_functional_template__$T = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Taginput = normalizeComponent_1(
      { render: __vue_render__$N, staticRenderFns: __vue_staticRenderFns__$N },
      __vue_inject_styles__$T,
      __vue_script__$T,
      __vue_scope_id__$T,
      __vue_is_functional_template__$T,
      __vue_module_identifier__$T,
      undefined,
      undefined
    );

  var Plugin$v = {
    install: function install(Vue) {
      registerComponent(Vue, Taginput);
    }
  };
  use(Plugin$v);

  var Plugin$w = {
    install: function install(Vue) {
      registerComponent(Vue, Timepicker);
    }
  };
  use(Plugin$w);

  //
  var script$U = {
    name: 'BToast',
    mixins: [NoticeMixin],
    data: function data() {
      return {
        newDuration: this.duration || config$1.defaultToastDuration
      };
    }
  };

  /* script */
  const __vue_script__$U = script$U;

  /* template */
  var __vue_render__$O = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"enter-active-class":_vm.transition.enter,"leave-active-class":_vm.transition.leave}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"toast",class:[_vm.type, _vm.position],attrs:{"aria-hidden":!_vm.isActive,"role":"alert"}},[_c('div',{domProps:{"innerHTML":_vm._s(_vm.message)}})])])};
  var __vue_staticRenderFns__$O = [];

    /* style */
    const __vue_inject_styles__$U = undefined;
    /* scoped */
    const __vue_scope_id__$U = undefined;
    /* module identifier */
    const __vue_module_identifier__$U = undefined;
    /* functional template */
    const __vue_is_functional_template__$U = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Toast = normalizeComponent_1(
      { render: __vue_render__$O, staticRenderFns: __vue_staticRenderFns__$O },
      __vue_inject_styles__$U,
      __vue_script__$U,
      __vue_scope_id__$U,
      __vue_is_functional_template__$U,
      __vue_module_identifier__$U,
      undefined,
      undefined
    );

  var ToastProgrammatic = {
    open: function open(params) {
      var message;
      var parent;
      if (typeof params === 'string') message = params;
      var defaultParam = {
        message: message,
        position: config$1.defaultToastPosition || 'is-top'
      };

      if (params.parent) {
        parent = params.parent;
        delete params.parent;
      }

      var propsData = Object.assign(defaultParam, params);
      var vm = typeof window !== 'undefined' && window.Vue ? window.Vue : Vue;
      var ToastComponent = vm.extend(Toast);
      return new ToastComponent({
        parent: parent,
        el: document.createElement('div'),
        propsData: propsData
      });
    }
  };
  var Plugin$x = {
    install: function install(Vue) {
      registerComponentProgrammatic(Vue, 'toast', ToastProgrammatic);
    }
  };
  use(Plugin$x);

  var Plugin$y = {
    install: function install(Vue) {
      registerComponent(Vue, Tooltip);
    }
  };
  use(Plugin$y);

  //
  var script$V = {
    name: 'BUpload',
    mixins: [FormElementMixin],
    inheritAttrs: false,
    props: {
      value: {
        type: [Object, Function, File, Array]
      },
      multiple: Boolean,
      disabled: Boolean,
      accept: String,
      dragDrop: Boolean,
      type: {
        type: String,
        default: 'is-primary'
      },
      native: {
        type: Boolean,
        default: false
      }
    },
    data: function data() {
      return {
        newValue: this.value,
        dragDropFocus: false,
        _elementRef: 'input'
      };
    },
    watch: {
      /**
       *   When v-model is changed:
       *   1. Get value from input file
       *   2. Set internal value.
       *   3. Reset input value if array is empty or when input file is not found in newValue
       *   4. If it's invalid, validate again.
       */
      value: function value(_value) {
        var inputFiles = this.$refs.input.files;
        this.newValue = _value;

        if (!this.newValue || Array.isArray(this.newValue) && this.newValue.length === 0 || !inputFiles[0] || Array.isArray(this.newValue) && !this.newValue.some(function (a) {
          return a.name === inputFiles[0].name;
        })) {
          this.$refs.input.value = null;
        }

        !this.isValid && !this.dragDrop && this.checkHtml5Validity();
      }
    },
    methods: {
      /**
      * Listen change event on input type 'file',
      * emit 'input' event and validate
      */
      onFileChange: function onFileChange(event) {
        if (this.disabled || this.loading) return;

        if (this.dragDrop) {
          this.updateDragDropFocus(false);
        }

        var value = event.target.files || event.dataTransfer.files;

        if (value.length === 0) {
          if (!this.newValue) {
            return;
          }

          if (this.native) {
            this.newValue = null;
          }
        } else if (!this.multiple) {
          // only one element in case drag drop mode and isn't multiple
          if (this.dragDrop && value.length !== 1) return;else {
            var file = value[0];

            if (this.checkType(file)) {
              this.newValue = file;
            } else if (this.newValue) {
              this.newValue = null;
            } else {
              return;
            }
          }
        } else {
          // always new values if native or undefined local
          var newValues = false;

          if (this.native || !this.newValue) {
            this.newValue = [];
            newValues = true;
          }

          for (var i = 0; i < value.length; i++) {
            var _file = value[i];

            if (this.checkType(_file)) {
              this.newValue.push(_file);
              newValues = true;
            }
          }

          if (!newValues) {
            return;
          }
        }

        this.$emit('input', this.newValue);
        !this.dragDrop && this.checkHtml5Validity();
      },

      /**
      * Listen drag-drop to update internal variable
      */
      updateDragDropFocus: function updateDragDropFocus(focus) {
        if (!this.disabled && !this.loading) {
          this.dragDropFocus = focus;
        }
      },

      /**
      * Check mime type of file
      */
      checkType: function checkType(file) {
        if (!this.accept) return true;
        var types = this.accept.split(',');
        if (types.length === 0) return true;
        var valid = false;

        for (var i = 0; i < types.length && !valid; i++) {
          var type = types[i].trim();

          if (type) {
            if (type.substring(0, 1) === '.') {
              // check extension
              var extIndex = file.name.lastIndexOf('.');
              var extension = extIndex >= 0 ? file.name.substring(extIndex) : '';

              if (extension.toLowerCase() === type.toLowerCase()) {
                valid = true;
              }
            } else {
              // check mime type
              if (file.type.match(type)) {
                valid = true;
              }
            }
          }
        }

        return valid;
      }
    }
  };

  /* script */
  const __vue_script__$V = script$V;

  /* template */
  var __vue_render__$P = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('label',{staticClass:"upload control"},[(!_vm.dragDrop)?[_vm._t("default")]:_c('div',{staticClass:"upload-draggable",class:[_vm.type, {
              'is-loading': _vm.loading,
              'is-disabled': _vm.disabled,
              'is-hovered': _vm.dragDropFocus
          }],on:{"dragover":function($event){$event.preventDefault();_vm.updateDragDropFocus(true);},"dragleave":function($event){$event.preventDefault();_vm.updateDragDropFocus(false);},"dragenter":function($event){$event.preventDefault();_vm.updateDragDropFocus(true);},"drop":function($event){$event.preventDefault();_vm.onFileChange($event);}}},[_vm._t("default")],2),_vm._v(" "),_c('input',_vm._b({ref:"input",attrs:{"type":"file","multiple":_vm.multiple,"accept":_vm.accept,"disabled":_vm.disabled},on:{"change":_vm.onFileChange}},'input',_vm.$attrs,false))],2)};
  var __vue_staticRenderFns__$P = [];

    /* style */
    const __vue_inject_styles__$V = undefined;
    /* scoped */
    const __vue_scope_id__$V = undefined;
    /* module identifier */
    const __vue_module_identifier__$V = undefined;
    /* functional template */
    const __vue_is_functional_template__$V = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var Upload = normalizeComponent_1(
      { render: __vue_render__$P, staticRenderFns: __vue_staticRenderFns__$P },
      __vue_inject_styles__$V,
      __vue_script__$V,
      __vue_scope_id__$V,
      __vue_is_functional_template__$V,
      __vue_module_identifier__$V,
      undefined,
      undefined
    );

  var Plugin$z = {
    install: function install(Vue) {
      registerComponent(Vue, Upload);
    }
  };
  use(Plugin$z);



  var components = /*#__PURE__*/Object.freeze({
    Autocomplete: Plugin,
    Button: Plugin$1,
    Checkbox: Plugin$2,
    Clockpicker: Plugin$4,
    Collapse: Plugin$3,
    Datepicker: Plugin$5,
    Datetimepicker: Plugin$6,
    Dialog: Plugin$7,
    Dropdown: Plugin$8,
    Field: Plugin$9,
    Icon: Plugin$a,
    Input: Plugin$b,
    Loading: Plugin$c,
    Menu: Plugin$d,
    Message: Plugin$e,
    Modal: Plugin$f,
    Navbar: Plugin$h,
    Notification: Plugin$g,
    Numberinput: Plugin$i,
    Pagination: Plugin$j,
    Progress: Plugin$k,
    Radio: Plugin$l,
    Rate: Plugin$m,
    Select: Plugin$n,
    Slider: Plugin$o,
    Snackbar: Plugin$p,
    Steps: Plugin$q,
    Switch: Plugin$r,
    Table: Plugin$s,
    Tabs: Plugin$t,
    Tag: Plugin$u,
    Taginput: Plugin$v,
    Timepicker: Plugin$w,
    Toast: Plugin$x,
    Tooltip: Plugin$y,
    Upload: Plugin$z
  });

  var Buefy = {
    install: function install(Vue) {
      var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

      // Options
      setOptions(Object.assign(config$1, options)); // Components


      for (var componentKey in components) {
        Vue.use(components[componentKey]);
      } // Config component


      var BuefyProgrammatic = {
        setOptions: function setOptions$1(options) {
          setOptions(Object.assign(config$1, options));
        }
      };
      registerComponentProgrammatic(Vue, 'config', BuefyProgrammatic);
    }
  };
  use(Buefy);

  exports.Autocomplete = Plugin;
  exports.Button = Plugin$1;
  exports.Checkbox = Plugin$2;
  exports.Clockpicker = Plugin$4;
  exports.Collapse = Plugin$3;
  exports.Datepicker = Plugin$5;
  exports.Datetimepicker = Plugin$6;
  exports.Dialog = Plugin$7;
  exports.DialogProgrammatic = DialogProgrammatic;
  exports.Dropdown = Plugin$8;
  exports.Field = Plugin$9;
  exports.Icon = Plugin$a;
  exports.Input = Plugin$b;
  exports.Loading = Plugin$c;
  exports.LoadingProgrammatic = LoadingProgrammatic;
  exports.Menu = Plugin$d;
  exports.Message = Plugin$e;
  exports.Modal = Plugin$f;
  exports.ModalProgrammatic = ModalProgrammatic;
  exports.Navbar = Plugin$h;
  exports.Notification = Plugin$g;
  exports.NotificationProgrammatic = NotificationProgrammatic;
  exports.Numberinput = Plugin$i;
  exports.Pagination = Plugin$j;
  exports.Progress = Plugin$k;
  exports.Radio = Plugin$l;
  exports.Rate = Plugin$m;
  exports.Select = Plugin$n;
  exports.Slider = Plugin$o;
  exports.Snackbar = Plugin$p;
  exports.SnackbarProgrammatic = SnackbarProgrammatic;
  exports.Steps = Plugin$q;
  exports.Switch = Plugin$r;
  exports.Table = Plugin$s;
  exports.Tabs = Plugin$t;
  exports.Tag = Plugin$u;
  exports.Taginput = Plugin$v;
  exports.Timepicker = Plugin$w;
  exports.Toast = Plugin$x;
  exports.ToastProgrammatic = ToastProgrammatic;
  exports.Tooltip = Plugin$y;
  exports.Upload = Plugin$z;
  exports.default = Buefy;

  Object.defineProperty(exports, '__esModule', { value: true });

}));
