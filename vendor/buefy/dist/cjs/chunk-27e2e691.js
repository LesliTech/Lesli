'use strict';

var __chunk_1 = require('./chunk-a535ca7c.js');
var __chunk_2 = require('./chunk-f920b094.js');
var __chunk_3 = require('./chunk-98a92ff2.js');
var __chunk_4 = require('./chunk-191e0131.js');
var __chunk_5 = require('./chunk-ef3fcce1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_7 = require('./chunk-555220c3.js');
var __chunk_12 = require('./chunk-0fcd89df.js');
var __chunk_13 = require('./chunk-5b69a143.js');
var __chunk_14 = require('./chunk-dd8f96ae.js');

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
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
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"datepicker-row"},[(_vm.showWeekNumber)?_c('a',{staticClass:"datepicker-cell is-week-number"},[_vm._v("\n        "+_vm._s(_vm.getWeekNumber(_vm.week[6]))+"\n    ")]):_vm._e(),_vm._v(" "),_vm._l((_vm.week),function(day,index){return [(_vm.selectableDate(day) && !_vm.disabled)?_c('a',{key:index,staticClass:"datepicker-cell",class:[_vm.classObject(day), {'has-event': _vm.eventsDateMatch(day)}, _vm.indicators],attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.emitChosenDate(day);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(day);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(day);}],"mouseenter":function($event){_vm.setRangeHoverEndDate(day);}}},[_vm._v("\n            "+_vm._s(day.getDate())+"\n            "),(_vm.eventsDateMatch(day))?_c('div',{staticClass:"events"},_vm._l((_vm.eventsDateMatch(day)),function(event,index){return _c('div',{key:index,staticClass:"event",class:event.type})})):_vm._e()]):_c('div',{key:index,staticClass:"datepicker-cell",class:_vm.classObject(day)},[_vm._v("\n            "+_vm._s(day.getDate())+"\n        ")])]})],2)};
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
  

  
  var DatepickerTableRow = __chunk_6.__vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

var isDefined = function isDefined(d) {
  return d !== undefined;
};

