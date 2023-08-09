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

/***/ "./app/vue/users/sessions.js":
/*!***********************************!*\
  !*** ./app/vue/users/sessions.js ***!
  \***********************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.r(__webpack_exports__);\nObject(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/public'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }());\n/*\nLesli\n\nCopyright (c) 2023, Lesli Technologies, S. A.\n\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GNU General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\nThis program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\nGNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License\nalong with this program. If not, see http://www.gnu.org/licenses/.\n\nLesli · Your Smart Business Assistant. \n\nMade with ♥ by https://www.lesli.tech\nBuilding a better future, one line of code at a time.\n\n@contact  hello@lesli.tech\n@website  https://lesli.tech\n@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html\n\n// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~\n// · \n*/\n\n// · \n\n\n// · \nObject(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/public'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }())({\n  data() {\n    return {\n      loading: false,\n      sign_in: {\n        email: \"\",\n        password: \"\"\n      },\n      notification: {\n        message: \"\",\n        show: false,\n        type: \"default\"\n      },\n      errors: [\"holi\"]\n    };\n  },\n  mounted() {\n    this.$refs?.email?.focus();\n  },\n  methods: {\n    togglePasswordInput() {\n      if (this.$refs.password.type === \"password\") {\n        this.$refs.password.type = \"text\";\n      } else {\n        this.$refs.password.type = \"password\";\n      }\n    },\n    validateEmail() {\n      if (/^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+$/.test(this.sign_in.email)) {\n        console.log(\"error\");\n      }\n    },\n    build_redirect_url() {\n      let default_path = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : null;\n      // redirect to the root of the domain by default\n      let redirect_url = \"/\";\n      try {\n        // search for a redirection route in the url params\n        redirect_url = Object.fromEntries(new URLSearchParams(window.location.search)).r;\n      } catch (error) {}\n\n      // redirect to the default path if: \n      //      - there is no query params with redirection\n      if (!redirect_url && default_path) {\n        redirect_url = default_path;\n      }\n\n      // redirect to the root if: \n      //      - error parsing redirection route\n      //      - there is no query params with redirection\n      if (!redirect_url) {\n        redirect_url = \"/\";\n      }\n      return redirect_url;\n    },\n    postLogin(event) {\n      this.loading = true;\n      event.preventDefault();\n      this.notification.show = false;\n      let data = {\n        user: {\n          email: this.sign_in.email.toLowerCase(),\n          password: this.sign_in.password\n        }\n      };\n      this.http.post(\"/login\", data).then(response => {\n        this.url.go(this.build_redirect_url(response.default_path));\n      }).catch(error => {\n        this.showNotification(error.message);\n      }).finally(() => {\n        this.loading = false;\n      });\n    },\n    typing() {\n      this.notification.message = \"\";\n      this.notification.show = false;\n      this.notification.type = \"default\";\n    },\n    showNotification(message) {\n      let type = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : \"danger\";\n      this.notification.message = message;\n      this.notification.type = type;\n      this.notification.show = true;\n    }\n  }\n});\n\n//# sourceURL=webpack://lesli-vue/./app/vue/users/sessions.js?");

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
/******/ 	__webpack_modules__["./app/vue/users/sessions.js"](0, __webpack_exports__, __webpack_require__);
/******/ 	
/******/ })()
;