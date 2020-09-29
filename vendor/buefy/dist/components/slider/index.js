/*! Buefy v0.8.20 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = global || self, factory(global.Slider = {}));
}(this, function (exports) { 'use strict';

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

  //
  var script = {
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
        return this.type || config.defaultTooltipType;
      },
      newAnimated: function newAnimated() {
        return this.animated || config.defaultTooltipAnimated;
      },
      newDelay: function newDelay() {
        return this.delay || config.defaultTooltipDelay;
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
  var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{class:[_vm.newType, _vm.position, _vm.size, {
              'b-tooltip': _vm.active,
              'is-square': _vm.square,
              'is-animated': _vm.newAnimated,
              'is-always': _vm.always,
              'is-multiline': _vm.multilined,
              'is-dashed': _vm.dashed
          }],style:({'transition-delay': (_vm.newDelay + "ms")}),attrs:{"data-label":_vm.label}},[_vm._t("default")],2)};
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
    

    
    var Tooltip = normalizeComponent_1(
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

          var diff = (event.clientX - this.startX) / this.$parent.sliderSize() * 100;
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
  const __vue_script__$1 = script$1;

  /* template */
  var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-slider-thumb-wrapper",class:{ 'is-dragging': _vm.dragging },style:(_vm.wrapperStyle)},[_c('b-tooltip',{attrs:{"label":_vm.tooltipLabel,"type":_vm.type,"always":_vm.dragging || _vm.isFocused,"active":!_vm.disabled && _vm.tooltip}},[_c('div',_vm._b({staticClass:"b-slider-thumb",attrs:{"tabindex":_vm.disabled ? false : 0},on:{"mousedown":_vm.onButtonDown,"touchstart":_vm.onButtonDown,"focus":_vm.onFocus,"blur":_vm.onBlur,"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"left",37,$event.key,["Left","ArrowLeft"])){ return null; }if('button' in $event && $event.button !== 0){ return null; }$event.preventDefault();return _vm.onLeftKeyDown($event)},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"right",39,$event.key,["Right","ArrowRight"])){ return null; }if('button' in $event && $event.button !== 2){ return null; }$event.preventDefault();return _vm.onRightKeyDown($event)},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"down",40,$event.key,["Down","ArrowDown"])){ return null; }$event.preventDefault();return _vm.onLeftKeyDown($event)},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"up",38,$event.key,["Up","ArrowUp"])){ return null; }$event.preventDefault();return _vm.onRightKeyDown($event)},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"home",undefined,$event.key,undefined)){ return null; }$event.preventDefault();return _vm.onHomeKeyDown($event)},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"end",undefined,$event.key,undefined)){ return null; }$event.preventDefault();return _vm.onEndKeyDown($event)}]}},'div',_vm.$attrs,false))])],1)};
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
    

    
    var SliderThumb = normalizeComponent_1(
      { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
      __vue_inject_styles__$1,
      __vue_script__$1,
      __vue_scope_id__$1,
      __vue_is_functional_template__$1,
      __vue_module_identifier__$1,
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
  var script$2 = {
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
  const __vue_script__$2 = script$2;

  /* template */
  var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-slider-tick",class:{ 'is-tick-hidden': _vm.hidden },style:(_vm.getTickStyle(_vm.position))},[(_vm.$slots.default)?_c('span',{staticClass:"b-slider-tick-label"},[_vm._t("default")],2):_vm._e()])};
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
    

    
    var SliderTick = normalizeComponent_1(
      { render: __vue_render__$2, staticRenderFns: __vue_staticRenderFns__$2 },
      __vue_inject_styles__$2,
      __vue_script__$2,
      __vue_scope_id__$2,
      __vue_is_functional_template__$2,
      __vue_module_identifier__$2,
      undefined,
      undefined
    );

  var _components;
  var script$3 = {
    name: 'BSlider',
    components: (_components = {}, _defineProperty(_components, SliderThumb.name, SliderThumb), _defineProperty(_components, SliderTick.name, SliderTick), _components),
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
      ariaLabel: [String, Array],
      biggerSliderFocus: {
        type: Boolean,
        default: false
      }
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
      rootClasses: function rootClasses() {
        return {
          'is-rounded': this.rounded,
          'is-dragging': this.dragging,
          'is-disabled': this.disabled,
          'slider-focus': this.biggerSliderFocus
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
      sliderSize: function sliderSize() {
        return this.$refs.slider.getBoundingClientRect().width;
      },
      onSliderClick: function onSliderClick(event) {
        if (this.disabled || this.isTrackClickDisabled) return;
        var sliderOffsetLeft = this.$refs.slider.getBoundingClientRect().left;
        var percent = (event.clientX - sliderOffsetLeft) / this.sliderSize() * 100;
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
  const __vue_script__$3 = script$3;

  /* template */
  var __vue_render__$3 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-slider",class:[_vm.size, _vm.type, _vm.rootClasses ],on:{"click":_vm.onSliderClick}},[_c('div',{ref:"slider",staticClass:"b-slider-track"},[_c('div',{staticClass:"b-slider-fill",style:(_vm.barStyle)}),_vm._v(" "),(_vm.ticks)?_vm._l((_vm.tickValues),function(val,key){return _c('b-slider-tick',{key:key,attrs:{"value":val}})}):_vm._e(),_vm._v(" "),_vm._t("default"),_vm._v(" "),_c('b-slider-thumb',{ref:"button1",attrs:{"type":_vm.newTooltipType,"tooltip":_vm.tooltip,"custom-formatter":_vm.customFormatter,"role":"slider","aria-valuenow":_vm.value1,"aria-valuemin":_vm.min,"aria-valuemax":_vm.max,"aria-orientation":"horizontal","aria-label":Array.isArray(_vm.ariaLabel) ? _vm.ariaLabel[0] : _vm.ariaLabel,"aria-disabled":_vm.disabled},on:{"dragstart":_vm.onDragStart,"dragend":_vm.onDragEnd},model:{value:(_vm.value1),callback:function ($$v) {_vm.value1=$$v;},expression:"value1"}}),_vm._v(" "),(_vm.isRange)?_c('b-slider-thumb',{ref:"button2",attrs:{"type":_vm.newTooltipType,"tooltip":_vm.tooltip,"custom-formatter":_vm.customFormatter,"role":"slider","aria-valuenow":_vm.value2,"aria-valuemin":_vm.min,"aria-valuemax":_vm.max,"aria-orientation":"horizontal","aria-label":Array.isArray(_vm.ariaLabel) ? _vm.ariaLabel[1] : '',"aria-disabled":_vm.disabled},on:{"dragstart":_vm.onDragStart,"dragend":_vm.onDragEnd},model:{value:(_vm.value2),callback:function ($$v) {_vm.value2=$$v;},expression:"value2"}}):_vm._e()],2)])};
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
    

    
    var Slider = normalizeComponent_1(
      { render: __vue_render__$3, staticRenderFns: __vue_staticRenderFns__$3 },
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
      registerComponent(Vue, Slider);
      registerComponent(Vue, SliderTick);
    }
  };
  use(Plugin);

  exports.BSlider = Slider;
  exports.BSliderTick = SliderTick;
  exports.default = Plugin;

  Object.defineProperty(exports, '__esModule', { value: true });

}));