var script$1 = {
  name: 'BDatepickerTable',
  components: __chunk_1._defineProperty({}, DatepickerTableRow.name, DatepickerTableRow),
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
const __vue_script__$1 = script$1;

/* template */
var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('section',{staticClass:"datepicker-table"},[_c('header',{staticClass:"datepicker-header"},_vm._l((_vm.visibleDayNames),function(day,index){return _c('div',{key:index,staticClass:"datepicker-cell"},[_vm._v("\n            "+_vm._s(day)+"\n        ")])})),_vm._v(" "),_c('div',{staticClass:"datepicker-body",class:{'has-events':_vm.hasEvents}},_vm._l((_vm.weeksInThisMonth),function(week,index){return _c('b-datepicker-table-row',{key:index,attrs:{"selected-date":_vm.value,"week":week,"month":_vm.focused.month,"min-date":_vm.minDate,"max-date":_vm.maxDate,"disabled":_vm.disabled,"unselectable-dates":_vm.unselectableDates,"unselectable-days-of-week":_vm.unselectableDaysOfWeek,"selectable-dates":_vm.selectableDates,"events":_vm.eventsInThisWeek(week),"indicators":_vm.indicators,"date-creator":_vm.dateCreator,"nearby-month-days":_vm.nearbyMonthDays,"nearby-selectable-month-days":_vm.nearbySelectableMonthDays,"show-week-number":_vm.showWeekNumber,"first-day-of-week":_vm.firstDayOfWeek,"rules-for-first-week":_vm.rulesForFirstWeek,"range":_vm.range,"hovered-date-range":_vm.hoveredDateRange,"multiple":_vm.multiple},on:{"select":_vm.updateSelectedDate,"rangeHoverEndDate":_vm.setRangeHoverEndDate}})}))])};
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
  

  
  var DatepickerTable = __chunk_6.__vue_normalize__(
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
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
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
const __vue_script__$2 = script$2;

/* template */
var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('section',{staticClass:"datepicker-table"},[_c('div',{staticClass:"datepicker-body",class:{'has-events':_vm.hasEvents}},[_c('div',{staticClass:"datepicker-months"},[_vm._l((_vm.monthDates),function(date,index){return [(_vm.selectableDate(date) && !_vm.disabled)?_c('a',{key:index,staticClass:"datepicker-cell",class:[
                        _vm.classObject(date),
                        {'has-event': _vm.eventsDateMatch(date)},
                        _vm.indicators
                    ],attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.emitChosenDate(date);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(date);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.emitChosenDate(date);}]}},[_vm._v("\n                    "+_vm._s(_vm.monthNames[date.getMonth()])+"\n                    "),(_vm.eventsDateMatch(date))?_c('div',{staticClass:"events"},_vm._l((_vm.eventsDateMatch(date)),function(event,index){return _c('div',{key:index,staticClass:"event",class:event.type})})):_vm._e()]):_c('div',{key:index,staticClass:"datepicker-cell",class:_vm.classObject(date)},[_vm._v("\n                    "+_vm._s(_vm.monthNames[date.getMonth()])+"\n                ")])]})],2)])])};
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
  

  
  var DatepickerMonth = __chunk_6.__vue_normalize__(
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

var script$3 = {
  name: 'BDatepicker',
  components: (_components = {}, __chunk_1._defineProperty(_components, DatepickerTable.name, DatepickerTable), __chunk_1._defineProperty(_components, DatepickerMonth.name, DatepickerMonth), __chunk_1._defineProperty(_components, __chunk_7.Input.name, __chunk_7.Input), __chunk_1._defineProperty(_components, __chunk_13.Field.name, __chunk_13.Field), __chunk_1._defineProperty(_components, __chunk_14.Select.name, __chunk_14.Select), __chunk_1._defineProperty(_components, __chunk_5.Icon.name, __chunk_5.Icon), __chunk_1._defineProperty(_components, __chunk_12.Dropdown.name, __chunk_12.Dropdown), __chunk_1._defineProperty(_components, __chunk_12.DropdownItem.name, __chunk_12.DropdownItem), _components),
  mixins: [__chunk_4.FormElementMixin],
  inheritAttrs: false,
  props: {
    value: {
      type: [Date, Array]
    },
    dayNames: {
      type: Array,
      default: function _default() {
        if (Array.isArray(__chunk_3.config.defaultDayNames)) {
          return __chunk_3.config.defaultDayNames;
        } else {
          return ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'S'];
        }
      }
    },
    monthNames: {
      type: Array,
      default: function _default() {
        if (Array.isArray(__chunk_3.config.defaultMonthNames)) {
          return __chunk_3.config.defaultMonthNames;
        } else {
          return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        }
      }
    },
    firstDayOfWeek: {
      type: Number,
      default: function _default() {
        if (typeof __chunk_3.config.defaultFirstDayOfWeek === 'number') {
          return __chunk_3.config.defaultFirstDayOfWeek;
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
        return __chunk_3.config.defaultUnselectableDaysOfWeek;
      }
    },
    selectableDates: Array,
    dateFormatter: {
      type: Function,
      default: function _default(date, vm) {
        if (typeof __chunk_3.config.defaultDateFormatter === 'function') {
          return __chunk_3.config.defaultDateFormatter(date);
        } else {
          return defaultDateFormatter(date, vm);
        }
      }
    },
    dateParser: {
      type: Function,
      default: function _default(date, vm) {
        if (typeof __chunk_3.config.defaultDateParser === 'function') {
          return __chunk_3.config.defaultDateParser(date);
        } else {
          return defaultDateParser(date, vm);
        }
      }
    },
    dateCreator: {
      type: Function,
      default: function _default() {
        if (typeof __chunk_3.config.defaultDateCreator === 'function') {
          return __chunk_3.config.defaultDateCreator();
        } else {
          return new Date();
        }
      }
    },
    mobileNative: {
      type: Boolean,
      default: function _default() {
        return __chunk_3.config.defaultDatepickerMobileNative;
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
      default: __chunk_3.config.defaultIconPrev
    },
    iconNext: {
      type: String,
      default: __chunk_3.config.defaultIconNext
    },
    yearsRange: {
      type: Array,
      default: function _default() {
        return __chunk_3.config.defaultDatepickerYearsRange;
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
        return __chunk_3.config.defaultDatepickerNearbyMonthDays;
      }
    },
    nearbySelectableMonthDays: {
      type: Boolean,
      default: function _default() {
        return __chunk_3.config.defaultDatepickerNearbySelectableMonthDays;
      }
    },
    showWeekNumber: {
      type: Boolean,
      default: function _default() {
        return __chunk_3.config.defaultDatepickerShowWeekNumber;
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
    isMobile: function isMobile() {
      return this.mobileNative && __chunk_2.isMobile.any();
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
const __vue_script__$3 = script$3;

/* template */
var __vue_render__$3 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"datepicker control",class:[_vm.size, {'is-expanded': _vm.expanded}]},[(!_vm.isMobile || _vm.inline)?_c('b-dropdown',{ref:"dropdown",attrs:{"position":_vm.position,"disabled":_vm.disabled,"inline":_vm.inline}},[(!_vm.inline)?_c('b-input',_vm._b({ref:"input",attrs:{"slot":"trigger","autocomplete":"off","value":_vm.formatValue(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"rounded":_vm.rounded,"loading":_vm.loading,"disabled":_vm.disabled,"readonly":!_vm.editable,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.handleOnFocus,"blur":_vm.onBlur},nativeOn:{"click":function($event){_vm.onInputClick($event);},"keyup":function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }_vm.togglePicker(true);},"change":function($event){_vm.onChange($event.target.value);}},slot:"trigger"},'b-input',_vm.$attrs,false)):_vm._e(),_vm._v(" "),_c('b-dropdown-item',{attrs:{"disabled":_vm.disabled,"custom":""}},[_c('header',{staticClass:"datepicker-header"},[(_vm.$slots.header !== undefined && _vm.$slots.header.length)?[_vm._t("header")]:_c('div',{staticClass:"pagination field is-centered",class:_vm.size},[_c('a',{directives:[{name:"show",rawName:"v-show",value:(!_vm.showPrev && !_vm.disabled),expression:"!showPrev && !disabled"}],staticClass:"pagination-previous",attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.prev($event);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.prev($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.prev($event);}]}},[_c('b-icon',{attrs:{"icon":_vm.iconPrev,"pack":_vm.iconPack,"both":"","type":"is-primary is-clickable"}})],1),_vm._v(" "),_c('a',{directives:[{name:"show",rawName:"v-show",value:(!_vm.showNext && !_vm.disabled),expression:"!showNext && !disabled"}],staticClass:"pagination-next",attrs:{"role":"button","href":"#","disabled":_vm.disabled},on:{"click":function($event){$event.preventDefault();_vm.next($event);},"keydown":[function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"enter",13,$event.key)){ return null; }$event.preventDefault();_vm.next($event);},function($event){if(!('button' in $event)&&_vm._k($event.keyCode,"space",32,$event.key)){ return null; }$event.preventDefault();_vm.next($event);}]}},[_c('b-icon',{attrs:{"icon":_vm.iconNext,"pack":_vm.iconPack,"both":"","type":"is-primary is-clickable"}})],1),_vm._v(" "),_c('div',{staticClass:"pagination-list"},[_c('b-field',[(!_vm.isTypeMonth)?_c('b-select',{attrs:{"disabled":_vm.disabled,"size":_vm.size},model:{value:(_vm.focusedDateData.month),callback:function ($$v) {_vm.$set(_vm.focusedDateData, "month", $$v);},expression:"focusedDateData.month"}},_vm._l((_vm.monthNames),function(month,index){return _c('option',{key:month,domProps:{"value":index}},[_vm._v("\n                                    "+_vm._s(month)+"\n                                ")])})):_vm._e(),_vm._v(" "),_c('b-select',{attrs:{"disabled":_vm.disabled,"size":_vm.size},model:{value:(_vm.focusedDateData.year),callback:function ($$v) {_vm.$set(_vm.focusedDateData, "year", $$v);},expression:"focusedDateData.year"}},_vm._l((_vm.listOfYears),function(year){return _c('option',{key:year,domProps:{"value":year}},[_vm._v("\n                                    "+_vm._s(year)+"\n                                ")])}))],1)],1)])],2),_vm._v(" "),(!_vm.isTypeMonth)?_c('div',{staticClass:"datepicker-content"},[_c('b-datepicker-table',{attrs:{"day-names":_vm.dayNames,"month-names":_vm.monthNames,"first-day-of-week":_vm.firstDayOfWeek,"rules-for-first-week":_vm.rulesForFirstWeek,"min-date":_vm.minDate,"max-date":_vm.maxDate,"focused":_vm.focusedDateData,"disabled":_vm.disabled,"unselectable-dates":_vm.unselectableDates,"unselectable-days-of-week":_vm.unselectableDaysOfWeek,"selectable-dates":_vm.selectableDates,"events":_vm.events,"indicators":_vm.indicators,"date-creator":_vm.dateCreator,"type-month":_vm.isTypeMonth,"nearby-month-days":_vm.nearbyMonthDays,"nearby-selectable-month-days":_vm.nearbySelectableMonthDays,"show-week-number":_vm.showWeekNumber,"range":_vm.range,"multiple":_vm.multiple},on:{"close":function($event){_vm.togglePicker(false);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}})],1):_c('div',[_c('b-datepicker-month',{attrs:{"month-names":_vm.monthNames,"min-date":_vm.minDate,"max-date":_vm.maxDate,"focused":_vm.focusedDateData,"disabled":_vm.disabled,"unselectable-dates":_vm.unselectableDates,"unselectable-days-of-week":_vm.unselectableDaysOfWeek,"selectable-dates":_vm.selectableDates,"events":_vm.events,"indicators":_vm.indicators,"date-creator":_vm.dateCreator},on:{"close":function($event){_vm.togglePicker(false);}},model:{value:(_vm.computedValue),callback:function ($$v) {_vm.computedValue=$$v;},expression:"computedValue"}})],1),_vm._v(" "),(_vm.$slots.default !== undefined && _vm.$slots.default.length)?_c('footer',{staticClass:"datepicker-footer"},[_vm._t("default")],2):_vm._e()])],1):_c('b-input',_vm._b({ref:"input",attrs:{"type":!_vm.isTypeMonth ? 'date' : 'month',"autocomplete":"off","value":_vm.formatNative(_vm.computedValue),"placeholder":_vm.placeholder,"size":_vm.size,"icon":_vm.icon,"icon-pack":_vm.iconPack,"loading":_vm.loading,"max":_vm.formatNative(_vm.maxDate),"min":_vm.formatNative(_vm.minDate),"disabled":_vm.disabled,"readonly":false,"use-html5-validation":_vm.useHtml5Validation},on:{"focus":_vm.onFocus,"blur":_vm.onBlur},nativeOn:{"change":function($event){_vm.onChangeNativePicker($event);}}},'b-input',_vm.$attrs,false))],1)};
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
  

  
  var Datepicker = __chunk_6.__vue_normalize__(
    { render: __vue_render__$3, staticRenderFns: __vue_staticRenderFns__$3 },
    __vue_inject_styles__$3,
    __vue_script__$3,
    __vue_scope_id__$3,
    __vue_is_functional_template__$3,
    __vue_module_identifier__$3,
    undefined,
    undefined
  );

exports.Datepicker = Datepicker;
