'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var __chunk_1 = require('./chunk-14c82365.js');

/**
 * +/- function to native math sign
 */
function signPoly(value) {
  if (value < 0) return -1;
  return value > 0 ? 1 : 0;
}

var sign = Math.sign || signPoly;
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
  return __chunk_1._typeof(item) === 'object' && !Array.isArray(item);
};

var mergeFn = function mergeFn(target, source) {
  var deep = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

  if (deep || !Object.assign) {
    var isDeep = function isDeep(prop) {
      return isObject(source[prop]) && target !== null && target.hasOwnProperty(prop) && isObject(target[prop]);
    };

    var replaced = Object.getOwnPropertyNames(source).map(function (prop) {
      return __chunk_1._defineProperty({}, prop, isDeep(prop) ? mergeFn(target[prop], source[prop], deep) : source[prop]);
    }).reduce(function (a, b) {
      return __chunk_1._objectSpread2({}, a, {}, b);
    }, {});
    return __chunk_1._objectSpread2({}, target, {}, replaced);
  } else {
    return Object.assign(target, source);
  }
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
function removeElement(el) {
  if (typeof el.remove !== 'undefined') {
    el.remove();
  } else if (typeof el.parentNode !== 'undefined' && el.parentNode !== null) {
    el.parentNode.removeChild(el);
  }
}
function createAbsoluteElement(el) {
  var root = document.createElement('div');
  root.style.position = 'absolute';
  root.style.left = '0px';
  root.style.top = '0px';
  var wrapper = document.createElement('div');
  root.appendChild(wrapper);
  wrapper.appendChild(el);
  document.body.appendChild(root);
  return root;
}
/**
 * Escape regex characters
 * http://stackoverflow.com/a/6969486
 */

function escapeRegExpChars(value) {
  if (!value) return value; // eslint-disable-next-line

  return value.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
}
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
function createNewEvent(eventName) {
  var event;

  if (typeof Event === 'function') {
    event = new Event(eventName);
  } else {
    event = document.createEvent('Event');
    event.initEvent(eventName, true, true);
  }

  return event;
}

exports.createAbsoluteElement = createAbsoluteElement;
exports.createNewEvent = createNewEvent;
exports.escapeRegExpChars = escapeRegExpChars;
exports.getValueByPath = getValueByPath;
exports.indexOf = indexOf;
exports.isMobile = isMobile;
exports.merge = merge;
exports.multiColumnSort = multiColumnSort;
exports.removeElement = removeElement;
exports.sign = sign;
