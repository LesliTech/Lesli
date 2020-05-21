import { _ as _defineProperty } from './chunk-1fafdf15.js';
import { merge, sign } from './helpers.js';
import { c as config } from './chunk-6985c8ce.js';
import { I as Icon } from './chunk-cdfca85b.js';
import { _ as __vue_normalize__, r as registerComponent, u as use } from './chunk-cca88db8.js';

var script = {
  name: 'BCarousel',
  components: _defineProperty({}, Icon.name, Icon),
  props: {
    value: {
      type: Number,
      default: 0
    },
    animated: {
      type: String,
      default: 'slide'
    },
    interval: Number,
    hasDrag: {
      type: Boolean,
      default: true
    },
    autoplay: {
      type: Boolean,
      default: true
    },
    pauseHover: {
      type: Boolean,
      default: true
    },
    pauseInfo: {
      type: Boolean,
      default: true
    },
    pauseInfoType: {
      type: String,
      default: 'is-white'
    },
    pauseText: {
      type: String,
      default: 'Pause'
    },
    arrow: {
      type: Boolean,
      default: true
    },
    arrowBoth: {
      type: Boolean,
      default: true
    },
    arrowHover: {
      type: Boolean,
      default: true
    },
    repeat: {
      type: Boolean,
      default: true
    },
    iconPack: String,
    iconSize: String,
    iconPrev: {
      type: String,
      default: function _default() {
        return config.defaultIconPrev;
      }
    },
    iconNext: {
      type: String,
      default: function _default() {
        return config.defaultIconNext;
      }
    },
    indicator: {
      type: Boolean,
      default: true
    },
    indicatorBackground: Boolean,
    indicatorCustom: Boolean,
    indicatorCustomSize: {
      type: String,
      default: 'is-small'
    },
    indicatorInside: {
      type: Boolean,
      default: true
    },
    indicatorMode: {
      type: String,
      default: 'click'
    },
    indicatorPosition: {
      type: String,
      default: 'is-bottom'
    },
    indicatorStyle: {
      type: String,
      default: 'is-dots'
    },
    overlay: Boolean,
    progress: Boolean,
    progressType: {
      type: String,
      default: 'is-primary'
    },
    withCarouselList: Boolean
  },
  data: function data() {
    return {
      _isCarousel: true,
      activeItem: this.value,
      carouselItems: [],
      isPause: false,
      dragX: 0,
      timer: null
    };
  },
  computed: {
    indicatorClasses: function indicatorClasses() {
      return [{
        'has-background': this.indicatorBackground,
        'has-custom': this.indicatorCustom,
        'is-inside': this.indicatorInside
      }, this.indicatorCustom && this.indicatorCustomSize, this.indicatorInside && this.indicatorPosition];
    }
  },
  watch: {
    /**
     * When v-model is changed set the new active item.
     */
    value: function value(_value) {
      if (_value < this.activeItem) {
        this.changeItem(_value);
      } else {
        this.changeItem(_value, false);
      }
    },

    /**
     * When carousel-items are updated, set active one.
     */
    carouselItems: function carouselItems() {
      if (this.activeItem < this.carouselItems.length) {
        this.carouselItems[this.activeItem].isActive = true;
      }
    },

    /**
     *  When autoplay is change, set by status
     */
    autoplay: function autoplay(status) {
      status ? this.startTimer() : this.pauseTimer();
    }
  },
  methods: {
    startTimer: function startTimer() {
      var _this = this;

      if (!this.autoplay || this.timer) return;
      this.isPause = false;
      this.timer = setInterval(function () {
        if (!_this.repeat && _this.activeItem === _this.carouselItems.length - 1) {
          _this.pauseTimer();
        } else {
          _this.next();
        }
      }, this.interval || config.defaultCarouselInterval);
    },
    pauseTimer: function pauseTimer() {
      this.isPause = true;

      if (this.timer) {
        clearInterval(this.timer);
        this.timer = null;
      }
    },
    checkPause: function checkPause() {
      if (this.pauseHover && this.autoplay) {
        return this.pauseTimer();
      }
    },

    /**
     * Change the active item and emit change event.
     * action only for animated slide, there true = next, false = prev
     */
    changeItem: function changeItem(newIndex) {
      var action = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
      if (this.activeItem === newIndex) return;

      if (this.activeItem < this.carouselItems.length) {
        this.carouselItems[this.activeItem].status(false, action);
      }

      this.carouselItems[newIndex].status(true, action);
      this.activeItem = newIndex;
      this.$emit('change', newIndex);
    },
    // Indicator trigger when change active item.
    modeChange: function modeChange(trigger, value) {
      if (this.indicatorMode === trigger) {
        this.$emit('input', value);
        return value < this.activeItem ? this.changeItem(value) : this.changeItem(value, false);
      }
    },
    prev: function prev() {
      if (this.activeItem === 0) {
        if (this.repeat) this.changeItem(this.carouselItems.length - 1);
      } else {
        this.changeItem(this.activeItem - 1);
      }
    },
    next: function next() {
      if (this.activeItem === this.carouselItems.length - 1) {
        if (this.repeat) this.changeItem(0, false);
      } else {
        this.changeItem(this.activeItem + 1, false);
      }
    },
    // checking arrow between both
    checkArrow: function checkArrow(value) {
      if (this.arrowBoth) return true;
      if (this.activeItem !== value) return true;
    },
    // handle drag event
    dragStart: function dragStart(event) {
      if (!this.hasDrag) return;
      this.dragx = event.touches ? event.changedTouches[0].pageX : event.pageX;

      if (event.touches) {
        this.pauseTimer();
      } else {
        event.preventDefault();
      }
    },
    dragEnd: function dragEnd(event) {
      if (!this.hasDrag) return;
      var detected = event.touches ? event.changedTouches[0].pageX : event.pageX;
      var diffX = detected - this.dragx;

      if (Math.abs(diffX) > 50) {
        if (diffX < 0) {
          this.next();
        } else {
          this.prev();
        }
      }

      if (event.touches) {
        this.startTimer();
      }
    }
  },
  mounted: function mounted() {
    if (this.activeItem < this.carouselItems.length) {
      this.carouselItems[this.activeItem].isActive = true;
    }

    this.startTimer();
  },
  beforeDestroy: function beforeDestroy() {
    this.pauseTimer();
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"carousel",class:{'is-overlay': _vm.overlay},on:{"mouseenter":_vm.pauseTimer,"mouseleave":_vm.startTimer}},[(_vm.progress)?_c('progress',{staticClass:"progress",class:_vm.progressType,attrs:{"max":_vm.carouselItems.length - 1},domProps:{"value":_vm.activeItem}},[_vm._v("\r\n            "+_vm._s(_vm.carouselItems.length - 1)+"\r\n        ")]):_vm._e(),_vm._v(" "),_c('div',{staticClass:"carousel-items",on:{"mousedown":_vm.dragStart,"mouseup":_vm.dragEnd,"touchstart":function($event){$event.stopPropagation();return _vm.dragStart($event)},"touchend":function($event){$event.stopPropagation();return _vm.dragEnd($event)}}},[_vm._t("default"),_vm._v(" "),(_vm.arrow)?_c('div',{staticClass:"carousel-arrow",class:{'is-hovered': _vm.arrowHover}},[(_vm.checkArrow(0))?_c('b-icon',{staticClass:"has-icons-left",attrs:{"pack":_vm.iconPack,"icon":_vm.iconPrev,"size":_vm.iconSize,"both":""},nativeOn:{"click":function($event){$event.preventDefault();return _vm.prev($event)}}}):_vm._e(),_vm._v(" "),(_vm.checkArrow(_vm.carouselItems.length - 1))?_c('b-icon',{staticClass:"has-icons-right",attrs:{"pack":_vm.iconPack,"icon":_vm.iconNext,"size":_vm.iconSize,"both":""},nativeOn:{"click":function($event){$event.preventDefault();return _vm.next($event)}}}):_vm._e()],1):_vm._e()],2),_vm._v(" "),(_vm.autoplay && _vm.pauseHover && _vm.pauseInfo && _vm.isPause)?_c('div',{staticClass:"carousel-pause"},[_c('span',{staticClass:"tag",class:_vm.pauseInfoType},[_vm._v("\r\n                "+_vm._s(_vm.pauseText)+"\r\n            ")])]):_vm._e(),_vm._v(" "),(_vm.withCarouselList && !_vm.indicator)?[_vm._t("list",null,{active:_vm.activeItem,switch:_vm.changeItem})]:_vm._e(),_vm._v(" "),(_vm.indicator)?_c('div',{staticClass:"carousel-indicator",class:_vm.indicatorClasses},_vm._l((_vm.carouselItems),function(item,index){return _c('a',{key:index,staticClass:"indicator-item",class:{'is-active': index === _vm.activeItem},on:{"mouseover":function($event){_vm.modeChange('hover', index);},"click":function($event){_vm.modeChange('click', index);}}},[_vm._t("indicators",[_c('span',{staticClass:"indicator-style",class:_vm.indicatorStyle})],{i:index})],2)})):_vm._e(),_vm._v(" "),(_vm.overlay)?[_vm._t("overlay")]:_vm._e()],2)};
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
  

  
  var Carousel = __vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
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
var script$1 = {
  name: 'BCarouselItem',
  data: function data() {
    return {
      isActive: false,
      transitionName: null
    };
  },
  computed: {
    transition: function transition() {
      if (this.$parent.animated === 'fade') {
        return 'fade';
      } else {
        return this.transitionName;
      }
    }
  },
  methods: {
    /**
    * Status of item, alter animation name based on action.
    */
    status: function status(value, action) {
      this.transitionName = action ? 'slide-next' : 'slide-prev';
      this.isActive = value;
    }
  },
  created: function created() {
    if (!this.$parent.$data._isCarousel) {
      this.$destroy();
      throw new Error('You should wrap bCarouselItem on a bCarousel');
    }

    this.$parent.carouselItems.push(this);
  },
  beforeDestroy: function beforeDestroy() {
    var index = this.$parent.carouselItems.indexOf(this);

    if (index >= 0) {
      this.$parent.carouselItems.splice(index, 1);
    }
  }
};

