import { __extends } from 'tslib';
import { Component, createElement, render, createRef, Fragment, options, createContext as createContext$1 } from 'preact';

var globalObj = typeof globalThis !== 'undefined' ? globalThis : window; // // TODO: streamline when killing IE11 support
if (globalObj.FullCalendarVDom) {
    console.warn('FullCalendar VDOM already loaded');
}
else {
    globalObj.FullCalendarVDom = {
        Component: Component,
        createElement: createElement,
        render: render,
        createRef: createRef,
        Fragment: Fragment,
        createContext: createContext,
        flushToDom: flushToDom,
        unmountComponentAtNode: unmountComponentAtNode,
    };
}
// HACKS...
// TODO: lock version
// TODO: link gh issues
function flushToDom() {
    var oldDebounceRendering = options.debounceRendering; // orig
    var callbackQ = [];
    function execCallbackSync(callback) {
        callbackQ.push(callback);
    }
    options.debounceRendering = execCallbackSync;
    render(createElement(FakeComponent, {}), document.createElement('div'));
    while (callbackQ.length) {
        callbackQ.shift()();
    }
    options.debounceRendering = oldDebounceRendering;
}
var FakeComponent = /** @class */ (function (_super) {
    __extends(FakeComponent, _super);
    function FakeComponent() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    FakeComponent.prototype.render = function () { return createElement('div', {}); };
    FakeComponent.prototype.componentDidMount = function () { this.setState({}); };
    return FakeComponent;
}(Component));
function createContext(defaultValue) {
    var ContextType = createContext$1(defaultValue);
    var origProvider = ContextType.Provider;
    ContextType.Provider = function () {
        var _this = this;
        var isNew = !this.getChildContext;
        var children = origProvider.apply(this, arguments); // eslint-disable-line prefer-rest-params
        if (isNew) {
            var subs_1 = [];
            this.shouldComponentUpdate = function (_props) {
                if (_this.props.value !== _props.value) {
                    subs_1.forEach(function (c) {
                        c.context = _props.value;
                        c.forceUpdate();
                    });
                }
            };
            this.sub = function (c) {
                subs_1.push(c);
                var old = c.componentWillUnmount;
                c.componentWillUnmount = function () {
                    subs_1.splice(subs_1.indexOf(c), 1);
                    old && old.call(c);
                };
            };
        }
        return children;
    };
    return ContextType;
}
function unmountComponentAtNode(node) {
    render(null, node);
}
