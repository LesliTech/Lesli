'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-14c82365.js');
require('./chunk-cd0dcc1d.js');
var __chunk_5 = require('./chunk-13e039f5.js');
var __chunk_13 = require('./chunk-e2b9e5bd.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_13.Field);
  }
};
__chunk_5.use(Plugin);

exports.BField = __chunk_13.Field;
exports.default = Plugin;
