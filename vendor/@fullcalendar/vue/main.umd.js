/*
FullCalendar Vue Component v4.4.2
Docs: https://fullcalendar.io/docs/vue
License: MIT
*/
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports, require('@fullcalendar/core')) :
  typeof define === 'function' && define.amd ? define(['exports', '@fullcalendar/core'], factory) :
  (global = global || self, factory(global.FullCalendarVue = {}, global.FullCalendar));
}(this, (function (exports, core) { 'use strict';

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

  function _unsupportedIterableToArray(o, minLen) {
    if (!o) return;
    if (typeof o === "string") return _arrayLikeToArray(o, minLen);
    var n = Object.prototype.toString.call(o).slice(8, -1);
    if (n === "Object" && o.constructor) n = o.constructor.name;
    if (n === "Map" || n === "Set") return Array.from(o);
    if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen);
  }

  function _arrayLikeToArray(arr, len) {
    if (len == null || len > arr.length) len = arr.length;

    for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i];

    return arr2;
  }

  function _createForOfIteratorHelper(o, allowArrayLike) {
    var it;

    if (typeof Symbol === "undefined" || o[Symbol.iterator] == null) {
      if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") {
        if (it) o = it;
        var i = 0;

        var F = function () {};

        return {
          s: F,
          n: function () {
            if (i >= o.length) return {
              done: true
            };
            return {
              done: false,
              value: o[i++]
            };
          },
          e: function (e) {
            throw e;
          },
          f: F
        };
      }

      throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
    }

    var normalCompletion = true,
        didErr = false,
        err;
    return {
      s: function () {
        it = o[Symbol.iterator]();
      },
      n: function () {
        var step = it.next();
        normalCompletion = step.done;
        return step;
      },
      e: function (e) {
        didErr = true;
        err = e;
      },
      f: function () {
        try {
          if (!normalCompletion && it.return != null) it.return();
        } finally {
          if (didErr) throw err;
        }
      }
    };
  }

  var isArray = Array.isArray;
  var keyList = Object.keys;
  var hasProp = Object.prototype.hasOwnProperty;

  var fastDeepEqual = function equal(a, b) {
    if (a === b) return true;

    if (a && b && _typeof(a) == 'object' && _typeof(b) == 'object') {
      var arrA = isArray(a),
          arrB = isArray(b),
          i,
          length,
          key;

      if (arrA && arrB) {
        length = a.length;
        if (length != b.length) return false;

        for (i = length; i-- !== 0;) {
          if (!equal(a[i], b[i])) return false;
        }

        return true;
      }

      if (arrA != arrB) return false;
      var dateA = a instanceof Date,
          dateB = b instanceof Date;
      if (dateA != dateB) return false;
      if (dateA && dateB) return a.getTime() == b.getTime();
      var regexpA = a instanceof RegExp,
          regexpB = b instanceof RegExp;
      if (regexpA != regexpB) return false;
      if (regexpA && regexpB) return a.toString() == b.toString();
      var keys = keyList(a);
      length = keys.length;
      if (length !== keyList(b).length) return false;

      for (i = length; i-- !== 0;) {
        if (!hasProp.call(b, keys[i])) return false;
      }

      for (i = length; i-- !== 0;) {
        key = keys[i];
        if (!equal(a[key], b[key])) return false;
      }

      return true;
    }

    return a !== a && b !== b;
  };

  var hasOwnProperty = Object.prototype.hasOwnProperty;
  /*
  Really simple clone utility. Only copies plain arrays, objects, and Dates. Transfers everything else as-is.
  Wanted to use a third-party lib, but none did exactly this.
  */

  function deepCopy(input) {
    if (Array.isArray(input)) {
      return input.map(deepCopy);
    } else if (input instanceof Date) {
      return new Date(input.valueOf());
    } else if (_typeof(input) === 'object' && input) {
      // non-null object
      return mapHash(input, deepCopy);
    } else {
      // everything else (null, function, etc)
      return input;
    }
  }
  function mapHash(input, func) {
    var output = {};

    for (var key in input) {
      if (hasOwnProperty.call(input, key)) {
        output[key] = func(input[key], key);
      }
    }

    return output;
  }

  /*
  the docs point to this file as an index of options.
  when this files is moved, update the docs.
  */

  /*
  TODO: figure out booleans so attributes can be defined like:
  <FullCalendar editable />
  */
  var PROP_DEFS = {
    header: {},
    footer: {},
    customButtons: {},
    buttonIcons: {},
    themeSystem: {},
    bootstrapFontAwesome: {},
    firstDay: {},
    dir: {},
    weekends: {},
    hiddenDays: {},
    fixedWeekCount: {},
    weekNumbers: {},
    weekNumbersWithinDays: {},
    weekNumberCalculation: {},
    businessHours: {},
    showNonCurrentDates: {},
    height: {},
    contentHeight: {},
    aspectRatio: {},
    handleWindowResize: {},
    windowResizeDelay: {},
    eventLimit: {},
    eventLimitClick: {},
    timeZone: {},
    now: {},
    defaultView: {},
    allDaySlot: {},
    allDayText: {},
    slotDuration: {},
    slotLabelFormat: {},
    slotLabelInterval: {},
    snapDuration: {},
    scrollTime: {},
    minTime: {},
    maxTime: {},
    slotEventOverlap: {},
    listDayFormat: {},
    listDayAltFormat: {},
    noEventsMessage: {},
    defaultDate: {},
    nowIndicator: {},
    visibleRange: {},
    validRange: {},
    dateIncrement: {},
    dateAlignment: {},
    duration: {},
    dayCount: {},
    locales: {},
    locale: {},
    eventTimeFormat: {},
    columnHeader: {},
    columnHeaderFormat: {},
    columnHeaderText: {},
    columnHeaderHtml: {},
    titleFormat: {},
    weekLabel: {},
    displayEventTime: {},
    displayEventEnd: {},
    eventLimitText: {},
    dayPopoverFormat: {},
    navLinks: {},
    navLinkDayClick: {},
    navLinkWeekClick: {},
    selectable: {},
    selectMirror: {},
    unselectAuto: {},
    unselectCancel: {},
    defaultAllDayEventDuration: {},
    defaultTimedEventDuration: {},
    cmdFormatter: {},
    defaultRangeSeparator: {},
    selectConstraint: {},
    selectOverlap: {},
    selectAllow: {},
    editable: {},
    eventStartEditable: {},
    eventDurationEditable: {},
    eventConstraint: {},
    eventOverlap: {},
    eventAllow: {},
    eventClassName: {},
    eventClassNames: {},
    eventBackgroundColor: {},
    eventBorderColor: {},
    eventTextColor: {},
    eventColor: {},
    events: {},
    eventSources: {},
    allDayDefault: {},
    startParam: {},
    endParam: {},
    lazyFetching: {},
    nextDayThreshold: {},
    eventOrder: {},
    rerenderDelay: {},
    dragRevertDuration: {},
    dragScroll: {},
    longPressDelay: {},
    eventLongPressDelay: {},
    droppable: {},
    dropAccept: {},
    eventDataTransform: {},
    allDayMaintainDuration: {},
    eventResizableFromStart: {},
    timeGridEventMinHeight: {},
    allDayHtml: {},
    eventDragMinDistance: {},
    eventResourceEditable: {},
    eventSourceFailure: {},
    eventSourceSuccess: {},
    forceEventDuration: {},
    progressiveEventRendering: {},
    selectLongPressDelay: {},
    selectMinDistance: {},
    timeZoneParam: {},
    titleRangeSeparator: {},
    // compound OptionsInput...
    buttonText: {},
    views: {},
    plugins: {},
    // scheduler...
    schedulerLicenseKey: {},
    resources: {},
    resourceLabelText: {},
    resourceOrder: {},
    filterResourcesWithEvents: {},
    resourceText: {},
    resourceGroupField: {},
    resourceGroupText: {},
    resourceAreaWidth: {},
    resourceColumns: {},
    resourcesInitiallyExpanded: {},
    slotWidth: {},
    datesAboveResources: {},
    googleCalendarApiKey: {},
    refetchResourcesOnNavigate: {},
    // used to be emissions but are now props...
    datesRender: {},
    datesDestroy: {},
    dayRender: {},
    eventRender: {},
    eventDestroy: {},
    viewSkeletonRender: {},
    viewSkeletonDestroy: {},
    resourceRender: {}
  };
  var PROP_IS_DEEP = {
    header: true,
    footer: true,
    events: true,
    eventSources: true,
    resources: true
  };
  var EMISSION_NAMES = ['windowResize', 'dateClick', 'eventClick', 'eventMouseEnter', 'eventMouseLeave', 'select', 'unselect', 'loading', 'eventPositioned', '_eventsPositioned', 'eventDragStart', 'eventDragStop', 'eventDrop', 'eventResizeStart', 'eventResizeStop', 'eventResize', 'drop', 'eventReceive', 'eventLeave', '_destroyed', // should now be props... (TODO: eventually remove)
  'datesRender', 'datesDestroy', 'dayRender', 'eventRender', 'eventDestroy', 'viewSkeletonRender', 'viewSkeletonDestroy', 'resourceRender']; // identify deprecated emissions (TODO: eventually remove)

  var EMISSION_USE_PROP = {
    datesRender: true,
    datesDestroy: true,
    dayRender: true,
    eventRender: true,
    eventDestroy: true,
    viewSkeletonRender: true,
    viewSkeletonDestroy: true,
    resourceRender: true
  };

  /*
  VOCAB:
  "props" are the values passed in from the parent (they are NOT listeners/emissions)
  "emissions" are another way to say "events that will fire"
  "options" are the options that the FullCalendar API accepts

  NOTE: "deep" props are complex objects that we want to watch for internal changes.
  Vue allows a reference to be internally mutated. Each time we detect a mutation,
  we use deepCopy to freeze the state. This has the added benefit of stripping the
  getter/setter methods that Vue embeds.
  */

  var FullCalendarComponent = {
    props: PROP_DEFS,
    // INTERNALS
    // this.$options.calendar
    // this.$options.deepCopies - all current deep options
    // this.$options.dirtyOptions - null/undefined means nothing dirty
    data: function data() {
      return {
        renderId: 0,
        deepCopies: {}
      };
    },
    render: function render(createElement) {
      return createElement('div', {
        // when renderId is changed, Vue will trigger a real-DOM async rerender, calling beforeUpdate/updated
        attrs: {
          'data-fc-render-id': this.renderId
        }
      });
    },
    mounted: function mounted() {
      warnDeprecatedListeners(this.$listeners);
      this.$options.calendar = new core.Calendar(this.$el, this.buildCalendarOptions());
      this.$options.calendar.render();
    },
    beforeUpdate: function beforeUpdate() {
      this.renderDirty();
    },
    beforeDestroy: function beforeDestroy() {
      this.$options.calendar.destroy();
    },
    watch: mapHash(PROP_DEFS, buildPropWatcher),
    methods: {
      buildCalendarOptions: function buildCalendarOptions() {
        var _this = this;

        var options = {};

        var _iterator = _createForOfIteratorHelper(EMISSION_NAMES),
            _step;

        try {
          var _loop = function _loop() {
            var emissionName = _step.value;

            options[emissionName] = function () {
              for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
                args[_key] = arguments[_key];
              }

              _this.$emit.apply(_this, [emissionName].concat(args));
            };
          };

          for (_iterator.s(); !(_step = _iterator.n()).done;) {
            _loop();
          } // do after emissions. these props will override emissions with same name

        } catch (err) {
          _iterator.e(err);
        } finally {
          _iterator.f();
        }

        for (var propName in PROP_DEFS) {
          var propVal = this[propName]; // protect against FullCalendar choking on undefined options

          if (propVal !== undefined) {
            if (PROP_IS_DEEP[propName]) {
              propVal = deepCopy(propVal); // freeze state

              this.deepCopies[propName] = propVal; // side effect!
            }

            options[propName] = propVal;
          }
        }

        return options;
      },
      recordDirtyOption: function recordDirtyOption(optionName, newVal) {
        (this.$options.dirtyOptions || (this.$options.dirtyOptions = {}))[optionName] = newVal;
        this.renderId++; // triggers a render eventually
      },
      renderDirty: function renderDirty() {
        var dirtyOptions = this.$options.dirtyOptions;

        if (dirtyOptions) {
          this.$options.dirtyOptions = null; // clear before rendering. might trigger new dirtiness

          this.$options.calendar.mutateOptions(dirtyOptions, [], false, fastDeepEqual);
        }
      },
      getApi: function getApi() {
        return this.$options.calendar;
      }
    }
  };

  function buildPropWatcher(propDef, propName) {
    if (PROP_IS_DEEP[propName]) {
      return {
        deep: true,
        // listen to children as well
        handler: function handler(newVal) {
          // use this instead of the handler's param because if same reference, will always be equal
          var oldVal = this.deepCopies[propName];

          if (!fastDeepEqual(newVal, oldVal)) {
            newVal = deepCopy(newVal); // freeze state

            this.deepCopies[propName] = newVal; // always keep this up to date

            this.recordDirtyOption(propName, newVal);
          }
        }
      };
    } else {
      return function (newVal) {
        this.recordDirtyOption(propName, newVal);
      };
    }
  }

  function warnDeprecatedListeners(listenerHash) {
    for (var emissionName in listenerHash) {
      if (EMISSION_USE_PROP[emissionName]) {
        console.warn('Use of ' + emissionName + ' as an event is deprecated. Please convert to a prop.');
      }
    }
  }

  /*
  Registers the component globally if appropriate.
  This modules exposes the component AND an install function.

  Derived from:
  https://vuejs.org/v2/cookbook/packaging-sfc-for-npm.html
  */

  var installed = false; // declare install function executed by Vue.use()

  function install(Vue) {
    if (!installed) {
      installed = true;
      Vue.component('FullCalendar', FullCalendarComponent);
    }
  } // detect a globally availble version of Vue (eg. in browser via <script> tag)

  var GlobalVue;

  if (typeof window !== 'undefined') {
    GlobalVue = window.Vue;
  } else if (typeof global !== 'undefined') {
    GlobalVue = global.Vue;
  } // auto-install if possible


  if (GlobalVue) {
    GlobalVue.use({
      install: install
    });
  } // to allow use as module (npm/webpack/etc.) export component

  exports.default = FullCalendarComponent;
  exports.install = install;

  Object.defineProperty(exports, '__esModule', { value: true });

})));
