import { c as config } from './chunk-9e3207cc.js';
import { _ as __vue_normalize__ } from './chunk-cca88db8.js';

//
var script = {
  name: 'BIcon',
  props: {
    type: [String, Object],
    pack: String,
    icon: String,
    size: String,
    customSize: String,
    customClass: String,
    both: Boolean // This is used internally to show both MDI and FA icon

  },
  computed: {
    /**
    * Internal icon name based on the pack.
    * If pack is 'fa', gets the equivalent FA icon name of the MDI,
    * internal icons are always MDI.
    */
    newIcon: function newIcon() {
      return this.newPack === 'mdi' ? "".concat(this.newPack, "-").concat(this.icon) : this.addFAPrefix(this.getEquivalentIconOf(this.icon));
    },
    newPack: function newPack() {
      return this.pack || config.defaultIconPack;
    },
    newType: function newType() {
      if (!this.type) return;
      var splitType = [];

      if (typeof this.type === 'string') {
        splitType = this.type.split('-');
      } else {
        for (var key in this.type) {
          if (this.type[key]) {
            splitType = key.split('-');
            break;
          }
        }
      }

      if (splitType.length <= 1) return;
      return "has-text-".concat(splitType[1]);
    },
    newCustomSize: function newCustomSize() {
      return this.customSize || this.customSizeByPack;
    },
    customSizeByPack: function customSizeByPack() {
      var defaultSize = this.newPack === 'mdi' ? 'mdi-24px' : this.addFAPrefix('lg');
      var mediumSize = this.newPack === 'mdi' ? 'mdi-36px' : this.addFAPrefix('2x');
      var largeSize = this.newPack === 'mdi' ? 'mdi-48px' : this.addFAPrefix('3x');

      switch (this.size) {
        case 'is-small':
          return;

        case 'is-medium':
          return mediumSize;

        case 'is-large':
          return largeSize;

        default:
          return defaultSize;
      }
    },
    useIconComponent: function useIconComponent() {
      return config.defaultIconComponent;
    }
  },
  methods: {
    addFAPrefix: function addFAPrefix(value) {
      if (this.useIconComponent) {
        return value;
      }

      return "fa-".concat(value);
    },

    /**
    * Equivalent FA icon name of the MDI.
    */
    getEquivalentIconOf: function getEquivalentIconOf(value) {
      // Only transform the class if the both prop is set to true
      if (!this.both) {
        return value;
      }

      switch (value) {
        case 'check':
          return 'check';

        case 'information':
          return 'info-circle';

        case 'check-circle':
          return 'check-circle';

        case 'alert':
          return 'exclamation-triangle';

        case 'alert-circle':
          return 'exclamation-circle';

        case 'arrow-up':
          return 'arrow-up';

        case 'chevron-right':
          return 'angle-right';

        case 'chevron-left':
          return 'angle-left';

        case 'chevron-down':
          return 'angle-down';

        case 'eye':
          return 'eye';

        case 'eye-off':
          return 'eye-slash';

        case 'menu-down':
          return 'caret-down';

        case 'menu-up':
          return 'caret-up';

        default:
          return value;
      }
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('span',{staticClass:"icon",class:[_vm.newType, _vm.size]},[(!_vm.useIconComponent)?_c('i',{class:[_vm.newPack, _vm.newIcon, _vm.newCustomSize, _vm.customClass]}):_c(_vm.useIconComponent,{tag:"component",class:[_vm.customClass],attrs:{"icon":[_vm.newPack, _vm.newIcon],"size":_vm.newCustomSize}})],1)};
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
  

  
  var Icon = __vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

export { Icon as I };
