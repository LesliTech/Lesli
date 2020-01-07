'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-8806479f.js');
var __chunk_5 = require('./chunk-13e039f5.js');
require('./chunk-c5b5b708.js');
var __chunk_12 = require('./chunk-a60f20f8.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_12.Dropdown);
    __chunk_5.registerComponent(Vue, __chunk_12.DropdownItem);
  }
};
__chunk_5.use(Plugin);

exports.BDropdown = __chunk_12.Dropdown;
exports.BDropdownItem = __chunk_12.DropdownItem;
exports.default = Plugin;
