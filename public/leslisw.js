/*
 * ATTENTION: The "eval" devtool has been used (maybe by default in mode: "development").
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "./lib/assets/javascripts/leslisw.js":
/*!*******************************************!*\
  !*** ./lib/assets/javascripts/leslisw.js ***!
  \*******************************************/
/***/ (() => {

eval("/*\n\nCopyright (c) 2021, all rights reserved.\n\nAll the information provided by this platform is protected by international laws related  to \nindustrial property, intellectual property, copyright and relative international laws. \nAll intellectual or industrial property rights of the code, texts, trade mark, design, \npictures and any other information belongs to the owner of this platform.\n\nWithout the written permission of the owner, any replication, modification,\ntransmission, publication is strictly forbidden.\n\nFor more information read the license file including with this software.\n\n// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~\n// · \n\n*/\nself.addEventListener('push', function (event) {\n  if (!(self.Notification && self.Notification.permission === 'granted')) {\n    return;\n  }\n\n  var data = {};\n\n  if (event.data) {\n    data = event.data.json();\n  }\n\n  var subject = data.subject || '';\n  var tag = data.tag || 'lesli';\n  var body = data.body || '';\n  var icon = '';\n  event.waitUntil(self.registration.showNotification(subject, {\n    icon: icon,\n    body: body,\n    tag: tag\n  }));\n});\n\n//# sourceURL=webpack://lesli/./lib/assets/javascripts/leslisw.js?");

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module can't be inlined because the eval devtool is used.
/******/ 	var __webpack_exports__ = {};
/******/ 	__webpack_modules__["./lib/assets/javascripts/leslisw.js"]();
/******/ 	
/******/ })()
;