'use strict';

var __chunk_1 = require('./chunk-9f6a8079.js');
var __chunk_5 = require('./chunk-d492406b.js');
var __chunk_6 = require('./chunk-13e039f5.js');

var script = {
  name: 'BPagination',
  components: __chunk_1._defineProperty({}, __chunk_5.Icon.name, __chunk_5.Icon),
  props: {
    total: [Number, String],
    perPage: {
      type: [Number, String],
      default: 20
    },
    current: {
      type: [Number, String],
      default: 1
    },
    rangeBefore: {
      type: [Number, String],
      default: 1
    },
    rangeAfter: {
      type: [Number, String],
      default: 1
    },
    size: String,
    simple: Boolean,
    rounded: Boolean,
    order: String,
    iconPack: String,
    ariaNextLabel: String,
    ariaPreviousLabel: String,
    ariaPageLabel: String,
    ariaCurrentLabel: String
  },
  computed: {
    rootClasses: function rootClasses() {
      return [this.order, this.size, {
        'is-simple': this.simple,
        'is-rounded': this.rounded
      }];
    },
    beforeCurrent: function beforeCurrent() {
      return parseInt(this.rangeBefore);
    },
    afterCurrent: function afterCurrent() {
      return parseInt(this.rangeAfter);
    },

    /**
    * Total page size (count).
    */
    pageCount: function pageCount() {
      return Math.ceil(this.total / this.perPage);
    },

    /**
    * First item of the page (count).
    */
    firstItem: function firstItem() {
      var firstItem = this.current * this.perPage - this.perPage + 1;
      return firstItem >= 0 ? firstItem : 0;
    },

    /**
    * Check if previous button is available.
    */
    hasPrev: function hasPrev() {
      return this.current > 1;
    },

    /**
    * Check if first page button should be visible.
    */
    hasFirst: function hasFirst() {
      return this.current >= 2 + this.beforeCurrent;
    },

    /**
    * Check if first ellipsis should be visible.
    */
    hasFirstEllipsis: function hasFirstEllipsis() {
      return this.current >= this.beforeCurrent + 4;
    },

    /**
    * Check if last page button should be visible.
    */
    hasLast: function hasLast() {
      return this.current <= this.pageCount - (1 + this.afterCurrent);
    },

    /**
    * Check if last ellipsis should be visible.
    */
    hasLastEllipsis: function hasLastEllipsis() {
      return this.current < this.pageCount - (2 + this.afterCurrent);
    },

    /**
    * Check if next button is available.
    */
    hasNext: function hasNext() {
      return this.current < this.pageCount;
    },

    /**
    * Get near pages, 1 before and 1 after the current.
    * Also add the click event to the array.
    */
    pagesInRange: function pagesInRange() {
      var _this = this;

      if (this.simple) return;
      var left = Math.max(1, this.current - this.beforeCurrent);

      if (left - 1 === 2) {
        left--; // Do not show the ellipsis if there is only one to hide
      }

      var right = Math.min(this.current + this.afterCurrent, this.pageCount);

      if (this.pageCount - right === 2) {
        right++; // Do not show the ellipsis if there is only one to hide
      }

      var pages = [];

      var _loop = function _loop(i) {
        pages.push({
          number: i,
          isCurrent: _this.current === i,
          click: function click(event) {
            if (_this.current === i) return;

            _this.$emit('change', i);

            _this.$emit('update:current', i); // Set focus on element to keep tab order


            _this.$nextTick(function () {
              return event.target.focus();
            });
          }
        });
      };

      for (var i = left; i <= right; i++) {
        _loop(i);
      }

      return pages;
    }
  },
  watch: {
    /**
    * If current page is trying to be greater than page count, set to last.
    */
    pageCount: function pageCount(value) {
      if (this.current > value) this.last();
    }
  },
  methods: {
    /**
    * Previous button click listener.
    */
    prev: function prev() {
      if (!this.hasPrev) return;
      this.$emit('change', this.current - 1);
      this.$emit('update:current', this.current - 1);
    },

    /**
    * First button click listener.
    */
    first: function first() {
      this.$emit('change', 1);
      this.$emit('update:current', 1);
    },

    /**
    * Last button click listener.
    */
    last: function last() {
      this.$emit('change', this.pageCount);
      this.$emit('update:current', this.pageCount);
    },

    /**
    * Next button click listener.
    */
    next: function next() {
      if (!this.hasNext) return;
      this.$emit('change', this.current + 1);
      this.$emit('update:current', this.current + 1);
    },

    /**
    * Get text for aria-label according to page number.
    */
    getAriaPageLabel: function getAriaPageLabel(pageNumber, isCurrent) {
      if (this.ariaPageLabel && (!isCurrent || !this.ariaCurrentLabel)) {
        return this.ariaPageLabel + ' ' + pageNumber + '.';
      } else if (this.ariaPageLabel && isCurrent && this.ariaCurrentLabel) {
        return this.ariaCurrentLabel + ', ' + this.ariaPageLabel + ' ' + pageNumber + '.';
      }

      return null;
    }
  }
};

