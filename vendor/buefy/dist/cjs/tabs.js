'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var __chunk_1 = require('./chunk-9f6a8079.js');
require('./chunk-545f01b1.js');
var __chunk_5 = require('./chunk-60061aa8.js');
var __chunk_6 = require('./chunk-13e039f5.js');
var __chunk_20 = require('./chunk-3dffe6e7.js');

var _components;
var script = {
  name: 'BTabs',
  components: (_components = {}, __chunk_1._defineProperty(_components, __chunk_5.Icon.name, __chunk_5.Icon), __chunk_1._defineProperty(_components, __chunk_20.SlotComponent.name, __chunk_20.SlotComponent), _components),
  props: {
    value: Number,
    expanded: Boolean,
    type: String,
    size: String,
    position: String,
    animated: {
      type: Boolean,
      default: true
    },
    destroyOnHide: {
      type: Boolean,
      default: false
    }
  },
  data: function data() {
    return {
      activeTab: this.value || 0,
      tabItems: [],
      contentHeight: 0,
      isTransitioning: false,
      _isTabs: true // Used internally by TabItem

    };
  },
  computed: {
    navClasses: function navClasses() {
      return [this.type, this.size, this.position, {
        'is-fullwidth': this.expanded,
        'is-toggle-rounded is-toggle': this.type === 'is-toggle-rounded'
      }];
    }
  },
  watch: {
    /**
    * When v-model is changed set the new active tab.
    */
    value: function value(_value) {
      this.changeTab(_value);
    },

    /**
    * When tab-items are updated, set active one.
    */
    tabItems: function tabItems() {
      if (this.activeTab < this.tabItems.length) {
        this.tabItems[this.activeTab].isActive = true;
      }
    }
  },
  methods: {
    /**
    * Change the active tab and emit change event.
    */
    changeTab: function changeTab(newIndex) {
      if (this.activeTab === newIndex) return;

      if (this.activeTab < this.tabItems.length) {
        this.tabItems[this.activeTab].deactivate(this.activeTab, newIndex);
      }

      this.tabItems[newIndex].activate(this.activeTab, newIndex);
      this.activeTab = newIndex;
      this.$emit('change', newIndex);
    },

    /**
    * Tab click listener, emit input event and change active tab.
    */
    tabClick: function tabClick(value) {
      this.$emit('input', value);
      this.changeTab(value);
    }
  },
  mounted: function mounted() {
    if (this.activeTab < this.tabItems.length) {
      this.tabItems[this.activeTab].isActive = true;
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"b-tabs",class:{ 'is-fullwidth': _vm.expanded }},[_c('nav',{staticClass:"tabs",class:_vm.navClasses},[_c('ul',_vm._l((_vm.tabItems),function(tabItem,index){return _c('li',{directives:[{name:"show",rawName:"v-show",value:(tabItem.visible),expression:"tabItem.visible"}],key:index,class:{ 'is-active': _vm.activeTab === index, 'is-disabled': tabItem.disabled }},[_c('a',{on:{"click":function($event){_vm.tabClick(index);}}},[(tabItem.$slots.header)?[_c('b-slot-component',{attrs:{"component":tabItem,"name":"header","tag":"span"}})]:[(tabItem.icon)?_c('b-icon',{attrs:{"icon":tabItem.icon,"pack":tabItem.iconPack,"size":_vm.size}}):_vm._e(),_vm._v(" "),_c('span',[_vm._v(_vm._s(tabItem.label))])]],2)])}))]),_vm._v(" "),_c('section',{staticClass:"tab-content",class:{'is-transitioning': _vm.isTransitioning}},[_vm._t("default")],2)])};
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
  

  
  var Tabs = __chunk_6.__vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

var script$1 = {
  name: 'BTabItem',
  props: {
    label: String,
    icon: String,
    iconPack: String,
    disabled: Boolean,
    visible: {
      type: Boolean,
      default: true
    }
  },
  data: function data() {
    return {
      isActive: false,
      transitionName: null
    };
  },
  methods: {
    /**
    * Activate tab, alter animation name based on the index.
    */
    activate: function activate(oldIndex, index) {
      this.transitionName = index < oldIndex ? 'slide-next' : 'slide-prev';
      this.isActive = true;
    },

    /**
    * Deactivate tab, alter animation name based on the index.
    */
    deactivate: function deactivate(oldIndex, index) {
      this.transitionName = index < oldIndex ? 'slide-next' : 'slide-prev';
      this.isActive = false;
    }
  },
  created: function created() {
    if (!this.$parent.$data._isTabs) {
      this.$destroy();
      throw new Error('You should wrap bTabItem on a bTabs');
    }

    this.$parent.tabItems.push(this);
  },
  beforeDestroy: function beforeDestroy() {
    var index = this.$parent.tabItems.indexOf(this);

    if (index >= 0) {
      this.$parent.tabItems.splice(index, 1);
    }
  },
  render: function render(createElement) {
    var _this = this;

    // if destroy apply v-if
    if (this.$parent.destroyOnHide) {
      if (!this.isActive || !this.visible) {
        return;
      }
    }

    var vnode = createElement('div', {
      directives: [{
        name: 'show',
        value: this.isActive && this.visible
      }],
      attrs: {
        'class': 'tab-item'
      }
    }, this.$slots.default); // check animated prop

    if (this.$parent.animated) {
      return createElement('transition', {
        props: {
          'name': this.transitionName
        },
        on: {
          'before-enter': function beforeEnter() {
            _this.$parent.isTransitioning = true;
          },
          'after-enter': function afterEnter() {
            _this.$parent.isTransitioning = false;
          }
        }
      }, [vnode]);
    }

    return vnode;
  }
};

/* script */
const __vue_script__$1 = script$1;

/* template */

  /* style */
  const __vue_inject_styles__$1 = undefined;
  /* scoped */
  const __vue_scope_id__$1 = undefined;
  /* module identifier */
  const __vue_module_identifier__$1 = undefined;
  /* functional template */
  const __vue_is_functional_template__$1 = undefined;
  /* style inject */
  
  /* style inject SSR */
  

  
  var TabItem = __chunk_6.__vue_normalize__(
    {},
    __vue_inject_styles__$1,
    __vue_script__$1,
    __vue_scope_id__$1,
    __vue_is_functional_template__$1,
    __vue_module_identifier__$1,
    undefined,
    undefined
  );

var Plugin = {
  install: function install(Vue) {
    __chunk_6.registerComponent(Vue, Tabs);
    __chunk_6.registerComponent(Vue, TabItem);
  }
};
__chunk_6.use(Plugin);

exports.TabItem = TabItem;
exports.Tabs = Tabs;
exports.default = Plugin;
