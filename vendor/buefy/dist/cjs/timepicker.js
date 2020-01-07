'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-f98e7e80.js');
require('./helpers.js');
require('./chunk-8806479f.js');
require('./chunk-f7289f47.js');
require('./chunk-45103eda.js');
var __chunk_5 = require('./chunk-13e039f5.js');
require('./chunk-f974ef53.js');
require('./chunk-b458d93b.js');
require('./chunk-c5b5b708.js');
require('./chunk-a60f20f8.js');
require('./chunk-0e2a0143.js');
require('./chunk-ae3b7de5.js');
var __chunk_16 = require('./chunk-9439f388.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_16.Timepicker);
  }
};
__chunk_5.use(Plugin);

exports.BTimepicker = __chunk_16.Timepicker;
exports.default = Plugin;
