'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-14c82365.js');
require('./helpers.js');
require('./chunk-60255743.js');
var __chunk_5 = require('./chunk-13e039f5.js');
var __chunk_24 = require('./chunk-e57b3891.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_24.Tooltip);
  }
};
__chunk_5.use(Plugin);

exports.BTooltip = __chunk_24.Tooltip;
exports.default = Plugin;
