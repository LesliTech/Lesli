'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-9f6a8079.js');
require('./chunk-545f01b1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_12 = require('./chunk-ef4753d5.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_12.Field);
  }
};
__chunk_6.use(Plugin);

exports.Field = __chunk_12.Field;
exports.default = Plugin;
