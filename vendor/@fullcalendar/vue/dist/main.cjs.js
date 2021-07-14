'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var tslib = require('tslib');
var Vue = require('vue');
var core = require('@fullcalendar/core');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var Vue__default = /*#__PURE__*/_interopDefaultLegacy(Vue);

var OPTION_IS_COMPLEX = {
    headerToolbar: true,
    footerToolbar: true,
    events: true,
    eventSources: true,
    resources: true
};

// TODO: add types!
/*
works with objects and arrays
*/
function shallowCopy(val) {
    if (typeof val === 'object') {
        if (Array.isArray(val)) {
            val = Array.prototype.slice.call(val);
        }
        else if (val) { // non-null
            val = tslib.__assign({}, val);
        }
    }
    return val;
}
function mapHash(input, func) {
    var output = {};
    for (var key in input) {
        if (input.hasOwnProperty(key)) {
            output[key] = func(input[key], key);
        }
    }
    return output;
}

/*
wrap it in an object with a `vue` key, which the custom content-type handler system will look for
*/
function wrapVDomGenerator(vDomGenerator) {
    return function (props) {
        return { vue: vDomGenerator(props) };
    };
}
function createVueContentTypePlugin(parent) {
    return core.createPlugin({
        contentTypeHandlers: {
            vue: function () { return buildVDomHandler(parent); }, // looks for the `vue` key
        }
    });
}
function buildVDomHandler(parent) {
    var currentEl;
    var v; // the Vue instance
    function render(el, vDomContent) {
        if (currentEl !== el) {
            if (currentEl && v) { // if changing elements, recreate the vue
                v.$destroy();
            }
            currentEl = el;
        }
        if (!v) {
            v = initVue(vDomContent, parent);
            // vue's mount method *replaces* the given element. create an artificial inner el
            var innerEl = document.createElement('span');
            el.appendChild(innerEl);
            v.$mount(innerEl);
        }
        else {
            v.content = vDomContent;
        }
    }
    function destroy() {
        if (v) { // needed?
            v.$destroy();
        }
    }
    return { render: render, destroy: destroy };
}
function initVue(initialContent, parent) {
    return new Vue__default['default']({
        parent: parent,
        data: {
            content: initialContent,
        },
        render: function (h) {
            var content = this.content;
            // the slot result can be an array, but the returned value of a vue component's
            // render method must be a single node.
            if (content.length === 1) {
                return content[0];
            }
            else {
                return h('span', {}, content);
            }
        }
    });
}

var FullCalendar = Vue__default['default'].extend({
    props: {
        options: Object
    },
    data: initData,
    render: function (createElement) {
        return createElement('div', {
            // when renderId is changed, Vue will trigger a real-DOM async rerender, calling beforeUpdate/updated
            attrs: { 'data-fc-render-id': this.renderId }
        });
    },
    mounted: function () {
        var internal = this.$options;
        internal.scopedSlotOptions = mapHash(this.$scopedSlots, wrapVDomGenerator); // needed for buildOptions
        var calendar = new core.Calendar(this.$el, this.buildOptions(this.options, this));
        internal.calendar = calendar;
        calendar.render();
    },
    methods: {
        getApi: getApi,
        buildOptions: buildOptions,
    },
    beforeUpdate: function () {
        this.getApi().resumeRendering(); // the watcher handlers paused it
    },
    beforeDestroy: function () {
        this.getApi().destroy();
    },
    watch: buildWatchers()
});
function initData() {
    return {
        renderId: 0
    };
}
function buildOptions(suppliedOptions, parent) {
    var internal = this.$options;
    suppliedOptions = suppliedOptions || {};
    return tslib.__assign(tslib.__assign(tslib.__assign({}, internal.scopedSlotOptions), suppliedOptions), { plugins: (suppliedOptions.plugins || []).concat([
            createVueContentTypePlugin(parent)
        ]) });
}
function getApi() {
    var internal = this.$options;
    return internal.calendar;
}
function buildWatchers() {
    var watchers = {
        // watches changes of ALL options and their nested objects,
        // but this is only a means to be notified of top-level non-complex options changes.
        options: {
            deep: true,
            handler: function (options) {
                var calendar = this.getApi();
                calendar.pauseRendering();
                calendar.resetOptions(this.buildOptions(options, this));
                this.renderId++; // will queue a rerender
            }
        }
    };
    var _loop_1 = function (complexOptionName) {
        // handlers called when nested objects change
        watchers["options." + complexOptionName] = {
            deep: true,
            handler: function (val) {
                var _a;
                // unfortunately the handler is called with undefined if new props were set, but the complex one wasn't ever set
                if (val !== undefined) {
                    var calendar = this.getApi();
                    calendar.pauseRendering();
                    calendar.resetOptions((_a = {},
                        // the only reason we shallow-copy is to trick FC into knowing there's a nested change.
                        // TODO: future versions of FC will more gracefully handle event option-changes that are same-reference.
                        _a[complexOptionName] = shallowCopy(val),
                        _a), true);
                    this.renderId++; // will queue a rerender
                }
            }
        };
    };
    for (var complexOptionName in OPTION_IS_COMPLEX) {
        _loop_1(complexOptionName);
    }
    return watchers;
}

/*
Registers the component globally if appropriate.
This modules exposes the component AND an install function.

Derived from:
https://vuejs.org/v2/cookbook/packaging-sfc-for-npm.html
*/
var installed = false;
// declare install function executed by Vue.use()
function install(Vue) {
    if (!installed) {
        installed = true;
        Vue.component('FullCalendar', FullCalendar);
    }
}
// detect a globally availble version of Vue (eg. in browser via <script> tag)
var GlobalVue;
if (typeof globalThis !== 'undefined') {
    GlobalVue = globalThis.Vue;
}
else {
    GlobalVue = window.Vue;
}
// auto-install if possible
if (GlobalVue) {
    GlobalVue.use({
        install: install
    });
}

exports.default = FullCalendar;
exports.install = install;
Object.keys(core).forEach(function (k) {
    if (k !== 'default' && !exports.hasOwnProperty(k)) Object.defineProperty(exports, k, {
        enumerable: true,
        get: function () {
            return core[k];
        }
    });
});
