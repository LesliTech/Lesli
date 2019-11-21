import { a as _defineProperty } from './chunk-40949afc.js';
import './chunk-d3a97e18.js';
import './chunk-9d997597.js';
import { F as FormElementMixin } from './chunk-02b123d5.js';
import { I as Icon } from './chunk-2b1ca282.js';
import { _ as __vue_normalize__, r as registerComponent, u as use } from './chunk-cca88db8.js';
import { I as Input } from './chunk-9b7023ac.js';

var _components;
var script = {
  name: 'BNumberinput',
  components: (_components = {}, _defineProperty(_components, Icon.name, Icon), _defineProperty(_components, Input.name, Input), _components),
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
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-numberinput field",class:_vm.fieldClasses},[_c('p',{staticClass:"control",on:{"mouseup":function($event){_vm.onStopLongPress(false);},"mouseleave":function($event){_vm.onStopLongPress(false);},"touchend":function($event){_vm.onStopLongPress(false);},"touchcancel":function($event){_vm.onStopLongPress(false);}}},[_c('button',{staticClass:"button",class:_vm.buttonClasses,attrs:{"type":"button","disabled":_vm.disabled || _vm.disabledMin},on:{"mousedown":function($event){_vm.onStartLongPress($event, false);},"touchstart":function($event){$event.preventDefault();_vm.onStartLongPress($event, false);},"click":function($event){_vm.onControlClick($event, false);}}},[_c('b-icon',{attrs:{"icon":"minus","pack":_vm.iconPack,"size":_vm.iconSize}})],1)]),_vm._v(" "),_c('b-input',_vm._b({ref:"input",attrs:{"type":"number","step":_vm.newStep,"max":_vm.max,"min":_vm.min,"size":_vm.size,"disabled":_vm.disabled,"readonly":!_vm.editable,"loading":_vm.loading,"rounded":_vm.rounded,"icon":_vm.icon,"icon-pack":_vm.iconPack,"autocomplete":_vm.autocomplete,"expanded":_vm.expanded,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":function($event){_vm.$emit('focus', $event);},"blur":function($event){_vm.$emit('blur', $event);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=_vm._n($$v);},expression:"computedValue"}},'b-input',_vm.$attrs,false)),_vm._v(" "),_c('p',{staticClass:"control",on:{"mouseup":function($event){_vm.onStopLongPress(true);},"mouseleave":function($event){_vm.onStopLongPress(true);},"touchend":function($event){_vm.onStopLongPress(true);},"touchcancel":function($event){_vm.onStopLongPress(true);}}},[_c('button',{staticClass:"button",class:_vm.buttonClasses,attrs:{"type":"button","disabled":_vm.disabled || _vm.disabledMax},on:{"mousedown":function($event){_vm.onStartLongPress($event, true);},"touchstart":function($event){$event.preventDefault();_vm.onStartLongPress($event, true);},"click":function($event){_vm.onControlClick($event, true);}}},[_c('b-icon',{attrs:{"icon":"plus","pack":_vm.iconPack,"size":_vm.iconSize}})],1)])],1)};
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
  

  
  var Numberinput = __vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Numberinput);
  }
};
use(Plugin);

export default Plugin;
