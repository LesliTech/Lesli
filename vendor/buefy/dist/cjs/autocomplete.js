'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-f98e7e80.js');
require('./helpers.js');
require('./chunk-8806479f.js');
require('./chunk-f7289f47.js');
require('./chunk-45103eda.js');
var __chunk_5 = require('./chunk-13e039f5.js');
require('./chunk-f974ef53.js');
var __chunk_7 = require('./chunk-2e7a70c8.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_7.Autocomplete);
  }
};
__chunk_5.use(Plugin);

exports.BAutocomplete = __chunk_7.Autocomplete;
exports.default = Plugin;