/* script */
const __vue_script__ = script;

/* template */
var __vue_render__ = function () {var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;return _c('nav',{staticClass:"pagination",class:_vm.rootClasses},[_c('a',{staticClass:"pagination-previous",attrs:{"role":"button","href":"#","disabled":!_vm.hasPrev,"aria-label":_vm.ariaPreviousLabel},on:{"click":function($event){$event.preventDefault();_vm.prev($event);}}},[_c('b-icon',{attrs:{"icon":"chevron-left","pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),_c('a',{staticClass:"pagination-next",attrs:{"role":"button","href":"#","disabled":!_vm.hasNext,"aria-label":_vm.ariaNextLabel},on:{"click":function($event){$event.preventDefault();_vm.next($event);}}},[_c('b-icon',{attrs:{"icon":"chevron-right","pack":_vm.iconPack,"both":"","aria-hidden":"true"}})],1),_vm._v(" "),(!_vm.simple)?_c('ul',{staticClass:"pagination-list"},[(_vm.hasFirst)?_c('li',[_c('a',{staticClass:"pagination-link",attrs:{"role":"button","href":"#","aria-label":_vm.getAriaPageLabel(1, false)},on:{"click":function($event){$event.preventDefault();_vm.first($event);}}},[_vm._v("\n                1\n            ")])]):_vm._e(),_vm._v(" "),(_vm.hasFirstEllipsis)?_c('li',[_c('span',{staticClass:"pagination-ellipsis"},[_vm._v("…")])]):_vm._e(),_vm._v(" "),_vm._l((_vm.pagesInRange),function(page){return _c('li',{key:page.number},[_c('a',{staticClass:"pagination-link",class:{ 'is-current': page.isCurrent },attrs:{"role":"button","href":"#","aria-label":_vm.getAriaPageLabel(page.number, page.isCurrent),"aria-current":page.isCurrent},on:{"click":function($event){$event.preventDefault();page.click($event);}}},[_vm._v("\n                "+_vm._s(page.number)+"\n            ")])])}),_vm._v(" "),(_vm.hasLastEllipsis)?_c('li',[_c('span',{staticClass:"pagination-ellipsis"},[_vm._v("…")])]):_vm._e(),_vm._v(" "),(_vm.hasLast)?_c('li',[_c('a',{staticClass:"pagination-link",attrs:{"role":"button","href":"#","aria-label":_vm.getAriaPageLabel(_vm.pageCount, false)},on:{"click":function($event){$event.preventDefault();_vm.last($event);}}},[_vm._v("\n                "+_vm._s(_vm.pageCount)+"\n            ")])]):_vm._e()],2):_vm._e(),_vm._v(" "),(_vm.simple)?_c('small',{staticClass:"info"},[(_vm.perPage == 1)?[_vm._v("\n            "+_vm._s(_vm.firstItem)+" / "+_vm._s(_vm.total)+"\n        ")]:[_vm._v("\n            "+_vm._s(_vm.firstItem)+"-"+_vm._s(Math.min(_vm.current * _vm.perPage, _vm.total))+" / "+_vm._s(_vm.total)+"\n        ")]],2):_vm._e()])};
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
  

  
  var Pagination = __chunk_6.__vue_normalize__(
    { render: __vue_render__, staticRenderFns: __vue_staticRenderFns__ },
    __vue_inject_styles__,
    __vue_script__,
    __vue_scope_id__,
    __vue_is_functional_template__,
    __vue_module_identifier__,
    undefined,
    undefined
  );

exports.Pagination = Pagination;