/* script */
const __vue_script__$1 = script$1;

/* template */
var __vue_render__$1 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('transition',{attrs:{"name":_vm.transition}},[_c('div',{directives:[{name:"show",rawName:"v-show",value:(_vm.isActive),expression:"isActive"}],staticClass:"carousel-item"},[_vm._t("default")],2)])};
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
  

  
  var CarouselItem = __vue_normalize__(
    { render: __vue_render__$1, staticRenderFns: __vue_staticRenderFns__$1 },
    __vue_inject_styles__$1,
    __vue_script__$1,
    __vue_scope_id__$1,
    __vue_is_functional_template__$1,
    __vue_module_identifier__$1,
    undefined,
    undefined
  );

var script$2 = {
  name: 'BCarouselList',
  components: _defineProperty({}, Icon.name, Icon),
  props: {
    config: {
      type: Object,
      default: function _default() {
        return {};
      }
    },
    data: {
      type: Array,
      default: function _default() {
        return [];
      }
    },
    value: {
      type: Number,
      default: 0
    },
    hasDrag: {
      type: Boolean,
      default: true
    },
    hasGrayscale: Boolean,
    hasOpacity: Boolean,
    repeat: Boolean,
    itemsToShow: {
      type: Number,
      default: 4
    },
    itemsToList: {
      type: Number,
      default: 1
    },
    asIndicator: Boolean,
    arrow: {
      type: Boolean,
      default: true
    },
    arrowHover: {
      type: Boolean,
      default: true
    },
    iconPack: String,
    iconSize: String,
    iconPrev: {
      type: String,
      default: function _default() {
        return config.defaultIconPrev;
      }
    },
    iconNext: {
      type: String,
      default: function _default() {
        return config.defaultIconNext;
      }
    },
    refresh: Boolean
  },
  data: function data() {
    return {
      activeItem: this.value,
      breakpoints: {},
      delta: 0,
      dragging: false,
      hold: 0,
      itemWidth: 0,
      settings: {}
    };
  },
  computed: {
    listClass: function listClass() {
      return [{
        'has-grayscale': this.settings.hasGrayscale || this.hasGrayscale,
        'has-opacity': this.settings.hasOpacity || this.hasOpacity,
        'is-dragging': this.dragging
      }];
    },
    itemStyle: function itemStyle() {
      return "width: ".concat(this.itemWidth, "px;");
    },
    transformStyle: function transformStyle() {
      var translate = this.delta + 1 * (this.activeItem * this.itemWidth);
      var result = this.dragging ? -translate : -Math.abs(translate);
      return "transform: translateX(".concat(result, "px);");
    },
    total: function total() {
      return this.data.length - 1;
    }
  },
  watch: {
    /**
     * When v-model is changed set the new active item.
     */
    value: function value(_value) {
      this.switchTo(_value);
    },

    /**
     * Only for overlay and as indicator.
     * when call overlay with click.
     */
    refresh: function refresh(status) {
      if (status && this.asIndicator) {
        this.getWidth();
      }
    },
    '$props': {
      handler: function handler(value) {
        this.initConfig();
        this.update();
      },
      deep: true
    }
  },
  methods: {
    initConfig: function initConfig() {
      this.breakpoints = this.config.breakpoints;
      this.settings = merge(this.$props, this.config, true);
    },
    getWidth: function getWidth() {
      var rect = this.$el.getBoundingClientRect();
      this.itemWidth = rect.width / this.settings.itemsToShow;
    },
    update: function update() {
      if (this.breakpoints) {
        this.updateConfig();
      }

      this.getWidth();
    },
    updateConfig: function updateConfig() {
      var _this = this;

      var breakpoints = Object.keys(this.breakpoints).sort(function (a, b) {
        return b - a;
      });
      var checking;
      breakpoints.some(function (breakpoint) {
        checking = window.matchMedia("(min-width: ".concat(breakpoint, "px)")).matches;

        if (checking) {
          _this.settings = _this.config.breakpoints[breakpoint];
          return true;
        }
      });

      if (!checking) {
        this.settings = this.config;
      }
    },
    switchTo: function switchTo(newIndex) {
      if (newIndex < 0 || this.activeItem === newIndex || !this.repeat && newIndex > this.total) return;
      var result = this.repeat && newIndex > this.total ? 0 : newIndex;
      this.activeItem = result;
      this.$emit('switch', result);
    },
    next: function next() {
      this.switchTo(this.activeItem + this.itemsToList);
    },
    prev: function prev() {
      this.switchTo(this.activeItem - this.itemsToList);
    },
    checkArrow: function checkArrow(value) {
      if (this.repeat || this.activeItem !== value) return true;
    },
    checkAsIndicator: function checkAsIndicator(value, e) {
      if (!this.asIndicator) return;
      var timeCheck = new Date().getTime(); // al solution: holding, 100 - 400 not 100% but 200 is better!

      if (!e.touches && timeCheck - this.hold > 200) return;
      this.switchTo(value);
    },
    // handle drag event
    dragStart: function dragStart(event) {
      if (!this.hasDrag || event.button !== 0 && event.type !== 'touchstart') return;
      this.hold = new Date().getTime();
      this.dragging = true;
      this.dragStartX = event.touches ? event.touches[0].clientX : event.clientX;
      window.addEventListener(event.touches ? 'touchmove' : 'mousemove', this.dragMove);
      window.addEventListener(event.touches ? 'touchend' : 'mouseup', this.dragEnd);
    },
    dragMove: function dragMove(event) {
      this.dragEndX = event.touches ? event.touches[0].clientX : event.clientX;
      var deltaX = this.dragEndX - this.dragStartX;
      this.delta = deltaX < 0 ? Math.abs(deltaX) : -Math.abs(deltaX);

      if (!event.touches) {
        event.preventDefault();
      }
    },
    dragEnd: function dragEnd(event) {
      var signCheck = 1 * sign(this.delta);
      var results = Math.round(Math.abs(this.delta / this.itemWidth) + 0.15); // Hack

      this.switchTo(this.activeItem + signCheck * results);
      this.dragging = false;
      this.delta = 0;
      window.removeEventListener(event.touches ? 'touchmove' : 'mousemove', this.dragMove);
      window.removeEventListener(event.touches ? 'touchend' : 'mouseup', this.dragEnd);
    }
  },
  created: function created() {
    this.initConfig();

    if (typeof window !== 'undefined') {
      window.addEventListener('resize', this.update);
    }
  },
  mounted: function mounted() {
    var _this2 = this;

    this.$nextTick(function () {
      _this2.update();
    });
  },
  beforeDestroy: function beforeDestroy() {
    if (typeof window !== 'undefined') {
      window.removeEventListener('resize', this.update);
    }
  }
};

