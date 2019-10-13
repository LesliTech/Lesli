'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-9f6a8079.js');
require('./chunk-59b91990.js');
require('./chunk-545f01b1.js');
require('./chunk-c146745e.js');
require('./chunk-60061aa8.js');
var __chunk_6 = require('./chunk-13e039f5.js');
require('./chunk-f0c597f9.js');
var __chunk_8 = require('./chunk-5b2a3329.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_8.Autocomplete);
  }
};
__chunk_6.use(Plugin);

exports.Autocomplete = __chunk_8.Autocomplete;
exports.default = Plugin;
