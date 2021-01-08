'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var bg = {
  code: 'bg',
  week: {
    dow: 1, // Monday is the first day of the week.
    doy: 7, // The week that contains Jan 1st is the first week of the year.
  },
  buttonText: {
    prev: 'назад',
    next: 'напред',
    today: 'днес',
    month: 'Месец',
    week: 'Седмица',
    day: 'Ден',
    list: 'График',
  },
  allDayText: 'Цял ден',
  moreLinkText: function(n) {
    return '+още ' + n
  },
  noEventsText: 'Няма събития за показване',
};

exports.default = bg;
