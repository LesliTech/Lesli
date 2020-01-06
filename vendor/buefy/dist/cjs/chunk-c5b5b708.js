'use strict';

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

exports.trapFocus = directive;
