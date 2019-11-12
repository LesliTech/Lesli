'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-a535ca7c.js');
require('./chunk-98a92ff2.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_13 = require('./chunk-5b69a143.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_13.Field);
  }
};
__chunk_6.use(Plugin);

exports.default = Plugin;
