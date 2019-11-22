'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var __chunk_1 = require('./chunk-a535ca7c.js');
var __chunk_2 = require('./chunk-f920b094.js');
var __chunk_3 = require('./chunk-98a92ff2.js');
var __chunk_4 = require('./chunk-191e0131.js');
require('./chunk-ef3fcce1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
require('./chunk-555220c3.js');
require('./chunk-82f36361.js');
require('./chunk-68185b37.js');
require('./chunk-0fcd89df.js');
require('./chunk-5b69a143.js');
require('./chunk-dd8f96ae.js');
var __chunk_15 = require('./chunk-27e2e691.js');
var __chunk_16 = require('./chunk-4b16ce84.js');

var _components;
var script = {
  name: 'BDatetimepicker',
  components: (_components = {}, __chunk_1._defineProperty(_components, __chunk_15.Datepicker.name, __chunk_15.Datepicker), __chunk_1._defineProperty(_components, __chunk_16.Timepicker.name, __chunk_16.Timepicker), _components),
  mixins: [__chunk_4.FormElementMixin],
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
        if (typeof __chunk_3.config.defaultDatetimeCreator === 'function') {
          return __chunk_3.config.defaultDatetimeCreator(date);
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
    isMobile: function isMobile() {
      return this.mobileNative && __chunk_2.isMobile.any();
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
      } else if (typeof __chunk_3.config.defaultDatetimeParser === 'function') {
        return __chunk_3.config.defaultDatetimeParser(date);
      } else {
        return new Date(Date.parse(date));
      }
    },
    defaultDatetimeFormatter: function defaultDatetimeFormatter(date) {
      if (typeof this.datetimeFormatter === 'function') {
        return this.datetimeFormatter(date);
      } else if (typeof __chunk_3.config.defaultDatetimeParser === 'function') {
        return __chunk_3.config.defaultDatetimeParser(date);
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
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return (!_vm.isMobile || _vm.inline)?_c('b-datepicker',_vm._b({ref:"datepicker",attrs:{"open-on-focus":_vm.openOnFocus,"position":_vm.position,"loading":_vm.loading,"inline":_vm.inline,"editable":_vm.editable,"close-on-click":false,"date-formatter":_vm.defaultDatetimeFormatter,"date-parser":_vm.defaultDatetimeParser,"min-date":_vm.minDate,"max-date":_vm.maxDate,"icon":_vm.icon,"icon-pack":_vm.iconPack,"size":_vm.datepickerSize,"range":false,"disabled":_vm.disabled,"mobile-native":_vm.mobileNative},on:{"change-month":function($event){_vm.$emit('change-month', $event);},"change-year":function($event){_vm.$emit('change-year', $event);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}},'b-datepicker',_vm.datepicker,false),[_c('nav',{staticClass:"level is-mobile"},[(_vm.$slots.left !== undefined)?_c('div',{staticClass:"level-item has-text-centered"},[_vm._t("left")],2):_vm._e(),_vm._v(" "),_c('div',{staticClass:"level-item has-text-centered"},[_c('b-timepicker',_vm._b({ref:"timepicker",attrs:{"inline":"","editable":_vm.editable,"min-time":_vm.minTime,"max-time":_vm.maxTime,"size":_vm.timepickerSize,"disabled":_vm.timepickerDisabled},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}},'b-timepicker',_vm.timepicker,false))],1),_vm._v(" "),(_vm.$slots.right !== undefined)?_c('div',{staticClass:"level-item has-text-centered"},[_vm._t("right")],2):_vm._e()])]):_c('b-input',_vm._b({ref:"input",attrs:{"type":"datetime-local","autocomplete":"off","value":_vm.formatNative(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"max":_vm.formatNative(_vm.maxDate),"min":_vm.formatNative(_vm.minDate),"disabled":_vm.disabled,"readonly":false,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.onFocus,"blur":_vm.onBlur},nativeOn:{"change":function($event){_vm.onChangeNativePicker($event);}}},'b-input',_vm.$attrs,false))};
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
  

  
  var Datetimepicker = __chunk_6.__vue_normalize__(
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
    __chunk_6.registerComponent(Vue, Datetimepicker);
  }
};
__chunk_6.use(Plugin);

exports.default = Plugin;
