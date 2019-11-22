/*! Buefy v0.8.6 | MIT License | github.com/buefy/buefy */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = global || self, factory(global.Clockpicker = {}));
}(this, function (exports) { 'use strict';

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
  var script$2 = {
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

  /* script */
  const __vue_script__$2 = script$2;

  /* template */
  var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{staticClass:"icon",class:[_vm.newType, _vm.size]},[(!_vm.useIconComponent)?_c('i',{class:[_vm.newPack, _vm.newIcon, _vm.newCustomSize, _vm.customClass]}):_c(_vm.useIconComponent,{tag:"component",class:[_vm.customClass],attrs:{"icon":[_vm.newPack, _vm.newIcon],"size":_vm.newCustomSize}})],1)};
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
    

    
    var Icon = normalizeComponent_1(
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
  const __vue_script__$3 = script$3;

  /* template */
  var __vue_render__$3 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"control",class:_vm.rootClasses},[(_vm.type !== 'textarea')?_c('input',_vm._b({ref:"input",staticClass:"input",class:[_vm.inputClasses, _vm.customClass],attrs:{"type":_vm.newType,"autocomplete":_vm.newAutocomplete,"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'input',_vm.$attrs,false)):_c('textarea',_vm._b({ref:"textarea",staticClass:"textarea",class:[_vm.inputClasses, _vm.customClass],attrs:{"maxlength":_vm.maxlength},domProps:{"value":_vm.computedValue},on:{"input":_vm.onInput,"blur":_vm.onBlur,"focus":_vm.onFocus}},'textarea',_vm.$attrs,false)),_vm._v(" "),(_vm.icon)?_c('b-icon',{staticClass:"is-left",attrs:{"icon":_vm.icon,"pack":_vm.iconPack,"size":_vm.iconSize}}):_vm._e(),_vm._v(" "),(!_vm.loading && (_vm.passwordReveal || _vm.statusTypeIcon))?_c('b-icon',{staticClass:"is-right",class:{ 'is-clickable': _vm.passwordReveal },attrs:{"icon":_vm.passwordReveal ? _vm.passwordVisibleIcon : _vm.statusTypeIcon,"pack":_vm.iconPack,"size":_vm.iconSize,"type":!_vm.passwordReveal ? _vm.statusType : 'is-primary',"both":""},nativeOn:{"click":function($event){_vm.togglePasswordVisibility($event);}}}):_vm._e(),_vm._v(" "),(_vm.maxlength && _vm.hasCounter && _vm.type !== 'number')?_c('small',{staticClass:"help counter",class:{ 'is-invisible': !_vm.isFocused }},[_vm._v("\n        "+_vm._s(_vm.valueLength)+" / "+_vm._s(_vm.maxlength)+"\n    ")]):_vm._e()],1)};
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
    

    
    var Input = normalizeComponent_1(
      { render: __vue_render__$3, staticRenderFns: __vue_staticRenderFns__$3 },
      __vue_inject_styles__$3,
      __vue_script__$3,
      __vue_scope_id__$3,
      __vue_is_functional_template__$3,
      __vue_module_identifier__$3,
      undefined,
      undefined
    );

  var script$4 = {
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
  const __vue_script__$4 = script$4;

  /* template */

    /* style */
    const __vue_inject_styles__$4 = undefined;
    /* scoped */
    const __vue_scope_id__$4 = undefined;
    /* module identifier */
    const __vue_module_identifier__$4 = undefined;
    /* functional template */
    const __vue_is_functional_template__$4 = undefined;
    /* style inject */
    
    /* style inject SSR */
    

    
    var FieldBody = normalizeComponent_1(
      {},
      __vue_inject_styles__$4,
      __vue_script__$4,
      __vue_scope_id__$4,
      __vue_is_functional_template__$4,
      __vue_module_identifier__$4,
      undefined,
      undefined
    );

  var script$5 = {
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
  const __vue_script__$5 = script$5;

  /* template */
  var __vue_render__$4 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"field",class:[_vm.rootClasses, _vm.fieldType()]},[(_vm.horizontal)?_c('div',{staticClass:"field-label",class:[_vm.customClass, _vm.fieldLabelSize]},[(_vm.hasLabel)?_c('label',{staticClass:"label",class:_vm.customClass,attrs:{"for":_vm.labelFor}},[(_vm.$slots.label)?_vm._t("label"):[_vm._v(_vm._s(_vm.label))]],2):_vm._e()]):[(_vm.hasLabel)?_c('label',{staticClass:"label",class:_vm.customClass,attrs:{"for":_vm.labelFor}},[(_vm.$slots.label)?_vm._t("label"):[_vm._v(_vm._s(_vm.label))]],2):_vm._e()],_vm._v(" "),(_vm.horizontal)?_c('b-field-body',{attrs:{"message":_vm.newMessage ? _vm.formattedMessage : '',"type":_vm.newType}},[_vm._t("default")],2):[_vm._t("default")],_vm._v(" "),(_vm.newMessage && !_vm.horizontal)?_c('p',{staticClass:"help",class:_vm.newType,domProps:{"innerHTML":_vm._s(_vm.formattedMessage)}}):_vm._e()],2)};
  var __vue_staticRenderFns__$4 = [];

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
    

    
    var Field = normalizeComponent_1(
      { render: __vue_render__$4, staticRenderFns: __vue_staticRenderFns__$4 },
      __vue_inject_styles__$5,
      __vue_script__$5,
      __vue_scope_id__$5,
      __vue_is_functional_template__$5,
      __vue_module_identifier__$5,
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
  var script$6 = {
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
  const __vue_script__$6 = script$6;

  /* template */
  var __vue_render__$5 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-clockpicker-face",on:{"mousedown":_vm.onMouseDown,"mouseup":_vm.onMouseUp,"mousemove":_vm.onDragMove,"touchstart":_vm.onMouseDown,"touchend":_vm.onMouseUp,"touchmove":_vm.onDragMove}},[_c('div',{ref:"clock",staticClass:"b-clockpicker-face-outer-ring"},[_c('div',{staticClass:"b-clockpicker-face-hand",style:(_vm.handStyle)}),_vm._v(" "),_vm._l((_vm.faceNumbers),function(num,index){return _c('span',{key:index,staticClass:"b-clockpicker-face-number",class:_vm.getFaceNumberClasses(num),style:({ transform: _vm.getNumberTranslate(num.value) })},[_c('span',[_vm._v(_vm._s(num.label))])])})],2)])};
  var __vue_staticRenderFns__$5 = [];

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
    

    
    var ClockpickerFace = normalizeComponent_1(
      { render: __vue_render__$5, staticRenderFns: __vue_staticRenderFns__$5 },
      __vue_inject_styles__$6,
      __vue_script__$6,
      __vue_scope_id__$6,
      __vue_is_functional_template__$6,
      __vue_module_identifier__$6,
      undefined,
      undefined
    );

  var _components;
  var outerPadding = 12;
  var script$7 = {
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
  const __vue_script__$7 = script$7;

  /* template */
  var __vue_render__$6 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-clockpicker control",class:[_vm.size, _vm.type, {'is-expanded': _vm.expanded}]},[(!_vm.isMobile || _vm.inline)?_c('b-dropdown',{ref:"dropdown",attrs:{"position":_vm.position,"disabled":_vm.disabled,"inline":_vm.inline}},[(!_vm.inline)?_c('b-input',_vm._b({ref:"input",attrs:{"slot":"trigger","autocomplete":"off","value":_vm.formatValue(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"disabled":_vm.disabled,"readonly":!_vm.editable,"rounded":_vm.rounded,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":function($event){_vm.onBlur() && _vm.checkHtml5Validity();}},nativeOn:{"click":function($event){$event.stopPropagation();_vm.toggle(true);},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.toggle(true);},"change":function($event){_vm.onChangeNativePicker($event);}},slot:"trigger"},'b-input',_vm.$attrs,false)):_vm._e(),_vm._v(" "),_c('div',{staticClass:"card",attrs:{"disabled":_vm.disabled,"custom":""}},[(_vm.inline)?_c('header',{staticClass:"card-header"},[_c('div',{staticClass:"b-clockpicker-header card-header-title"},[_c('div',{staticClass:"b-clockpicker-time"},[_c('span',{staticClass:"b-clockpicker-btn",class:{ active: _vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = true;}}},[_vm._v(_vm._s(_vm.hoursDisplay))]),_vm._v(" "),_c('span',[_vm._v(":")]),_vm._v(" "),_c('span',{staticClass:"b-clockpicker-btn",class:{ active: !_vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = false;}}},[_vm._v(_vm._s(_vm.minutesDisplay))])]),_vm._v(" "),(!_vm.isHourFormat24)?_c('div',{staticClass:"b-clockpicker-period"},[_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.AM },on:{"click":function($event){_vm.onMeridienClick(_vm.AM);}}},[_vm._v("am")]),_vm._v(" "),_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.PM },on:{"click":function($event){_vm.onMeridienClick(_vm.PM);}}},[_vm._v("pm")])]):_vm._e()])]):_vm._e(),_vm._v(" "),_c('div',{staticClass:"card-content"},[_c('div',{staticClass:"b-clockpicker-body",style:({ width: _vm.faceSize + 'px', height: _vm.faceSize + 'px' })},[(!_vm.inline)?_c('div',{staticClass:"b-clockpicker-time"},[_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = true;}}},[_vm._v(_vm._s(_vm.hoursLabel))]),_vm._v(" "),_c('span',{staticClass:"b-clockpicker-btn",class:{ active: !_vm.isSelectingHour },on:{"click":function($event){_vm.isSelectingHour = false;}}},[_vm._v(_vm._s(_vm.minutesLabel))])]):_vm._e(),_vm._v(" "),(!_vm.isHourFormat24 && !_vm.inline)?_c('div',{staticClass:"b-clockpicker-period"},[_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.AM },on:{"click":function($event){_vm.onMeridienClick(_vm.AM);}}},[_vm._v(_vm._s(_vm.AM))]),_vm._v(" "),_c('div',{staticClass:"b-clockpicker-btn",class:{ active: _vm.meridienSelected == _vm.PM },on:{"click":function($event){_vm.onMeridienClick(_vm.PM);}}},[_vm._v(_vm._s(_vm.PM))])]):_vm._e(),_vm._v(" "),_c('b-clockpicker-face',{attrs:{"picker-size":_vm.faceSize,"min":_vm.minFaceValue,"max":_vm.maxFaceValue,"face-numbers":_vm.isSelectingHour ? _vm.hours : _vm.minutes,"disabled-values":_vm.faceDisabledValues,"double":_vm.isSelectingHour && _vm.isHourFormat24,"value":_vm.isSelectingHour ? _vm.hoursSelected : _vm.minutesSelected},on:{"input":_vm.onClockInput,"change":_vm.onClockChange}})],1)]),_vm._v(" "),(_vm.$slots.default !== undefined && _vm.$slots.default.length)?_c('footer',{staticClass:"b-clockpicker-footer card-footer"},[_vm._t("default")],2):_vm._e()])],1):_c('b-input',_vm._b({ref:"input",attrs:{"type":"time","autocomplete":"off","value":_vm.formatHHMMSS(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"max":_vm.formatHHMMSS(_vm.maxTime),"min":_vm.formatHHMMSS(_vm.minTime),"disabled":_vm.disabled,"readonly":false,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":function($event){_vm.onBlur() && _vm.checkHtml5Validity();}},nativeOn:{"click":function($event){$event.stopPropagation();_vm.toggle(true);},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.toggle(true);},"change":function($event){_vm.onChangeNativePicker($event);}}},'b-input',_vm.$attrs,false))],1)};
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
    

    
    var Clockpicker = normalizeComponent_1(
      { render: __vue_render__$6, staticRenderFns: __vue_staticRenderFns__$6 },
      __vue_inject_styles__$7,
      __vue_script__$7,
      __vue_scope_id__$7,
      __vue_is_functional_template__$7,
      __vue_module_identifier__$7,
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
      registerComponent(Vue, Clockpicker);
    }
  };
  use(Plugin);

  exports.default = Plugin;

  Object.defineProperty(exports, '__esModule', { value: true });

}));
