'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-f98e7e80.js');
require('./helpers.js');
require('./chunk-8806479f.js');
var __chunk_4 = require('./chunk-45103eda.js');
var __chunk_5 = require('./chunk-13e039f5.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_4.Icon);
  }
};
__chunk_5.use(Plugin);

exports.BIcon = __chunk_4.Icon;
exports.default = Plugin;
