'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-f98e7e80.js');
require('./helpers.js');
require('./chunk-8806479f.js');
require('./chunk-45103eda.js');
var __chunk_5 = require('./chunk-13e039f5.js');
var __chunk_21 = require('./chunk-a8911a0c.js');

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
