'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-545f01b1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_19 = require('./chunk-6963026a.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_19.Tooltip);
  }
};
__chunk_6.use(Plugin);

exports.Tooltip = __chunk_19.Tooltip;
exports.default = Plugin;
