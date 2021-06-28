'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-14c82365.js');
require('./helpers.js');
require('./chunk-cd0dcc1d.js');
require('./chunk-cdf52db8.js');
require('./chunk-d7fda995.js');
var __chunk_5 = require('./chunk-13e039f5.js');
var __chunk_14 = require('./chunk-c9f4ec1d.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_14.Select);
  }
};
__chunk_5.use(Plugin);

exports.BSelect = __chunk_14.Select;
exports.default = Plugin;
