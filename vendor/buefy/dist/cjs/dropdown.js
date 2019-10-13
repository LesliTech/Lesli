'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-545f01b1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_11 = require('./chunk-544a95da.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_11.Dropdown);
    __chunk_6.registerComponent(Vue, __chunk_11.DropdownItem);
  }
};
__chunk_6.use(Plugin);

exports.Dropdown = __chunk_11.Dropdown;
exports.DropdownItem = __chunk_11.DropdownItem;
exports.default = Plugin;
