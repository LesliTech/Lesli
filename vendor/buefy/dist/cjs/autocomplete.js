'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-a535ca7c.js');
require('./chunk-f920b094.js');
require('./chunk-98a92ff2.js');
require('./chunk-191e0131.js');
require('./chunk-ef3fcce1.js');
var __chunk_6 = require('./chunk-13e039f5.js');
require('./chunk-555220c3.js');
var __chunk_8 = require('./chunk-f549f4e5.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, __chunk_8.Autocomplete);
  }
};
__chunk_6.use(Plugin);

exports.default = Plugin;
