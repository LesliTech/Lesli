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

/***/ "./app/vue/users/registrations.js":
/*!****************************************!*\
  !*** ./app/vue/users/registrations.js ***!
  \****************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.r(__webpack_exports__);\nObject(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/lesli/components/select/Select.vue'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }());\nObject(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/public'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }());\n/*\nLesli\n\nCopyright (c) 2023, Lesli Technologies, S. A.\n\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GNU General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\nThis program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\nGNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License\nalong with this program. If not, see http://www.gnu.org/licenses/.\n\nLesli · Your Smart Business Assistant. \n\nMade with ♥ by https://www.lesli.tech\nBuilding a better future, one line of code at a time.\n\n@contact  hello@lesli.tech\n@website  https://lesli.tech\n@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html\n\n// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~\n// · \n*/\n\n// · \n\n\n// · \n\n\n// · \nObject(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/public'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }())({\n  data() {\n    return {\n      translations: {},\n      password_uppercase: 0,\n      password_symbol: 0,\n      password_number: 0,\n      telephone_code: \"+49\",\n      telephone_codes: null,\n      sign_up: {\n        email: null,\n        password: '',\n        password_confirmation: '',\n        first_name: null,\n        last_name: null,\n        telephone: null\n      },\n      progress_bar_active: false,\n      notification: {\n        show: false,\n        message: '',\n        type: 'is-danger'\n      }\n    };\n  },\n  components: {\n    lesliSelect: Object(function webpackMissingModule() { var e = new Error(\"Cannot find module 'Lesli/lesli/components/select/Select.vue'\"); e.code = 'MODULE_NOT_FOUND'; throw e; }())\n  },\n  mounted() {\n    this.$refs.email.focus();\n  },\n  methods: {\n    /**\n     * @param {*} event that triggers the function\n     * @description this function is triggered when the user submits the form to sign up\n     */\n    postRegistration(event) {\n      this.notification.show = false;\n      event.preventDefault();\n      const user = this.validateFields();\n      this.http.post(this.url.to(), user).then(response => {\n        setTimeout(() => {\n          this.url.go(\"/login\");\n        }, 5000);\n      }).catch(err => {\n        this.showNotification(err.message);\n      });\n    },\n    typing() {\n      this.notification.message = \"\";\n      this.notification.show = false;\n      this.notification.type = \"default\";\n      this.verifyPasswords();\n    },\n    showNotification(message) {\n      let type = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : \"danger\";\n      this.notification.message = message;\n      this.notification.type = type;\n      this.notification.show = true;\n    },\n    /**\n     * @description validates the password strength\n     */\n    verifyPasswords() {\n      this.password_uppercase = 0;\n      this.password_number = 0;\n      this.password_symbol = 0;\n      if (this.sign_up.password.length <= 0) {\n        return;\n      }\n      if (this.sign_up.password.search(/[A-Z]/) < 0) {\n        this.password_uppercase = 1;\n      } else {\n        this.password_uppercase = 2;\n      }\n      if (this.sign_up.password.search(/[0-9]/) < 0) {\n        this.password_number = 1;\n      } else {\n        this.password_number = 2;\n      }\n      if (this.sign_up.password.search(/[!#$%&]/) < 0) {\n        this.password_symbol = 1;\n      } else {\n        this.password_symbol = 2;\n      }\n    },\n    /**\n     * @description this function validates if the fields are correct\n     * @returns object with the user to be registered\n     */\n    validateFields() {\n      // · copy object without reference\n      const user = JSON.parse(JSON.stringify(this.sign_up));\n      if (user.password_confirmation == \"\") {\n        user.password_confirmation = user.password;\n      }\n      return user;\n    }\n  }\n});\n\n//# sourceURL=webpack://lesli-vue/./app/vue/users/registrations.js?");

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
/******/ 	__webpack_modules__["./app/vue/users/registrations.js"](0, __webpack_exports__, __webpack_require__);
/******/ 	
/******/ })()
;