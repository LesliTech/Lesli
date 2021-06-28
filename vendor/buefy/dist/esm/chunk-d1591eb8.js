import { _ as _defineProperty } from './chunk-1fafdf15.js';
import { c as config } from './chunk-6985c8ce.js';
import { F as FormElementMixin } from './chunk-d0a313ea.js';
import { I as Icon } from './chunk-cdfca85b.js';
import { _ as __vue_normalize__ } from './chunk-cca88db8.js';

var script = {
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
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:_vm.rootClasses},[(_vm.type !== 'textarea')?_c('input',_vm._b({ref:"input",staticClass:"input",class:[_vm.inputClasses, _vm.customClass],attrs:{"type":_vm.newType,"autocomplete":_vm.newAutocomplete,"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'input',_vm.$attrs,false)):_c('textarea',_vm._b({ref:"textarea",staticClass:"textarea",class:[_vm.inputClasses, _vm.customClass],attrs:{"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'textarea',_vm.$attrs,false)),_vm._v(" "),(_vm.icon)?_c('b-icon',{staticClass:"is-left",class:{'is-clickable': _vm.iconClickable},attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":_vm.iconSize},nativeOn:{"click":function($event){_vm.iconClick('icon-click', $event);}}}):_vm._e(),_vm._v(" "),(!_vm.loading && _vm.hasIconRight)?_c('b-icon',{staticClass:"is-right",class:{ 'is-clickable': _vm.passwordReveal || _vm.iconRightClickable },attrs:{"icon":_vm.rightIcon,"pack":_vm.iconPack,"size":_vm.iconSize,"type":_vm.rightIconType,"both":""},nativeOn:{"click":function($event){return _vm.rightIconClick($event)}}}):_vm._e(),_vm._v(" "),(_vm.maxlength && _vm.hasCounter && _vm.type !== 'number')?_c('small',{staticClass:"help counter",class:{ 'is-invisible': !_vm.isFocused }},[_vm._v("\r\n            "+_vm._s(_vm.valueLength)+" / "+_vm._s(_vm.maxlength)+"\r\n        ")]):_vm._e()],1)};
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
  

  
  var Input = __vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

export { Input as I };
