'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-9f6a8079.js');
require('./chunk-545f01b1.js');
require('./chunk-c146745e.js');
require('./chunk-60061aa8.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_7 = require('./chunk-f0c597f9.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_7.Input);
  }
};
__chunk_6.use(Plugin);

exports.Input = __chunk_7.Input;
exports.default = Plugin;
