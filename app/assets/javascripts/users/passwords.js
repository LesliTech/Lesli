/*
 * ATTENTION: The "eval" devtool has been used (maybe by default in mode: "development").
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ "./app/vue/users/passwords.js":
/*!************************************!*\
  !*** ./app/vue/users/passwords.js ***!
  \************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.r(__webpack_exports__);\nObject(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/public'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }());\n/*\nLesli\n\nCopyright (c) 2023, Lesli Technologies, S. A.\n\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GNU General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\nThis program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\nGNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License\nalong with this program. If not, see http://www.gnu.org/licenses/.\n\nLesli · Your Smart Business Assistant. \n\nMade with ♥ by https://www.lesli.tech\nBuilding a better future, one line of code at a time.\n\n@contact  hello@lesli.tech\n@website  https://lesli.tech\n@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html\n\n// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~\n// · \n*/\n\n// · \n\n// · \n\n\n// · \nObject(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/public'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }())({\n  data() {\n    return {\n      loading: false,\n      translations: {\n        main: I18n.t(\"core.users/passwords\")\n      },\n      sign_in: {\n        email: \"\",\n        password: \"\"\n      },\n      password_edit: {\n        new_password: \"\",\n        new_password_confirmation: \"\"\n      },\n      notification: {\n        message: \"\",\n        show: false,\n        type: \"danger\"\n      }\n    };\n  },\n  methods: {\n    postPasswordNew(event) {\n      this.notification.show = false;\n      this.loading = true;\n      event.preventDefault();\n      let data = {\n        user: {\n          email: this.sign_in.email.toLowerCase(),\n          password: this.sign_in.password\n        }\n      };\n      this.http.post(\"/password\", data).then(response => {\n        this.showNotification(this.translations.main.notification_reset_password_instructions_sent, \"success\");\n      }).catch(error => {\n        this.showNotification(error.message);\n      }).finally(() => {\n        this.loading = false;\n      });\n    },\n    putPasswordEdit(event) {\n      this.notification.show = false;\n      this.loading = true;\n      event.preventDefault();\n\n      // check if passwords match\n      if (this.password_edit.new_password != this.password_edit.new_password_confirmation) {\n        this.showNotification(this.translations.main.error_passwords_do_not_match, \"danger\");\n        return;\n      }\n      var token = null;\n      try {\n        token = Object.fromEntries(new URLSearchParams(window.location.search)).reset_password_token;\n      } catch (error) {\n        token = null;\n      }\n      this.http.put(\"/password\", {\n        user: {\n          password: this.password_edit.new_password,\n          password_confirmation: this.password_edit.new_password_confirmation,\n          reset_password_token: token\n        }\n      }).then(response => {\n        this.showNotification(this.translations.main.notification_password_updated, \"success\");\n        setTimeout(() => {\n          this.url.go(\"/login\");\n        }, 2000);\n      }).catch(error => {\n        this.showNotification(error.message, \"danger\");\n      }).finally(() => {\n        this.loading = false;\n      });\n    },\n    showNotification(message) {\n      let type = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : \"danger\";\n      this.notification.message = message;\n      this.notification.type = type;\n      this.notification.show = true;\n    }\n  }\n});\n\n//# sourceURL=webpack://lesli-vue/./app/vue/users/passwords.js?");

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The require scope
/******/ 	var __webpack_require__ = {};
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	(() => {
/******/ 		// define __esModule on exports
/******/ 		__webpack_require__.r = (exports) => {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	})();
/******/ 	
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module can't be inlined because the eval devtool is used.
/******/ 	var __webpack_exports__ = {};
/******/ 	__webpack_modules__["./app/vue/users/passwords.js"](0, __webpack_exports__, __webpack_require__);
/******/ 	
/******/ })()
;