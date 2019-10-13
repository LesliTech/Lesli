'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-545f01b1.js');
var __chunk_5 = require('./chunk-60061aa8.js');
var __chunk_6 = require('./chunk-13e039f5.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_5.Icon);
  }
};
__chunk_6.use(Plugin);

exports.Icon = __chunk_5.Icon;
exports.default = Plugin;
