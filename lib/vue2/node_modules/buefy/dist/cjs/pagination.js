'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-14c82365.js');
require('./helpers.js');
require('./chunk-cd0dcc1d.js');
require('./chunk-d7fda995.js');
var __chunk_5 = require('./chunk-13e039f5.js');
var __chunk_21 = require('./chunk-47054fd3.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_21.Pagination);
    __chunk_5.registerComponent(Vue, __chunk_21.PaginationButton);
  }
};
__chunk_5.use(Plugin);

exports.BPagination = __chunk_21.Pagination;
exports.BPaginationButton = __chunk_21.PaginationButton;
exports.default = Plugin;
