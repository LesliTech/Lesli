import { c as config } from './chunk-6985c8ce.js';
import { _ as __vue_normalize__ } from './chunk-cca88db8.js';

//
var script = {
  name: 'BTooltip',
  props: {
    active: {
      type: Boolean,
      default: true
    },
    type: String,
    label: String,
    position: {
      type: String,
      default: 'is-top',
      validator: function validator(value) {
        return ['is-top', 'is-bottom', 'is-left', 'is-right'].indexOf(value) > -1;
      }
    },
    always: Boolean,
    animated: Boolean,
    square: Boolean,
    dashed: Boolean,
    multilined: Boolean,
    size: {
      type: String,
      default: 'is-medium'
    },
    delay: Number
  },
  computed: {
    newType: function newType() {
      return this.type || config.defaultTooltipType;
    },
    newAnimated: function newAnimated() {
      return this.animated || config.defaultTooltipAnimated;
    },
    newDelay: function newDelay() {
      return this.delay || config.defaultTooltipDelay;
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{class:[_vm.newType, _vm.position, _vm.size, {
            'b-tooltip': _vm.active,
            'is-square': _vm.square,
            'is-animated': _vm.newAnimated,
            'is-always': _vm.always,
            'is-multiline': _vm.multilined,
            'is-dashed': _vm.dashed
        }],style:({'transition-delay': (_vm.newDelay + "ms")}),attrs:{"data-label":_vm.label}},[_vm._t("default")],2)};
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
  

  
  var Tooltip = __vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

export { Tooltip as T };
