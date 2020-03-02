'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-5094d8df.js');
require('./helpers.js');
require('./chunk-805257cc.js');
require('./chunk-c0ff4e55.js');
require('./chunk-bc189645.js');
var __chunk_5 = require('./chunk-13e039f5.js');
require('./chunk-9295ec8b.js');
require('./chunk-fc48ea13.js');
require('./chunk-c5b5b708.js');
require('./chunk-385dea12.js');
require('./chunk-4defa6e0.js');
require('./chunk-77d9ea65.js');
var __chunk_16 = require('./chunk-4eb8554a.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_16.Timepicker);
  }
};
__chunk_5.use(Plugin);

exports.BTimepicker = __chunk_16.Timepicker;
exports.default = Plugin;
