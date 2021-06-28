'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

require('./chunk-14c82365.js');
require('./helpers.js');
require('./chunk-cd0dcc1d.js');
require('./chunk-cdf52db8.js');
require('./chunk-d7fda995.js');
var __chunk_5 = require('./chunk-13e039f5.js');
require('./chunk-2c156199.js');
require('./chunk-ae7e641a.js');
require('./chunk-a8b51847.js');
require('./chunk-e2b9e5bd.js');
require('./chunk-c9f4ec1d.js');
var __chunk_15 = require('./chunk-763efdc9.js');

var Plugin = {
  install: function install(Vue) {
    __chunk_5.registerComponent(Vue, __chunk_15.Datepicker);
  }
};
__chunk_5.use(Plugin);

exports.BDatepicker = __chunk_15.Datepicker;
exports.default = Plugin;
