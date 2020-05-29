'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-cd0dcc1d.js');
var __chunk_5 = require('./chunk-13e039f5.js');
var __chunk_22 = require('./chunk-ac697190.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_22.Tooltip);
  }
};
__chunk_5.use(Plugin);

exports.BTooltip = __chunk_22.Tooltip;
exports.default = Plugin;
