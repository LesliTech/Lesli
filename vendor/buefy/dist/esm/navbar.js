import { _ as _defineProperty } from './chunk-d6200087.js';
import { _ as __vue_normalize__, r as registerComponent, u as use } from './chunk-cca88db8.js';

//
//
//
//
//
//
//
//
//
//
//
//
//
//
var script = {
  name: 'NavbarBurger',
  props: {
    isOpened: {
      type: Boolean,
      default: false
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('a',{staticClass:"navbar-burger burger",class:{ 'is-active': _vm.isOpened },attrs:{"role":"button","aria-label":"menu","aria-expanded":_vm.isOpened}},[_c('span',{attrs:{"aria-hidden":"true"}}),_vm._v(" "),_c('span',{attrs:{"aria-hidden":"true"}}),_vm._v(" "),_c('span',{attrs:{"aria-hidden":"true"}})])};
var __vue_staticRenderFns__ = [];

  /* style */
  const __vue_inject_styles__ = undefined;
  /* scoped */
  const __vue_scope_id__ = undefined;
  /* module identifier */
  const __vue_module_identifier__ = undefined;
  /* functional template */
  const __vue_is_functional_template__ = false;
  /* style inject */
  
  /* style inject SSR */
  

  
  var NavbarBurger = __vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

var FIXED_TOP_CLASS = 'is-fixed-top';
var FIXED_BOTTOM_CLASS = 'is-fixed-bottom';
var script$1 = {
  name: 'BNavbar',
  components: {
    NavbarBurger: NavbarBurger
  },
  props: {
    type: [String, Object],
    transparent: {
      type: Boolean,
      default: false
    },
    fixedTop: {
      type: Boolean,
      default: false
    },
    fixedBottom: {
      type: Boolean,
      default: false
    },
    isActive: {
      type: Boolean,
      default: false
    }
  },
  data: function data() {
    return {
      internalIsActive: this.isActive
    };
  },
  computed: {
    isOpened: function isOpened() {
      return this.internalIsActive;
    },
    computedClasses: function computedClasses() {
      return [this.type, _defineProperty({}, FIXED_TOP_CLASS, this.fixedTop), _defineProperty({}, FIXED_BOTTOM_CLASS, this.fixedBottom)];
    }
  },
  watch: {
    isActive: {
      handler: function handler(isActive) {
        this.internalIsActive = isActive;
      },
      immediate: true
    },
    fixedTop: {
      handler: function handler(isSet) {
        this.checkIfFixedPropertiesAreColliding();

        if (isSet) {
          return this.setBodyClass(FIXED_TOP_CLASS);
        }

        this.removeBodyClass(FIXED_TOP_CLASS);
      },
      immediate: true
    },
    fixedBottom: {
      handler: function handler(isSet) {
        this.checkIfFixedPropertiesAreColliding();

        if (isSet) {
          return this.setBodyClass(FIXED_BOTTOM_CLASS);
        }

        this.removeBodyClass(FIXED_BOTTOM_CLASS);
      },
      immediate: true
    }
  },
  methods: {
    toggleActive: function toggleActive() {
      this.internalIsActive = !this.internalIsActive;
      this.$emit('update:isActive', this.internalIsActive);
    },
    setBodyClass: function setBodyClass(className) {
      if (typeof window !== 'undefined') {
        document.body.classList.add(className);
      }
    },
    removeBodyClass: function removeBodyClass(className) {
      if (typeof window !== 'undefined') {
        document.body.classList.remove(className);
      }
    },
    checkIfFixedPropertiesAreColliding: function checkIfFixedPropertiesAreColliding() {
      var areColliding = this.fixedTop && this.fixedBottom;

      if (areColliding) {
        throw new Error('You should choose if the BNavbar is fixed bottom or fixed top, but not both');
      }
    }
  },
  beforeDestroy: function beforeDestroy() {
    this.removeBodyClass(FIXED_BOTTOM_CLASS);
    this.removeBodyClass(FIXED_TOP_CLASS);
  }
};

/* script */
const __vue_script__$1 = script$1;

/* template */
var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('nav',{staticClass:"navbar",class:_vm.computedClasses,attrs:{"role":"navigation","aria-label":"main navigation"}},[_c('div',{staticClass:"navbar-brand"},[_vm._t("brand"),_vm._v(" "),_vm._t("burger",[_c('navbar-burger',{attrs:{"is-opened":_vm.isOpened},nativeOn:{"click":function($event){_vm.toggleActive($event);}}})],null,{ isOpened: _vm.isOpened, toggleActive: _vm.toggleActive })],2),_vm._v(" "),_c('div',{staticClass:"navbar-menu",class:{ 'is-active': _vm.isOpened }},[_c('div',{staticClass:"navbar-start"},[_vm._t("start")],2),_vm._v(" "),_c('div',{staticClass:"navbar-end"},[_vm._t("end")],2)])])};
var __vue_staticRenderFns__$1 = [];

  /* style */
  const __vue_inject_styles__$1 = undefined;
  /* scoped */
  const __vue_scope_id__$1 = undefined;
  /* module identifier */
  const __vue_module_identifier__$1 = undefined;
  /* functional template */
  const __vue_is_functional_template__$1 = false;
  /* style inject */
  
  /* style inject SSR */
  

  
  var Navbar = __vue_normalize__(
    { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
    __vue_inject_styles__$1,
    __vue_script__$1,
    __vue_scope_id__$1,
    __vue_is_functional_template__$1,
    __vue_module_identifier__$1,
    undefined,
    undefined
  );

//
//
//
//
//
//
//
//
//
//
var script$2 = {
  name: 'BNavbarItem',
  props: {
    tag: {
      type: String,
      default: 'a'
    }
  }
};

/* script */
const __vue_script__$2 = script$2;

/* template */
var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c(_vm.tag,_vm._b({tag:"component",staticClass:"navbar-item"},'component',_vm.$attrs,false),[_vm._t("default")],2)};
var __vue_staticRenderFns__$2 = [];

  /* style */
  const __vue_inject_styles__$2 = undefined;
  /* scoped */
  const __vue_scope_id__$2 = undefined;
  /* module identifier */
  const __vue_module_identifier__$2 = undefined;
  /* functional template */
  const __vue_is_functional_template__$2 = false;
  /* style inject */
  
  /* style inject SSR */
  

  
  var NavbarItem = __vue_normalize__(
    { render: __vue_render__$2, staticRenderFns: __vue_staticRenderFns__$2 },
    __vue_inject_styles__$2,
    __vue_script__$2,
    __vue_scope_id__$2,
    __vue_is_functional_template__$2,
    __vue_module_identifier__$2,
    undefined,
    undefined
  );

var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Navbar);
    registerComponent(Vue, NavbarItem);
  }
};
use(Plugin);

export default Plugin;
export { Navbar, NavbarItem };
