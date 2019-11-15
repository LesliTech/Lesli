'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-98a92ff2.js');
var __chunk_6 = require('./chunk-13e039f5.js');
require('./chunk-68185b37.js');
var __chunk_12 = require('./chunk-0fcd89df.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_12.Dropdown);
    __chunk_6.registerComponent(Vue, __chunk_12.DropdownItem);
  }
};
__chunk_6.use(Plugin);

exports.default = Plugin;
