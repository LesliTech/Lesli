'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-9f6a8079.js');
require('./chunk-545f01b1.js');
require('./chunk-60061aa8.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_18 = require('./chunk-876befa8.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_18.Pagination);
  }
};
__chunk_6.use(Plugin);

exports.Pagination = __chunk_18.Pagination;
exports.default = Plugin;
