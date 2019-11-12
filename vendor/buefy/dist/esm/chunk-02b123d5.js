import { c as config } from './chunk-9d997597.js';

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

export { FormElementMixin as F };