/* script */
const __vue_script__$2 = script$2;

/* template */
var __vue_render__$2 = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('div',{staticClass:"carousel-list",class:{'has-shadow': _vm.activeItem > 0},on:{"mousedown":function($event){$event.stopPropagation();$event.preventDefault();return _vm.dragStart($event)},"touchstart":_vm.dragStart}},[_c('div',{staticClass:"carousel-slides",class:_vm.listClass,style:(_vm.transformStyle)},_vm._l((_vm.data),function(list,index){return _c('div',{key:index,staticClass:"carousel-slide",class:{'is-active': _vm.activeItem === index},style:(_vm.itemStyle),on:{"click":function($event){_vm.checkAsIndicator(index, $event);}}},[_vm._t("item",[_c('figure',{staticClass:"image"},[_c('img',{attrs:{"src":list.image,"title":list.title}})])],{list:list,index:index,active:_vm.activeItem})],2)})),_vm._v(" "),(_vm.arrow)?_c('div',{staticClass:"carousel-arrow",class:{'is-hovered': _vm.arrowHover}},[_c('b-icon',{directives:[{name:"show",rawName:"v-show",value:(_vm.activeItem > 0),expression:"activeItem > 0"}],staticClass:"has-icons-left",attrs:{"pack":_vm.iconPack,"icon":_vm.iconPrev,"size":_vm.iconSize,"both":""},nativeOn:{"click":function($event){$event.preventDefault();return _vm.prev($event)}}}),_vm._v(" "),_c('b-icon',{directives:[{name:"show",rawName:"v-show",value:(_vm.checkArrow(_vm.total)),expression:"checkArrow(total)"}],staticClass:"has-icons-right",attrs:{"pack":_vm.iconPack,"icon":_vm.iconNext,"size":_vm.iconSize,"both":""},nativeOn:{"click":function($event){$event.preventDefault();return _vm.next($event)}}})],1):_vm._e()])};
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
  

  
  var CarouselList = __vue_normalize__(
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
    registerComponent(Vue, Carousel);
    registerComponent(Vue, CarouselItem);
    registerComponent(Vue, CarouselList);
  }
};
use(Plugin);

export default Plugin;
export { Carousel as BCarousel, CarouselItem as BCarouselItem, CarouselList as BCarouselList };
