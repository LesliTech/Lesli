/*! Buefy v0.8.20 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = global || self, factory(global.Table = {}));
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

  function _toConsumableArray(arr) {
    return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread();
  }

  function _arrayWithoutHoles(arr) {
    if (Array.isArray(arr)) {
      for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

      return arr2;
    }
  }

  function _arrayWithHoles(arr) {
    if (Array.isArray(arr)) return arr;
  }

  function _iterableToArray(iter) {
    if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter);
  }

  function _nonIterableSpread() {
    throw new TypeError("Invalid attempt to spread non-iterable instance");
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
  function multiColumnSort(inputArray, sortingPriority) {
    // clone it to prevent the any watchers from triggering every sorting iteration
    var array = JSON.parse(JSON.stringify(inputArray));

    var fieldSorter = function fieldSorter(fields) {
      return function (a, b) {
        return fields.map(function (o) {
          var dir = 1;

          if (o[0] === '-') {
            dir = -1;
            o = o.substring(1);
          }

          return a[o] > b[o] ? dir : a[o] < b[o] ? -dir : 0;
        }).reduce(function (p, n) {
          return p || n;
        }, 0);
      };
    };

    return array.sort(fieldSorter(sortingPriority));
  }

  var CheckRadioMixin = {
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

  //
  var script = {
    name: 'BCheckbox',
    mixins: [CheckRadioMixin],
    props: {
      indeterminate: Boolean,
      trueValue: {
        type: [String, Number, Boolean, Function, Object, Array],
        default: true
      },
      falseValue: {
        type: [String, Number, Boolean, Function, Object, Array],
        default: false
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
  var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('label',{ref:"label",staticClass:"b-checkbox checkbox",class:[_vm.size, { 'is-disabled': _vm.disabled }],attrs:{"disabled":_vm.disabled},on:{"click":_vm.focus,"keydown":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key,"Enter")){ return null; }$event.preventDefault();_vm.$refs.label.click();}}},[_c('input',{directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"input",attrs:{"type":"checkbox","disabled":_vm.disabled,"required":_vm.required,"name":_vm.name,"true-value":_vm.trueValue,"false-value":_vm.falseValue},domProps:{"indeterminate":_vm.indeterminate,"value":_vm.nativeValue,"checked":Array.isArray(_vm.computedValue)?_vm._i(_vm.computedValue,_vm.nativeValue)>-1:_vm._q(_vm.computedValue,_vm.trueValue)},on:{"click":function($event){$event.stopPropagation();},"change":function($event){var $$a=_vm.computedValue,$$el=$event.target,$$c=$$el.checked?(_vm.trueValue):(_vm.falseValue);if(Array.isArray($$a)){var $$v=_vm.nativeValue,$$i=_vm._i($$a,$$v);if($$el.checked){$$i<0&&(_vm.computedValue=$$a.concat([$$v]));}else{$$i>-1&&(_vm.computedValue=$$a.slice(0,$$i).concat($$a.slice($$i+1)));}}else{_vm.computedValue=$$c;}}}}),_vm._v(" "),_c('span',{staticClass:"check",class:_vm.type}),_vm._v(" "),_c('span',{staticClass:"control-label"},[_vm._t("default")],2)])};
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
    

    
    var Checkbox = normalizeComponent_1(
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

  //
  var script$3 = {
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
          return config.defaultLinkTags.indexOf(value) >= 0;
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
  const __vue_script__$3 = script$3;

  /* template */
  var __vue_render__$3 = function () {
  var _obj;
  var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c(_vm.tag,_vm._b({tag:"component",staticClass:"pagination-link",class:( _obj = { 'is-current': _vm.page.isCurrent }, _obj[_vm.page.class] = true, _obj ),attrs:{"role":"button","href":_vm.href,"disabled":_vm.isDisabled,"aria-label":_vm.page['aria-label'],"aria-current":_vm.page.isCurrent},on:{"click":function($event){$event.preventDefault();return _vm.page.click($event)}}},'component',_vm.$attrs,false),[_vm._t("default",[_vm._v(_vm._s(_vm.page.number))])],2)};
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
    

    
    var PaginationButton = normalizeComponent_1(
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
    name: 'BPagination',
    components: (_components = {}, _defineProperty(_components, Icon.name, Icon), _defineProperty(_components, PaginationButton.name, PaginationButton), _components),
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
        default: function _default() {
          return config.defaultIconPrev;
        }
      },
      iconNext: {
        type: String,
        default: function _default() {
          return config.defaultIconNext;
        }
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
  const __vue_script__$4 = script$4;

  /* template */
  var __vue_render__$4 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('nav',{staticClass:"pagination",class:_vm.rootClasses},[(_vm.$scopedSlots.previous)?_vm._t("previous",[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],{page:_vm.getPage(_vm.current - 1, {
                  disabled: !_vm.hasPrev,
                  class: 'pagination-previous',
                  'aria-label': _vm.ariaPreviousLabel
          })}):_c('BPaginationButton',{staticClass:"pagination-previous",attrs:{"disabled":!_vm.hasPrev,"page":_vm.getPage(_vm.current - 1)}},[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),(_vm.$scopedSlots.next)?_vm._t("next",[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],{page:_vm.getPage(_vm.current + 1, {
                  disabled: !_vm.hasNext,
                  class: 'pagination-next',
                  'aria-label': _vm.ariaNextLabel
          })}):_c('BPaginationButton',{staticClass:"pagination-next",attrs:{"disabled":!_vm.hasNext,"page":_vm.getPage(_vm.current + 1)}},[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),(_vm.simple)?_c('small',{staticClass:"info"},[(_vm.perPage == 1)?[_vm._v("\r\n                "+_vm._s(_vm.firstItem)+" / "+_vm._s(_vm.total)+"\r\n            ")]:[_vm._v("\r\n                "+_vm._s(_vm.firstItem)+"-"+_vm._s(Math.min(_vm.current * _vm.perPage, _vm.total))+" / "+_vm._s(_vm.total)+"\r\n            ")]],2):_c('ul',{staticClass:"pagination-list"},[(_vm.hasFirst)?_c('li',[(_vm.$scopedSlots.default)?_vm._t("default",null,{page:_vm.getPage(1)}):_c('BPaginationButton',{attrs:{"page":_vm.getPage(1)}})],2):_vm._e(),_vm._v(" "),(_vm.hasFirstEllipsis)?_c('li',[_c('span',{staticClass:"pagination-ellipsis"},[_vm._v("…")])]):_vm._e(),_vm._v(" "),_vm._l((_vm.pagesInRange),function(page){return _c('li',{key:page.number},[(_vm.$scopedSlots.default)?_vm._t("default",null,{page:page}):_c('BPaginationButton',{attrs:{"page":page}})],2)}),_vm._v(" "),(_vm.hasLastEllipsis)?_c('li',[_c('span',{staticClass:"pagination-ellipsis"},[_vm._v("…")])]):_vm._e(),_vm._v(" "),(_vm.hasLast)?_c('li',[(_vm.$scopedSlots.default)?_vm._t("default",null,{page:_vm.getPage(_vm.pageCount)}):_c('BPaginationButton',{attrs:{"page":_vm.getPage(_vm.pageCount)}})],2):_vm._e()],2)],2)};
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
    

    
    var Pagination = normalizeComponent_1(
      { render: __vue_render__$4, staticRenderFns: __vue_staticRenderFns__$4 },
      __vue_inject_styles__$4,
      __vue_script__$4,
      __vue_scope_id__$4,
      __vue_is_functional_template__$4,
      __vue_module_identifier__$4,
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

  var script$5 = {
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
  const __vue_script__$5 = script$5;

  /* template */
  var __vue_render__$5 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:{ 'is-expanded': _vm.expanded, 'has-icons-left': _vm.icon }},[_c('span',{staticClass:"select",class:_vm.spanClasses},[_c('select',_vm._b({directives:[{name:"model",rawName:"v-model",value:(_vm.computedValue),expression:"computedValue"}],ref:"select",attrs:{"multiple":_vm.multiple,"size":_vm.nativeSize},on:{"blur":function($event){_vm.$emit('blur', $event) && _vm.checkHtml5Validity();},"focus":function($event){_vm.$emit('focus', $event);},"change":function($event){var $$selectedVal = Array.prototype.filter.call($event.target.options,function(o){return o.selected}).map(function(o){var val = "_value" in o ? o._value : o.value;return val}); _vm.computedValue=$event.target.multiple ? $$selectedVal : $$selectedVal[0];}}},'select',_vm.$attrs,false),[(_vm.placeholder)?[(_vm.computedValue == null)?_c('option',{attrs:{"disabled":"","hidden":""},domProps:{"value":null}},[_vm._v("\r\n                        "+_vm._s(_vm.placeholder)+"\r\n                    ")]):_vm._e()]:_vm._e(),_vm._v(" "),_vm._t("default")],2)]),_vm._v(" "),(_vm.icon)?_c('b-icon',{staticClass:"is-left",attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":_vm.iconSize}}):_vm._e()],1)};
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
    

    
    var Select = normalizeComponent_1(
      { render: __vue_render__$5, staticRenderFns: __vue_staticRenderFns__$5 },
      __vue_inject_styles__$5,
      __vue_script__$5,
      __vue_scope_id__$5,
      __vue_is_functional_template__$5,
      __vue_module_identifier__$5,
      undefined,
      undefined
    );

  var _components$1;
  var script$6 = {
    name: 'BTableMobileSort',
    components: (_components$1 = {}, _defineProperty(_components$1, Select.name, Select), _defineProperty(_components$1, Icon.name, Icon), _components$1),
    props: {
      currentSortColumn: Object,
      sortMultipleData: Array,
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
      },
      sortMultiple: {
        type: Boolean,
        default: false
      }
    },
    data: function data() {
      return {
        sortMultipleSelect: '',
        mobileSort: this.currentSortColumn,
        defaultEvent: {
          shiftKey: true,
          altKey: true,
          ctrlKey: true
        },
        ignoreSort: false
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
      sortMultipleSelect: function sortMultipleSelect(column) {
        if (this.ignoreSort) {
          this.ignoreSort = false;
        } else {
          this.$emit('sort', column, this.defaultEvent);
        }
      },
      mobileSort: function mobileSort(column) {
        if (this.currentSortColumn === column) return;
        this.$emit('sort', column, this.defaultEvent);
      },
      currentSortColumn: function currentSortColumn(column) {
        this.mobileSort = column;
      }
    },
    methods: {
      removePriority: function removePriority() {
        var _this2 = this;

        this.$emit('removePriority', this.sortMultipleSelect); // ignore the watcher to sort when we just change whats displayed in the select
        // otherwise the direction will be flipped
        // The sort event is already triggered by the emit

        this.ignoreSort = true; // Select one of the other options when we reset one

        var remainingFields = this.sortMultipleData.filter(function (data) {
          return data.field !== _this2.sortMultipleSelect.field;
        }).map(function (data) {
          return data.field;
        });
        this.sortMultipleSelect = this.columns.filter(function (column) {
          return remainingFields.includes(column.field);
        })[0];
      },
      getSortingObjectOfColumn: function getSortingObjectOfColumn(column) {
        return this.sortMultipleData.filter(function (i) {
          return i.field === column.field;
        })[0];
      },
      columnIsDesc: function columnIsDesc(column) {
        var sortingObject = this.getSortingObjectOfColumn(column);

        if (sortingObject) {
          return !!(sortingObject.order && sortingObject.order === 'desc');
        }

        return true;
      },
      getLabel: function getLabel(column) {
        var sortingObject = this.getSortingObjectOfColumn(column);

        if (sortingObject) {
          return column.label + '(' + (this.sortMultipleData.indexOf(sortingObject) + 1) + ')';
        }

        return column.label;
      },
      sort: function sort() {
        this.$emit('sort', this.sortMultiple ? this.sortMultipleSelect : this.mobileSort, this.defaultEvent);
      }
    }
  };

  /* script */
  const __vue_script__$6 = script$6;

  /* template */
  var __vue_render__$6 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"field table-mobile-sort"},[_c('div',{staticClass:"field has-addons"},[(_vm.sortMultiple)?_c('b-select',{attrs:{"expanded":""},model:{value:(_vm.sortMultipleSelect),callback:function ($$v) {_vm.sortMultipleSelect=$$v;},expression:"sortMultipleSelect"}},_vm._l((_vm.columns),function(column,index){return (column.sortable)?_c('option',{key:index,domProps:{"value":column}},[_vm._v("\r\n                    "+_vm._s(_vm.getLabel(column))+"\r\n                    "),(_vm.getSortingObjectOfColumn(column))?[(_vm.columnIsDesc(column))?[_vm._v("\r\n                            ↓\r\n                        ")]:[_vm._v("\r\n                            ↑\r\n                        ")]]:_vm._e()],2):_vm._e()})):_c('b-select',{attrs:{"expanded":""},model:{value:(_vm.mobileSort),callback:function ($$v) {_vm.mobileSort=$$v;},expression:"mobileSort"}},[(_vm.placeholder)?[_c('option',{directives:[{name:"show",rawName:"v-show",value:(_vm.showPlaceholder),expression:"showPlaceholder"}],attrs:{"selected":"","disabled":"","hidden":""},domProps:{"value":{}}},[_vm._v("\r\n                        "+_vm._s(_vm.placeholder)+"\r\n                    ")])]:_vm._e(),_vm._v(" "),_vm._l((_vm.columns),function(column,index){return (column.sortable)?_c('option',{key:index,domProps:{"value":column}},[_vm._v("\r\n                    "+_vm._s(column.label)+"\r\n                ")]):_vm._e()})],2),_vm._v(" "),_c('div',{staticClass:"control"},[(_vm.sortMultiple && _vm.sortMultipleData.length > 0)?[_c('button',{staticClass:"button is-primary",on:{"click":_vm.sort}},[_c('b-icon',{class:{ 'is-desc': _vm.columnIsDesc(_vm.sortMultipleSelect) },attrs:{"icon":_vm.sortIcon,"pack":_vm.iconPack,"size":_vm.sortIconSize,"both":""}})],1),_vm._v(" "),_c('button',{staticClass:"button is-primary",on:{"click":_vm.removePriority}},[_c('b-icon',{attrs:{"icon":"delete","size":_vm.sortIconSize,"both":""}})],1)]:(!_vm.sortMultiple)?_c('button',{staticClass:"button is-primary",on:{"click":_vm.sort}},[_c('b-icon',{directives:[{name:"show",rawName:"v-show",value:(_vm.currentSortColumn === _vm.mobileSort),expression:"currentSortColumn === mobileSort"}],class:{ 'is-desc': !_vm.isAsc },attrs:{"icon":_vm.sortIcon,"pack":_vm.iconPack,"size":_vm.sortIconSize,"both":""}})],1):_vm._e()],2)],1)])};
  var __vue_staticRenderFns__$6 = [];

    /* style */
    const __vue_inject_styles__$6 = undefined;
    /* scoped */
    const __vue_scope_id__$6 = undefined;
    /* module identifier */
    const __vue_module_identifier__$6 = undefined;
    /* functional template */
    const __vue_is_functional_template__$6 = false;
    /* style inject */
    
    /* style inject SSR */
    

    
    var TableMobileSort = normalizeComponent_1(
      { render: __vue_render__$6, staticRenderFns: __vue_staticRenderFns__$6 },
      __vue_inject_styles__$6,
      __vue_script__$6,
      __vue_scope_id__$6,
      __vue_is_functional_template__$6,
      __vue_module_identifier__$6,
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
  var script$7 = {
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
      subheading: [String, Number],
      customSort: Function,
      sticky: Boolean,
      headerSelectable: {
        type: Boolean,
        default: true
      },
      headerClass: String,
      cellClass: String,
      internal: Boolean // Used internally by Table

    },
    data: function data() {
      return {
        newKey: this.customKey || this.label,
        _isTableColumn: true
      };
    },
    computed: {
      rootClasses: function rootClasses() {
        return [this.cellClass, {
          'has-text-right': this.numeric && !this.centered,
          'has-text-centered': this.centered,
          'is-sticky': this.sticky
        }];
      }
    },
    beforeMount: function beforeMount() {
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
    },
    beforeDestroy: function beforeDestroy() {
      if (!this.$parent.visibleData.length) return;
      if (this.$parent.newColumns.length !== 1) return;

      if (this.$parent.newColumns.length) {
        var index = this.$parent.newColumns.map(function (column) {
          return column.newKey;
        }).indexOf(this.newKey);

        if (index >= 0) {
          this.$parent.newColumns.splice(index, 1);
        }
      }
    }
  };

  /* script */
  const __vue_script__$7 = script$7;

  /* template */
  var __vue_render__$7 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (_vm.visible)?_c('td',{class:_vm.rootClasses,attrs:{"data-label":_vm.label}},[_vm._t("default")],2):_vm._e()};
  var __vue_staticRenderFns__$7 = [];

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
    

    
    var TableColumn = normalizeComponent_1(
      { render: __vue_render__$7, staticRenderFns: __vue_staticRenderFns__$7 },
      __vue_inject_styles__$7,
      __vue_script__$7,
      __vue_scope_id__$7,
      __vue_is_functional_template__$7,
      __vue_module_identifier__$7,
      undefined,
      undefined
    );

  var _components$2;
  var script$8 = {
    name: 'BTable',
    components: (_components$2 = {}, _defineProperty(_components$2, Checkbox.name, Checkbox), _defineProperty(_components$2, Icon.name, Icon), _defineProperty(_components$2, Input.name, Input), _defineProperty(_components$2, Pagination.name, Pagination), _defineProperty(_components$2, SlotComponent.name, SlotComponent), _defineProperty(_components$2, TableMobileSort.name, TableMobileSort), _defineProperty(_components$2, TableColumn.name, TableColumn), _components$2),
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
      isRowSelectable: {
        type: Function,
        default: function _default() {
          return true;
        }
      },
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
      sortMultiple: {
        type: Boolean,
        default: false
      },
      sortMultipleData: {
        type: Array,
        default: function _default() {
          return [];
        }
      },
      sortMultipleKey: {
        type: String,
        default: null
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
      backendFiltering: Boolean,
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
        default: false
      },
      scrollable: Boolean,
      ariaNextLabel: String,
      ariaPreviousLabel: String,
      ariaPageLabel: String,
      ariaCurrentLabel: String,
      stickyHeader: Boolean,
      height: [Number, String],
      filtersEvent: {
        type: String,
        default: ''
      },
      cardLayout: Boolean
    },
    data: function data() {
      return {
        sortMultipleDataLocal: [],
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
      sortMultipleDataComputed: function sortMultipleDataComputed() {
        return this.backendSorting ? this.sortMultipleData : this.sortMultipleDataLocal;
      },
      tableClasses: function tableClasses() {
        return {
          'is-bordered': this.bordered,
          'is-striped': this.striped,
          'is-narrow': this.narrowed,
          'is-hoverable': (this.hoverable || this.focusable) && this.visibleData.length
        };
      },
      tableWrapperClasses: function tableWrapperClasses() {
        return {
          'has-mobile-cards': this.mobileCards,
          'has-sticky-header': this.stickyHeader,
          'is-card-list': this.cardLayout,
          'table-container': this.isScrollable
        };
      },
      rooClasses: function rooClasses() {
        return {
          'is-loading': this.loading
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
      * Check if has any column using subheading.
      */
      hasCustomSubheadings: function hasCustomSubheadings() {
        if (this.$scopedSlots && this.$scopedSlots.subheading) return true;
        return this.newColumns.some(function (column) {
          return column.subheading || column.$scopedSlots && column.$scopedSlots.subheading;
        });
      },

      /**
      * Return total column count based if it's checkable or expanded
      */
      columnCount: function columnCount() {
        var count = this.newColumns.length;
        count += this.checkable ? 1 : 0;
        count += this.detailed && this.showDetailIcon ? 1 : 0;
        return count;
      },

      /**
      * return if detailed row tabled
      * will be with chevron column & icon or not
      */
      showDetailRowIcon: function showDetailRowIcon() {
        return this.detailed && this.showDetailIcon;
      },

      /**
      * return if scrollable table
      */
      isScrollable: function isScrollable() {
        if (this.scrollable) return true;
        if (!this.newColumns) return false;
        return this.newColumns.some(function (column) {
          return column.sticky;
        });
      }
    },
    watch: {
      /**
      * When data prop change:
      *   1. Update internal value.
      *   2. Filter data if it's not backend-filtered.
      *   3. Sort again if it's not backend-sorted.
      *   4. Set new total if it's not backend-paginated.
      */
      data: function data(value) {
        var _this3 = this;

        this.newData = value;

        if (!this.backendFiltering) {
          this.newData = value.filter(function (row) {
            return _this3.isRowFiltered(row);
          });
        }

        if (!this.backendSorting) {
          this.sort(this.currentSortColumn, true);
        }

        if (!this.backendPagination) {
          this.newDataTotal = this.newData.length;
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

          if (this.backendFiltering) {
            this.$emit('filters-change', value);
          } else {
            this.newData = this.data.filter(function (row) {
              return _this4.isRowFiltered(row);
            });

            if (!this.backendPagination) {
              this.newDataTotal = this.newData.length;
            }

            if (!this.backendSorting) {
              if (this.sortMultiple && this.sortMultipleDataLocal && this.sortMultipleDataLocal.length > 0) {
                this.doSortMultiColumn();
              } else if (Object.keys(this.currentSortColumn).length > 0) {
                this.doSortSingleColumn(this.currentSortColumn);
              }
            }
          }
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
      onFiltersEvent: function onFiltersEvent(event) {
        this.$emit("filters-event-".concat(this.filtersEvent), {
          event: event,
          filters: this.filters
        });
      },
      findIndexOfSortData: function findIndexOfSortData(column) {
        var sortObj = this.sortMultipleDataComputed.filter(function (i) {
          return i.field === column.field;
        })[0];
        return this.sortMultipleDataComputed.indexOf(sortObj) + 1;
      },
      removeSortingPriority: function removeSortingPriority(column) {
        if (this.backendSorting) {
          this.$emit('sorting-priority-removed', column.field);
        } else {
          this.sortMultipleDataLocal = this.sortMultipleDataLocal.filter(function (priority) {
            return priority.field !== column.field;
          });
          var formattedSortingPriority = this.sortMultipleDataLocal.map(function (i) {
            return (i.order && i.order === 'desc' ? '-' : '') + i.field;
          });
          this.newData = multiColumnSort(this.newData, formattedSortingPriority);
        }
      },
      resetMultiSorting: function resetMultiSorting() {
        this.sortMultipleDataLocal = [];
        this.currentSortColumn = {};
        this.newData = this.data;
      },

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
      sortMultiColumn: function sortMultiColumn(column) {
        this.currentSortColumn = {};

        if (!this.backendSorting) {
          var existingPriority = this.sortMultipleDataLocal.filter(function (i) {
            return i.field === column.field;
          })[0];

          if (existingPriority) {
            existingPriority.order = existingPriority.order === 'desc' ? 'asc' : 'desc';
          } else {
            this.sortMultipleDataLocal.push({
              field: column.field,
              order: column.isAsc
            });
          }

          this.doSortMultiColumn();
        }
      },
      doSortMultiColumn: function doSortMultiColumn() {
        var formattedSortingPriority = this.sortMultipleDataLocal.map(function (i) {
          return (i.order && i.order === 'desc' ? '-' : '') + i.field;
        });
        this.newData = multiColumnSort(this.newData, formattedSortingPriority);
      },

      /**
      * Sort the column.
      * Toggle current direction on column if it's sortable
      * and not just updating the prop.
      */
      sort: function sort(column) {
        var updatingData = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
        var event = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;

        if ( // if backend sorting is enabled, just emit the sort press like usual
        // if the correct key combination isnt pressed, sort like usual
        !this.backendSorting && this.sortMultiple && (this.sortMultipleKey && event[this.sortMultipleKey] || !this.sortMultipleKey)) {
          this.sortMultiColumn(column);
        } else {
          if (!column || !column.sortable) return; // sort multiple is enabled but the correct key combination isnt pressed so reset

          if (this.sortMultiple) {
            this.sortMultipleDataLocal = [];
          }

          if (!updatingData) {
            this.isAsc = column === this.currentSortColumn ? !this.isAsc : this.defaultSortDirection.toLowerCase() !== 'desc';
          }

          if (!this.firstTimeSort) {
            this.$emit('sort', column.field, this.isAsc ? 'asc' : 'desc', event);
          }

          if (!this.backendSorting) {
            this.doSortSingleColumn(column);
          }

          this.currentSortColumn = column;
        }
      },
      doSortSingleColumn: function doSortSingleColumn(column) {
        this.newData = this.sortBy(this.newData, column.field, column.customSort, this.isAsc);
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
          if (_this5.isRowCheckable(currentRow)) {
            _this5.removeCheckedRow(currentRow);
          }

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
        if (!this.isRowCheckable(row)) return;
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
        if (this.selected === row) return;
        if (!this.isRowSelectable(row)) return; // Emit new and old row

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

          var value = this.getValueByPath(row, key);
          if (value == null) return false;

          if (Number.isInteger(value)) {
            if (value !== Number(this.filters[key])) return false;
          } else {
            var re = new RegExp(this.filters[key], 'i');
            if (typeof value === 'boolean') value = "".concat(value);
            if (!value.match(re)) return false;
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
        return !key.length || !index ? index : index[key];
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
          if (Object.keys(this.currentSortColumn).length > 0) {
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
        var row = this.visibleData[index];

        if (!this.isRowSelectable(row)) {
          var newIndex = null;

          if (pos > 0) {
            for (var i = index; i < this.visibleData.length && newIndex === null; i++) {
              if (this.isRowSelectable(this.visibleData[i])) newIndex = i;
            }
          } else {
            for (var _i = index; _i >= 0 && newIndex === null; _i--) {
              if (this.isRowSelectable(this.visibleData[_i])) newIndex = _i;
            }
          }

          if (newIndex >= 0) {
            this.selectRow(this.visibleData[newIndex]);
          }
        } else {
          this.selectRow(row);
        }
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

        if (!this.backendSorting) {
          if (this.sortMultiple && this.sortMultipleData) {
            this.sortMultipleData.forEach(function (column) {
              _this7.sortMultiColumn(column);
            });
          } else {
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

            var sortColumn = this.newColumns.filter(function (column) {
              return column.field === sortField;
            })[0];

            if (sortColumn) {
              this.isAsc = sortDirection.toLowerCase() !== 'desc';
              this.sort(sortColumn, true);
            }
          }
        }
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
    },
    beforeDestroy: function beforeDestroy() {
      this.newData = [];
      this.newColumns = [];
    }
  };

  /* script */
  const __vue_script__$8 = script$8;

  /* template */
  var __vue_render__$8 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-table",class:_vm.rooClasses},[(_vm.mobileCards && _vm.hasSortablenewColumns)?_c('b-table-mobile-sort',{attrs:{"current-sort-column":_vm.currentSortColumn,"sort-multiple":_vm.sortMultiple,"sort-multiple-data":_vm.sortMultipleDataComputed,"is-asc":_vm.isAsc,"columns":_vm.newColumns,"placeholder":_vm.mobileSortPlaceholder,"icon-pack":_vm.iconPack,"sort-icon":_vm.sortIcon,"sort-icon-size":_vm.sortIconSize},on:{"sort":function (column, event) { return _vm.sort(column, null, event); },"removePriority":function (column) { return _vm.removeSortingPriority(column); }}}):_vm._e(),_vm._v(" "),(_vm.paginated && (_vm.paginationPosition === 'top' || _vm.paginationPosition === 'both'))?_c('div',{staticClass:"top level"},[_c('div',{staticClass:"level-left"},[_vm._t("top-left")],2),_vm._v(" "),_c('div',{staticClass:"level-right"},[(_vm.paginated)?_c('div',{staticClass:"level-item"},[_c('b-pagination',{attrs:{"icon-pack":_vm.iconPack,"total":_vm.newDataTotal,"per-page":_vm.perPage,"simple":_vm.paginationSimple,"size":_vm.paginationSize,"current":_vm.newCurrentPage,"aria-next-label":_vm.ariaNextLabel,"aria-previous-label":_vm.ariaPreviousLabel,"aria-page-label":_vm.ariaPageLabel,"aria-current-label":_vm.ariaCurrentLabel},on:{"change":_vm.pageChanged}})],1):_vm._e()])]):_vm._e(),_vm._v(" "),_c('div',{staticClass:"table-wrapper",class:_vm.tableWrapperClasses,style:({
                  height: _vm.height === undefined ? null :
                  (isNaN(_vm.height) ? _vm.height : _vm.height + 'px')
              })},[_c('table',{staticClass:"table",class:_vm.tableClasses,attrs:{"tabindex":!_vm.focusable ? false : 0},on:{"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"up",38,$event.key,["Up","ArrowUp"])){ return null; }if($event.target !== $event.currentTarget){ return null; }$event.preventDefault();_vm.pressedArrow(-1);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"down",40,$event.key,["Down","ArrowDown"])){ return null; }if($event.target !== $event.currentTarget){ return null; }$event.preventDefault();_vm.pressedArrow(1);}]}},[(_vm.newColumns.length)?_c('thead',[_c('tr',[(_vm.showDetailRowIcon)?_c('th',{attrs:{"width":"40px"}}):_vm._e(),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'left')?_c('th',{staticClass:"checkbox-cell"},[(_vm.headerCheckable)?[_c('b-checkbox',{attrs:{"value":_vm.isAllChecked,"disabled":_vm.isAllUncheckable},nativeOn:{"change":function($event){return _vm.checkAll($event)}}})]:_vm._e()],2):_vm._e(),_vm._v(" "),_vm._l((_vm.visibleColumns),function(column,index){return _c('th',{key:index,class:[column.headerClass, {
                                  'is-current-sort': !_vm.sortMultiple && _vm.currentSortColumn === column,
                                  'is-sortable': column.sortable,
                                  'is-sticky': column.sticky,
                                  'is-unselectable': !column.headerSelectable
                              }],style:({
                                  width: column.width === undefined ? null :
                                  (isNaN(column.width) ? column.width : column.width + 'px')
                              }),on:{"click":function($event){$event.stopPropagation();_vm.sort(column, null, $event);}}},[_c('div',{staticClass:"th-wrap",class:{
                                      'is-numeric': column.numeric,
                                      'is-centered': column.centered
                              }},[(column.$scopedSlots && column.$scopedSlots.header)?[_c('b-slot-component',{attrs:{"component":column,"scoped":true,"name":"header","tag":"span","props":{ column: column, index: index }}})]:(_vm.$scopedSlots.header)?[_vm._t("header",null,{column:column,index:index})]:[_vm._v(_vm._s(column.label))],_vm._v(" "),(_vm.sortMultiple &&
                                          _vm.sortMultipleDataComputed &&
                                          _vm.sortMultipleDataComputed.length > 0 &&
                                          _vm.sortMultipleDataComputed.filter(function (i) { return i.field === column.field; }).length > 0)?[_c('b-icon',{class:{
                                              'is-desc': _vm.sortMultipleDataComputed.filter(function (i) { return i.field === column.field; })[0].order === 'desc'
                                          },attrs:{"icon":_vm.sortIcon,"pack":_vm.iconPack,"both":"","size":_vm.sortIconSize}}),_vm._v("\r\n                                    "+_vm._s(_vm.findIndexOfSortData(column))+"\r\n                                    "),_c('button',{staticClass:"delete is-small multi-sort-cancel-icon",attrs:{"type":"button"},on:{"click":function($event){$event.stopPropagation();_vm.removeSortingPriority(column);}}})]:(column.sortable && !_vm.sortMultiple)?_c('b-icon',{class:{
                                          'is-desc': !_vm.isAsc,
                                          'is-invisible': _vm.currentSortColumn !== column
                                      },attrs:{"icon":_vm.sortIcon,"pack":_vm.iconPack,"both":"","size":_vm.sortIconSize}}):_vm._e()],2)])}),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'right')?_c('th',{staticClass:"checkbox-cell"},[(_vm.headerCheckable)?[_c('b-checkbox',{attrs:{"value":_vm.isAllChecked,"disabled":_vm.isAllUncheckable},nativeOn:{"change":function($event){return _vm.checkAll($event)}}})]:_vm._e()],2):_vm._e()],2),_vm._v(" "),(_vm.hasCustomSubheadings)?_c('tr',{staticClass:"is-subheading"},[(_vm.showDetailRowIcon)?_c('th',{attrs:{"width":"40px"}}):_vm._e(),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'left')?_c('th'):_vm._e(),_vm._v(" "),_vm._l((_vm.visibleColumns),function(column,index){return _c('th',{key:index,style:({
                                  width: column.width === undefined ? null
                              : (isNaN(column.width) ? column.width : column.width + 'px') })},[_c('div',{staticClass:"th-wrap",class:{
                                      'is-numeric': column.numeric,
                                      'is-centered': column.centered
                              }},[(column.$scopedSlots && column.$scopedSlots.subheading)?[_c('b-slot-component',{attrs:{"component":column,"scoped":true,"name":"subheading","tag":"span","props":{ column: column, index: index }}})]:(_vm.$scopedSlots.subheading)?[_vm._t("subheading",null,{column:column,index:index})]:[_vm._v(_vm._s(column.subheading))]],2)])}),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'right')?_c('th'):_vm._e()],2):_vm._e(),_vm._v(" "),(_vm.hasSearchablenewColumns)?_c('tr',[(_vm.showDetailRowIcon)?_c('th',{attrs:{"width":"40px"}}):_vm._e(),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'left')?_c('th'):_vm._e(),_vm._v(" "),_vm._l((_vm.visibleColumns),function(column,index){return _c('th',{key:index,style:({
                                  width: column.width === undefined ? null
                              : (isNaN(column.width) ? column.width : column.width + 'px') })},[_c('div',{staticClass:"th-wrap"},[(column.searchable)?[(column.$scopedSlots
                                          && column.$scopedSlots.searchable)?[_c('b-slot-component',{attrs:{"component":column,"scoped":true,"name":"searchable","tag":"span","props":{ column: column, filters: _vm.filters }}})]:_c('b-input',{attrs:{"type":column.numeric ? 'number' : 'text'},nativeOn:{"[filtersEvent]":function($event){return _vm.onFiltersEvent($event)}},model:{value:(_vm.filters[column.field]),callback:function ($$v) {_vm.$set(_vm.filters, column.field, $$v);},expression:"filters[column.field]"}})]:_vm._e()],2)])}),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'right')?_c('th'):_vm._e()],2):_vm._e()]):_vm._e(),_vm._v(" "),(_vm.visibleData.length)?_c('tbody',[_vm._l((_vm.visibleData),function(row,index){return [_c('tr',{key:_vm.customRowKey ? row[_vm.customRowKey] : index,class:[_vm.rowClass(row, index), {
                                  'is-selected': row === _vm.selected,
                                  'is-checked': _vm.isRowChecked(row),
                              }],attrs:{"draggable":_vm.draggable},on:{"click":function($event){_vm.selectRow(row);},"dblclick":function($event){_vm.$emit('dblclick', row);},"mouseenter":function($event){_vm.$listeners.mouseenter ? _vm.$emit('mouseenter', row) : null;},"mouseleave":function($event){_vm.$listeners.mouseleave ? _vm.$emit('mouseleave', row) : null;},"contextmenu":function($event){_vm.$emit('contextmenu', row, $event);},"dragstart":function($event){_vm.handleDragStart($event, row, index);},"dragend":function($event){_vm.handleDragEnd($event, row, index);},"drop":function($event){_vm.handleDrop($event, row, index);},"dragover":function($event){_vm.handleDragOver($event, row, index);},"dragleave":function($event){_vm.handleDragLeave($event, row, index);}}},[(_vm.showDetailRowIcon)?_c('td',{staticClass:"chevron-cell"},[(_vm.hasDetailedVisible(row))?_c('a',{attrs:{"role":"button"},on:{"click":function($event){$event.stopPropagation();_vm.toggleDetails(row);}}},[_c('b-icon',{class:{'is-expanded': _vm.isVisibleDetailRow(row)},attrs:{"icon":"chevron-right","pack":_vm.iconPack,"both":""}})],1):_vm._e()]):_vm._e(),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'left')?_c('td',{staticClass:"checkbox-cell"},[_c('b-checkbox',{attrs:{"disabled":!_vm.isRowCheckable(row),"value":_vm.isRowChecked(row)},nativeOn:{"click":function($event){$event.preventDefault();$event.stopPropagation();_vm.checkRow(row, index, $event);}}})],1):_vm._e(),_vm._v(" "),(_vm.$scopedSlots.default)?_vm._t("default",null,{row:row,index:index}):_vm._l((_vm.newColumns),function(column){return _c('BTableColumn',_vm._b({key:column.customKey || column.label,attrs:{"internal":""}},'BTableColumn',column,false),[(column.renderHtml)?_c('span',{domProps:{"innerHTML":_vm._s(_vm.getValueByPath(row, column.field))}}):[_vm._v("\r\n                                        "+_vm._s(_vm.getValueByPath(row, column.field))+"\r\n                                    ")]],2)}),_vm._v(" "),(_vm.checkable && _vm.checkboxPosition === 'right')?_c('td',{staticClass:"checkbox-cell"},[_c('b-checkbox',{attrs:{"disabled":!_vm.isRowCheckable(row),"value":_vm.isRowChecked(row)},nativeOn:{"click":function($event){$event.preventDefault();$event.stopPropagation();_vm.checkRow(row, index, $event);}}})],1):_vm._e()],2),_vm._v(" "),(_vm.isActiveDetailRow(row))?_c('tr',{staticClass:"detail"},[_c('td',{attrs:{"colspan":_vm.columnCount}},[_c('div',{staticClass:"detail-container"},[_vm._t("detail",null,{row:row,index:index})],2)])]):_vm._e(),_vm._v(" "),(_vm.isActiveCustomDetailRow(row))?_vm._t("detail",null,{row:row,index:index}):_vm._e()]})],2):_c('tbody',[_c('tr',{staticClass:"is-empty"},[_c('td',{attrs:{"colspan":_vm.columnCount}},[_vm._t("empty")],2)])]),_vm._v(" "),(_vm.$slots.footer !== undefined)?_c('tfoot',[_c('tr',{staticClass:"table-footer"},[(_vm.hasCustomFooterSlot())?_vm._t("footer"):_c('th',{attrs:{"colspan":_vm.columnCount}},[_vm._t("footer")],2)],2)]):_vm._e()])]),_vm._v(" "),((_vm.checkable && _vm.hasBottomLeftSlot()) ||
              (_vm.paginated && (_vm.paginationPosition === 'bottom' || _vm.paginationPosition === 'both')))?_c('div',{staticClass:"level"},[_c('div',{staticClass:"level-left"},[_vm._t("bottom-left")],2),_vm._v(" "),_c('div',{staticClass:"level-right"},[(_vm.paginated)?_c('div',{staticClass:"level-item"},[_c('b-pagination',{attrs:{"icon-pack":_vm.iconPack,"total":_vm.newDataTotal,"per-page":_vm.perPage,"simple":_vm.paginationSimple,"size":_vm.paginationSize,"current":_vm.newCurrentPage,"aria-next-label":_vm.ariaNextLabel,"aria-previous-label":_vm.ariaPreviousLabel,"aria-page-label":_vm.ariaPageLabel,"aria-current-label":_vm.ariaCurrentLabel},on:{"change":_vm.pageChanged}})],1):_vm._e()])]):_vm._e()],1)};
  var __vue_staticRenderFns__$8 = [];

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
    

    
    var Table = normalizeComponent_1(
      { render: __vue_render__$8, staticRenderFns: __vue_staticRenderFns__$8 },
      __vue_inject_styles__$8,
      __vue_script__$8,
      __vue_scope_id__$8,
      __vue_is_functional_template__$8,
      __vue_module_identifier__$8,
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
      registerComponent(Vue, Table);
      registerComponent(Vue, TableColumn);
    }
  };
  use(Plugin);

  exports.BTable = Table;
  exports.BTableColumn = TableColumn;
  exports.default = Plugin;

  Object.defineProperty(exports, '__esModule', { value: true });

}));
