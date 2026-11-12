true&&(function polyfill() {
    const relList = document.createElement('link').relList;
    if (relList && relList.supports && relList.supports('modulepreload')) {
        return;
    }
    for (const link of document.querySelectorAll('link[rel="modulepreload"]')) {
        processPreload(link);
    }
    new MutationObserver((mutations) => {
        for (const mutation of mutations) {
            if (mutation.type !== 'childList') {
                continue;
            }
            for (const node of mutation.addedNodes) {
                if (node.tagName === 'LINK' && node.rel === 'modulepreload')
                    processPreload(node);
            }
        }
    }).observe(document, { childList: true, subtree: true });
    function getFetchOpts(link) {
        const fetchOpts = {};
        if (link.integrity)
            fetchOpts.integrity = link.integrity;
        if (link.referrerPolicy)
            fetchOpts.referrerPolicy = link.referrerPolicy;
        if (link.crossOrigin === 'use-credentials')
            fetchOpts.credentials = 'include';
        else if (link.crossOrigin === 'anonymous')
            fetchOpts.credentials = 'omit';
        else
            fetchOpts.credentials = 'same-origin';
        return fetchOpts;
    }
    function processPreload(link) {
        if (link.ep)
            // ep marker = processed
            return;
        link.ep = true;
        // prepopulate the load record
        const fetchOpts = getFetchOpts(link);
        fetch(link.href, fetchOpts);
    }
}());

function getDefaultExportFromCjs (x) {
	return x && x.__esModule && Object.prototype.hasOwnProperty.call(x, 'default') ? x['default'] : x;
}

var jsxRuntime = {exports: {}};

var reactJsxRuntime_production_min = {};

var react = {exports: {}};

var react_production_min = {};

/**
 * @license React
 * react.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
var l$1=Symbol.for("react.element"),n$1=Symbol.for("react.portal"),p$2=Symbol.for("react.fragment"),q$1=Symbol.for("react.strict_mode"),r=Symbol.for("react.profiler"),t=Symbol.for("react.provider"),u=Symbol.for("react.context"),v$1=Symbol.for("react.forward_ref"),w=Symbol.for("react.suspense"),x=Symbol.for("react.memo"),y=Symbol.for("react.lazy"),z$1=Symbol.iterator;function A$1(a){if(null===a||"object"!==typeof a)return null;a=z$1&&a[z$1]||a["@@iterator"];return "function"===typeof a?a:null}
var B$1={isMounted:function(){return !1},enqueueForceUpdate:function(){},enqueueReplaceState:function(){},enqueueSetState:function(){}},C$1=Object.assign,D$1={};function E$1(a,b,e){this.props=a;this.context=b;this.refs=D$1;this.updater=e||B$1;}E$1.prototype.isReactComponent={};
E$1.prototype.setState=function(a,b){if("object"!==typeof a&&"function"!==typeof a&&null!=a)throw Error("setState(...): takes an object of state variables to update or a function which returns an object of state variables.");this.updater.enqueueSetState(this,a,b,"setState");};E$1.prototype.forceUpdate=function(a){this.updater.enqueueForceUpdate(this,a,"forceUpdate");};function F(){}F.prototype=E$1.prototype;function G$1(a,b,e){this.props=a;this.context=b;this.refs=D$1;this.updater=e||B$1;}var H$1=G$1.prototype=new F;
H$1.constructor=G$1;C$1(H$1,E$1.prototype);H$1.isPureReactComponent=!0;var I$1=Array.isArray,J=Object.prototype.hasOwnProperty,K$1={current:null},L$1={key:!0,ref:!0,__self:!0,__source:!0};
function M$1(a,b,e){var d,c={},k=null,h=null;if(null!=b)for(d in void 0!==b.ref&&(h=b.ref),void 0!==b.key&&(k=""+b.key),b)J.call(b,d)&&!L$1.hasOwnProperty(d)&&(c[d]=b[d]);var g=arguments.length-2;if(1===g)c.children=e;else if(1<g){for(var f=Array(g),m=0;m<g;m++)f[m]=arguments[m+2];c.children=f;}if(a&&a.defaultProps)for(d in g=a.defaultProps,g)void 0===c[d]&&(c[d]=g[d]);return {$$typeof:l$1,type:a,key:k,ref:h,props:c,_owner:K$1.current}}
function N$2(a,b){return {$$typeof:l$1,type:a.type,key:b,ref:a.ref,props:a.props,_owner:a._owner}}function O$1(a){return "object"===typeof a&&null!==a&&a.$$typeof===l$1}function escape(a){var b={"=":"=0",":":"=2"};return "$"+a.replace(/[=:]/g,function(a){return b[a]})}var P$1=/\/+/g;function Q$1(a,b){return "object"===typeof a&&null!==a&&null!=a.key?escape(""+a.key):b.toString(36)}
function R$1(a,b,e,d,c){var k=typeof a;if("undefined"===k||"boolean"===k)a=null;var h=!1;if(null===a)h=!0;else switch(k){case "string":case "number":h=!0;break;case "object":switch(a.$$typeof){case l$1:case n$1:h=!0;}}if(h)return h=a,c=c(h),a=""===d?"."+Q$1(h,0):d,I$1(c)?(e="",null!=a&&(e=a.replace(P$1,"$&/")+"/"),R$1(c,b,e,"",function(a){return a})):null!=c&&(O$1(c)&&(c=N$2(c,e+(!c.key||h&&h.key===c.key?"":(""+c.key).replace(P$1,"$&/")+"/")+a)),b.push(c)),1;h=0;d=""===d?".":d+":";if(I$1(a))for(var g=0;g<a.length;g++){k=
a[g];var f=d+Q$1(k,g);h+=R$1(k,b,e,f,c);}else if(f=A$1(a),"function"===typeof f)for(a=f.call(a),g=0;!(k=a.next()).done;)k=k.value,f=d+Q$1(k,g++),h+=R$1(k,b,e,f,c);else if("object"===k)throw b=String(a),Error("Objects are not valid as a React child (found: "+("[object Object]"===b?"object with keys {"+Object.keys(a).join(", ")+"}":b)+"). If you meant to render a collection of children, use an array instead.");return h}
function S$1(a,b,e){if(null==a)return a;var d=[],c=0;R$1(a,d,"","",function(a){return b.call(e,a,c++)});return d}function T$1(a){if(-1===a._status){var b=a._result;b=b();b.then(function(b){if(0===a._status||-1===a._status)a._status=1,a._result=b;},function(b){if(0===a._status||-1===a._status)a._status=2,a._result=b;});-1===a._status&&(a._status=0,a._result=b);}if(1===a._status)return a._result.default;throw a._result;}
var U$1={current:null},V$1={transition:null},W$1={ReactCurrentDispatcher:U$1,ReactCurrentBatchConfig:V$1,ReactCurrentOwner:K$1};function X$1(){throw Error("act(...) is not supported in production builds of React.");}
react_production_min.Children={map:S$1,forEach:function(a,b,e){S$1(a,function(){b.apply(this,arguments);},e);},count:function(a){var b=0;S$1(a,function(){b++;});return b},toArray:function(a){return S$1(a,function(a){return a})||[]},only:function(a){if(!O$1(a))throw Error("React.Children.only expected to receive a single React element child.");return a}};react_production_min.Component=E$1;react_production_min.Fragment=p$2;react_production_min.Profiler=r;react_production_min.PureComponent=G$1;react_production_min.StrictMode=q$1;react_production_min.Suspense=w;
react_production_min.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=W$1;react_production_min.act=X$1;
react_production_min.cloneElement=function(a,b,e){if(null===a||void 0===a)throw Error("React.cloneElement(...): The argument must be a React element, but you passed "+a+".");var d=C$1({},a.props),c=a.key,k=a.ref,h=a._owner;if(null!=b){void 0!==b.ref&&(k=b.ref,h=K$1.current);void 0!==b.key&&(c=""+b.key);if(a.type&&a.type.defaultProps)var g=a.type.defaultProps;for(f in b)J.call(b,f)&&!L$1.hasOwnProperty(f)&&(d[f]=void 0===b[f]&&void 0!==g?g[f]:b[f]);}var f=arguments.length-2;if(1===f)d.children=e;else if(1<f){g=Array(f);
for(var m=0;m<f;m++)g[m]=arguments[m+2];d.children=g;}return {$$typeof:l$1,type:a.type,key:c,ref:k,props:d,_owner:h}};react_production_min.createContext=function(a){a={$$typeof:u,_currentValue:a,_currentValue2:a,_threadCount:0,Provider:null,Consumer:null,_defaultValue:null,_globalName:null};a.Provider={$$typeof:t,_context:a};return a.Consumer=a};react_production_min.createElement=M$1;react_production_min.createFactory=function(a){var b=M$1.bind(null,a);b.type=a;return b};react_production_min.createRef=function(){return {current:null}};
react_production_min.forwardRef=function(a){return {$$typeof:v$1,render:a}};react_production_min.isValidElement=O$1;react_production_min.lazy=function(a){return {$$typeof:y,_payload:{_status:-1,_result:a},_init:T$1}};react_production_min.memo=function(a,b){return {$$typeof:x,type:a,compare:void 0===b?null:b}};react_production_min.startTransition=function(a){var b=V$1.transition;V$1.transition={};try{a();}finally{V$1.transition=b;}};react_production_min.unstable_act=X$1;react_production_min.useCallback=function(a,b){return U$1.current.useCallback(a,b)};react_production_min.useContext=function(a){return U$1.current.useContext(a)};
react_production_min.useDebugValue=function(){};react_production_min.useDeferredValue=function(a){return U$1.current.useDeferredValue(a)};react_production_min.useEffect=function(a,b){return U$1.current.useEffect(a,b)};react_production_min.useId=function(){return U$1.current.useId()};react_production_min.useImperativeHandle=function(a,b,e){return U$1.current.useImperativeHandle(a,b,e)};react_production_min.useInsertionEffect=function(a,b){return U$1.current.useInsertionEffect(a,b)};react_production_min.useLayoutEffect=function(a,b){return U$1.current.useLayoutEffect(a,b)};
react_production_min.useMemo=function(a,b){return U$1.current.useMemo(a,b)};react_production_min.useReducer=function(a,b,e){return U$1.current.useReducer(a,b,e)};react_production_min.useRef=function(a){return U$1.current.useRef(a)};react_production_min.useState=function(a){return U$1.current.useState(a)};react_production_min.useSyncExternalStore=function(a,b,e){return U$1.current.useSyncExternalStore(a,b,e)};react_production_min.useTransition=function(){return U$1.current.useTransition()};react_production_min.version="18.3.1";

{
  react.exports = react_production_min;
}

var reactExports = react.exports;
const React = /*@__PURE__*/getDefaultExportFromCjs(reactExports);

/**
 * @license React
 * react-jsx-runtime.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
var f=reactExports,k=Symbol.for("react.element"),l=Symbol.for("react.fragment"),m$1=Object.prototype.hasOwnProperty,n=f.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,p$1={key:!0,ref:!0,__self:!0,__source:!0};
function q(c,a,g){var b,d={},e=null,h=null;void 0!==g&&(e=""+g);void 0!==a.key&&(e=""+a.key);void 0!==a.ref&&(h=a.ref);for(b in a)m$1.call(a,b)&&!p$1.hasOwnProperty(b)&&(d[b]=a[b]);if(c&&c.defaultProps)for(b in a=c.defaultProps,a)void 0===d[b]&&(d[b]=a[b]);return {$$typeof:k,type:c,key:e,ref:h,props:d,_owner:n.current}}reactJsxRuntime_production_min.Fragment=l;reactJsxRuntime_production_min.jsx=q;reactJsxRuntime_production_min.jsxs=q;

{
  jsxRuntime.exports = reactJsxRuntime_production_min;
}

var jsxRuntimeExports = jsxRuntime.exports;

const Fragment = jsxRuntimeExports.Fragment;
const jsx = jsxRuntimeExports.jsx;
const jsxs = jsxRuntimeExports.jsxs;

var reactDom = {exports: {}};

var reactDom_production_min = {};

var scheduler = {exports: {}};

var scheduler_production_min = {};

/**
 * @license React
 * scheduler.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

(function (exports) {
function f(a,b){var c=a.length;a.push(b);a:for(;0<c;){var d=c-1>>>1,e=a[d];if(0<g(e,b))a[d]=b,a[c]=e,c=d;else break a}}function h(a){return 0===a.length?null:a[0]}function k(a){if(0===a.length)return null;var b=a[0],c=a.pop();if(c!==b){a[0]=c;a:for(var d=0,e=a.length,w=e>>>1;d<w;){var m=2*(d+1)-1,C=a[m],n=m+1,x=a[n];if(0>g(C,c))n<e&&0>g(x,C)?(a[d]=x,a[n]=c,d=n):(a[d]=C,a[m]=c,d=m);else if(n<e&&0>g(x,c))a[d]=x,a[n]=c,d=n;else break a}}return b}
	function g(a,b){var c=a.sortIndex-b.sortIndex;return 0!==c?c:a.id-b.id}if("object"===typeof performance&&"function"===typeof performance.now){var l=performance;exports.unstable_now=function(){return l.now()};}else {var p=Date,q=p.now();exports.unstable_now=function(){return p.now()-q};}var r=[],t=[],u=1,v=null,y=3,z=!1,A=!1,B=!1,D="function"===typeof setTimeout?setTimeout:null,E="function"===typeof clearTimeout?clearTimeout:null,F="undefined"!==typeof setImmediate?setImmediate:null;
	"undefined"!==typeof navigator&&void 0!==navigator.scheduling&&void 0!==navigator.scheduling.isInputPending&&navigator.scheduling.isInputPending.bind(navigator.scheduling);function G(a){for(var b=h(t);null!==b;){if(null===b.callback)k(t);else if(b.startTime<=a)k(t),b.sortIndex=b.expirationTime,f(r,b);else break;b=h(t);}}function H(a){B=!1;G(a);if(!A)if(null!==h(r))A=!0,I(J);else {var b=h(t);null!==b&&K(H,b.startTime-a);}}
	function J(a,b){A=!1;B&&(B=!1,E(L),L=-1);z=!0;var c=y;try{G(b);for(v=h(r);null!==v&&(!(v.expirationTime>b)||a&&!M());){var d=v.callback;if("function"===typeof d){v.callback=null;y=v.priorityLevel;var e=d(v.expirationTime<=b);b=exports.unstable_now();"function"===typeof e?v.callback=e:v===h(r)&&k(r);G(b);}else k(r);v=h(r);}if(null!==v)var w=!0;else {var m=h(t);null!==m&&K(H,m.startTime-b);w=!1;}return w}finally{v=null,y=c,z=!1;}}var N=!1,O=null,L=-1,P=5,Q=-1;
	function M(){return exports.unstable_now()-Q<P?!1:!0}function R(){if(null!==O){var a=exports.unstable_now();Q=a;var b=!0;try{b=O(!0,a);}finally{b?S():(N=!1,O=null);}}else N=!1;}var S;if("function"===typeof F)S=function(){F(R);};else if("undefined"!==typeof MessageChannel){var T=new MessageChannel,U=T.port2;T.port1.onmessage=R;S=function(){U.postMessage(null);};}else S=function(){D(R,0);};function I(a){O=a;N||(N=!0,S());}function K(a,b){L=D(function(){a(exports.unstable_now());},b);}
	exports.unstable_IdlePriority=5;exports.unstable_ImmediatePriority=1;exports.unstable_LowPriority=4;exports.unstable_NormalPriority=3;exports.unstable_Profiling=null;exports.unstable_UserBlockingPriority=2;exports.unstable_cancelCallback=function(a){a.callback=null;};exports.unstable_continueExecution=function(){A||z||(A=!0,I(J));};
	exports.unstable_forceFrameRate=function(a){0>a||125<a?console.error("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported"):P=0<a?Math.floor(1E3/a):5;};exports.unstable_getCurrentPriorityLevel=function(){return y};exports.unstable_getFirstCallbackNode=function(){return h(r)};exports.unstable_next=function(a){switch(y){case 1:case 2:case 3:var b=3;break;default:b=y;}var c=y;y=b;try{return a()}finally{y=c;}};exports.unstable_pauseExecution=function(){};
	exports.unstable_requestPaint=function(){};exports.unstable_runWithPriority=function(a,b){switch(a){case 1:case 2:case 3:case 4:case 5:break;default:a=3;}var c=y;y=a;try{return b()}finally{y=c;}};
	exports.unstable_scheduleCallback=function(a,b,c){var d=exports.unstable_now();"object"===typeof c&&null!==c?(c=c.delay,c="number"===typeof c&&0<c?d+c:d):c=d;switch(a){case 1:var e=-1;break;case 2:e=250;break;case 5:e=1073741823;break;case 4:e=1E4;break;default:e=5E3;}e=c+e;a={id:u++,callback:b,priorityLevel:a,startTime:c,expirationTime:e,sortIndex:-1};c>d?(a.sortIndex=c,f(t,a),null===h(r)&&a===h(t)&&(B?(E(L),L=-1):B=!0,K(H,c-d))):(a.sortIndex=e,f(r,a),A||z||(A=!0,I(J)));return a};
	exports.unstable_shouldYield=M;exports.unstable_wrapCallback=function(a){var b=y;return function(){var c=y;y=b;try{return a.apply(this,arguments)}finally{y=c;}}}; 
} (scheduler_production_min));

{
  scheduler.exports = scheduler_production_min;
}

var schedulerExports = scheduler.exports;

/**
 * @license React
 * react-dom.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
var aa=reactExports,ca=schedulerExports;function p(a){for(var b="https://reactjs.org/docs/error-decoder.html?invariant="+a,c=1;c<arguments.length;c++)b+="&args[]="+encodeURIComponent(arguments[c]);return "Minified React error #"+a+"; visit "+b+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings."}var da=new Set,ea={};function fa(a,b){ha(a,b);ha(a+"Capture",b);}
function ha(a,b){ea[a]=b;for(a=0;a<b.length;a++)da.add(b[a]);}
var ia=!("undefined"===typeof window||"undefined"===typeof window.document||"undefined"===typeof window.document.createElement),ja=Object.prototype.hasOwnProperty,ka=/^[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\-.0-9\u00B7\u0300-\u036F\u203F-\u2040]*$/,la=
{},ma={};function oa(a){if(ja.call(ma,a))return !0;if(ja.call(la,a))return !1;if(ka.test(a))return ma[a]=!0;la[a]=!0;return !1}function pa(a,b,c,d){if(null!==c&&0===c.type)return !1;switch(typeof b){case "function":case "symbol":return !0;case "boolean":if(d)return !1;if(null!==c)return !c.acceptsBooleans;a=a.toLowerCase().slice(0,5);return "data-"!==a&&"aria-"!==a;default:return !1}}
function qa(a,b,c,d){if(null===b||"undefined"===typeof b||pa(a,b,c,d))return !0;if(d)return !1;if(null!==c)switch(c.type){case 3:return !b;case 4:return !1===b;case 5:return isNaN(b);case 6:return isNaN(b)||1>b}return !1}function v(a,b,c,d,e,f,g){this.acceptsBooleans=2===b||3===b||4===b;this.attributeName=d;this.attributeNamespace=e;this.mustUseProperty=c;this.propertyName=a;this.type=b;this.sanitizeURL=f;this.removeEmptyString=g;}var z={};
"children dangerouslySetInnerHTML defaultValue defaultChecked innerHTML suppressContentEditableWarning suppressHydrationWarning style".split(" ").forEach(function(a){z[a]=new v(a,0,!1,a,null,!1,!1);});[["acceptCharset","accept-charset"],["className","class"],["htmlFor","for"],["httpEquiv","http-equiv"]].forEach(function(a){var b=a[0];z[b]=new v(b,1,!1,a[1],null,!1,!1);});["contentEditable","draggable","spellCheck","value"].forEach(function(a){z[a]=new v(a,2,!1,a.toLowerCase(),null,!1,!1);});
["autoReverse","externalResourcesRequired","focusable","preserveAlpha"].forEach(function(a){z[a]=new v(a,2,!1,a,null,!1,!1);});"allowFullScreen async autoFocus autoPlay controls default defer disabled disablePictureInPicture disableRemotePlayback formNoValidate hidden loop noModule noValidate open playsInline readOnly required reversed scoped seamless itemScope".split(" ").forEach(function(a){z[a]=new v(a,3,!1,a.toLowerCase(),null,!1,!1);});
["checked","multiple","muted","selected"].forEach(function(a){z[a]=new v(a,3,!0,a,null,!1,!1);});["capture","download"].forEach(function(a){z[a]=new v(a,4,!1,a,null,!1,!1);});["cols","rows","size","span"].forEach(function(a){z[a]=new v(a,6,!1,a,null,!1,!1);});["rowSpan","start"].forEach(function(a){z[a]=new v(a,5,!1,a.toLowerCase(),null,!1,!1);});var ra=/[\-:]([a-z])/g;function sa(a){return a[1].toUpperCase()}
"accent-height alignment-baseline arabic-form baseline-shift cap-height clip-path clip-rule color-interpolation color-interpolation-filters color-profile color-rendering dominant-baseline enable-background fill-opacity fill-rule flood-color flood-opacity font-family font-size font-size-adjust font-stretch font-style font-variant font-weight glyph-name glyph-orientation-horizontal glyph-orientation-vertical horiz-adv-x horiz-origin-x image-rendering letter-spacing lighting-color marker-end marker-mid marker-start overline-position overline-thickness paint-order panose-1 pointer-events rendering-intent shape-rendering stop-color stop-opacity strikethrough-position strikethrough-thickness stroke-dasharray stroke-dashoffset stroke-linecap stroke-linejoin stroke-miterlimit stroke-opacity stroke-width text-anchor text-decoration text-rendering underline-position underline-thickness unicode-bidi unicode-range units-per-em v-alphabetic v-hanging v-ideographic v-mathematical vector-effect vert-adv-y vert-origin-x vert-origin-y word-spacing writing-mode xmlns:xlink x-height".split(" ").forEach(function(a){var b=a.replace(ra,
sa);z[b]=new v(b,1,!1,a,null,!1,!1);});"xlink:actuate xlink:arcrole xlink:role xlink:show xlink:title xlink:type".split(" ").forEach(function(a){var b=a.replace(ra,sa);z[b]=new v(b,1,!1,a,"http://www.w3.org/1999/xlink",!1,!1);});["xml:base","xml:lang","xml:space"].forEach(function(a){var b=a.replace(ra,sa);z[b]=new v(b,1,!1,a,"http://www.w3.org/XML/1998/namespace",!1,!1);});["tabIndex","crossOrigin"].forEach(function(a){z[a]=new v(a,1,!1,a.toLowerCase(),null,!1,!1);});
z.xlinkHref=new v("xlinkHref",1,!1,"xlink:href","http://www.w3.org/1999/xlink",!0,!1);["src","href","action","formAction"].forEach(function(a){z[a]=new v(a,1,!1,a.toLowerCase(),null,!0,!0);});
function ta(a,b,c,d){var e=z.hasOwnProperty(b)?z[b]:null;if(null!==e?0!==e.type:d||!(2<b.length)||"o"!==b[0]&&"O"!==b[0]||"n"!==b[1]&&"N"!==b[1])qa(b,c,e,d)&&(c=null),d||null===e?oa(b)&&(null===c?a.removeAttribute(b):a.setAttribute(b,""+c)):e.mustUseProperty?a[e.propertyName]=null===c?3===e.type?!1:"":c:(b=e.attributeName,d=e.attributeNamespace,null===c?a.removeAttribute(b):(e=e.type,c=3===e||4===e&&!0===c?"":""+c,d?a.setAttributeNS(d,b,c):a.setAttribute(b,c)));}
var ua=aa.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED,va=Symbol.for("react.element"),wa=Symbol.for("react.portal"),ya=Symbol.for("react.fragment"),za=Symbol.for("react.strict_mode"),Aa=Symbol.for("react.profiler"),Ba=Symbol.for("react.provider"),Ca=Symbol.for("react.context"),Da=Symbol.for("react.forward_ref"),Ea=Symbol.for("react.suspense"),Fa=Symbol.for("react.suspense_list"),Ga=Symbol.for("react.memo"),Ha=Symbol.for("react.lazy");var Ia=Symbol.for("react.offscreen");var Ja=Symbol.iterator;function Ka(a){if(null===a||"object"!==typeof a)return null;a=Ja&&a[Ja]||a["@@iterator"];return "function"===typeof a?a:null}var A=Object.assign,La;function Ma(a){if(void 0===La)try{throw Error();}catch(c){var b=c.stack.trim().match(/\n( *(at )?)/);La=b&&b[1]||"";}return "\n"+La+a}var Na=!1;
function Oa(a,b){if(!a||Na)return "";Na=!0;var c=Error.prepareStackTrace;Error.prepareStackTrace=void 0;try{if(b)if(b=function(){throw Error();},Object.defineProperty(b.prototype,"props",{set:function(){throw Error();}}),"object"===typeof Reflect&&Reflect.construct){try{Reflect.construct(b,[]);}catch(l){var d=l;}Reflect.construct(a,[],b);}else {try{b.call();}catch(l){d=l;}a.call(b.prototype);}else {try{throw Error();}catch(l){d=l;}a();}}catch(l){if(l&&d&&"string"===typeof l.stack){for(var e=l.stack.split("\n"),
f=d.stack.split("\n"),g=e.length-1,h=f.length-1;1<=g&&0<=h&&e[g]!==f[h];)h--;for(;1<=g&&0<=h;g--,h--)if(e[g]!==f[h]){if(1!==g||1!==h){do if(g--,h--,0>h||e[g]!==f[h]){var k="\n"+e[g].replace(" at new "," at ");a.displayName&&k.includes("<anonymous>")&&(k=k.replace("<anonymous>",a.displayName));return k}while(1<=g&&0<=h)}break}}}finally{Na=!1,Error.prepareStackTrace=c;}return (a=a?a.displayName||a.name:"")?Ma(a):""}
function Pa(a){switch(a.tag){case 5:return Ma(a.type);case 16:return Ma("Lazy");case 13:return Ma("Suspense");case 19:return Ma("SuspenseList");case 0:case 2:case 15:return a=Oa(a.type,!1),a;case 11:return a=Oa(a.type.render,!1),a;case 1:return a=Oa(a.type,!0),a;default:return ""}}
function Qa(a){if(null==a)return null;if("function"===typeof a)return a.displayName||a.name||null;if("string"===typeof a)return a;switch(a){case ya:return "Fragment";case wa:return "Portal";case Aa:return "Profiler";case za:return "StrictMode";case Ea:return "Suspense";case Fa:return "SuspenseList"}if("object"===typeof a)switch(a.$$typeof){case Ca:return (a.displayName||"Context")+".Consumer";case Ba:return (a._context.displayName||"Context")+".Provider";case Da:var b=a.render;a=a.displayName;a||(a=b.displayName||
b.name||"",a=""!==a?"ForwardRef("+a+")":"ForwardRef");return a;case Ga:return b=a.displayName||null,null!==b?b:Qa(a.type)||"Memo";case Ha:b=a._payload;a=a._init;try{return Qa(a(b))}catch(c){}}return null}
function Ra(a){var b=a.type;switch(a.tag){case 24:return "Cache";case 9:return (b.displayName||"Context")+".Consumer";case 10:return (b._context.displayName||"Context")+".Provider";case 18:return "DehydratedFragment";case 11:return a=b.render,a=a.displayName||a.name||"",b.displayName||(""!==a?"ForwardRef("+a+")":"ForwardRef");case 7:return "Fragment";case 5:return b;case 4:return "Portal";case 3:return "Root";case 6:return "Text";case 16:return Qa(b);case 8:return b===za?"StrictMode":"Mode";case 22:return "Offscreen";
case 12:return "Profiler";case 21:return "Scope";case 13:return "Suspense";case 19:return "SuspenseList";case 25:return "TracingMarker";case 1:case 0:case 17:case 2:case 14:case 15:if("function"===typeof b)return b.displayName||b.name||null;if("string"===typeof b)return b}return null}function Sa(a){switch(typeof a){case "boolean":case "number":case "string":case "undefined":return a;case "object":return a;default:return ""}}
function Ta(a){var b=a.type;return (a=a.nodeName)&&"input"===a.toLowerCase()&&("checkbox"===b||"radio"===b)}
function Ua(a){var b=Ta(a)?"checked":"value",c=Object.getOwnPropertyDescriptor(a.constructor.prototype,b),d=""+a[b];if(!a.hasOwnProperty(b)&&"undefined"!==typeof c&&"function"===typeof c.get&&"function"===typeof c.set){var e=c.get,f=c.set;Object.defineProperty(a,b,{configurable:!0,get:function(){return e.call(this)},set:function(a){d=""+a;f.call(this,a);}});Object.defineProperty(a,b,{enumerable:c.enumerable});return {getValue:function(){return d},setValue:function(a){d=""+a;},stopTracking:function(){a._valueTracker=
null;delete a[b];}}}}function Va(a){a._valueTracker||(a._valueTracker=Ua(a));}function Wa(a){if(!a)return !1;var b=a._valueTracker;if(!b)return !0;var c=b.getValue();var d="";a&&(d=Ta(a)?a.checked?"true":"false":a.value);a=d;return a!==c?(b.setValue(a),!0):!1}function Xa(a){a=a||("undefined"!==typeof document?document:void 0);if("undefined"===typeof a)return null;try{return a.activeElement||a.body}catch(b){return a.body}}
function Ya(a,b){var c=b.checked;return A({},b,{defaultChecked:void 0,defaultValue:void 0,value:void 0,checked:null!=c?c:a._wrapperState.initialChecked})}function Za(a,b){var c=null==b.defaultValue?"":b.defaultValue,d=null!=b.checked?b.checked:b.defaultChecked;c=Sa(null!=b.value?b.value:c);a._wrapperState={initialChecked:d,initialValue:c,controlled:"checkbox"===b.type||"radio"===b.type?null!=b.checked:null!=b.value};}function ab(a,b){b=b.checked;null!=b&&ta(a,"checked",b,!1);}
function bb(a,b){ab(a,b);var c=Sa(b.value),d=b.type;if(null!=c)if("number"===d){if(0===c&&""===a.value||a.value!=c)a.value=""+c;}else a.value!==""+c&&(a.value=""+c);else if("submit"===d||"reset"===d){a.removeAttribute("value");return}b.hasOwnProperty("value")?cb(a,b.type,c):b.hasOwnProperty("defaultValue")&&cb(a,b.type,Sa(b.defaultValue));null==b.checked&&null!=b.defaultChecked&&(a.defaultChecked=!!b.defaultChecked);}
function db(a,b,c){if(b.hasOwnProperty("value")||b.hasOwnProperty("defaultValue")){var d=b.type;if(!("submit"!==d&&"reset"!==d||void 0!==b.value&&null!==b.value))return;b=""+a._wrapperState.initialValue;c||b===a.value||(a.value=b);a.defaultValue=b;}c=a.name;""!==c&&(a.name="");a.defaultChecked=!!a._wrapperState.initialChecked;""!==c&&(a.name=c);}
function cb(a,b,c){if("number"!==b||Xa(a.ownerDocument)!==a)null==c?a.defaultValue=""+a._wrapperState.initialValue:a.defaultValue!==""+c&&(a.defaultValue=""+c);}var eb=Array.isArray;
function fb(a,b,c,d){a=a.options;if(b){b={};for(var e=0;e<c.length;e++)b["$"+c[e]]=!0;for(c=0;c<a.length;c++)e=b.hasOwnProperty("$"+a[c].value),a[c].selected!==e&&(a[c].selected=e),e&&d&&(a[c].defaultSelected=!0);}else {c=""+Sa(c);b=null;for(e=0;e<a.length;e++){if(a[e].value===c){a[e].selected=!0;d&&(a[e].defaultSelected=!0);return}null!==b||a[e].disabled||(b=a[e]);}null!==b&&(b.selected=!0);}}
function gb(a,b){if(null!=b.dangerouslySetInnerHTML)throw Error(p(91));return A({},b,{value:void 0,defaultValue:void 0,children:""+a._wrapperState.initialValue})}function hb(a,b){var c=b.value;if(null==c){c=b.children;b=b.defaultValue;if(null!=c){if(null!=b)throw Error(p(92));if(eb(c)){if(1<c.length)throw Error(p(93));c=c[0];}b=c;}null==b&&(b="");c=b;}a._wrapperState={initialValue:Sa(c)};}
function ib(a,b){var c=Sa(b.value),d=Sa(b.defaultValue);null!=c&&(c=""+c,c!==a.value&&(a.value=c),null==b.defaultValue&&a.defaultValue!==c&&(a.defaultValue=c));null!=d&&(a.defaultValue=""+d);}function jb(a){var b=a.textContent;b===a._wrapperState.initialValue&&""!==b&&null!==b&&(a.value=b);}function kb(a){switch(a){case "svg":return "http://www.w3.org/2000/svg";case "math":return "http://www.w3.org/1998/Math/MathML";default:return "http://www.w3.org/1999/xhtml"}}
function lb(a,b){return null==a||"http://www.w3.org/1999/xhtml"===a?kb(b):"http://www.w3.org/2000/svg"===a&&"foreignObject"===b?"http://www.w3.org/1999/xhtml":a}
var mb,nb=function(a){return "undefined"!==typeof MSApp&&MSApp.execUnsafeLocalFunction?function(b,c,d,e){MSApp.execUnsafeLocalFunction(function(){return a(b,c,d,e)});}:a}(function(a,b){if("http://www.w3.org/2000/svg"!==a.namespaceURI||"innerHTML"in a)a.innerHTML=b;else {mb=mb||document.createElement("div");mb.innerHTML="<svg>"+b.valueOf().toString()+"</svg>";for(b=mb.firstChild;a.firstChild;)a.removeChild(a.firstChild);for(;b.firstChild;)a.appendChild(b.firstChild);}});
function ob(a,b){if(b){var c=a.firstChild;if(c&&c===a.lastChild&&3===c.nodeType){c.nodeValue=b;return}}a.textContent=b;}
var pb={animationIterationCount:!0,aspectRatio:!0,borderImageOutset:!0,borderImageSlice:!0,borderImageWidth:!0,boxFlex:!0,boxFlexGroup:!0,boxOrdinalGroup:!0,columnCount:!0,columns:!0,flex:!0,flexGrow:!0,flexPositive:!0,flexShrink:!0,flexNegative:!0,flexOrder:!0,gridArea:!0,gridRow:!0,gridRowEnd:!0,gridRowSpan:!0,gridRowStart:!0,gridColumn:!0,gridColumnEnd:!0,gridColumnSpan:!0,gridColumnStart:!0,fontWeight:!0,lineClamp:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,tabSize:!0,widows:!0,zIndex:!0,
zoom:!0,fillOpacity:!0,floodOpacity:!0,stopOpacity:!0,strokeDasharray:!0,strokeDashoffset:!0,strokeMiterlimit:!0,strokeOpacity:!0,strokeWidth:!0},qb=["Webkit","ms","Moz","O"];Object.keys(pb).forEach(function(a){qb.forEach(function(b){b=b+a.charAt(0).toUpperCase()+a.substring(1);pb[b]=pb[a];});});function rb(a,b,c){return null==b||"boolean"===typeof b||""===b?"":c||"number"!==typeof b||0===b||pb.hasOwnProperty(a)&&pb[a]?(""+b).trim():b+"px"}
function sb(a,b){a=a.style;for(var c in b)if(b.hasOwnProperty(c)){var d=0===c.indexOf("--"),e=rb(c,b[c],d);"float"===c&&(c="cssFloat");d?a.setProperty(c,e):a[c]=e;}}var tb=A({menuitem:!0},{area:!0,base:!0,br:!0,col:!0,embed:!0,hr:!0,img:!0,input:!0,keygen:!0,link:!0,meta:!0,param:!0,source:!0,track:!0,wbr:!0});
function ub(a,b){if(b){if(tb[a]&&(null!=b.children||null!=b.dangerouslySetInnerHTML))throw Error(p(137,a));if(null!=b.dangerouslySetInnerHTML){if(null!=b.children)throw Error(p(60));if("object"!==typeof b.dangerouslySetInnerHTML||!("__html"in b.dangerouslySetInnerHTML))throw Error(p(61));}if(null!=b.style&&"object"!==typeof b.style)throw Error(p(62));}}
function vb(a,b){if(-1===a.indexOf("-"))return "string"===typeof b.is;switch(a){case "annotation-xml":case "color-profile":case "font-face":case "font-face-src":case "font-face-uri":case "font-face-format":case "font-face-name":case "missing-glyph":return !1;default:return !0}}var wb=null;function xb(a){a=a.target||a.srcElement||window;a.correspondingUseElement&&(a=a.correspondingUseElement);return 3===a.nodeType?a.parentNode:a}var yb=null,zb=null,Ab=null;
function Bb(a){if(a=Cb(a)){if("function"!==typeof yb)throw Error(p(280));var b=a.stateNode;b&&(b=Db(b),yb(a.stateNode,a.type,b));}}function Eb(a){zb?Ab?Ab.push(a):Ab=[a]:zb=a;}function Fb(){if(zb){var a=zb,b=Ab;Ab=zb=null;Bb(a);if(b)for(a=0;a<b.length;a++)Bb(b[a]);}}function Gb(a,b){return a(b)}function Hb(){}var Ib=!1;function Jb(a,b,c){if(Ib)return a(b,c);Ib=!0;try{return Gb(a,b,c)}finally{if(Ib=!1,null!==zb||null!==Ab)Hb(),Fb();}}
function Kb(a,b){var c=a.stateNode;if(null===c)return null;var d=Db(c);if(null===d)return null;c=d[b];a:switch(b){case "onClick":case "onClickCapture":case "onDoubleClick":case "onDoubleClickCapture":case "onMouseDown":case "onMouseDownCapture":case "onMouseMove":case "onMouseMoveCapture":case "onMouseUp":case "onMouseUpCapture":case "onMouseEnter":(d=!d.disabled)||(a=a.type,d=!("button"===a||"input"===a||"select"===a||"textarea"===a));a=!d;break a;default:a=!1;}if(a)return null;if(c&&"function"!==
typeof c)throw Error(p(231,b,typeof c));return c}var Lb=!1;if(ia)try{var Mb={};Object.defineProperty(Mb,"passive",{get:function(){Lb=!0;}});window.addEventListener("test",Mb,Mb);window.removeEventListener("test",Mb,Mb);}catch(a){Lb=!1;}function Nb(a,b,c,d,e,f,g,h,k){var l=Array.prototype.slice.call(arguments,3);try{b.apply(c,l);}catch(m){this.onError(m);}}var Ob=!1,Pb=null,Qb=!1,Rb=null,Sb={onError:function(a){Ob=!0;Pb=a;}};function Tb(a,b,c,d,e,f,g,h,k){Ob=!1;Pb=null;Nb.apply(Sb,arguments);}
function Ub(a,b,c,d,e,f,g,h,k){Tb.apply(this,arguments);if(Ob){if(Ob){var l=Pb;Ob=!1;Pb=null;}else throw Error(p(198));Qb||(Qb=!0,Rb=l);}}function Vb(a){var b=a,c=a;if(a.alternate)for(;b.return;)b=b.return;else {a=b;do b=a,0!==(b.flags&4098)&&(c=b.return),a=b.return;while(a)}return 3===b.tag?c:null}function Wb(a){if(13===a.tag){var b=a.memoizedState;null===b&&(a=a.alternate,null!==a&&(b=a.memoizedState));if(null!==b)return b.dehydrated}return null}function Xb(a){if(Vb(a)!==a)throw Error(p(188));}
function Yb(a){var b=a.alternate;if(!b){b=Vb(a);if(null===b)throw Error(p(188));return b!==a?null:a}for(var c=a,d=b;;){var e=c.return;if(null===e)break;var f=e.alternate;if(null===f){d=e.return;if(null!==d){c=d;continue}break}if(e.child===f.child){for(f=e.child;f;){if(f===c)return Xb(e),a;if(f===d)return Xb(e),b;f=f.sibling;}throw Error(p(188));}if(c.return!==d.return)c=e,d=f;else {for(var g=!1,h=e.child;h;){if(h===c){g=!0;c=e;d=f;break}if(h===d){g=!0;d=e;c=f;break}h=h.sibling;}if(!g){for(h=f.child;h;){if(h===
c){g=!0;c=f;d=e;break}if(h===d){g=!0;d=f;c=e;break}h=h.sibling;}if(!g)throw Error(p(189));}}if(c.alternate!==d)throw Error(p(190));}if(3!==c.tag)throw Error(p(188));return c.stateNode.current===c?a:b}function Zb(a){a=Yb(a);return null!==a?$b(a):null}function $b(a){if(5===a.tag||6===a.tag)return a;for(a=a.child;null!==a;){var b=$b(a);if(null!==b)return b;a=a.sibling;}return null}
var ac=ca.unstable_scheduleCallback,bc=ca.unstable_cancelCallback,cc=ca.unstable_shouldYield,dc=ca.unstable_requestPaint,B=ca.unstable_now,ec=ca.unstable_getCurrentPriorityLevel,fc=ca.unstable_ImmediatePriority,gc=ca.unstable_UserBlockingPriority,hc=ca.unstable_NormalPriority,ic=ca.unstable_LowPriority,jc=ca.unstable_IdlePriority,kc=null,lc=null;function mc(a){if(lc&&"function"===typeof lc.onCommitFiberRoot)try{lc.onCommitFiberRoot(kc,a,void 0,128===(a.current.flags&128));}catch(b){}}
var oc=Math.clz32?Math.clz32:nc,pc=Math.log,qc=Math.LN2;function nc(a){a>>>=0;return 0===a?32:31-(pc(a)/qc|0)|0}var rc=64,sc=4194304;
function tc(a){switch(a&-a){case 1:return 1;case 2:return 2;case 4:return 4;case 8:return 8;case 16:return 16;case 32:return 32;case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:return a&4194240;case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:return a&130023424;case 134217728:return 134217728;case 268435456:return 268435456;case 536870912:return 536870912;case 1073741824:return 1073741824;
default:return a}}function uc(a,b){var c=a.pendingLanes;if(0===c)return 0;var d=0,e=a.suspendedLanes,f=a.pingedLanes,g=c&268435455;if(0!==g){var h=g&~e;0!==h?d=tc(h):(f&=g,0!==f&&(d=tc(f)));}else g=c&~e,0!==g?d=tc(g):0!==f&&(d=tc(f));if(0===d)return 0;if(0!==b&&b!==d&&0===(b&e)&&(e=d&-d,f=b&-b,e>=f||16===e&&0!==(f&4194240)))return b;0!==(d&4)&&(d|=c&16);b=a.entangledLanes;if(0!==b)for(a=a.entanglements,b&=d;0<b;)c=31-oc(b),e=1<<c,d|=a[c],b&=~e;return d}
function vc(a,b){switch(a){case 1:case 2:case 4:return b+250;case 8:case 16:case 32:case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:return b+5E3;case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:return -1;case 134217728:case 268435456:case 536870912:case 1073741824:return -1;default:return -1}}
function wc(a,b){for(var c=a.suspendedLanes,d=a.pingedLanes,e=a.expirationTimes,f=a.pendingLanes;0<f;){var g=31-oc(f),h=1<<g,k=e[g];if(-1===k){if(0===(h&c)||0!==(h&d))e[g]=vc(h,b);}else k<=b&&(a.expiredLanes|=h);f&=~h;}}function xc(a){a=a.pendingLanes&-1073741825;return 0!==a?a:a&1073741824?1073741824:0}function yc(){var a=rc;rc<<=1;0===(rc&4194240)&&(rc=64);return a}function zc(a){for(var b=[],c=0;31>c;c++)b.push(a);return b}
function Ac(a,b,c){a.pendingLanes|=b;536870912!==b&&(a.suspendedLanes=0,a.pingedLanes=0);a=a.eventTimes;b=31-oc(b);a[b]=c;}function Bc(a,b){var c=a.pendingLanes&~b;a.pendingLanes=b;a.suspendedLanes=0;a.pingedLanes=0;a.expiredLanes&=b;a.mutableReadLanes&=b;a.entangledLanes&=b;b=a.entanglements;var d=a.eventTimes;for(a=a.expirationTimes;0<c;){var e=31-oc(c),f=1<<e;b[e]=0;d[e]=-1;a[e]=-1;c&=~f;}}
function Cc(a,b){var c=a.entangledLanes|=b;for(a=a.entanglements;c;){var d=31-oc(c),e=1<<d;e&b|a[d]&b&&(a[d]|=b);c&=~e;}}var C=0;function Dc(a){a&=-a;return 1<a?4<a?0!==(a&268435455)?16:536870912:4:1}var Ec,Fc,Gc,Hc,Ic,Jc=!1,Kc=[],Lc=null,Mc=null,Nc=null,Oc=new Map,Pc=new Map,Qc=[],Rc="mousedown mouseup touchcancel touchend touchstart auxclick dblclick pointercancel pointerdown pointerup dragend dragstart drop compositionend compositionstart keydown keypress keyup input textInput copy cut paste click change contextmenu reset submit".split(" ");
function Sc(a,b){switch(a){case "focusin":case "focusout":Lc=null;break;case "dragenter":case "dragleave":Mc=null;break;case "mouseover":case "mouseout":Nc=null;break;case "pointerover":case "pointerout":Oc.delete(b.pointerId);break;case "gotpointercapture":case "lostpointercapture":Pc.delete(b.pointerId);}}
function Tc(a,b,c,d,e,f){if(null===a||a.nativeEvent!==f)return a={blockedOn:b,domEventName:c,eventSystemFlags:d,nativeEvent:f,targetContainers:[e]},null!==b&&(b=Cb(b),null!==b&&Fc(b)),a;a.eventSystemFlags|=d;b=a.targetContainers;null!==e&&-1===b.indexOf(e)&&b.push(e);return a}
function Uc(a,b,c,d,e){switch(b){case "focusin":return Lc=Tc(Lc,a,b,c,d,e),!0;case "dragenter":return Mc=Tc(Mc,a,b,c,d,e),!0;case "mouseover":return Nc=Tc(Nc,a,b,c,d,e),!0;case "pointerover":var f=e.pointerId;Oc.set(f,Tc(Oc.get(f)||null,a,b,c,d,e));return !0;case "gotpointercapture":return f=e.pointerId,Pc.set(f,Tc(Pc.get(f)||null,a,b,c,d,e)),!0}return !1}
function Vc(a){var b=Wc(a.target);if(null!==b){var c=Vb(b);if(null!==c)if(b=c.tag,13===b){if(b=Wb(c),null!==b){a.blockedOn=b;Ic(a.priority,function(){Gc(c);});return}}else if(3===b&&c.stateNode.current.memoizedState.isDehydrated){a.blockedOn=3===c.tag?c.stateNode.containerInfo:null;return}}a.blockedOn=null;}
function Xc(a){if(null!==a.blockedOn)return !1;for(var b=a.targetContainers;0<b.length;){var c=Yc(a.domEventName,a.eventSystemFlags,b[0],a.nativeEvent);if(null===c){c=a.nativeEvent;var d=new c.constructor(c.type,c);wb=d;c.target.dispatchEvent(d);wb=null;}else return b=Cb(c),null!==b&&Fc(b),a.blockedOn=c,!1;b.shift();}return !0}function Zc(a,b,c){Xc(a)&&c.delete(b);}function $c(){Jc=!1;null!==Lc&&Xc(Lc)&&(Lc=null);null!==Mc&&Xc(Mc)&&(Mc=null);null!==Nc&&Xc(Nc)&&(Nc=null);Oc.forEach(Zc);Pc.forEach(Zc);}
function ad(a,b){a.blockedOn===b&&(a.blockedOn=null,Jc||(Jc=!0,ca.unstable_scheduleCallback(ca.unstable_NormalPriority,$c)));}
function bd(a){function b(b){return ad(b,a)}if(0<Kc.length){ad(Kc[0],a);for(var c=1;c<Kc.length;c++){var d=Kc[c];d.blockedOn===a&&(d.blockedOn=null);}}null!==Lc&&ad(Lc,a);null!==Mc&&ad(Mc,a);null!==Nc&&ad(Nc,a);Oc.forEach(b);Pc.forEach(b);for(c=0;c<Qc.length;c++)d=Qc[c],d.blockedOn===a&&(d.blockedOn=null);for(;0<Qc.length&&(c=Qc[0],null===c.blockedOn);)Vc(c),null===c.blockedOn&&Qc.shift();}var cd=ua.ReactCurrentBatchConfig,dd=!0;
function ed(a,b,c,d){var e=C,f=cd.transition;cd.transition=null;try{C=1,fd(a,b,c,d);}finally{C=e,cd.transition=f;}}function gd(a,b,c,d){var e=C,f=cd.transition;cd.transition=null;try{C=4,fd(a,b,c,d);}finally{C=e,cd.transition=f;}}
function fd(a,b,c,d){if(dd){var e=Yc(a,b,c,d);if(null===e)hd(a,b,d,id,c),Sc(a,d);else if(Uc(e,a,b,c,d))d.stopPropagation();else if(Sc(a,d),b&4&&-1<Rc.indexOf(a)){for(;null!==e;){var f=Cb(e);null!==f&&Ec(f);f=Yc(a,b,c,d);null===f&&hd(a,b,d,id,c);if(f===e)break;e=f;}null!==e&&d.stopPropagation();}else hd(a,b,d,null,c);}}var id=null;
function Yc(a,b,c,d){id=null;a=xb(d);a=Wc(a);if(null!==a)if(b=Vb(a),null===b)a=null;else if(c=b.tag,13===c){a=Wb(b);if(null!==a)return a;a=null;}else if(3===c){if(b.stateNode.current.memoizedState.isDehydrated)return 3===b.tag?b.stateNode.containerInfo:null;a=null;}else b!==a&&(a=null);id=a;return null}
function jd(a){switch(a){case "cancel":case "click":case "close":case "contextmenu":case "copy":case "cut":case "auxclick":case "dblclick":case "dragend":case "dragstart":case "drop":case "focusin":case "focusout":case "input":case "invalid":case "keydown":case "keypress":case "keyup":case "mousedown":case "mouseup":case "paste":case "pause":case "play":case "pointercancel":case "pointerdown":case "pointerup":case "ratechange":case "reset":case "resize":case "seeked":case "submit":case "touchcancel":case "touchend":case "touchstart":case "volumechange":case "change":case "selectionchange":case "textInput":case "compositionstart":case "compositionend":case "compositionupdate":case "beforeblur":case "afterblur":case "beforeinput":case "blur":case "fullscreenchange":case "focus":case "hashchange":case "popstate":case "select":case "selectstart":return 1;case "drag":case "dragenter":case "dragexit":case "dragleave":case "dragover":case "mousemove":case "mouseout":case "mouseover":case "pointermove":case "pointerout":case "pointerover":case "scroll":case "toggle":case "touchmove":case "wheel":case "mouseenter":case "mouseleave":case "pointerenter":case "pointerleave":return 4;
case "message":switch(ec()){case fc:return 1;case gc:return 4;case hc:case ic:return 16;case jc:return 536870912;default:return 16}default:return 16}}var kd=null,ld=null,md=null;function nd(){if(md)return md;var a,b=ld,c=b.length,d,e="value"in kd?kd.value:kd.textContent,f=e.length;for(a=0;a<c&&b[a]===e[a];a++);var g=c-a;for(d=1;d<=g&&b[c-d]===e[f-d];d++);return md=e.slice(a,1<d?1-d:void 0)}
function od(a){var b=a.keyCode;"charCode"in a?(a=a.charCode,0===a&&13===b&&(a=13)):a=b;10===a&&(a=13);return 32<=a||13===a?a:0}function pd(){return !0}function qd(){return !1}
function rd(a){function b(b,d,e,f,g){this._reactName=b;this._targetInst=e;this.type=d;this.nativeEvent=f;this.target=g;this.currentTarget=null;for(var c in a)a.hasOwnProperty(c)&&(b=a[c],this[c]=b?b(f):f[c]);this.isDefaultPrevented=(null!=f.defaultPrevented?f.defaultPrevented:!1===f.returnValue)?pd:qd;this.isPropagationStopped=qd;return this}A(b.prototype,{preventDefault:function(){this.defaultPrevented=!0;var a=this.nativeEvent;a&&(a.preventDefault?a.preventDefault():"unknown"!==typeof a.returnValue&&
(a.returnValue=!1),this.isDefaultPrevented=pd);},stopPropagation:function(){var a=this.nativeEvent;a&&(a.stopPropagation?a.stopPropagation():"unknown"!==typeof a.cancelBubble&&(a.cancelBubble=!0),this.isPropagationStopped=pd);},persist:function(){},isPersistent:pd});return b}
var sd={eventPhase:0,bubbles:0,cancelable:0,timeStamp:function(a){return a.timeStamp||Date.now()},defaultPrevented:0,isTrusted:0},td=rd(sd),ud=A({},sd,{view:0,detail:0}),vd=rd(ud),wd,xd,yd,Ad=A({},ud,{screenX:0,screenY:0,clientX:0,clientY:0,pageX:0,pageY:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,getModifierState:zd,button:0,buttons:0,relatedTarget:function(a){return void 0===a.relatedTarget?a.fromElement===a.srcElement?a.toElement:a.fromElement:a.relatedTarget},movementX:function(a){if("movementX"in
a)return a.movementX;a!==yd&&(yd&&"mousemove"===a.type?(wd=a.screenX-yd.screenX,xd=a.screenY-yd.screenY):xd=wd=0,yd=a);return wd},movementY:function(a){return "movementY"in a?a.movementY:xd}}),Bd=rd(Ad),Cd=A({},Ad,{dataTransfer:0}),Dd=rd(Cd),Ed=A({},ud,{relatedTarget:0}),Fd=rd(Ed),Gd=A({},sd,{animationName:0,elapsedTime:0,pseudoElement:0}),Hd=rd(Gd),Id=A({},sd,{clipboardData:function(a){return "clipboardData"in a?a.clipboardData:window.clipboardData}}),Jd=rd(Id),Kd=A({},sd,{data:0}),Ld=rd(Kd),Md={Esc:"Escape",
Spacebar:" ",Left:"ArrowLeft",Up:"ArrowUp",Right:"ArrowRight",Down:"ArrowDown",Del:"Delete",Win:"OS",Menu:"ContextMenu",Apps:"ContextMenu",Scroll:"ScrollLock",MozPrintableKey:"Unidentified"},Nd={8:"Backspace",9:"Tab",12:"Clear",13:"Enter",16:"Shift",17:"Control",18:"Alt",19:"Pause",20:"CapsLock",27:"Escape",32:" ",33:"PageUp",34:"PageDown",35:"End",36:"Home",37:"ArrowLeft",38:"ArrowUp",39:"ArrowRight",40:"ArrowDown",45:"Insert",46:"Delete",112:"F1",113:"F2",114:"F3",115:"F4",116:"F5",117:"F6",118:"F7",
119:"F8",120:"F9",121:"F10",122:"F11",123:"F12",144:"NumLock",145:"ScrollLock",224:"Meta"},Od={Alt:"altKey",Control:"ctrlKey",Meta:"metaKey",Shift:"shiftKey"};function Pd(a){var b=this.nativeEvent;return b.getModifierState?b.getModifierState(a):(a=Od[a])?!!b[a]:!1}function zd(){return Pd}
var Qd=A({},ud,{key:function(a){if(a.key){var b=Md[a.key]||a.key;if("Unidentified"!==b)return b}return "keypress"===a.type?(a=od(a),13===a?"Enter":String.fromCharCode(a)):"keydown"===a.type||"keyup"===a.type?Nd[a.keyCode]||"Unidentified":""},code:0,location:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,repeat:0,locale:0,getModifierState:zd,charCode:function(a){return "keypress"===a.type?od(a):0},keyCode:function(a){return "keydown"===a.type||"keyup"===a.type?a.keyCode:0},which:function(a){return "keypress"===
a.type?od(a):"keydown"===a.type||"keyup"===a.type?a.keyCode:0}}),Rd=rd(Qd),Sd=A({},Ad,{pointerId:0,width:0,height:0,pressure:0,tangentialPressure:0,tiltX:0,tiltY:0,twist:0,pointerType:0,isPrimary:0}),Td=rd(Sd),Ud=A({},ud,{touches:0,targetTouches:0,changedTouches:0,altKey:0,metaKey:0,ctrlKey:0,shiftKey:0,getModifierState:zd}),Vd=rd(Ud),Wd=A({},sd,{propertyName:0,elapsedTime:0,pseudoElement:0}),Xd=rd(Wd),Yd=A({},Ad,{deltaX:function(a){return "deltaX"in a?a.deltaX:"wheelDeltaX"in a?-a.wheelDeltaX:0},
deltaY:function(a){return "deltaY"in a?a.deltaY:"wheelDeltaY"in a?-a.wheelDeltaY:"wheelDelta"in a?-a.wheelDelta:0},deltaZ:0,deltaMode:0}),Zd=rd(Yd),$d=[9,13,27,32],ae=ia&&"CompositionEvent"in window,be=null;ia&&"documentMode"in document&&(be=document.documentMode);var ce=ia&&"TextEvent"in window&&!be,de=ia&&(!ae||be&&8<be&&11>=be),ee=String.fromCharCode(32),fe=!1;
function ge(a,b){switch(a){case "keyup":return -1!==$d.indexOf(b.keyCode);case "keydown":return 229!==b.keyCode;case "keypress":case "mousedown":case "focusout":return !0;default:return !1}}function he(a){a=a.detail;return "object"===typeof a&&"data"in a?a.data:null}var ie=!1;function je(a,b){switch(a){case "compositionend":return he(b);case "keypress":if(32!==b.which)return null;fe=!0;return ee;case "textInput":return a=b.data,a===ee&&fe?null:a;default:return null}}
function ke(a,b){if(ie)return "compositionend"===a||!ae&&ge(a,b)?(a=nd(),md=ld=kd=null,ie=!1,a):null;switch(a){case "paste":return null;case "keypress":if(!(b.ctrlKey||b.altKey||b.metaKey)||b.ctrlKey&&b.altKey){if(b.char&&1<b.char.length)return b.char;if(b.which)return String.fromCharCode(b.which)}return null;case "compositionend":return de&&"ko"!==b.locale?null:b.data;default:return null}}
var le={color:!0,date:!0,datetime:!0,"datetime-local":!0,email:!0,month:!0,number:!0,password:!0,range:!0,search:!0,tel:!0,text:!0,time:!0,url:!0,week:!0};function me(a){var b=a&&a.nodeName&&a.nodeName.toLowerCase();return "input"===b?!!le[a.type]:"textarea"===b?!0:!1}function ne(a,b,c,d){Eb(d);b=oe(b,"onChange");0<b.length&&(c=new td("onChange","change",null,c,d),a.push({event:c,listeners:b}));}var pe=null,qe=null;function re(a){se(a,0);}function te(a){var b=ue(a);if(Wa(b))return a}
function ve(a,b){if("change"===a)return b}var we=!1;if(ia){var xe;if(ia){var ye="oninput"in document;if(!ye){var ze=document.createElement("div");ze.setAttribute("oninput","return;");ye="function"===typeof ze.oninput;}xe=ye;}else xe=!1;we=xe&&(!document.documentMode||9<document.documentMode);}function Ae(){pe&&(pe.detachEvent("onpropertychange",Be),qe=pe=null);}function Be(a){if("value"===a.propertyName&&te(qe)){var b=[];ne(b,qe,a,xb(a));Jb(re,b);}}
function Ce(a,b,c){"focusin"===a?(Ae(),pe=b,qe=c,pe.attachEvent("onpropertychange",Be)):"focusout"===a&&Ae();}function De(a){if("selectionchange"===a||"keyup"===a||"keydown"===a)return te(qe)}function Ee(a,b){if("click"===a)return te(b)}function Fe(a,b){if("input"===a||"change"===a)return te(b)}function Ge(a,b){return a===b&&(0!==a||1/a===1/b)||a!==a&&b!==b}var He="function"===typeof Object.is?Object.is:Ge;
function Ie(a,b){if(He(a,b))return !0;if("object"!==typeof a||null===a||"object"!==typeof b||null===b)return !1;var c=Object.keys(a),d=Object.keys(b);if(c.length!==d.length)return !1;for(d=0;d<c.length;d++){var e=c[d];if(!ja.call(b,e)||!He(a[e],b[e]))return !1}return !0}function Je(a){for(;a&&a.firstChild;)a=a.firstChild;return a}
function Ke(a,b){var c=Je(a);a=0;for(var d;c;){if(3===c.nodeType){d=a+c.textContent.length;if(a<=b&&d>=b)return {node:c,offset:b-a};a=d;}a:{for(;c;){if(c.nextSibling){c=c.nextSibling;break a}c=c.parentNode;}c=void 0;}c=Je(c);}}function Le(a,b){return a&&b?a===b?!0:a&&3===a.nodeType?!1:b&&3===b.nodeType?Le(a,b.parentNode):"contains"in a?a.contains(b):a.compareDocumentPosition?!!(a.compareDocumentPosition(b)&16):!1:!1}
function Me(){for(var a=window,b=Xa();b instanceof a.HTMLIFrameElement;){try{var c="string"===typeof b.contentWindow.location.href;}catch(d){c=!1;}if(c)a=b.contentWindow;else break;b=Xa(a.document);}return b}function Ne(a){var b=a&&a.nodeName&&a.nodeName.toLowerCase();return b&&("input"===b&&("text"===a.type||"search"===a.type||"tel"===a.type||"url"===a.type||"password"===a.type)||"textarea"===b||"true"===a.contentEditable)}
function Oe(a){var b=Me(),c=a.focusedElem,d=a.selectionRange;if(b!==c&&c&&c.ownerDocument&&Le(c.ownerDocument.documentElement,c)){if(null!==d&&Ne(c))if(b=d.start,a=d.end,void 0===a&&(a=b),"selectionStart"in c)c.selectionStart=b,c.selectionEnd=Math.min(a,c.value.length);else if(a=(b=c.ownerDocument||document)&&b.defaultView||window,a.getSelection){a=a.getSelection();var e=c.textContent.length,f=Math.min(d.start,e);d=void 0===d.end?f:Math.min(d.end,e);!a.extend&&f>d&&(e=d,d=f,f=e);e=Ke(c,f);var g=Ke(c,
d);e&&g&&(1!==a.rangeCount||a.anchorNode!==e.node||a.anchorOffset!==e.offset||a.focusNode!==g.node||a.focusOffset!==g.offset)&&(b=b.createRange(),b.setStart(e.node,e.offset),a.removeAllRanges(),f>d?(a.addRange(b),a.extend(g.node,g.offset)):(b.setEnd(g.node,g.offset),a.addRange(b)));}b=[];for(a=c;a=a.parentNode;)1===a.nodeType&&b.push({element:a,left:a.scrollLeft,top:a.scrollTop});"function"===typeof c.focus&&c.focus();for(c=0;c<b.length;c++)a=b[c],a.element.scrollLeft=a.left,a.element.scrollTop=a.top;}}
var Pe=ia&&"documentMode"in document&&11>=document.documentMode,Qe=null,Re=null,Se=null,Te=!1;
function Ue(a,b,c){var d=c.window===c?c.document:9===c.nodeType?c:c.ownerDocument;Te||null==Qe||Qe!==Xa(d)||(d=Qe,"selectionStart"in d&&Ne(d)?d={start:d.selectionStart,end:d.selectionEnd}:(d=(d.ownerDocument&&d.ownerDocument.defaultView||window).getSelection(),d={anchorNode:d.anchorNode,anchorOffset:d.anchorOffset,focusNode:d.focusNode,focusOffset:d.focusOffset}),Se&&Ie(Se,d)||(Se=d,d=oe(Re,"onSelect"),0<d.length&&(b=new td("onSelect","select",null,b,c),a.push({event:b,listeners:d}),b.target=Qe)));}
function Ve(a,b){var c={};c[a.toLowerCase()]=b.toLowerCase();c["Webkit"+a]="webkit"+b;c["Moz"+a]="moz"+b;return c}var We={animationend:Ve("Animation","AnimationEnd"),animationiteration:Ve("Animation","AnimationIteration"),animationstart:Ve("Animation","AnimationStart"),transitionend:Ve("Transition","TransitionEnd")},Xe={},Ye={};
ia&&(Ye=document.createElement("div").style,"AnimationEvent"in window||(delete We.animationend.animation,delete We.animationiteration.animation,delete We.animationstart.animation),"TransitionEvent"in window||delete We.transitionend.transition);function Ze(a){if(Xe[a])return Xe[a];if(!We[a])return a;var b=We[a],c;for(c in b)if(b.hasOwnProperty(c)&&c in Ye)return Xe[a]=b[c];return a}var $e=Ze("animationend"),af=Ze("animationiteration"),bf=Ze("animationstart"),cf=Ze("transitionend"),df=new Map,ef="abort auxClick cancel canPlay canPlayThrough click close contextMenu copy cut drag dragEnd dragEnter dragExit dragLeave dragOver dragStart drop durationChange emptied encrypted ended error gotPointerCapture input invalid keyDown keyPress keyUp load loadedData loadedMetadata loadStart lostPointerCapture mouseDown mouseMove mouseOut mouseOver mouseUp paste pause play playing pointerCancel pointerDown pointerMove pointerOut pointerOver pointerUp progress rateChange reset resize seeked seeking stalled submit suspend timeUpdate touchCancel touchEnd touchStart volumeChange scroll toggle touchMove waiting wheel".split(" ");
function ff(a,b){df.set(a,b);fa(b,[a]);}for(var gf=0;gf<ef.length;gf++){var hf=ef[gf],jf=hf.toLowerCase(),kf=hf[0].toUpperCase()+hf.slice(1);ff(jf,"on"+kf);}ff($e,"onAnimationEnd");ff(af,"onAnimationIteration");ff(bf,"onAnimationStart");ff("dblclick","onDoubleClick");ff("focusin","onFocus");ff("focusout","onBlur");ff(cf,"onTransitionEnd");ha("onMouseEnter",["mouseout","mouseover"]);ha("onMouseLeave",["mouseout","mouseover"]);ha("onPointerEnter",["pointerout","pointerover"]);
ha("onPointerLeave",["pointerout","pointerover"]);fa("onChange","change click focusin focusout input keydown keyup selectionchange".split(" "));fa("onSelect","focusout contextmenu dragend focusin keydown keyup mousedown mouseup selectionchange".split(" "));fa("onBeforeInput",["compositionend","keypress","textInput","paste"]);fa("onCompositionEnd","compositionend focusout keydown keypress keyup mousedown".split(" "));fa("onCompositionStart","compositionstart focusout keydown keypress keyup mousedown".split(" "));
fa("onCompositionUpdate","compositionupdate focusout keydown keypress keyup mousedown".split(" "));var lf="abort canplay canplaythrough durationchange emptied encrypted ended error loadeddata loadedmetadata loadstart pause play playing progress ratechange resize seeked seeking stalled suspend timeupdate volumechange waiting".split(" "),mf=new Set("cancel close invalid load scroll toggle".split(" ").concat(lf));
function nf(a,b,c){var d=a.type||"unknown-event";a.currentTarget=c;Ub(d,b,void 0,a);a.currentTarget=null;}
function se(a,b){b=0!==(b&4);for(var c=0;c<a.length;c++){var d=a[c],e=d.event;d=d.listeners;a:{var f=void 0;if(b)for(var g=d.length-1;0<=g;g--){var h=d[g],k=h.instance,l=h.currentTarget;h=h.listener;if(k!==f&&e.isPropagationStopped())break a;nf(e,h,l);f=k;}else for(g=0;g<d.length;g++){h=d[g];k=h.instance;l=h.currentTarget;h=h.listener;if(k!==f&&e.isPropagationStopped())break a;nf(e,h,l);f=k;}}}if(Qb)throw a=Rb,Qb=!1,Rb=null,a;}
function D(a,b){var c=b[of];void 0===c&&(c=b[of]=new Set);var d=a+"__bubble";c.has(d)||(pf(b,a,2,!1),c.add(d));}function qf(a,b,c){var d=0;b&&(d|=4);pf(c,a,d,b);}var rf="_reactListening"+Math.random().toString(36).slice(2);function sf(a){if(!a[rf]){a[rf]=!0;da.forEach(function(b){"selectionchange"!==b&&(mf.has(b)||qf(b,!1,a),qf(b,!0,a));});var b=9===a.nodeType?a:a.ownerDocument;null===b||b[rf]||(b[rf]=!0,qf("selectionchange",!1,b));}}
function pf(a,b,c,d){switch(jd(b)){case 1:var e=ed;break;case 4:e=gd;break;default:e=fd;}c=e.bind(null,b,c,a);e=void 0;!Lb||"touchstart"!==b&&"touchmove"!==b&&"wheel"!==b||(e=!0);d?void 0!==e?a.addEventListener(b,c,{capture:!0,passive:e}):a.addEventListener(b,c,!0):void 0!==e?a.addEventListener(b,c,{passive:e}):a.addEventListener(b,c,!1);}
function hd(a,b,c,d,e){var f=d;if(0===(b&1)&&0===(b&2)&&null!==d)a:for(;;){if(null===d)return;var g=d.tag;if(3===g||4===g){var h=d.stateNode.containerInfo;if(h===e||8===h.nodeType&&h.parentNode===e)break;if(4===g)for(g=d.return;null!==g;){var k=g.tag;if(3===k||4===k)if(k=g.stateNode.containerInfo,k===e||8===k.nodeType&&k.parentNode===e)return;g=g.return;}for(;null!==h;){g=Wc(h);if(null===g)return;k=g.tag;if(5===k||6===k){d=f=g;continue a}h=h.parentNode;}}d=d.return;}Jb(function(){var d=f,e=xb(c),g=[];
a:{var h=df.get(a);if(void 0!==h){var k=td,n=a;switch(a){case "keypress":if(0===od(c))break a;case "keydown":case "keyup":k=Rd;break;case "focusin":n="focus";k=Fd;break;case "focusout":n="blur";k=Fd;break;case "beforeblur":case "afterblur":k=Fd;break;case "click":if(2===c.button)break a;case "auxclick":case "dblclick":case "mousedown":case "mousemove":case "mouseup":case "mouseout":case "mouseover":case "contextmenu":k=Bd;break;case "drag":case "dragend":case "dragenter":case "dragexit":case "dragleave":case "dragover":case "dragstart":case "drop":k=
Dd;break;case "touchcancel":case "touchend":case "touchmove":case "touchstart":k=Vd;break;case $e:case af:case bf:k=Hd;break;case cf:k=Xd;break;case "scroll":k=vd;break;case "wheel":k=Zd;break;case "copy":case "cut":case "paste":k=Jd;break;case "gotpointercapture":case "lostpointercapture":case "pointercancel":case "pointerdown":case "pointermove":case "pointerout":case "pointerover":case "pointerup":k=Td;}var t=0!==(b&4),J=!t&&"scroll"===a,x=t?null!==h?h+"Capture":null:h;t=[];for(var w=d,u;null!==
w;){u=w;var F=u.stateNode;5===u.tag&&null!==F&&(u=F,null!==x&&(F=Kb(w,x),null!=F&&t.push(tf(w,F,u))));if(J)break;w=w.return;}0<t.length&&(h=new k(h,n,null,c,e),g.push({event:h,listeners:t}));}}if(0===(b&7)){a:{h="mouseover"===a||"pointerover"===a;k="mouseout"===a||"pointerout"===a;if(h&&c!==wb&&(n=c.relatedTarget||c.fromElement)&&(Wc(n)||n[uf]))break a;if(k||h){h=e.window===e?e:(h=e.ownerDocument)?h.defaultView||h.parentWindow:window;if(k){if(n=c.relatedTarget||c.toElement,k=d,n=n?Wc(n):null,null!==
n&&(J=Vb(n),n!==J||5!==n.tag&&6!==n.tag))n=null;}else k=null,n=d;if(k!==n){t=Bd;F="onMouseLeave";x="onMouseEnter";w="mouse";if("pointerout"===a||"pointerover"===a)t=Td,F="onPointerLeave",x="onPointerEnter",w="pointer";J=null==k?h:ue(k);u=null==n?h:ue(n);h=new t(F,w+"leave",k,c,e);h.target=J;h.relatedTarget=u;F=null;Wc(e)===d&&(t=new t(x,w+"enter",n,c,e),t.target=u,t.relatedTarget=J,F=t);J=F;if(k&&n)b:{t=k;x=n;w=0;for(u=t;u;u=vf(u))w++;u=0;for(F=x;F;F=vf(F))u++;for(;0<w-u;)t=vf(t),w--;for(;0<u-w;)x=
vf(x),u--;for(;w--;){if(t===x||null!==x&&t===x.alternate)break b;t=vf(t);x=vf(x);}t=null;}else t=null;null!==k&&wf(g,h,k,t,!1);null!==n&&null!==J&&wf(g,J,n,t,!0);}}}a:{h=d?ue(d):window;k=h.nodeName&&h.nodeName.toLowerCase();if("select"===k||"input"===k&&"file"===h.type)var na=ve;else if(me(h))if(we)na=Fe;else {na=De;var xa=Ce;}else (k=h.nodeName)&&"input"===k.toLowerCase()&&("checkbox"===h.type||"radio"===h.type)&&(na=Ee);if(na&&(na=na(a,d))){ne(g,na,c,e);break a}xa&&xa(a,h,d);"focusout"===a&&(xa=h._wrapperState)&&
xa.controlled&&"number"===h.type&&cb(h,"number",h.value);}xa=d?ue(d):window;switch(a){case "focusin":if(me(xa)||"true"===xa.contentEditable)Qe=xa,Re=d,Se=null;break;case "focusout":Se=Re=Qe=null;break;case "mousedown":Te=!0;break;case "contextmenu":case "mouseup":case "dragend":Te=!1;Ue(g,c,e);break;case "selectionchange":if(Pe)break;case "keydown":case "keyup":Ue(g,c,e);}var $a;if(ae)b:{switch(a){case "compositionstart":var ba="onCompositionStart";break b;case "compositionend":ba="onCompositionEnd";
break b;case "compositionupdate":ba="onCompositionUpdate";break b}ba=void 0;}else ie?ge(a,c)&&(ba="onCompositionEnd"):"keydown"===a&&229===c.keyCode&&(ba="onCompositionStart");ba&&(de&&"ko"!==c.locale&&(ie||"onCompositionStart"!==ba?"onCompositionEnd"===ba&&ie&&($a=nd()):(kd=e,ld="value"in kd?kd.value:kd.textContent,ie=!0)),xa=oe(d,ba),0<xa.length&&(ba=new Ld(ba,a,null,c,e),g.push({event:ba,listeners:xa}),$a?ba.data=$a:($a=he(c),null!==$a&&(ba.data=$a))));if($a=ce?je(a,c):ke(a,c))d=oe(d,"onBeforeInput"),
0<d.length&&(e=new Ld("onBeforeInput","beforeinput",null,c,e),g.push({event:e,listeners:d}),e.data=$a);}se(g,b);});}function tf(a,b,c){return {instance:a,listener:b,currentTarget:c}}function oe(a,b){for(var c=b+"Capture",d=[];null!==a;){var e=a,f=e.stateNode;5===e.tag&&null!==f&&(e=f,f=Kb(a,c),null!=f&&d.unshift(tf(a,f,e)),f=Kb(a,b),null!=f&&d.push(tf(a,f,e)));a=a.return;}return d}function vf(a){if(null===a)return null;do a=a.return;while(a&&5!==a.tag);return a?a:null}
function wf(a,b,c,d,e){for(var f=b._reactName,g=[];null!==c&&c!==d;){var h=c,k=h.alternate,l=h.stateNode;if(null!==k&&k===d)break;5===h.tag&&null!==l&&(h=l,e?(k=Kb(c,f),null!=k&&g.unshift(tf(c,k,h))):e||(k=Kb(c,f),null!=k&&g.push(tf(c,k,h))));c=c.return;}0!==g.length&&a.push({event:b,listeners:g});}var xf=/\r\n?/g,yf=/\u0000|\uFFFD/g;function zf(a){return ("string"===typeof a?a:""+a).replace(xf,"\n").replace(yf,"")}function Af(a,b,c){b=zf(b);if(zf(a)!==b&&c)throw Error(p(425));}function Bf(){}
var Cf=null,Df=null;function Ef(a,b){return "textarea"===a||"noscript"===a||"string"===typeof b.children||"number"===typeof b.children||"object"===typeof b.dangerouslySetInnerHTML&&null!==b.dangerouslySetInnerHTML&&null!=b.dangerouslySetInnerHTML.__html}
var Ff="function"===typeof setTimeout?setTimeout:void 0,Gf="function"===typeof clearTimeout?clearTimeout:void 0,Hf="function"===typeof Promise?Promise:void 0,Jf="function"===typeof queueMicrotask?queueMicrotask:"undefined"!==typeof Hf?function(a){return Hf.resolve(null).then(a).catch(If)}:Ff;function If(a){setTimeout(function(){throw a;});}
function Kf(a,b){var c=b,d=0;do{var e=c.nextSibling;a.removeChild(c);if(e&&8===e.nodeType)if(c=e.data,"/$"===c){if(0===d){a.removeChild(e);bd(b);return}d--;}else "$"!==c&&"$?"!==c&&"$!"!==c||d++;c=e;}while(c);bd(b);}function Lf(a){for(;null!=a;a=a.nextSibling){var b=a.nodeType;if(1===b||3===b)break;if(8===b){b=a.data;if("$"===b||"$!"===b||"$?"===b)break;if("/$"===b)return null}}return a}
function Mf(a){a=a.previousSibling;for(var b=0;a;){if(8===a.nodeType){var c=a.data;if("$"===c||"$!"===c||"$?"===c){if(0===b)return a;b--;}else "/$"===c&&b++;}a=a.previousSibling;}return null}var Nf=Math.random().toString(36).slice(2),Of="__reactFiber$"+Nf,Pf="__reactProps$"+Nf,uf="__reactContainer$"+Nf,of="__reactEvents$"+Nf,Qf="__reactListeners$"+Nf,Rf="__reactHandles$"+Nf;
function Wc(a){var b=a[Of];if(b)return b;for(var c=a.parentNode;c;){if(b=c[uf]||c[Of]){c=b.alternate;if(null!==b.child||null!==c&&null!==c.child)for(a=Mf(a);null!==a;){if(c=a[Of])return c;a=Mf(a);}return b}a=c;c=a.parentNode;}return null}function Cb(a){a=a[Of]||a[uf];return !a||5!==a.tag&&6!==a.tag&&13!==a.tag&&3!==a.tag?null:a}function ue(a){if(5===a.tag||6===a.tag)return a.stateNode;throw Error(p(33));}function Db(a){return a[Pf]||null}var Sf=[],Tf=-1;function Uf(a){return {current:a}}
function E(a){0>Tf||(a.current=Sf[Tf],Sf[Tf]=null,Tf--);}function G(a,b){Tf++;Sf[Tf]=a.current;a.current=b;}var Vf={},H=Uf(Vf),Wf=Uf(!1),Xf=Vf;function Yf(a,b){var c=a.type.contextTypes;if(!c)return Vf;var d=a.stateNode;if(d&&d.__reactInternalMemoizedUnmaskedChildContext===b)return d.__reactInternalMemoizedMaskedChildContext;var e={},f;for(f in c)e[f]=b[f];d&&(a=a.stateNode,a.__reactInternalMemoizedUnmaskedChildContext=b,a.__reactInternalMemoizedMaskedChildContext=e);return e}
function Zf(a){a=a.childContextTypes;return null!==a&&void 0!==a}function $f(){E(Wf);E(H);}function ag(a,b,c){if(H.current!==Vf)throw Error(p(168));G(H,b);G(Wf,c);}function bg(a,b,c){var d=a.stateNode;b=b.childContextTypes;if("function"!==typeof d.getChildContext)return c;d=d.getChildContext();for(var e in d)if(!(e in b))throw Error(p(108,Ra(a)||"Unknown",e));return A({},c,d)}
function cg(a){a=(a=a.stateNode)&&a.__reactInternalMemoizedMergedChildContext||Vf;Xf=H.current;G(H,a);G(Wf,Wf.current);return !0}function dg(a,b,c){var d=a.stateNode;if(!d)throw Error(p(169));c?(a=bg(a,b,Xf),d.__reactInternalMemoizedMergedChildContext=a,E(Wf),E(H),G(H,a)):E(Wf);G(Wf,c);}var eg=null,fg=!1,gg=!1;function hg(a){null===eg?eg=[a]:eg.push(a);}function ig(a){fg=!0;hg(a);}
function jg(){if(!gg&&null!==eg){gg=!0;var a=0,b=C;try{var c=eg;for(C=1;a<c.length;a++){var d=c[a];do d=d(!0);while(null!==d)}eg=null;fg=!1;}catch(e){throw null!==eg&&(eg=eg.slice(a+1)),ac(fc,jg),e;}finally{C=b,gg=!1;}}return null}var kg=[],lg=0,mg=null,ng=0,og=[],pg=0,qg=null,rg=1,sg="";function tg(a,b){kg[lg++]=ng;kg[lg++]=mg;mg=a;ng=b;}
function ug(a,b,c){og[pg++]=rg;og[pg++]=sg;og[pg++]=qg;qg=a;var d=rg;a=sg;var e=32-oc(d)-1;d&=~(1<<e);c+=1;var f=32-oc(b)+e;if(30<f){var g=e-e%5;f=(d&(1<<g)-1).toString(32);d>>=g;e-=g;rg=1<<32-oc(b)+e|c<<e|d;sg=f+a;}else rg=1<<f|c<<e|d,sg=a;}function vg(a){null!==a.return&&(tg(a,1),ug(a,1,0));}function wg(a){for(;a===mg;)mg=kg[--lg],kg[lg]=null,ng=kg[--lg],kg[lg]=null;for(;a===qg;)qg=og[--pg],og[pg]=null,sg=og[--pg],og[pg]=null,rg=og[--pg],og[pg]=null;}var xg=null,yg=null,I=!1,zg=null;
function Ag(a,b){var c=Bg(5,null,null,0);c.elementType="DELETED";c.stateNode=b;c.return=a;b=a.deletions;null===b?(a.deletions=[c],a.flags|=16):b.push(c);}
function Cg(a,b){switch(a.tag){case 5:var c=a.type;b=1!==b.nodeType||c.toLowerCase()!==b.nodeName.toLowerCase()?null:b;return null!==b?(a.stateNode=b,xg=a,yg=Lf(b.firstChild),!0):!1;case 6:return b=""===a.pendingProps||3!==b.nodeType?null:b,null!==b?(a.stateNode=b,xg=a,yg=null,!0):!1;case 13:return b=8!==b.nodeType?null:b,null!==b?(c=null!==qg?{id:rg,overflow:sg}:null,a.memoizedState={dehydrated:b,treeContext:c,retryLane:1073741824},c=Bg(18,null,null,0),c.stateNode=b,c.return=a,a.child=c,xg=a,yg=
null,!0):!1;default:return !1}}function Dg(a){return 0!==(a.mode&1)&&0===(a.flags&128)}function Eg(a){if(I){var b=yg;if(b){var c=b;if(!Cg(a,b)){if(Dg(a))throw Error(p(418));b=Lf(c.nextSibling);var d=xg;b&&Cg(a,b)?Ag(d,c):(a.flags=a.flags&-4097|2,I=!1,xg=a);}}else {if(Dg(a))throw Error(p(418));a.flags=a.flags&-4097|2;I=!1;xg=a;}}}function Fg(a){for(a=a.return;null!==a&&5!==a.tag&&3!==a.tag&&13!==a.tag;)a=a.return;xg=a;}
function Gg(a){if(a!==xg)return !1;if(!I)return Fg(a),I=!0,!1;var b;(b=3!==a.tag)&&!(b=5!==a.tag)&&(b=a.type,b="head"!==b&&"body"!==b&&!Ef(a.type,a.memoizedProps));if(b&&(b=yg)){if(Dg(a))throw Hg(),Error(p(418));for(;b;)Ag(a,b),b=Lf(b.nextSibling);}Fg(a);if(13===a.tag){a=a.memoizedState;a=null!==a?a.dehydrated:null;if(!a)throw Error(p(317));a:{a=a.nextSibling;for(b=0;a;){if(8===a.nodeType){var c=a.data;if("/$"===c){if(0===b){yg=Lf(a.nextSibling);break a}b--;}else "$"!==c&&"$!"!==c&&"$?"!==c||b++;}a=a.nextSibling;}yg=
null;}}else yg=xg?Lf(a.stateNode.nextSibling):null;return !0}function Hg(){for(var a=yg;a;)a=Lf(a.nextSibling);}function Ig(){yg=xg=null;I=!1;}function Jg(a){null===zg?zg=[a]:zg.push(a);}var Kg=ua.ReactCurrentBatchConfig;
function Lg(a,b,c){a=c.ref;if(null!==a&&"function"!==typeof a&&"object"!==typeof a){if(c._owner){c=c._owner;if(c){if(1!==c.tag)throw Error(p(309));var d=c.stateNode;}if(!d)throw Error(p(147,a));var e=d,f=""+a;if(null!==b&&null!==b.ref&&"function"===typeof b.ref&&b.ref._stringRef===f)return b.ref;b=function(a){var b=e.refs;null===a?delete b[f]:b[f]=a;};b._stringRef=f;return b}if("string"!==typeof a)throw Error(p(284));if(!c._owner)throw Error(p(290,a));}return a}
function Mg(a,b){a=Object.prototype.toString.call(b);throw Error(p(31,"[object Object]"===a?"object with keys {"+Object.keys(b).join(", ")+"}":a));}function Ng(a){var b=a._init;return b(a._payload)}
function Og(a){function b(b,c){if(a){var d=b.deletions;null===d?(b.deletions=[c],b.flags|=16):d.push(c);}}function c(c,d){if(!a)return null;for(;null!==d;)b(c,d),d=d.sibling;return null}function d(a,b){for(a=new Map;null!==b;)null!==b.key?a.set(b.key,b):a.set(b.index,b),b=b.sibling;return a}function e(a,b){a=Pg(a,b);a.index=0;a.sibling=null;return a}function f(b,c,d){b.index=d;if(!a)return b.flags|=1048576,c;d=b.alternate;if(null!==d)return d=d.index,d<c?(b.flags|=2,c):d;b.flags|=2;return c}function g(b){a&&
null===b.alternate&&(b.flags|=2);return b}function h(a,b,c,d){if(null===b||6!==b.tag)return b=Qg(c,a.mode,d),b.return=a,b;b=e(b,c);b.return=a;return b}function k(a,b,c,d){var f=c.type;if(f===ya)return m(a,b,c.props.children,d,c.key);if(null!==b&&(b.elementType===f||"object"===typeof f&&null!==f&&f.$$typeof===Ha&&Ng(f)===b.type))return d=e(b,c.props),d.ref=Lg(a,b,c),d.return=a,d;d=Rg(c.type,c.key,c.props,null,a.mode,d);d.ref=Lg(a,b,c);d.return=a;return d}function l(a,b,c,d){if(null===b||4!==b.tag||
b.stateNode.containerInfo!==c.containerInfo||b.stateNode.implementation!==c.implementation)return b=Sg(c,a.mode,d),b.return=a,b;b=e(b,c.children||[]);b.return=a;return b}function m(a,b,c,d,f){if(null===b||7!==b.tag)return b=Tg(c,a.mode,d,f),b.return=a,b;b=e(b,c);b.return=a;return b}function q(a,b,c){if("string"===typeof b&&""!==b||"number"===typeof b)return b=Qg(""+b,a.mode,c),b.return=a,b;if("object"===typeof b&&null!==b){switch(b.$$typeof){case va:return c=Rg(b.type,b.key,b.props,null,a.mode,c),
c.ref=Lg(a,null,b),c.return=a,c;case wa:return b=Sg(b,a.mode,c),b.return=a,b;case Ha:var d=b._init;return q(a,d(b._payload),c)}if(eb(b)||Ka(b))return b=Tg(b,a.mode,c,null),b.return=a,b;Mg(a,b);}return null}function r(a,b,c,d){var e=null!==b?b.key:null;if("string"===typeof c&&""!==c||"number"===typeof c)return null!==e?null:h(a,b,""+c,d);if("object"===typeof c&&null!==c){switch(c.$$typeof){case va:return c.key===e?k(a,b,c,d):null;case wa:return c.key===e?l(a,b,c,d):null;case Ha:return e=c._init,r(a,
b,e(c._payload),d)}if(eb(c)||Ka(c))return null!==e?null:m(a,b,c,d,null);Mg(a,c);}return null}function y(a,b,c,d,e){if("string"===typeof d&&""!==d||"number"===typeof d)return a=a.get(c)||null,h(b,a,""+d,e);if("object"===typeof d&&null!==d){switch(d.$$typeof){case va:return a=a.get(null===d.key?c:d.key)||null,k(b,a,d,e);case wa:return a=a.get(null===d.key?c:d.key)||null,l(b,a,d,e);case Ha:var f=d._init;return y(a,b,c,f(d._payload),e)}if(eb(d)||Ka(d))return a=a.get(c)||null,m(b,a,d,e,null);Mg(b,d);}return null}
function n(e,g,h,k){for(var l=null,m=null,u=g,w=g=0,x=null;null!==u&&w<h.length;w++){u.index>w?(x=u,u=null):x=u.sibling;var n=r(e,u,h[w],k);if(null===n){null===u&&(u=x);break}a&&u&&null===n.alternate&&b(e,u);g=f(n,g,w);null===m?l=n:m.sibling=n;m=n;u=x;}if(w===h.length)return c(e,u),I&&tg(e,w),l;if(null===u){for(;w<h.length;w++)u=q(e,h[w],k),null!==u&&(g=f(u,g,w),null===m?l=u:m.sibling=u,m=u);I&&tg(e,w);return l}for(u=d(e,u);w<h.length;w++)x=y(u,e,w,h[w],k),null!==x&&(a&&null!==x.alternate&&u.delete(null===
x.key?w:x.key),g=f(x,g,w),null===m?l=x:m.sibling=x,m=x);a&&u.forEach(function(a){return b(e,a)});I&&tg(e,w);return l}function t(e,g,h,k){var l=Ka(h);if("function"!==typeof l)throw Error(p(150));h=l.call(h);if(null==h)throw Error(p(151));for(var u=l=null,m=g,w=g=0,x=null,n=h.next();null!==m&&!n.done;w++,n=h.next()){m.index>w?(x=m,m=null):x=m.sibling;var t=r(e,m,n.value,k);if(null===t){null===m&&(m=x);break}a&&m&&null===t.alternate&&b(e,m);g=f(t,g,w);null===u?l=t:u.sibling=t;u=t;m=x;}if(n.done)return c(e,
m),I&&tg(e,w),l;if(null===m){for(;!n.done;w++,n=h.next())n=q(e,n.value,k),null!==n&&(g=f(n,g,w),null===u?l=n:u.sibling=n,u=n);I&&tg(e,w);return l}for(m=d(e,m);!n.done;w++,n=h.next())n=y(m,e,w,n.value,k),null!==n&&(a&&null!==n.alternate&&m.delete(null===n.key?w:n.key),g=f(n,g,w),null===u?l=n:u.sibling=n,u=n);a&&m.forEach(function(a){return b(e,a)});I&&tg(e,w);return l}function J(a,d,f,h){"object"===typeof f&&null!==f&&f.type===ya&&null===f.key&&(f=f.props.children);if("object"===typeof f&&null!==f){switch(f.$$typeof){case va:a:{for(var k=
f.key,l=d;null!==l;){if(l.key===k){k=f.type;if(k===ya){if(7===l.tag){c(a,l.sibling);d=e(l,f.props.children);d.return=a;a=d;break a}}else if(l.elementType===k||"object"===typeof k&&null!==k&&k.$$typeof===Ha&&Ng(k)===l.type){c(a,l.sibling);d=e(l,f.props);d.ref=Lg(a,l,f);d.return=a;a=d;break a}c(a,l);break}else b(a,l);l=l.sibling;}f.type===ya?(d=Tg(f.props.children,a.mode,h,f.key),d.return=a,a=d):(h=Rg(f.type,f.key,f.props,null,a.mode,h),h.ref=Lg(a,d,f),h.return=a,a=h);}return g(a);case wa:a:{for(l=f.key;null!==
d;){if(d.key===l)if(4===d.tag&&d.stateNode.containerInfo===f.containerInfo&&d.stateNode.implementation===f.implementation){c(a,d.sibling);d=e(d,f.children||[]);d.return=a;a=d;break a}else {c(a,d);break}else b(a,d);d=d.sibling;}d=Sg(f,a.mode,h);d.return=a;a=d;}return g(a);case Ha:return l=f._init,J(a,d,l(f._payload),h)}if(eb(f))return n(a,d,f,h);if(Ka(f))return t(a,d,f,h);Mg(a,f);}return "string"===typeof f&&""!==f||"number"===typeof f?(f=""+f,null!==d&&6===d.tag?(c(a,d.sibling),d=e(d,f),d.return=a,a=d):
(c(a,d),d=Qg(f,a.mode,h),d.return=a,a=d),g(a)):c(a,d)}return J}var Ug=Og(!0),Vg=Og(!1),Wg=Uf(null),Xg=null,Yg=null,Zg=null;function $g(){Zg=Yg=Xg=null;}function ah(a){var b=Wg.current;E(Wg);a._currentValue=b;}function bh(a,b,c){for(;null!==a;){var d=a.alternate;(a.childLanes&b)!==b?(a.childLanes|=b,null!==d&&(d.childLanes|=b)):null!==d&&(d.childLanes&b)!==b&&(d.childLanes|=b);if(a===c)break;a=a.return;}}
function ch(a,b){Xg=a;Zg=Yg=null;a=a.dependencies;null!==a&&null!==a.firstContext&&(0!==(a.lanes&b)&&(dh=!0),a.firstContext=null);}function eh(a){var b=a._currentValue;if(Zg!==a)if(a={context:a,memoizedValue:b,next:null},null===Yg){if(null===Xg)throw Error(p(308));Yg=a;Xg.dependencies={lanes:0,firstContext:a};}else Yg=Yg.next=a;return b}var fh=null;function gh(a){null===fh?fh=[a]:fh.push(a);}
function hh(a,b,c,d){var e=b.interleaved;null===e?(c.next=c,gh(b)):(c.next=e.next,e.next=c);b.interleaved=c;return ih(a,d)}function ih(a,b){a.lanes|=b;var c=a.alternate;null!==c&&(c.lanes|=b);c=a;for(a=a.return;null!==a;)a.childLanes|=b,c=a.alternate,null!==c&&(c.childLanes|=b),c=a,a=a.return;return 3===c.tag?c.stateNode:null}var jh=!1;function kh(a){a.updateQueue={baseState:a.memoizedState,firstBaseUpdate:null,lastBaseUpdate:null,shared:{pending:null,interleaved:null,lanes:0},effects:null};}
function lh(a,b){a=a.updateQueue;b.updateQueue===a&&(b.updateQueue={baseState:a.baseState,firstBaseUpdate:a.firstBaseUpdate,lastBaseUpdate:a.lastBaseUpdate,shared:a.shared,effects:a.effects});}function mh(a,b){return {eventTime:a,lane:b,tag:0,payload:null,callback:null,next:null}}
function nh(a,b,c){var d=a.updateQueue;if(null===d)return null;d=d.shared;if(0!==(K&2)){var e=d.pending;null===e?b.next=b:(b.next=e.next,e.next=b);d.pending=b;return ih(a,c)}e=d.interleaved;null===e?(b.next=b,gh(d)):(b.next=e.next,e.next=b);d.interleaved=b;return ih(a,c)}function oh(a,b,c){b=b.updateQueue;if(null!==b&&(b=b.shared,0!==(c&4194240))){var d=b.lanes;d&=a.pendingLanes;c|=d;b.lanes=c;Cc(a,c);}}
function ph(a,b){var c=a.updateQueue,d=a.alternate;if(null!==d&&(d=d.updateQueue,c===d)){var e=null,f=null;c=c.firstBaseUpdate;if(null!==c){do{var g={eventTime:c.eventTime,lane:c.lane,tag:c.tag,payload:c.payload,callback:c.callback,next:null};null===f?e=f=g:f=f.next=g;c=c.next;}while(null!==c);null===f?e=f=b:f=f.next=b;}else e=f=b;c={baseState:d.baseState,firstBaseUpdate:e,lastBaseUpdate:f,shared:d.shared,effects:d.effects};a.updateQueue=c;return}a=c.lastBaseUpdate;null===a?c.firstBaseUpdate=b:a.next=
b;c.lastBaseUpdate=b;}
function qh(a,b,c,d){var e=a.updateQueue;jh=!1;var f=e.firstBaseUpdate,g=e.lastBaseUpdate,h=e.shared.pending;if(null!==h){e.shared.pending=null;var k=h,l=k.next;k.next=null;null===g?f=l:g.next=l;g=k;var m=a.alternate;null!==m&&(m=m.updateQueue,h=m.lastBaseUpdate,h!==g&&(null===h?m.firstBaseUpdate=l:h.next=l,m.lastBaseUpdate=k));}if(null!==f){var q=e.baseState;g=0;m=l=k=null;h=f;do{var r=h.lane,y=h.eventTime;if((d&r)===r){null!==m&&(m=m.next={eventTime:y,lane:0,tag:h.tag,payload:h.payload,callback:h.callback,
next:null});a:{var n=a,t=h;r=b;y=c;switch(t.tag){case 1:n=t.payload;if("function"===typeof n){q=n.call(y,q,r);break a}q=n;break a;case 3:n.flags=n.flags&-65537|128;case 0:n=t.payload;r="function"===typeof n?n.call(y,q,r):n;if(null===r||void 0===r)break a;q=A({},q,r);break a;case 2:jh=!0;}}null!==h.callback&&0!==h.lane&&(a.flags|=64,r=e.effects,null===r?e.effects=[h]:r.push(h));}else y={eventTime:y,lane:r,tag:h.tag,payload:h.payload,callback:h.callback,next:null},null===m?(l=m=y,k=q):m=m.next=y,g|=r;
h=h.next;if(null===h)if(h=e.shared.pending,null===h)break;else r=h,h=r.next,r.next=null,e.lastBaseUpdate=r,e.shared.pending=null;}while(1);null===m&&(k=q);e.baseState=k;e.firstBaseUpdate=l;e.lastBaseUpdate=m;b=e.shared.interleaved;if(null!==b){e=b;do g|=e.lane,e=e.next;while(e!==b)}else null===f&&(e.shared.lanes=0);rh|=g;a.lanes=g;a.memoizedState=q;}}
function sh(a,b,c){a=b.effects;b.effects=null;if(null!==a)for(b=0;b<a.length;b++){var d=a[b],e=d.callback;if(null!==e){d.callback=null;d=c;if("function"!==typeof e)throw Error(p(191,e));e.call(d);}}}var th={},uh=Uf(th),vh=Uf(th),wh=Uf(th);function xh(a){if(a===th)throw Error(p(174));return a}
function yh(a,b){G(wh,b);G(vh,a);G(uh,th);a=b.nodeType;switch(a){case 9:case 11:b=(b=b.documentElement)?b.namespaceURI:lb(null,"");break;default:a=8===a?b.parentNode:b,b=a.namespaceURI||null,a=a.tagName,b=lb(b,a);}E(uh);G(uh,b);}function zh(){E(uh);E(vh);E(wh);}function Ah(a){xh(wh.current);var b=xh(uh.current);var c=lb(b,a.type);b!==c&&(G(vh,a),G(uh,c));}function Bh(a){vh.current===a&&(E(uh),E(vh));}var L=Uf(0);
function Ch(a){for(var b=a;null!==b;){if(13===b.tag){var c=b.memoizedState;if(null!==c&&(c=c.dehydrated,null===c||"$?"===c.data||"$!"===c.data))return b}else if(19===b.tag&&void 0!==b.memoizedProps.revealOrder){if(0!==(b.flags&128))return b}else if(null!==b.child){b.child.return=b;b=b.child;continue}if(b===a)break;for(;null===b.sibling;){if(null===b.return||b.return===a)return null;b=b.return;}b.sibling.return=b.return;b=b.sibling;}return null}var Dh=[];
function Eh(){for(var a=0;a<Dh.length;a++)Dh[a]._workInProgressVersionPrimary=null;Dh.length=0;}var Fh=ua.ReactCurrentDispatcher,Gh=ua.ReactCurrentBatchConfig,Hh=0,M=null,N$1=null,O=null,Ih=!1,Jh=!1,Kh=0,Lh=0;function P(){throw Error(p(321));}function Mh(a,b){if(null===b)return !1;for(var c=0;c<b.length&&c<a.length;c++)if(!He(a[c],b[c]))return !1;return !0}
function Nh(a,b,c,d,e,f){Hh=f;M=b;b.memoizedState=null;b.updateQueue=null;b.lanes=0;Fh.current=null===a||null===a.memoizedState?Oh:Ph;a=c(d,e);if(Jh){f=0;do{Jh=!1;Kh=0;if(25<=f)throw Error(p(301));f+=1;O=N$1=null;b.updateQueue=null;Fh.current=Qh;a=c(d,e);}while(Jh)}Fh.current=Rh;b=null!==N$1&&null!==N$1.next;Hh=0;O=N$1=M=null;Ih=!1;if(b)throw Error(p(300));return a}function Sh(){var a=0!==Kh;Kh=0;return a}
function Th(){var a={memoizedState:null,baseState:null,baseQueue:null,queue:null,next:null};null===O?M.memoizedState=O=a:O=O.next=a;return O}function Uh(){if(null===N$1){var a=M.alternate;a=null!==a?a.memoizedState:null;}else a=N$1.next;var b=null===O?M.memoizedState:O.next;if(null!==b)O=b,N$1=a;else {if(null===a)throw Error(p(310));N$1=a;a={memoizedState:N$1.memoizedState,baseState:N$1.baseState,baseQueue:N$1.baseQueue,queue:N$1.queue,next:null};null===O?M.memoizedState=O=a:O=O.next=a;}return O}
function Vh(a,b){return "function"===typeof b?b(a):b}
function Wh(a){var b=Uh(),c=b.queue;if(null===c)throw Error(p(311));c.lastRenderedReducer=a;var d=N$1,e=d.baseQueue,f=c.pending;if(null!==f){if(null!==e){var g=e.next;e.next=f.next;f.next=g;}d.baseQueue=e=f;c.pending=null;}if(null!==e){f=e.next;d=d.baseState;var h=g=null,k=null,l=f;do{var m=l.lane;if((Hh&m)===m)null!==k&&(k=k.next={lane:0,action:l.action,hasEagerState:l.hasEagerState,eagerState:l.eagerState,next:null}),d=l.hasEagerState?l.eagerState:a(d,l.action);else {var q={lane:m,action:l.action,hasEagerState:l.hasEagerState,
eagerState:l.eagerState,next:null};null===k?(h=k=q,g=d):k=k.next=q;M.lanes|=m;rh|=m;}l=l.next;}while(null!==l&&l!==f);null===k?g=d:k.next=h;He(d,b.memoizedState)||(dh=!0);b.memoizedState=d;b.baseState=g;b.baseQueue=k;c.lastRenderedState=d;}a=c.interleaved;if(null!==a){e=a;do f=e.lane,M.lanes|=f,rh|=f,e=e.next;while(e!==a)}else null===e&&(c.lanes=0);return [b.memoizedState,c.dispatch]}
function Xh(a){var b=Uh(),c=b.queue;if(null===c)throw Error(p(311));c.lastRenderedReducer=a;var d=c.dispatch,e=c.pending,f=b.memoizedState;if(null!==e){c.pending=null;var g=e=e.next;do f=a(f,g.action),g=g.next;while(g!==e);He(f,b.memoizedState)||(dh=!0);b.memoizedState=f;null===b.baseQueue&&(b.baseState=f);c.lastRenderedState=f;}return [f,d]}function Yh(){}
function Zh(a,b){var c=M,d=Uh(),e=b(),f=!He(d.memoizedState,e);f&&(d.memoizedState=e,dh=!0);d=d.queue;$h(ai.bind(null,c,d,a),[a]);if(d.getSnapshot!==b||f||null!==O&&O.memoizedState.tag&1){c.flags|=2048;bi(9,ci.bind(null,c,d,e,b),void 0,null);if(null===Q)throw Error(p(349));0!==(Hh&30)||di(c,b,e);}return e}function di(a,b,c){a.flags|=16384;a={getSnapshot:b,value:c};b=M.updateQueue;null===b?(b={lastEffect:null,stores:null},M.updateQueue=b,b.stores=[a]):(c=b.stores,null===c?b.stores=[a]:c.push(a));}
function ci(a,b,c,d){b.value=c;b.getSnapshot=d;ei(b)&&fi(a);}function ai(a,b,c){return c(function(){ei(b)&&fi(a);})}function ei(a){var b=a.getSnapshot;a=a.value;try{var c=b();return !He(a,c)}catch(d){return !0}}function fi(a){var b=ih(a,1);null!==b&&gi(b,a,1,-1);}
function hi(a){var b=Th();"function"===typeof a&&(a=a());b.memoizedState=b.baseState=a;a={pending:null,interleaved:null,lanes:0,dispatch:null,lastRenderedReducer:Vh,lastRenderedState:a};b.queue=a;a=a.dispatch=ii.bind(null,M,a);return [b.memoizedState,a]}
function bi(a,b,c,d){a={tag:a,create:b,destroy:c,deps:d,next:null};b=M.updateQueue;null===b?(b={lastEffect:null,stores:null},M.updateQueue=b,b.lastEffect=a.next=a):(c=b.lastEffect,null===c?b.lastEffect=a.next=a:(d=c.next,c.next=a,a.next=d,b.lastEffect=a));return a}function ji(){return Uh().memoizedState}function ki(a,b,c,d){var e=Th();M.flags|=a;e.memoizedState=bi(1|b,c,void 0,void 0===d?null:d);}
function li(a,b,c,d){var e=Uh();d=void 0===d?null:d;var f=void 0;if(null!==N$1){var g=N$1.memoizedState;f=g.destroy;if(null!==d&&Mh(d,g.deps)){e.memoizedState=bi(b,c,f,d);return}}M.flags|=a;e.memoizedState=bi(1|b,c,f,d);}function mi(a,b){return ki(8390656,8,a,b)}function $h(a,b){return li(2048,8,a,b)}function ni(a,b){return li(4,2,a,b)}function oi(a,b){return li(4,4,a,b)}
function pi(a,b){if("function"===typeof b)return a=a(),b(a),function(){b(null);};if(null!==b&&void 0!==b)return a=a(),b.current=a,function(){b.current=null;}}function qi(a,b,c){c=null!==c&&void 0!==c?c.concat([a]):null;return li(4,4,pi.bind(null,b,a),c)}function ri(){}function si(a,b){var c=Uh();b=void 0===b?null:b;var d=c.memoizedState;if(null!==d&&null!==b&&Mh(b,d[1]))return d[0];c.memoizedState=[a,b];return a}
function ti(a,b){var c=Uh();b=void 0===b?null:b;var d=c.memoizedState;if(null!==d&&null!==b&&Mh(b,d[1]))return d[0];a=a();c.memoizedState=[a,b];return a}function ui(a,b,c){if(0===(Hh&21))return a.baseState&&(a.baseState=!1,dh=!0),a.memoizedState=c;He(c,b)||(c=yc(),M.lanes|=c,rh|=c,a.baseState=!0);return b}function vi(a,b){var c=C;C=0!==c&&4>c?c:4;a(!0);var d=Gh.transition;Gh.transition={};try{a(!1),b();}finally{C=c,Gh.transition=d;}}function wi(){return Uh().memoizedState}
function xi(a,b,c){var d=yi(a);c={lane:d,action:c,hasEagerState:!1,eagerState:null,next:null};if(zi(a))Ai(b,c);else if(c=hh(a,b,c,d),null!==c){var e=R();gi(c,a,d,e);Bi(c,b,d);}}
function ii(a,b,c){var d=yi(a),e={lane:d,action:c,hasEagerState:!1,eagerState:null,next:null};if(zi(a))Ai(b,e);else {var f=a.alternate;if(0===a.lanes&&(null===f||0===f.lanes)&&(f=b.lastRenderedReducer,null!==f))try{var g=b.lastRenderedState,h=f(g,c);e.hasEagerState=!0;e.eagerState=h;if(He(h,g)){var k=b.interleaved;null===k?(e.next=e,gh(b)):(e.next=k.next,k.next=e);b.interleaved=e;return}}catch(l){}finally{}c=hh(a,b,e,d);null!==c&&(e=R(),gi(c,a,d,e),Bi(c,b,d));}}
function zi(a){var b=a.alternate;return a===M||null!==b&&b===M}function Ai(a,b){Jh=Ih=!0;var c=a.pending;null===c?b.next=b:(b.next=c.next,c.next=b);a.pending=b;}function Bi(a,b,c){if(0!==(c&4194240)){var d=b.lanes;d&=a.pendingLanes;c|=d;b.lanes=c;Cc(a,c);}}
var Rh={readContext:eh,useCallback:P,useContext:P,useEffect:P,useImperativeHandle:P,useInsertionEffect:P,useLayoutEffect:P,useMemo:P,useReducer:P,useRef:P,useState:P,useDebugValue:P,useDeferredValue:P,useTransition:P,useMutableSource:P,useSyncExternalStore:P,useId:P,unstable_isNewReconciler:!1},Oh={readContext:eh,useCallback:function(a,b){Th().memoizedState=[a,void 0===b?null:b];return a},useContext:eh,useEffect:mi,useImperativeHandle:function(a,b,c){c=null!==c&&void 0!==c?c.concat([a]):null;return ki(4194308,
4,pi.bind(null,b,a),c)},useLayoutEffect:function(a,b){return ki(4194308,4,a,b)},useInsertionEffect:function(a,b){return ki(4,2,a,b)},useMemo:function(a,b){var c=Th();b=void 0===b?null:b;a=a();c.memoizedState=[a,b];return a},useReducer:function(a,b,c){var d=Th();b=void 0!==c?c(b):b;d.memoizedState=d.baseState=b;a={pending:null,interleaved:null,lanes:0,dispatch:null,lastRenderedReducer:a,lastRenderedState:b};d.queue=a;a=a.dispatch=xi.bind(null,M,a);return [d.memoizedState,a]},useRef:function(a){var b=
Th();a={current:a};return b.memoizedState=a},useState:hi,useDebugValue:ri,useDeferredValue:function(a){return Th().memoizedState=a},useTransition:function(){var a=hi(!1),b=a[0];a=vi.bind(null,a[1]);Th().memoizedState=a;return [b,a]},useMutableSource:function(){},useSyncExternalStore:function(a,b,c){var d=M,e=Th();if(I){if(void 0===c)throw Error(p(407));c=c();}else {c=b();if(null===Q)throw Error(p(349));0!==(Hh&30)||di(d,b,c);}e.memoizedState=c;var f={value:c,getSnapshot:b};e.queue=f;mi(ai.bind(null,d,
f,a),[a]);d.flags|=2048;bi(9,ci.bind(null,d,f,c,b),void 0,null);return c},useId:function(){var a=Th(),b=Q.identifierPrefix;if(I){var c=sg;var d=rg;c=(d&~(1<<32-oc(d)-1)).toString(32)+c;b=":"+b+"R"+c;c=Kh++;0<c&&(b+="H"+c.toString(32));b+=":";}else c=Lh++,b=":"+b+"r"+c.toString(32)+":";return a.memoizedState=b},unstable_isNewReconciler:!1},Ph={readContext:eh,useCallback:si,useContext:eh,useEffect:$h,useImperativeHandle:qi,useInsertionEffect:ni,useLayoutEffect:oi,useMemo:ti,useReducer:Wh,useRef:ji,useState:function(){return Wh(Vh)},
useDebugValue:ri,useDeferredValue:function(a){var b=Uh();return ui(b,N$1.memoizedState,a)},useTransition:function(){var a=Wh(Vh)[0],b=Uh().memoizedState;return [a,b]},useMutableSource:Yh,useSyncExternalStore:Zh,useId:wi,unstable_isNewReconciler:!1},Qh={readContext:eh,useCallback:si,useContext:eh,useEffect:$h,useImperativeHandle:qi,useInsertionEffect:ni,useLayoutEffect:oi,useMemo:ti,useReducer:Xh,useRef:ji,useState:function(){return Xh(Vh)},useDebugValue:ri,useDeferredValue:function(a){var b=Uh();return null===
N$1?b.memoizedState=a:ui(b,N$1.memoizedState,a)},useTransition:function(){var a=Xh(Vh)[0],b=Uh().memoizedState;return [a,b]},useMutableSource:Yh,useSyncExternalStore:Zh,useId:wi,unstable_isNewReconciler:!1};function Ci(a,b){if(a&&a.defaultProps){b=A({},b);a=a.defaultProps;for(var c in a)void 0===b[c]&&(b[c]=a[c]);return b}return b}function Di(a,b,c,d){b=a.memoizedState;c=c(d,b);c=null===c||void 0===c?b:A({},b,c);a.memoizedState=c;0===a.lanes&&(a.updateQueue.baseState=c);}
var Ei={isMounted:function(a){return (a=a._reactInternals)?Vb(a)===a:!1},enqueueSetState:function(a,b,c){a=a._reactInternals;var d=R(),e=yi(a),f=mh(d,e);f.payload=b;void 0!==c&&null!==c&&(f.callback=c);b=nh(a,f,e);null!==b&&(gi(b,a,e,d),oh(b,a,e));},enqueueReplaceState:function(a,b,c){a=a._reactInternals;var d=R(),e=yi(a),f=mh(d,e);f.tag=1;f.payload=b;void 0!==c&&null!==c&&(f.callback=c);b=nh(a,f,e);null!==b&&(gi(b,a,e,d),oh(b,a,e));},enqueueForceUpdate:function(a,b){a=a._reactInternals;var c=R(),d=
yi(a),e=mh(c,d);e.tag=2;void 0!==b&&null!==b&&(e.callback=b);b=nh(a,e,d);null!==b&&(gi(b,a,d,c),oh(b,a,d));}};function Fi(a,b,c,d,e,f,g){a=a.stateNode;return "function"===typeof a.shouldComponentUpdate?a.shouldComponentUpdate(d,f,g):b.prototype&&b.prototype.isPureReactComponent?!Ie(c,d)||!Ie(e,f):!0}
function Gi(a,b,c){var d=!1,e=Vf;var f=b.contextType;"object"===typeof f&&null!==f?f=eh(f):(e=Zf(b)?Xf:H.current,d=b.contextTypes,f=(d=null!==d&&void 0!==d)?Yf(a,e):Vf);b=new b(c,f);a.memoizedState=null!==b.state&&void 0!==b.state?b.state:null;b.updater=Ei;a.stateNode=b;b._reactInternals=a;d&&(a=a.stateNode,a.__reactInternalMemoizedUnmaskedChildContext=e,a.__reactInternalMemoizedMaskedChildContext=f);return b}
function Hi(a,b,c,d){a=b.state;"function"===typeof b.componentWillReceiveProps&&b.componentWillReceiveProps(c,d);"function"===typeof b.UNSAFE_componentWillReceiveProps&&b.UNSAFE_componentWillReceiveProps(c,d);b.state!==a&&Ei.enqueueReplaceState(b,b.state,null);}
function Ii(a,b,c,d){var e=a.stateNode;e.props=c;e.state=a.memoizedState;e.refs={};kh(a);var f=b.contextType;"object"===typeof f&&null!==f?e.context=eh(f):(f=Zf(b)?Xf:H.current,e.context=Yf(a,f));e.state=a.memoizedState;f=b.getDerivedStateFromProps;"function"===typeof f&&(Di(a,b,f,c),e.state=a.memoizedState);"function"===typeof b.getDerivedStateFromProps||"function"===typeof e.getSnapshotBeforeUpdate||"function"!==typeof e.UNSAFE_componentWillMount&&"function"!==typeof e.componentWillMount||(b=e.state,
"function"===typeof e.componentWillMount&&e.componentWillMount(),"function"===typeof e.UNSAFE_componentWillMount&&e.UNSAFE_componentWillMount(),b!==e.state&&Ei.enqueueReplaceState(e,e.state,null),qh(a,c,e,d),e.state=a.memoizedState);"function"===typeof e.componentDidMount&&(a.flags|=4194308);}function Ji(a,b){try{var c="",d=b;do c+=Pa(d),d=d.return;while(d);var e=c;}catch(f){e="\nError generating stack: "+f.message+"\n"+f.stack;}return {value:a,source:b,stack:e,digest:null}}
function Ki(a,b,c){return {value:a,source:null,stack:null!=c?c:null,digest:null!=b?b:null}}function Li(a,b){try{console.error(b.value);}catch(c){setTimeout(function(){throw c;});}}var Mi="function"===typeof WeakMap?WeakMap:Map;function Ni(a,b,c){c=mh(-1,c);c.tag=3;c.payload={element:null};var d=b.value;c.callback=function(){Oi||(Oi=!0,Pi=d);Li(a,b);};return c}
function Qi(a,b,c){c=mh(-1,c);c.tag=3;var d=a.type.getDerivedStateFromError;if("function"===typeof d){var e=b.value;c.payload=function(){return d(e)};c.callback=function(){Li(a,b);};}var f=a.stateNode;null!==f&&"function"===typeof f.componentDidCatch&&(c.callback=function(){Li(a,b);"function"!==typeof d&&(null===Ri?Ri=new Set([this]):Ri.add(this));var c=b.stack;this.componentDidCatch(b.value,{componentStack:null!==c?c:""});});return c}
function Si(a,b,c){var d=a.pingCache;if(null===d){d=a.pingCache=new Mi;var e=new Set;d.set(b,e);}else e=d.get(b),void 0===e&&(e=new Set,d.set(b,e));e.has(c)||(e.add(c),a=Ti.bind(null,a,b,c),b.then(a,a));}function Ui(a){do{var b;if(b=13===a.tag)b=a.memoizedState,b=null!==b?null!==b.dehydrated?!0:!1:!0;if(b)return a;a=a.return;}while(null!==a);return null}
function Vi(a,b,c,d,e){if(0===(a.mode&1))return a===b?a.flags|=65536:(a.flags|=128,c.flags|=131072,c.flags&=-52805,1===c.tag&&(null===c.alternate?c.tag=17:(b=mh(-1,1),b.tag=2,nh(c,b,1))),c.lanes|=1),a;a.flags|=65536;a.lanes=e;return a}var Wi=ua.ReactCurrentOwner,dh=!1;function Xi(a,b,c,d){b.child=null===a?Vg(b,null,c,d):Ug(b,a.child,c,d);}
function Yi(a,b,c,d,e){c=c.render;var f=b.ref;ch(b,e);d=Nh(a,b,c,d,f,e);c=Sh();if(null!==a&&!dh)return b.updateQueue=a.updateQueue,b.flags&=-2053,a.lanes&=~e,Zi(a,b,e);I&&c&&vg(b);b.flags|=1;Xi(a,b,d,e);return b.child}
function $i(a,b,c,d,e){if(null===a){var f=c.type;if("function"===typeof f&&!aj(f)&&void 0===f.defaultProps&&null===c.compare&&void 0===c.defaultProps)return b.tag=15,b.type=f,bj(a,b,f,d,e);a=Rg(c.type,null,d,b,b.mode,e);a.ref=b.ref;a.return=b;return b.child=a}f=a.child;if(0===(a.lanes&e)){var g=f.memoizedProps;c=c.compare;c=null!==c?c:Ie;if(c(g,d)&&a.ref===b.ref)return Zi(a,b,e)}b.flags|=1;a=Pg(f,d);a.ref=b.ref;a.return=b;return b.child=a}
function bj(a,b,c,d,e){if(null!==a){var f=a.memoizedProps;if(Ie(f,d)&&a.ref===b.ref)if(dh=!1,b.pendingProps=d=f,0!==(a.lanes&e))0!==(a.flags&131072)&&(dh=!0);else return b.lanes=a.lanes,Zi(a,b,e)}return cj(a,b,c,d,e)}
function dj(a,b,c){var d=b.pendingProps,e=d.children,f=null!==a?a.memoizedState:null;if("hidden"===d.mode)if(0===(b.mode&1))b.memoizedState={baseLanes:0,cachePool:null,transitions:null},G(ej,fj),fj|=c;else {if(0===(c&1073741824))return a=null!==f?f.baseLanes|c:c,b.lanes=b.childLanes=1073741824,b.memoizedState={baseLanes:a,cachePool:null,transitions:null},b.updateQueue=null,G(ej,fj),fj|=a,null;b.memoizedState={baseLanes:0,cachePool:null,transitions:null};d=null!==f?f.baseLanes:c;G(ej,fj);fj|=d;}else null!==
f?(d=f.baseLanes|c,b.memoizedState=null):d=c,G(ej,fj),fj|=d;Xi(a,b,e,c);return b.child}function gj(a,b){var c=b.ref;if(null===a&&null!==c||null!==a&&a.ref!==c)b.flags|=512,b.flags|=2097152;}function cj(a,b,c,d,e){var f=Zf(c)?Xf:H.current;f=Yf(b,f);ch(b,e);c=Nh(a,b,c,d,f,e);d=Sh();if(null!==a&&!dh)return b.updateQueue=a.updateQueue,b.flags&=-2053,a.lanes&=~e,Zi(a,b,e);I&&d&&vg(b);b.flags|=1;Xi(a,b,c,e);return b.child}
function hj(a,b,c,d,e){if(Zf(c)){var f=!0;cg(b);}else f=!1;ch(b,e);if(null===b.stateNode)ij(a,b),Gi(b,c,d),Ii(b,c,d,e),d=!0;else if(null===a){var g=b.stateNode,h=b.memoizedProps;g.props=h;var k=g.context,l=c.contextType;"object"===typeof l&&null!==l?l=eh(l):(l=Zf(c)?Xf:H.current,l=Yf(b,l));var m=c.getDerivedStateFromProps,q="function"===typeof m||"function"===typeof g.getSnapshotBeforeUpdate;q||"function"!==typeof g.UNSAFE_componentWillReceiveProps&&"function"!==typeof g.componentWillReceiveProps||
(h!==d||k!==l)&&Hi(b,g,d,l);jh=!1;var r=b.memoizedState;g.state=r;qh(b,d,g,e);k=b.memoizedState;h!==d||r!==k||Wf.current||jh?("function"===typeof m&&(Di(b,c,m,d),k=b.memoizedState),(h=jh||Fi(b,c,h,d,r,k,l))?(q||"function"!==typeof g.UNSAFE_componentWillMount&&"function"!==typeof g.componentWillMount||("function"===typeof g.componentWillMount&&g.componentWillMount(),"function"===typeof g.UNSAFE_componentWillMount&&g.UNSAFE_componentWillMount()),"function"===typeof g.componentDidMount&&(b.flags|=4194308)):
("function"===typeof g.componentDidMount&&(b.flags|=4194308),b.memoizedProps=d,b.memoizedState=k),g.props=d,g.state=k,g.context=l,d=h):("function"===typeof g.componentDidMount&&(b.flags|=4194308),d=!1);}else {g=b.stateNode;lh(a,b);h=b.memoizedProps;l=b.type===b.elementType?h:Ci(b.type,h);g.props=l;q=b.pendingProps;r=g.context;k=c.contextType;"object"===typeof k&&null!==k?k=eh(k):(k=Zf(c)?Xf:H.current,k=Yf(b,k));var y=c.getDerivedStateFromProps;(m="function"===typeof y||"function"===typeof g.getSnapshotBeforeUpdate)||
"function"!==typeof g.UNSAFE_componentWillReceiveProps&&"function"!==typeof g.componentWillReceiveProps||(h!==q||r!==k)&&Hi(b,g,d,k);jh=!1;r=b.memoizedState;g.state=r;qh(b,d,g,e);var n=b.memoizedState;h!==q||r!==n||Wf.current||jh?("function"===typeof y&&(Di(b,c,y,d),n=b.memoizedState),(l=jh||Fi(b,c,l,d,r,n,k)||!1)?(m||"function"!==typeof g.UNSAFE_componentWillUpdate&&"function"!==typeof g.componentWillUpdate||("function"===typeof g.componentWillUpdate&&g.componentWillUpdate(d,n,k),"function"===typeof g.UNSAFE_componentWillUpdate&&
g.UNSAFE_componentWillUpdate(d,n,k)),"function"===typeof g.componentDidUpdate&&(b.flags|=4),"function"===typeof g.getSnapshotBeforeUpdate&&(b.flags|=1024)):("function"!==typeof g.componentDidUpdate||h===a.memoizedProps&&r===a.memoizedState||(b.flags|=4),"function"!==typeof g.getSnapshotBeforeUpdate||h===a.memoizedProps&&r===a.memoizedState||(b.flags|=1024),b.memoizedProps=d,b.memoizedState=n),g.props=d,g.state=n,g.context=k,d=l):("function"!==typeof g.componentDidUpdate||h===a.memoizedProps&&r===
a.memoizedState||(b.flags|=4),"function"!==typeof g.getSnapshotBeforeUpdate||h===a.memoizedProps&&r===a.memoizedState||(b.flags|=1024),d=!1);}return jj(a,b,c,d,f,e)}
function jj(a,b,c,d,e,f){gj(a,b);var g=0!==(b.flags&128);if(!d&&!g)return e&&dg(b,c,!1),Zi(a,b,f);d=b.stateNode;Wi.current=b;var h=g&&"function"!==typeof c.getDerivedStateFromError?null:d.render();b.flags|=1;null!==a&&g?(b.child=Ug(b,a.child,null,f),b.child=Ug(b,null,h,f)):Xi(a,b,h,f);b.memoizedState=d.state;e&&dg(b,c,!0);return b.child}function kj(a){var b=a.stateNode;b.pendingContext?ag(a,b.pendingContext,b.pendingContext!==b.context):b.context&&ag(a,b.context,!1);yh(a,b.containerInfo);}
function lj(a,b,c,d,e){Ig();Jg(e);b.flags|=256;Xi(a,b,c,d);return b.child}var mj={dehydrated:null,treeContext:null,retryLane:0};function nj(a){return {baseLanes:a,cachePool:null,transitions:null}}
function oj(a,b,c){var d=b.pendingProps,e=L.current,f=!1,g=0!==(b.flags&128),h;(h=g)||(h=null!==a&&null===a.memoizedState?!1:0!==(e&2));if(h)f=!0,b.flags&=-129;else if(null===a||null!==a.memoizedState)e|=1;G(L,e&1);if(null===a){Eg(b);a=b.memoizedState;if(null!==a&&(a=a.dehydrated,null!==a))return 0===(b.mode&1)?b.lanes=1:"$!"===a.data?b.lanes=8:b.lanes=1073741824,null;g=d.children;a=d.fallback;return f?(d=b.mode,f=b.child,g={mode:"hidden",children:g},0===(d&1)&&null!==f?(f.childLanes=0,f.pendingProps=
g):f=pj(g,d,0,null),a=Tg(a,d,c,null),f.return=b,a.return=b,f.sibling=a,b.child=f,b.child.memoizedState=nj(c),b.memoizedState=mj,a):qj(b,g)}e=a.memoizedState;if(null!==e&&(h=e.dehydrated,null!==h))return rj(a,b,g,d,h,e,c);if(f){f=d.fallback;g=b.mode;e=a.child;h=e.sibling;var k={mode:"hidden",children:d.children};0===(g&1)&&b.child!==e?(d=b.child,d.childLanes=0,d.pendingProps=k,b.deletions=null):(d=Pg(e,k),d.subtreeFlags=e.subtreeFlags&14680064);null!==h?f=Pg(h,f):(f=Tg(f,g,c,null),f.flags|=2);f.return=
b;d.return=b;d.sibling=f;b.child=d;d=f;f=b.child;g=a.child.memoizedState;g=null===g?nj(c):{baseLanes:g.baseLanes|c,cachePool:null,transitions:g.transitions};f.memoizedState=g;f.childLanes=a.childLanes&~c;b.memoizedState=mj;return d}f=a.child;a=f.sibling;d=Pg(f,{mode:"visible",children:d.children});0===(b.mode&1)&&(d.lanes=c);d.return=b;d.sibling=null;null!==a&&(c=b.deletions,null===c?(b.deletions=[a],b.flags|=16):c.push(a));b.child=d;b.memoizedState=null;return d}
function qj(a,b){b=pj({mode:"visible",children:b},a.mode,0,null);b.return=a;return a.child=b}function sj(a,b,c,d){null!==d&&Jg(d);Ug(b,a.child,null,c);a=qj(b,b.pendingProps.children);a.flags|=2;b.memoizedState=null;return a}
function rj(a,b,c,d,e,f,g){if(c){if(b.flags&256)return b.flags&=-257,d=Ki(Error(p(422))),sj(a,b,g,d);if(null!==b.memoizedState)return b.child=a.child,b.flags|=128,null;f=d.fallback;e=b.mode;d=pj({mode:"visible",children:d.children},e,0,null);f=Tg(f,e,g,null);f.flags|=2;d.return=b;f.return=b;d.sibling=f;b.child=d;0!==(b.mode&1)&&Ug(b,a.child,null,g);b.child.memoizedState=nj(g);b.memoizedState=mj;return f}if(0===(b.mode&1))return sj(a,b,g,null);if("$!"===e.data){d=e.nextSibling&&e.nextSibling.dataset;
if(d)var h=d.dgst;d=h;f=Error(p(419));d=Ki(f,d,void 0);return sj(a,b,g,d)}h=0!==(g&a.childLanes);if(dh||h){d=Q;if(null!==d){switch(g&-g){case 4:e=2;break;case 16:e=8;break;case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:e=32;break;case 536870912:e=268435456;break;default:e=0;}e=0!==(e&(d.suspendedLanes|g))?0:e;
0!==e&&e!==f.retryLane&&(f.retryLane=e,ih(a,e),gi(d,a,e,-1));}tj();d=Ki(Error(p(421)));return sj(a,b,g,d)}if("$?"===e.data)return b.flags|=128,b.child=a.child,b=uj.bind(null,a),e._reactRetry=b,null;a=f.treeContext;yg=Lf(e.nextSibling);xg=b;I=!0;zg=null;null!==a&&(og[pg++]=rg,og[pg++]=sg,og[pg++]=qg,rg=a.id,sg=a.overflow,qg=b);b=qj(b,d.children);b.flags|=4096;return b}function vj(a,b,c){a.lanes|=b;var d=a.alternate;null!==d&&(d.lanes|=b);bh(a.return,b,c);}
function wj(a,b,c,d,e){var f=a.memoizedState;null===f?a.memoizedState={isBackwards:b,rendering:null,renderingStartTime:0,last:d,tail:c,tailMode:e}:(f.isBackwards=b,f.rendering=null,f.renderingStartTime=0,f.last=d,f.tail=c,f.tailMode=e);}
function xj(a,b,c){var d=b.pendingProps,e=d.revealOrder,f=d.tail;Xi(a,b,d.children,c);d=L.current;if(0!==(d&2))d=d&1|2,b.flags|=128;else {if(null!==a&&0!==(a.flags&128))a:for(a=b.child;null!==a;){if(13===a.tag)null!==a.memoizedState&&vj(a,c,b);else if(19===a.tag)vj(a,c,b);else if(null!==a.child){a.child.return=a;a=a.child;continue}if(a===b)break a;for(;null===a.sibling;){if(null===a.return||a.return===b)break a;a=a.return;}a.sibling.return=a.return;a=a.sibling;}d&=1;}G(L,d);if(0===(b.mode&1))b.memoizedState=
null;else switch(e){case "forwards":c=b.child;for(e=null;null!==c;)a=c.alternate,null!==a&&null===Ch(a)&&(e=c),c=c.sibling;c=e;null===c?(e=b.child,b.child=null):(e=c.sibling,c.sibling=null);wj(b,!1,e,c,f);break;case "backwards":c=null;e=b.child;for(b.child=null;null!==e;){a=e.alternate;if(null!==a&&null===Ch(a)){b.child=e;break}a=e.sibling;e.sibling=c;c=e;e=a;}wj(b,!0,c,null,f);break;case "together":wj(b,!1,null,null,void 0);break;default:b.memoizedState=null;}return b.child}
function ij(a,b){0===(b.mode&1)&&null!==a&&(a.alternate=null,b.alternate=null,b.flags|=2);}function Zi(a,b,c){null!==a&&(b.dependencies=a.dependencies);rh|=b.lanes;if(0===(c&b.childLanes))return null;if(null!==a&&b.child!==a.child)throw Error(p(153));if(null!==b.child){a=b.child;c=Pg(a,a.pendingProps);b.child=c;for(c.return=b;null!==a.sibling;)a=a.sibling,c=c.sibling=Pg(a,a.pendingProps),c.return=b;c.sibling=null;}return b.child}
function yj(a,b,c){switch(b.tag){case 3:kj(b);Ig();break;case 5:Ah(b);break;case 1:Zf(b.type)&&cg(b);break;case 4:yh(b,b.stateNode.containerInfo);break;case 10:var d=b.type._context,e=b.memoizedProps.value;G(Wg,d._currentValue);d._currentValue=e;break;case 13:d=b.memoizedState;if(null!==d){if(null!==d.dehydrated)return G(L,L.current&1),b.flags|=128,null;if(0!==(c&b.child.childLanes))return oj(a,b,c);G(L,L.current&1);a=Zi(a,b,c);return null!==a?a.sibling:null}G(L,L.current&1);break;case 19:d=0!==(c&
b.childLanes);if(0!==(a.flags&128)){if(d)return xj(a,b,c);b.flags|=128;}e=b.memoizedState;null!==e&&(e.rendering=null,e.tail=null,e.lastEffect=null);G(L,L.current);if(d)break;else return null;case 22:case 23:return b.lanes=0,dj(a,b,c)}return Zi(a,b,c)}var zj,Aj,Bj,Cj;
zj=function(a,b){for(var c=b.child;null!==c;){if(5===c.tag||6===c.tag)a.appendChild(c.stateNode);else if(4!==c.tag&&null!==c.child){c.child.return=c;c=c.child;continue}if(c===b)break;for(;null===c.sibling;){if(null===c.return||c.return===b)return;c=c.return;}c.sibling.return=c.return;c=c.sibling;}};Aj=function(){};
Bj=function(a,b,c,d){var e=a.memoizedProps;if(e!==d){a=b.stateNode;xh(uh.current);var f=null;switch(c){case "input":e=Ya(a,e);d=Ya(a,d);f=[];break;case "select":e=A({},e,{value:void 0});d=A({},d,{value:void 0});f=[];break;case "textarea":e=gb(a,e);d=gb(a,d);f=[];break;default:"function"!==typeof e.onClick&&"function"===typeof d.onClick&&(a.onclick=Bf);}ub(c,d);var g;c=null;for(l in e)if(!d.hasOwnProperty(l)&&e.hasOwnProperty(l)&&null!=e[l])if("style"===l){var h=e[l];for(g in h)h.hasOwnProperty(g)&&
(c||(c={}),c[g]="");}else "dangerouslySetInnerHTML"!==l&&"children"!==l&&"suppressContentEditableWarning"!==l&&"suppressHydrationWarning"!==l&&"autoFocus"!==l&&(ea.hasOwnProperty(l)?f||(f=[]):(f=f||[]).push(l,null));for(l in d){var k=d[l];h=null!=e?e[l]:void 0;if(d.hasOwnProperty(l)&&k!==h&&(null!=k||null!=h))if("style"===l)if(h){for(g in h)!h.hasOwnProperty(g)||k&&k.hasOwnProperty(g)||(c||(c={}),c[g]="");for(g in k)k.hasOwnProperty(g)&&h[g]!==k[g]&&(c||(c={}),c[g]=k[g]);}else c||(f||(f=[]),f.push(l,
c)),c=k;else "dangerouslySetInnerHTML"===l?(k=k?k.__html:void 0,h=h?h.__html:void 0,null!=k&&h!==k&&(f=f||[]).push(l,k)):"children"===l?"string"!==typeof k&&"number"!==typeof k||(f=f||[]).push(l,""+k):"suppressContentEditableWarning"!==l&&"suppressHydrationWarning"!==l&&(ea.hasOwnProperty(l)?(null!=k&&"onScroll"===l&&D("scroll",a),f||h===k||(f=[])):(f=f||[]).push(l,k));}c&&(f=f||[]).push("style",c);var l=f;if(b.updateQueue=l)b.flags|=4;}};Cj=function(a,b,c,d){c!==d&&(b.flags|=4);};
function Dj(a,b){if(!I)switch(a.tailMode){case "hidden":b=a.tail;for(var c=null;null!==b;)null!==b.alternate&&(c=b),b=b.sibling;null===c?a.tail=null:c.sibling=null;break;case "collapsed":c=a.tail;for(var d=null;null!==c;)null!==c.alternate&&(d=c),c=c.sibling;null===d?b||null===a.tail?a.tail=null:a.tail.sibling=null:d.sibling=null;}}
function S(a){var b=null!==a.alternate&&a.alternate.child===a.child,c=0,d=0;if(b)for(var e=a.child;null!==e;)c|=e.lanes|e.childLanes,d|=e.subtreeFlags&14680064,d|=e.flags&14680064,e.return=a,e=e.sibling;else for(e=a.child;null!==e;)c|=e.lanes|e.childLanes,d|=e.subtreeFlags,d|=e.flags,e.return=a,e=e.sibling;a.subtreeFlags|=d;a.childLanes=c;return b}
function Ej(a,b,c){var d=b.pendingProps;wg(b);switch(b.tag){case 2:case 16:case 15:case 0:case 11:case 7:case 8:case 12:case 9:case 14:return S(b),null;case 1:return Zf(b.type)&&$f(),S(b),null;case 3:d=b.stateNode;zh();E(Wf);E(H);Eh();d.pendingContext&&(d.context=d.pendingContext,d.pendingContext=null);if(null===a||null===a.child)Gg(b)?b.flags|=4:null===a||a.memoizedState.isDehydrated&&0===(b.flags&256)||(b.flags|=1024,null!==zg&&(Fj(zg),zg=null));Aj(a,b);S(b);return null;case 5:Bh(b);var e=xh(wh.current);
c=b.type;if(null!==a&&null!=b.stateNode)Bj(a,b,c,d,e),a.ref!==b.ref&&(b.flags|=512,b.flags|=2097152);else {if(!d){if(null===b.stateNode)throw Error(p(166));S(b);return null}a=xh(uh.current);if(Gg(b)){d=b.stateNode;c=b.type;var f=b.memoizedProps;d[Of]=b;d[Pf]=f;a=0!==(b.mode&1);switch(c){case "dialog":D("cancel",d);D("close",d);break;case "iframe":case "object":case "embed":D("load",d);break;case "video":case "audio":for(e=0;e<lf.length;e++)D(lf[e],d);break;case "source":D("error",d);break;case "img":case "image":case "link":D("error",
d);D("load",d);break;case "details":D("toggle",d);break;case "input":Za(d,f);D("invalid",d);break;case "select":d._wrapperState={wasMultiple:!!f.multiple};D("invalid",d);break;case "textarea":hb(d,f),D("invalid",d);}ub(c,f);e=null;for(var g in f)if(f.hasOwnProperty(g)){var h=f[g];"children"===g?"string"===typeof h?d.textContent!==h&&(!0!==f.suppressHydrationWarning&&Af(d.textContent,h,a),e=["children",h]):"number"===typeof h&&d.textContent!==""+h&&(!0!==f.suppressHydrationWarning&&Af(d.textContent,
h,a),e=["children",""+h]):ea.hasOwnProperty(g)&&null!=h&&"onScroll"===g&&D("scroll",d);}switch(c){case "input":Va(d);db(d,f,!0);break;case "textarea":Va(d);jb(d);break;case "select":case "option":break;default:"function"===typeof f.onClick&&(d.onclick=Bf);}d=e;b.updateQueue=d;null!==d&&(b.flags|=4);}else {g=9===e.nodeType?e:e.ownerDocument;"http://www.w3.org/1999/xhtml"===a&&(a=kb(c));"http://www.w3.org/1999/xhtml"===a?"script"===c?(a=g.createElement("div"),a.innerHTML="<script>\x3c/script>",a=a.removeChild(a.firstChild)):
"string"===typeof d.is?a=g.createElement(c,{is:d.is}):(a=g.createElement(c),"select"===c&&(g=a,d.multiple?g.multiple=!0:d.size&&(g.size=d.size))):a=g.createElementNS(a,c);a[Of]=b;a[Pf]=d;zj(a,b,!1,!1);b.stateNode=a;a:{g=vb(c,d);switch(c){case "dialog":D("cancel",a);D("close",a);e=d;break;case "iframe":case "object":case "embed":D("load",a);e=d;break;case "video":case "audio":for(e=0;e<lf.length;e++)D(lf[e],a);e=d;break;case "source":D("error",a);e=d;break;case "img":case "image":case "link":D("error",
a);D("load",a);e=d;break;case "details":D("toggle",a);e=d;break;case "input":Za(a,d);e=Ya(a,d);D("invalid",a);break;case "option":e=d;break;case "select":a._wrapperState={wasMultiple:!!d.multiple};e=A({},d,{value:void 0});D("invalid",a);break;case "textarea":hb(a,d);e=gb(a,d);D("invalid",a);break;default:e=d;}ub(c,e);h=e;for(f in h)if(h.hasOwnProperty(f)){var k=h[f];"style"===f?sb(a,k):"dangerouslySetInnerHTML"===f?(k=k?k.__html:void 0,null!=k&&nb(a,k)):"children"===f?"string"===typeof k?("textarea"!==
c||""!==k)&&ob(a,k):"number"===typeof k&&ob(a,""+k):"suppressContentEditableWarning"!==f&&"suppressHydrationWarning"!==f&&"autoFocus"!==f&&(ea.hasOwnProperty(f)?null!=k&&"onScroll"===f&&D("scroll",a):null!=k&&ta(a,f,k,g));}switch(c){case "input":Va(a);db(a,d,!1);break;case "textarea":Va(a);jb(a);break;case "option":null!=d.value&&a.setAttribute("value",""+Sa(d.value));break;case "select":a.multiple=!!d.multiple;f=d.value;null!=f?fb(a,!!d.multiple,f,!1):null!=d.defaultValue&&fb(a,!!d.multiple,d.defaultValue,
!0);break;default:"function"===typeof e.onClick&&(a.onclick=Bf);}switch(c){case "button":case "input":case "select":case "textarea":d=!!d.autoFocus;break a;case "img":d=!0;break a;default:d=!1;}}d&&(b.flags|=4);}null!==b.ref&&(b.flags|=512,b.flags|=2097152);}S(b);return null;case 6:if(a&&null!=b.stateNode)Cj(a,b,a.memoizedProps,d);else {if("string"!==typeof d&&null===b.stateNode)throw Error(p(166));c=xh(wh.current);xh(uh.current);if(Gg(b)){d=b.stateNode;c=b.memoizedProps;d[Of]=b;if(f=d.nodeValue!==c)if(a=
xg,null!==a)switch(a.tag){case 3:Af(d.nodeValue,c,0!==(a.mode&1));break;case 5:!0!==a.memoizedProps.suppressHydrationWarning&&Af(d.nodeValue,c,0!==(a.mode&1));}f&&(b.flags|=4);}else d=(9===c.nodeType?c:c.ownerDocument).createTextNode(d),d[Of]=b,b.stateNode=d;}S(b);return null;case 13:E(L);d=b.memoizedState;if(null===a||null!==a.memoizedState&&null!==a.memoizedState.dehydrated){if(I&&null!==yg&&0!==(b.mode&1)&&0===(b.flags&128))Hg(),Ig(),b.flags|=98560,f=!1;else if(f=Gg(b),null!==d&&null!==d.dehydrated){if(null===
a){if(!f)throw Error(p(318));f=b.memoizedState;f=null!==f?f.dehydrated:null;if(!f)throw Error(p(317));f[Of]=b;}else Ig(),0===(b.flags&128)&&(b.memoizedState=null),b.flags|=4;S(b);f=!1;}else null!==zg&&(Fj(zg),zg=null),f=!0;if(!f)return b.flags&65536?b:null}if(0!==(b.flags&128))return b.lanes=c,b;d=null!==d;d!==(null!==a&&null!==a.memoizedState)&&d&&(b.child.flags|=8192,0!==(b.mode&1)&&(null===a||0!==(L.current&1)?0===T&&(T=3):tj()));null!==b.updateQueue&&(b.flags|=4);S(b);return null;case 4:return zh(),
Aj(a,b),null===a&&sf(b.stateNode.containerInfo),S(b),null;case 10:return ah(b.type._context),S(b),null;case 17:return Zf(b.type)&&$f(),S(b),null;case 19:E(L);f=b.memoizedState;if(null===f)return S(b),null;d=0!==(b.flags&128);g=f.rendering;if(null===g)if(d)Dj(f,!1);else {if(0!==T||null!==a&&0!==(a.flags&128))for(a=b.child;null!==a;){g=Ch(a);if(null!==g){b.flags|=128;Dj(f,!1);d=g.updateQueue;null!==d&&(b.updateQueue=d,b.flags|=4);b.subtreeFlags=0;d=c;for(c=b.child;null!==c;)f=c,a=d,f.flags&=14680066,
g=f.alternate,null===g?(f.childLanes=0,f.lanes=a,f.child=null,f.subtreeFlags=0,f.memoizedProps=null,f.memoizedState=null,f.updateQueue=null,f.dependencies=null,f.stateNode=null):(f.childLanes=g.childLanes,f.lanes=g.lanes,f.child=g.child,f.subtreeFlags=0,f.deletions=null,f.memoizedProps=g.memoizedProps,f.memoizedState=g.memoizedState,f.updateQueue=g.updateQueue,f.type=g.type,a=g.dependencies,f.dependencies=null===a?null:{lanes:a.lanes,firstContext:a.firstContext}),c=c.sibling;G(L,L.current&1|2);return b.child}a=
a.sibling;}null!==f.tail&&B()>Gj&&(b.flags|=128,d=!0,Dj(f,!1),b.lanes=4194304);}else {if(!d)if(a=Ch(g),null!==a){if(b.flags|=128,d=!0,c=a.updateQueue,null!==c&&(b.updateQueue=c,b.flags|=4),Dj(f,!0),null===f.tail&&"hidden"===f.tailMode&&!g.alternate&&!I)return S(b),null}else 2*B()-f.renderingStartTime>Gj&&1073741824!==c&&(b.flags|=128,d=!0,Dj(f,!1),b.lanes=4194304);f.isBackwards?(g.sibling=b.child,b.child=g):(c=f.last,null!==c?c.sibling=g:b.child=g,f.last=g);}if(null!==f.tail)return b=f.tail,f.rendering=
b,f.tail=b.sibling,f.renderingStartTime=B(),b.sibling=null,c=L.current,G(L,d?c&1|2:c&1),b;S(b);return null;case 22:case 23:return Hj(),d=null!==b.memoizedState,null!==a&&null!==a.memoizedState!==d&&(b.flags|=8192),d&&0!==(b.mode&1)?0!==(fj&1073741824)&&(S(b),b.subtreeFlags&6&&(b.flags|=8192)):S(b),null;case 24:return null;case 25:return null}throw Error(p(156,b.tag));}
function Ij(a,b){wg(b);switch(b.tag){case 1:return Zf(b.type)&&$f(),a=b.flags,a&65536?(b.flags=a&-65537|128,b):null;case 3:return zh(),E(Wf),E(H),Eh(),a=b.flags,0!==(a&65536)&&0===(a&128)?(b.flags=a&-65537|128,b):null;case 5:return Bh(b),null;case 13:E(L);a=b.memoizedState;if(null!==a&&null!==a.dehydrated){if(null===b.alternate)throw Error(p(340));Ig();}a=b.flags;return a&65536?(b.flags=a&-65537|128,b):null;case 19:return E(L),null;case 4:return zh(),null;case 10:return ah(b.type._context),null;case 22:case 23:return Hj(),
null;case 24:return null;default:return null}}var Jj=!1,U=!1,Kj="function"===typeof WeakSet?WeakSet:Set,V=null;function Lj(a,b){var c=a.ref;if(null!==c)if("function"===typeof c)try{c(null);}catch(d){W(a,b,d);}else c.current=null;}function Mj(a,b,c){try{c();}catch(d){W(a,b,d);}}var Nj=!1;
function Oj(a,b){Cf=dd;a=Me();if(Ne(a)){if("selectionStart"in a)var c={start:a.selectionStart,end:a.selectionEnd};else a:{c=(c=a.ownerDocument)&&c.defaultView||window;var d=c.getSelection&&c.getSelection();if(d&&0!==d.rangeCount){c=d.anchorNode;var e=d.anchorOffset,f=d.focusNode;d=d.focusOffset;try{c.nodeType,f.nodeType;}catch(F){c=null;break a}var g=0,h=-1,k=-1,l=0,m=0,q=a,r=null;b:for(;;){for(var y;;){q!==c||0!==e&&3!==q.nodeType||(h=g+e);q!==f||0!==d&&3!==q.nodeType||(k=g+d);3===q.nodeType&&(g+=
q.nodeValue.length);if(null===(y=q.firstChild))break;r=q;q=y;}for(;;){if(q===a)break b;r===c&&++l===e&&(h=g);r===f&&++m===d&&(k=g);if(null!==(y=q.nextSibling))break;q=r;r=q.parentNode;}q=y;}c=-1===h||-1===k?null:{start:h,end:k};}else c=null;}c=c||{start:0,end:0};}else c=null;Df={focusedElem:a,selectionRange:c};dd=!1;for(V=b;null!==V;)if(b=V,a=b.child,0!==(b.subtreeFlags&1028)&&null!==a)a.return=b,V=a;else for(;null!==V;){b=V;try{var n=b.alternate;if(0!==(b.flags&1024))switch(b.tag){case 0:case 11:case 15:break;
case 1:if(null!==n){var t=n.memoizedProps,J=n.memoizedState,x=b.stateNode,w=x.getSnapshotBeforeUpdate(b.elementType===b.type?t:Ci(b.type,t),J);x.__reactInternalSnapshotBeforeUpdate=w;}break;case 3:var u=b.stateNode.containerInfo;1===u.nodeType?u.textContent="":9===u.nodeType&&u.documentElement&&u.removeChild(u.documentElement);break;case 5:case 6:case 4:case 17:break;default:throw Error(p(163));}}catch(F){W(b,b.return,F);}a=b.sibling;if(null!==a){a.return=b.return;V=a;break}V=b.return;}n=Nj;Nj=!1;return n}
function Pj(a,b,c){var d=b.updateQueue;d=null!==d?d.lastEffect:null;if(null!==d){var e=d=d.next;do{if((e.tag&a)===a){var f=e.destroy;e.destroy=void 0;void 0!==f&&Mj(b,c,f);}e=e.next;}while(e!==d)}}function Qj(a,b){b=b.updateQueue;b=null!==b?b.lastEffect:null;if(null!==b){var c=b=b.next;do{if((c.tag&a)===a){var d=c.create;c.destroy=d();}c=c.next;}while(c!==b)}}function Rj(a){var b=a.ref;if(null!==b){var c=a.stateNode;switch(a.tag){case 5:a=c;break;default:a=c;}"function"===typeof b?b(a):b.current=a;}}
function Sj(a){var b=a.alternate;null!==b&&(a.alternate=null,Sj(b));a.child=null;a.deletions=null;a.sibling=null;5===a.tag&&(b=a.stateNode,null!==b&&(delete b[Of],delete b[Pf],delete b[of],delete b[Qf],delete b[Rf]));a.stateNode=null;a.return=null;a.dependencies=null;a.memoizedProps=null;a.memoizedState=null;a.pendingProps=null;a.stateNode=null;a.updateQueue=null;}function Tj(a){return 5===a.tag||3===a.tag||4===a.tag}
function Uj(a){a:for(;;){for(;null===a.sibling;){if(null===a.return||Tj(a.return))return null;a=a.return;}a.sibling.return=a.return;for(a=a.sibling;5!==a.tag&&6!==a.tag&&18!==a.tag;){if(a.flags&2)continue a;if(null===a.child||4===a.tag)continue a;else a.child.return=a,a=a.child;}if(!(a.flags&2))return a.stateNode}}
function Vj(a,b,c){var d=a.tag;if(5===d||6===d)a=a.stateNode,b?8===c.nodeType?c.parentNode.insertBefore(a,b):c.insertBefore(a,b):(8===c.nodeType?(b=c.parentNode,b.insertBefore(a,c)):(b=c,b.appendChild(a)),c=c._reactRootContainer,null!==c&&void 0!==c||null!==b.onclick||(b.onclick=Bf));else if(4!==d&&(a=a.child,null!==a))for(Vj(a,b,c),a=a.sibling;null!==a;)Vj(a,b,c),a=a.sibling;}
function Wj(a,b,c){var d=a.tag;if(5===d||6===d)a=a.stateNode,b?c.insertBefore(a,b):c.appendChild(a);else if(4!==d&&(a=a.child,null!==a))for(Wj(a,b,c),a=a.sibling;null!==a;)Wj(a,b,c),a=a.sibling;}var X=null,Xj=!1;function Yj(a,b,c){for(c=c.child;null!==c;)Zj(a,b,c),c=c.sibling;}
function Zj(a,b,c){if(lc&&"function"===typeof lc.onCommitFiberUnmount)try{lc.onCommitFiberUnmount(kc,c);}catch(h){}switch(c.tag){case 5:U||Lj(c,b);case 6:var d=X,e=Xj;X=null;Yj(a,b,c);X=d;Xj=e;null!==X&&(Xj?(a=X,c=c.stateNode,8===a.nodeType?a.parentNode.removeChild(c):a.removeChild(c)):X.removeChild(c.stateNode));break;case 18:null!==X&&(Xj?(a=X,c=c.stateNode,8===a.nodeType?Kf(a.parentNode,c):1===a.nodeType&&Kf(a,c),bd(a)):Kf(X,c.stateNode));break;case 4:d=X;e=Xj;X=c.stateNode.containerInfo;Xj=!0;
Yj(a,b,c);X=d;Xj=e;break;case 0:case 11:case 14:case 15:if(!U&&(d=c.updateQueue,null!==d&&(d=d.lastEffect,null!==d))){e=d=d.next;do{var f=e,g=f.destroy;f=f.tag;void 0!==g&&(0!==(f&2)?Mj(c,b,g):0!==(f&4)&&Mj(c,b,g));e=e.next;}while(e!==d)}Yj(a,b,c);break;case 1:if(!U&&(Lj(c,b),d=c.stateNode,"function"===typeof d.componentWillUnmount))try{d.props=c.memoizedProps,d.state=c.memoizedState,d.componentWillUnmount();}catch(h){W(c,b,h);}Yj(a,b,c);break;case 21:Yj(a,b,c);break;case 22:c.mode&1?(U=(d=U)||null!==
c.memoizedState,Yj(a,b,c),U=d):Yj(a,b,c);break;default:Yj(a,b,c);}}function ak(a){var b=a.updateQueue;if(null!==b){a.updateQueue=null;var c=a.stateNode;null===c&&(c=a.stateNode=new Kj);b.forEach(function(b){var d=bk.bind(null,a,b);c.has(b)||(c.add(b),b.then(d,d));});}}
function ck(a,b){var c=b.deletions;if(null!==c)for(var d=0;d<c.length;d++){var e=c[d];try{var f=a,g=b,h=g;a:for(;null!==h;){switch(h.tag){case 5:X=h.stateNode;Xj=!1;break a;case 3:X=h.stateNode.containerInfo;Xj=!0;break a;case 4:X=h.stateNode.containerInfo;Xj=!0;break a}h=h.return;}if(null===X)throw Error(p(160));Zj(f,g,e);X=null;Xj=!1;var k=e.alternate;null!==k&&(k.return=null);e.return=null;}catch(l){W(e,b,l);}}if(b.subtreeFlags&12854)for(b=b.child;null!==b;)dk(b,a),b=b.sibling;}
function dk(a,b){var c=a.alternate,d=a.flags;switch(a.tag){case 0:case 11:case 14:case 15:ck(b,a);ek(a);if(d&4){try{Pj(3,a,a.return),Qj(3,a);}catch(t){W(a,a.return,t);}try{Pj(5,a,a.return);}catch(t){W(a,a.return,t);}}break;case 1:ck(b,a);ek(a);d&512&&null!==c&&Lj(c,c.return);break;case 5:ck(b,a);ek(a);d&512&&null!==c&&Lj(c,c.return);if(a.flags&32){var e=a.stateNode;try{ob(e,"");}catch(t){W(a,a.return,t);}}if(d&4&&(e=a.stateNode,null!=e)){var f=a.memoizedProps,g=null!==c?c.memoizedProps:f,h=a.type,k=a.updateQueue;
a.updateQueue=null;if(null!==k)try{"input"===h&&"radio"===f.type&&null!=f.name&&ab(e,f);vb(h,g);var l=vb(h,f);for(g=0;g<k.length;g+=2){var m=k[g],q=k[g+1];"style"===m?sb(e,q):"dangerouslySetInnerHTML"===m?nb(e,q):"children"===m?ob(e,q):ta(e,m,q,l);}switch(h){case "input":bb(e,f);break;case "textarea":ib(e,f);break;case "select":var r=e._wrapperState.wasMultiple;e._wrapperState.wasMultiple=!!f.multiple;var y=f.value;null!=y?fb(e,!!f.multiple,y,!1):r!==!!f.multiple&&(null!=f.defaultValue?fb(e,!!f.multiple,
f.defaultValue,!0):fb(e,!!f.multiple,f.multiple?[]:"",!1));}e[Pf]=f;}catch(t){W(a,a.return,t);}}break;case 6:ck(b,a);ek(a);if(d&4){if(null===a.stateNode)throw Error(p(162));e=a.stateNode;f=a.memoizedProps;try{e.nodeValue=f;}catch(t){W(a,a.return,t);}}break;case 3:ck(b,a);ek(a);if(d&4&&null!==c&&c.memoizedState.isDehydrated)try{bd(b.containerInfo);}catch(t){W(a,a.return,t);}break;case 4:ck(b,a);ek(a);break;case 13:ck(b,a);ek(a);e=a.child;e.flags&8192&&(f=null!==e.memoizedState,e.stateNode.isHidden=f,!f||
null!==e.alternate&&null!==e.alternate.memoizedState||(fk=B()));d&4&&ak(a);break;case 22:m=null!==c&&null!==c.memoizedState;a.mode&1?(U=(l=U)||m,ck(b,a),U=l):ck(b,a);ek(a);if(d&8192){l=null!==a.memoizedState;if((a.stateNode.isHidden=l)&&!m&&0!==(a.mode&1))for(V=a,m=a.child;null!==m;){for(q=V=m;null!==V;){r=V;y=r.child;switch(r.tag){case 0:case 11:case 14:case 15:Pj(4,r,r.return);break;case 1:Lj(r,r.return);var n=r.stateNode;if("function"===typeof n.componentWillUnmount){d=r;c=r.return;try{b=d,n.props=
b.memoizedProps,n.state=b.memoizedState,n.componentWillUnmount();}catch(t){W(d,c,t);}}break;case 5:Lj(r,r.return);break;case 22:if(null!==r.memoizedState){gk(q);continue}}null!==y?(y.return=r,V=y):gk(q);}m=m.sibling;}a:for(m=null,q=a;;){if(5===q.tag){if(null===m){m=q;try{e=q.stateNode,l?(f=e.style,"function"===typeof f.setProperty?f.setProperty("display","none","important"):f.display="none"):(h=q.stateNode,k=q.memoizedProps.style,g=void 0!==k&&null!==k&&k.hasOwnProperty("display")?k.display:null,h.style.display=
rb("display",g));}catch(t){W(a,a.return,t);}}}else if(6===q.tag){if(null===m)try{q.stateNode.nodeValue=l?"":q.memoizedProps;}catch(t){W(a,a.return,t);}}else if((22!==q.tag&&23!==q.tag||null===q.memoizedState||q===a)&&null!==q.child){q.child.return=q;q=q.child;continue}if(q===a)break a;for(;null===q.sibling;){if(null===q.return||q.return===a)break a;m===q&&(m=null);q=q.return;}m===q&&(m=null);q.sibling.return=q.return;q=q.sibling;}}break;case 19:ck(b,a);ek(a);d&4&&ak(a);break;case 21:break;default:ck(b,
a),ek(a);}}function ek(a){var b=a.flags;if(b&2){try{a:{for(var c=a.return;null!==c;){if(Tj(c)){var d=c;break a}c=c.return;}throw Error(p(160));}switch(d.tag){case 5:var e=d.stateNode;d.flags&32&&(ob(e,""),d.flags&=-33);var f=Uj(a);Wj(a,f,e);break;case 3:case 4:var g=d.stateNode.containerInfo,h=Uj(a);Vj(a,h,g);break;default:throw Error(p(161));}}catch(k){W(a,a.return,k);}a.flags&=-3;}b&4096&&(a.flags&=-4097);}function hk(a,b,c){V=a;ik(a);}
function ik(a,b,c){for(var d=0!==(a.mode&1);null!==V;){var e=V,f=e.child;if(22===e.tag&&d){var g=null!==e.memoizedState||Jj;if(!g){var h=e.alternate,k=null!==h&&null!==h.memoizedState||U;h=Jj;var l=U;Jj=g;if((U=k)&&!l)for(V=e;null!==V;)g=V,k=g.child,22===g.tag&&null!==g.memoizedState?jk(e):null!==k?(k.return=g,V=k):jk(e);for(;null!==f;)V=f,ik(f),f=f.sibling;V=e;Jj=h;U=l;}kk(a);}else 0!==(e.subtreeFlags&8772)&&null!==f?(f.return=e,V=f):kk(a);}}
function kk(a){for(;null!==V;){var b=V;if(0!==(b.flags&8772)){var c=b.alternate;try{if(0!==(b.flags&8772))switch(b.tag){case 0:case 11:case 15:U||Qj(5,b);break;case 1:var d=b.stateNode;if(b.flags&4&&!U)if(null===c)d.componentDidMount();else {var e=b.elementType===b.type?c.memoizedProps:Ci(b.type,c.memoizedProps);d.componentDidUpdate(e,c.memoizedState,d.__reactInternalSnapshotBeforeUpdate);}var f=b.updateQueue;null!==f&&sh(b,f,d);break;case 3:var g=b.updateQueue;if(null!==g){c=null;if(null!==b.child)switch(b.child.tag){case 5:c=
b.child.stateNode;break;case 1:c=b.child.stateNode;}sh(b,g,c);}break;case 5:var h=b.stateNode;if(null===c&&b.flags&4){c=h;var k=b.memoizedProps;switch(b.type){case "button":case "input":case "select":case "textarea":k.autoFocus&&c.focus();break;case "img":k.src&&(c.src=k.src);}}break;case 6:break;case 4:break;case 12:break;case 13:if(null===b.memoizedState){var l=b.alternate;if(null!==l){var m=l.memoizedState;if(null!==m){var q=m.dehydrated;null!==q&&bd(q);}}}break;case 19:case 17:case 21:case 22:case 23:case 25:break;
default:throw Error(p(163));}U||b.flags&512&&Rj(b);}catch(r){W(b,b.return,r);}}if(b===a){V=null;break}c=b.sibling;if(null!==c){c.return=b.return;V=c;break}V=b.return;}}function gk(a){for(;null!==V;){var b=V;if(b===a){V=null;break}var c=b.sibling;if(null!==c){c.return=b.return;V=c;break}V=b.return;}}
function jk(a){for(;null!==V;){var b=V;try{switch(b.tag){case 0:case 11:case 15:var c=b.return;try{Qj(4,b);}catch(k){W(b,c,k);}break;case 1:var d=b.stateNode;if("function"===typeof d.componentDidMount){var e=b.return;try{d.componentDidMount();}catch(k){W(b,e,k);}}var f=b.return;try{Rj(b);}catch(k){W(b,f,k);}break;case 5:var g=b.return;try{Rj(b);}catch(k){W(b,g,k);}}}catch(k){W(b,b.return,k);}if(b===a){V=null;break}var h=b.sibling;if(null!==h){h.return=b.return;V=h;break}V=b.return;}}
var lk=Math.ceil,mk=ua.ReactCurrentDispatcher,nk=ua.ReactCurrentOwner,ok=ua.ReactCurrentBatchConfig,K=0,Q=null,Y=null,Z=0,fj=0,ej=Uf(0),T=0,pk=null,rh=0,qk=0,rk=0,sk=null,tk=null,fk=0,Gj=Infinity,uk=null,Oi=!1,Pi=null,Ri=null,vk=!1,wk=null,xk=0,yk=0,zk=null,Ak=-1,Bk=0;function R(){return 0!==(K&6)?B():-1!==Ak?Ak:Ak=B()}
function yi(a){if(0===(a.mode&1))return 1;if(0!==(K&2)&&0!==Z)return Z&-Z;if(null!==Kg.transition)return 0===Bk&&(Bk=yc()),Bk;a=C;if(0!==a)return a;a=window.event;a=void 0===a?16:jd(a.type);return a}function gi(a,b,c,d){if(50<yk)throw yk=0,zk=null,Error(p(185));Ac(a,c,d);if(0===(K&2)||a!==Q)a===Q&&(0===(K&2)&&(qk|=c),4===T&&Ck(a,Z)),Dk(a,d),1===c&&0===K&&0===(b.mode&1)&&(Gj=B()+500,fg&&jg());}
function Dk(a,b){var c=a.callbackNode;wc(a,b);var d=uc(a,a===Q?Z:0);if(0===d)null!==c&&bc(c),a.callbackNode=null,a.callbackPriority=0;else if(b=d&-d,a.callbackPriority!==b){null!=c&&bc(c);if(1===b)0===a.tag?ig(Ek.bind(null,a)):hg(Ek.bind(null,a)),Jf(function(){0===(K&6)&&jg();}),c=null;else {switch(Dc(d)){case 1:c=fc;break;case 4:c=gc;break;case 16:c=hc;break;case 536870912:c=jc;break;default:c=hc;}c=Fk(c,Gk.bind(null,a));}a.callbackPriority=b;a.callbackNode=c;}}
function Gk(a,b){Ak=-1;Bk=0;if(0!==(K&6))throw Error(p(327));var c=a.callbackNode;if(Hk()&&a.callbackNode!==c)return null;var d=uc(a,a===Q?Z:0);if(0===d)return null;if(0!==(d&30)||0!==(d&a.expiredLanes)||b)b=Ik(a,d);else {b=d;var e=K;K|=2;var f=Jk();if(Q!==a||Z!==b)uk=null,Gj=B()+500,Kk(a,b);do try{Lk();break}catch(h){Mk(a,h);}while(1);$g();mk.current=f;K=e;null!==Y?b=0:(Q=null,Z=0,b=T);}if(0!==b){2===b&&(e=xc(a),0!==e&&(d=e,b=Nk(a,e)));if(1===b)throw c=pk,Kk(a,0),Ck(a,d),Dk(a,B()),c;if(6===b)Ck(a,d);
else {e=a.current.alternate;if(0===(d&30)&&!Ok(e)&&(b=Ik(a,d),2===b&&(f=xc(a),0!==f&&(d=f,b=Nk(a,f))),1===b))throw c=pk,Kk(a,0),Ck(a,d),Dk(a,B()),c;a.finishedWork=e;a.finishedLanes=d;switch(b){case 0:case 1:throw Error(p(345));case 2:Pk(a,tk,uk);break;case 3:Ck(a,d);if((d&130023424)===d&&(b=fk+500-B(),10<b)){if(0!==uc(a,0))break;e=a.suspendedLanes;if((e&d)!==d){R();a.pingedLanes|=a.suspendedLanes&e;break}a.timeoutHandle=Ff(Pk.bind(null,a,tk,uk),b);break}Pk(a,tk,uk);break;case 4:Ck(a,d);if((d&4194240)===
d)break;b=a.eventTimes;for(e=-1;0<d;){var g=31-oc(d);f=1<<g;g=b[g];g>e&&(e=g);d&=~f;}d=e;d=B()-d;d=(120>d?120:480>d?480:1080>d?1080:1920>d?1920:3E3>d?3E3:4320>d?4320:1960*lk(d/1960))-d;if(10<d){a.timeoutHandle=Ff(Pk.bind(null,a,tk,uk),d);break}Pk(a,tk,uk);break;case 5:Pk(a,tk,uk);break;default:throw Error(p(329));}}}Dk(a,B());return a.callbackNode===c?Gk.bind(null,a):null}
function Nk(a,b){var c=sk;a.current.memoizedState.isDehydrated&&(Kk(a,b).flags|=256);a=Ik(a,b);2!==a&&(b=tk,tk=c,null!==b&&Fj(b));return a}function Fj(a){null===tk?tk=a:tk.push.apply(tk,a);}
function Ok(a){for(var b=a;;){if(b.flags&16384){var c=b.updateQueue;if(null!==c&&(c=c.stores,null!==c))for(var d=0;d<c.length;d++){var e=c[d],f=e.getSnapshot;e=e.value;try{if(!He(f(),e))return !1}catch(g){return !1}}}c=b.child;if(b.subtreeFlags&16384&&null!==c)c.return=b,b=c;else {if(b===a)break;for(;null===b.sibling;){if(null===b.return||b.return===a)return !0;b=b.return;}b.sibling.return=b.return;b=b.sibling;}}return !0}
function Ck(a,b){b&=~rk;b&=~qk;a.suspendedLanes|=b;a.pingedLanes&=~b;for(a=a.expirationTimes;0<b;){var c=31-oc(b),d=1<<c;a[c]=-1;b&=~d;}}function Ek(a){if(0!==(K&6))throw Error(p(327));Hk();var b=uc(a,0);if(0===(b&1))return Dk(a,B()),null;var c=Ik(a,b);if(0!==a.tag&&2===c){var d=xc(a);0!==d&&(b=d,c=Nk(a,d));}if(1===c)throw c=pk,Kk(a,0),Ck(a,b),Dk(a,B()),c;if(6===c)throw Error(p(345));a.finishedWork=a.current.alternate;a.finishedLanes=b;Pk(a,tk,uk);Dk(a,B());return null}
function Qk(a,b){var c=K;K|=1;try{return a(b)}finally{K=c,0===K&&(Gj=B()+500,fg&&jg());}}function Rk(a){null!==wk&&0===wk.tag&&0===(K&6)&&Hk();var b=K;K|=1;var c=ok.transition,d=C;try{if(ok.transition=null,C=1,a)return a()}finally{C=d,ok.transition=c,K=b,0===(K&6)&&jg();}}function Hj(){fj=ej.current;E(ej);}
function Kk(a,b){a.finishedWork=null;a.finishedLanes=0;var c=a.timeoutHandle;-1!==c&&(a.timeoutHandle=-1,Gf(c));if(null!==Y)for(c=Y.return;null!==c;){var d=c;wg(d);switch(d.tag){case 1:d=d.type.childContextTypes;null!==d&&void 0!==d&&$f();break;case 3:zh();E(Wf);E(H);Eh();break;case 5:Bh(d);break;case 4:zh();break;case 13:E(L);break;case 19:E(L);break;case 10:ah(d.type._context);break;case 22:case 23:Hj();}c=c.return;}Q=a;Y=a=Pg(a.current,null);Z=fj=b;T=0;pk=null;rk=qk=rh=0;tk=sk=null;if(null!==fh){for(b=
0;b<fh.length;b++)if(c=fh[b],d=c.interleaved,null!==d){c.interleaved=null;var e=d.next,f=c.pending;if(null!==f){var g=f.next;f.next=e;d.next=g;}c.pending=d;}fh=null;}return a}
function Mk(a,b){do{var c=Y;try{$g();Fh.current=Rh;if(Ih){for(var d=M.memoizedState;null!==d;){var e=d.queue;null!==e&&(e.pending=null);d=d.next;}Ih=!1;}Hh=0;O=N$1=M=null;Jh=!1;Kh=0;nk.current=null;if(null===c||null===c.return){T=1;pk=b;Y=null;break}a:{var f=a,g=c.return,h=c,k=b;b=Z;h.flags|=32768;if(null!==k&&"object"===typeof k&&"function"===typeof k.then){var l=k,m=h,q=m.tag;if(0===(m.mode&1)&&(0===q||11===q||15===q)){var r=m.alternate;r?(m.updateQueue=r.updateQueue,m.memoizedState=r.memoizedState,
m.lanes=r.lanes):(m.updateQueue=null,m.memoizedState=null);}var y=Ui(g);if(null!==y){y.flags&=-257;Vi(y,g,h,f,b);y.mode&1&&Si(f,l,b);b=y;k=l;var n=b.updateQueue;if(null===n){var t=new Set;t.add(k);b.updateQueue=t;}else n.add(k);break a}else {if(0===(b&1)){Si(f,l,b);tj();break a}k=Error(p(426));}}else if(I&&h.mode&1){var J=Ui(g);if(null!==J){0===(J.flags&65536)&&(J.flags|=256);Vi(J,g,h,f,b);Jg(Ji(k,h));break a}}f=k=Ji(k,h);4!==T&&(T=2);null===sk?sk=[f]:sk.push(f);f=g;do{switch(f.tag){case 3:f.flags|=65536;
b&=-b;f.lanes|=b;var x=Ni(f,k,b);ph(f,x);break a;case 1:h=k;var w=f.type,u=f.stateNode;if(0===(f.flags&128)&&("function"===typeof w.getDerivedStateFromError||null!==u&&"function"===typeof u.componentDidCatch&&(null===Ri||!Ri.has(u)))){f.flags|=65536;b&=-b;f.lanes|=b;var F=Qi(f,h,b);ph(f,F);break a}}f=f.return;}while(null!==f)}Sk(c);}catch(na){b=na;Y===c&&null!==c&&(Y=c=c.return);continue}break}while(1)}function Jk(){var a=mk.current;mk.current=Rh;return null===a?Rh:a}
function tj(){if(0===T||3===T||2===T)T=4;null===Q||0===(rh&268435455)&&0===(qk&268435455)||Ck(Q,Z);}function Ik(a,b){var c=K;K|=2;var d=Jk();if(Q!==a||Z!==b)uk=null,Kk(a,b);do try{Tk();break}catch(e){Mk(a,e);}while(1);$g();K=c;mk.current=d;if(null!==Y)throw Error(p(261));Q=null;Z=0;return T}function Tk(){for(;null!==Y;)Uk(Y);}function Lk(){for(;null!==Y&&!cc();)Uk(Y);}function Uk(a){var b=Vk(a.alternate,a,fj);a.memoizedProps=a.pendingProps;null===b?Sk(a):Y=b;nk.current=null;}
function Sk(a){var b=a;do{var c=b.alternate;a=b.return;if(0===(b.flags&32768)){if(c=Ej(c,b,fj),null!==c){Y=c;return}}else {c=Ij(c,b);if(null!==c){c.flags&=32767;Y=c;return}if(null!==a)a.flags|=32768,a.subtreeFlags=0,a.deletions=null;else {T=6;Y=null;return}}b=b.sibling;if(null!==b){Y=b;return}Y=b=a;}while(null!==b);0===T&&(T=5);}function Pk(a,b,c){var d=C,e=ok.transition;try{ok.transition=null,C=1,Wk(a,b,c,d);}finally{ok.transition=e,C=d;}return null}
function Wk(a,b,c,d){do Hk();while(null!==wk);if(0!==(K&6))throw Error(p(327));c=a.finishedWork;var e=a.finishedLanes;if(null===c)return null;a.finishedWork=null;a.finishedLanes=0;if(c===a.current)throw Error(p(177));a.callbackNode=null;a.callbackPriority=0;var f=c.lanes|c.childLanes;Bc(a,f);a===Q&&(Y=Q=null,Z=0);0===(c.subtreeFlags&2064)&&0===(c.flags&2064)||vk||(vk=!0,Fk(hc,function(){Hk();return null}));f=0!==(c.flags&15990);if(0!==(c.subtreeFlags&15990)||f){f=ok.transition;ok.transition=null;
var g=C;C=1;var h=K;K|=4;nk.current=null;Oj(a,c);dk(c,a);Oe(Df);dd=!!Cf;Df=Cf=null;a.current=c;hk(c);dc();K=h;C=g;ok.transition=f;}else a.current=c;vk&&(vk=!1,wk=a,xk=e);f=a.pendingLanes;0===f&&(Ri=null);mc(c.stateNode);Dk(a,B());if(null!==b)for(d=a.onRecoverableError,c=0;c<b.length;c++)e=b[c],d(e.value,{componentStack:e.stack,digest:e.digest});if(Oi)throw Oi=!1,a=Pi,Pi=null,a;0!==(xk&1)&&0!==a.tag&&Hk();f=a.pendingLanes;0!==(f&1)?a===zk?yk++:(yk=0,zk=a):yk=0;jg();return null}
function Hk(){if(null!==wk){var a=Dc(xk),b=ok.transition,c=C;try{ok.transition=null;C=16>a?16:a;if(null===wk)var d=!1;else {a=wk;wk=null;xk=0;if(0!==(K&6))throw Error(p(331));var e=K;K|=4;for(V=a.current;null!==V;){var f=V,g=f.child;if(0!==(V.flags&16)){var h=f.deletions;if(null!==h){for(var k=0;k<h.length;k++){var l=h[k];for(V=l;null!==V;){var m=V;switch(m.tag){case 0:case 11:case 15:Pj(8,m,f);}var q=m.child;if(null!==q)q.return=m,V=q;else for(;null!==V;){m=V;var r=m.sibling,y=m.return;Sj(m);if(m===
l){V=null;break}if(null!==r){r.return=y;V=r;break}V=y;}}}var n=f.alternate;if(null!==n){var t=n.child;if(null!==t){n.child=null;do{var J=t.sibling;t.sibling=null;t=J;}while(null!==t)}}V=f;}}if(0!==(f.subtreeFlags&2064)&&null!==g)g.return=f,V=g;else b:for(;null!==V;){f=V;if(0!==(f.flags&2048))switch(f.tag){case 0:case 11:case 15:Pj(9,f,f.return);}var x=f.sibling;if(null!==x){x.return=f.return;V=x;break b}V=f.return;}}var w=a.current;for(V=w;null!==V;){g=V;var u=g.child;if(0!==(g.subtreeFlags&2064)&&null!==
u)u.return=g,V=u;else b:for(g=w;null!==V;){h=V;if(0!==(h.flags&2048))try{switch(h.tag){case 0:case 11:case 15:Qj(9,h);}}catch(na){W(h,h.return,na);}if(h===g){V=null;break b}var F=h.sibling;if(null!==F){F.return=h.return;V=F;break b}V=h.return;}}K=e;jg();if(lc&&"function"===typeof lc.onPostCommitFiberRoot)try{lc.onPostCommitFiberRoot(kc,a);}catch(na){}d=!0;}return d}finally{C=c,ok.transition=b;}}return !1}function Xk(a,b,c){b=Ji(c,b);b=Ni(a,b,1);a=nh(a,b,1);b=R();null!==a&&(Ac(a,1,b),Dk(a,b));}
function W(a,b,c){if(3===a.tag)Xk(a,a,c);else for(;null!==b;){if(3===b.tag){Xk(b,a,c);break}else if(1===b.tag){var d=b.stateNode;if("function"===typeof b.type.getDerivedStateFromError||"function"===typeof d.componentDidCatch&&(null===Ri||!Ri.has(d))){a=Ji(c,a);a=Qi(b,a,1);b=nh(b,a,1);a=R();null!==b&&(Ac(b,1,a),Dk(b,a));break}}b=b.return;}}
function Ti(a,b,c){var d=a.pingCache;null!==d&&d.delete(b);b=R();a.pingedLanes|=a.suspendedLanes&c;Q===a&&(Z&c)===c&&(4===T||3===T&&(Z&130023424)===Z&&500>B()-fk?Kk(a,0):rk|=c);Dk(a,b);}function Yk(a,b){0===b&&(0===(a.mode&1)?b=1:(b=sc,sc<<=1,0===(sc&130023424)&&(sc=4194304)));var c=R();a=ih(a,b);null!==a&&(Ac(a,b,c),Dk(a,c));}function uj(a){var b=a.memoizedState,c=0;null!==b&&(c=b.retryLane);Yk(a,c);}
function bk(a,b){var c=0;switch(a.tag){case 13:var d=a.stateNode;var e=a.memoizedState;null!==e&&(c=e.retryLane);break;case 19:d=a.stateNode;break;default:throw Error(p(314));}null!==d&&d.delete(b);Yk(a,c);}var Vk;
Vk=function(a,b,c){if(null!==a)if(a.memoizedProps!==b.pendingProps||Wf.current)dh=!0;else {if(0===(a.lanes&c)&&0===(b.flags&128))return dh=!1,yj(a,b,c);dh=0!==(a.flags&131072)?!0:!1;}else dh=!1,I&&0!==(b.flags&1048576)&&ug(b,ng,b.index);b.lanes=0;switch(b.tag){case 2:var d=b.type;ij(a,b);a=b.pendingProps;var e=Yf(b,H.current);ch(b,c);e=Nh(null,b,d,a,e,c);var f=Sh();b.flags|=1;"object"===typeof e&&null!==e&&"function"===typeof e.render&&void 0===e.$$typeof?(b.tag=1,b.memoizedState=null,b.updateQueue=
null,Zf(d)?(f=!0,cg(b)):f=!1,b.memoizedState=null!==e.state&&void 0!==e.state?e.state:null,kh(b),e.updater=Ei,b.stateNode=e,e._reactInternals=b,Ii(b,d,a,c),b=jj(null,b,d,!0,f,c)):(b.tag=0,I&&f&&vg(b),Xi(null,b,e,c),b=b.child);return b;case 16:d=b.elementType;a:{ij(a,b);a=b.pendingProps;e=d._init;d=e(d._payload);b.type=d;e=b.tag=Zk(d);a=Ci(d,a);switch(e){case 0:b=cj(null,b,d,a,c);break a;case 1:b=hj(null,b,d,a,c);break a;case 11:b=Yi(null,b,d,a,c);break a;case 14:b=$i(null,b,d,Ci(d.type,a),c);break a}throw Error(p(306,
d,""));}return b;case 0:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:Ci(d,e),cj(a,b,d,e,c);case 1:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:Ci(d,e),hj(a,b,d,e,c);case 3:a:{kj(b);if(null===a)throw Error(p(387));d=b.pendingProps;f=b.memoizedState;e=f.element;lh(a,b);qh(b,d,null,c);var g=b.memoizedState;d=g.element;if(f.isDehydrated)if(f={element:d,isDehydrated:!1,cache:g.cache,pendingSuspenseBoundaries:g.pendingSuspenseBoundaries,transitions:g.transitions},b.updateQueue.baseState=
f,b.memoizedState=f,b.flags&256){e=Ji(Error(p(423)),b);b=lj(a,b,d,c,e);break a}else if(d!==e){e=Ji(Error(p(424)),b);b=lj(a,b,d,c,e);break a}else for(yg=Lf(b.stateNode.containerInfo.firstChild),xg=b,I=!0,zg=null,c=Vg(b,null,d,c),b.child=c;c;)c.flags=c.flags&-3|4096,c=c.sibling;else {Ig();if(d===e){b=Zi(a,b,c);break a}Xi(a,b,d,c);}b=b.child;}return b;case 5:return Ah(b),null===a&&Eg(b),d=b.type,e=b.pendingProps,f=null!==a?a.memoizedProps:null,g=e.children,Ef(d,e)?g=null:null!==f&&Ef(d,f)&&(b.flags|=32),
gj(a,b),Xi(a,b,g,c),b.child;case 6:return null===a&&Eg(b),null;case 13:return oj(a,b,c);case 4:return yh(b,b.stateNode.containerInfo),d=b.pendingProps,null===a?b.child=Ug(b,null,d,c):Xi(a,b,d,c),b.child;case 11:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:Ci(d,e),Yi(a,b,d,e,c);case 7:return Xi(a,b,b.pendingProps,c),b.child;case 8:return Xi(a,b,b.pendingProps.children,c),b.child;case 12:return Xi(a,b,b.pendingProps.children,c),b.child;case 10:a:{d=b.type._context;e=b.pendingProps;f=b.memoizedProps;
g=e.value;G(Wg,d._currentValue);d._currentValue=g;if(null!==f)if(He(f.value,g)){if(f.children===e.children&&!Wf.current){b=Zi(a,b,c);break a}}else for(f=b.child,null!==f&&(f.return=b);null!==f;){var h=f.dependencies;if(null!==h){g=f.child;for(var k=h.firstContext;null!==k;){if(k.context===d){if(1===f.tag){k=mh(-1,c&-c);k.tag=2;var l=f.updateQueue;if(null!==l){l=l.shared;var m=l.pending;null===m?k.next=k:(k.next=m.next,m.next=k);l.pending=k;}}f.lanes|=c;k=f.alternate;null!==k&&(k.lanes|=c);bh(f.return,
c,b);h.lanes|=c;break}k=k.next;}}else if(10===f.tag)g=f.type===b.type?null:f.child;else if(18===f.tag){g=f.return;if(null===g)throw Error(p(341));g.lanes|=c;h=g.alternate;null!==h&&(h.lanes|=c);bh(g,c,b);g=f.sibling;}else g=f.child;if(null!==g)g.return=f;else for(g=f;null!==g;){if(g===b){g=null;break}f=g.sibling;if(null!==f){f.return=g.return;g=f;break}g=g.return;}f=g;}Xi(a,b,e.children,c);b=b.child;}return b;case 9:return e=b.type,d=b.pendingProps.children,ch(b,c),e=eh(e),d=d(e),b.flags|=1,Xi(a,b,d,c),
b.child;case 14:return d=b.type,e=Ci(d,b.pendingProps),e=Ci(d.type,e),$i(a,b,d,e,c);case 15:return bj(a,b,b.type,b.pendingProps,c);case 17:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:Ci(d,e),ij(a,b),b.tag=1,Zf(d)?(a=!0,cg(b)):a=!1,ch(b,c),Gi(b,d,e),Ii(b,d,e,c),jj(null,b,d,!0,a,c);case 19:return xj(a,b,c);case 22:return dj(a,b,c)}throw Error(p(156,b.tag));};function Fk(a,b){return ac(a,b)}
function $k(a,b,c,d){this.tag=a;this.key=c;this.sibling=this.child=this.return=this.stateNode=this.type=this.elementType=null;this.index=0;this.ref=null;this.pendingProps=b;this.dependencies=this.memoizedState=this.updateQueue=this.memoizedProps=null;this.mode=d;this.subtreeFlags=this.flags=0;this.deletions=null;this.childLanes=this.lanes=0;this.alternate=null;}function Bg(a,b,c,d){return new $k(a,b,c,d)}function aj(a){a=a.prototype;return !(!a||!a.isReactComponent)}
function Zk(a){if("function"===typeof a)return aj(a)?1:0;if(void 0!==a&&null!==a){a=a.$$typeof;if(a===Da)return 11;if(a===Ga)return 14}return 2}
function Pg(a,b){var c=a.alternate;null===c?(c=Bg(a.tag,b,a.key,a.mode),c.elementType=a.elementType,c.type=a.type,c.stateNode=a.stateNode,c.alternate=a,a.alternate=c):(c.pendingProps=b,c.type=a.type,c.flags=0,c.subtreeFlags=0,c.deletions=null);c.flags=a.flags&14680064;c.childLanes=a.childLanes;c.lanes=a.lanes;c.child=a.child;c.memoizedProps=a.memoizedProps;c.memoizedState=a.memoizedState;c.updateQueue=a.updateQueue;b=a.dependencies;c.dependencies=null===b?null:{lanes:b.lanes,firstContext:b.firstContext};
c.sibling=a.sibling;c.index=a.index;c.ref=a.ref;return c}
function Rg(a,b,c,d,e,f){var g=2;d=a;if("function"===typeof a)aj(a)&&(g=1);else if("string"===typeof a)g=5;else a:switch(a){case ya:return Tg(c.children,e,f,b);case za:g=8;e|=8;break;case Aa:return a=Bg(12,c,b,e|2),a.elementType=Aa,a.lanes=f,a;case Ea:return a=Bg(13,c,b,e),a.elementType=Ea,a.lanes=f,a;case Fa:return a=Bg(19,c,b,e),a.elementType=Fa,a.lanes=f,a;case Ia:return pj(c,e,f,b);default:if("object"===typeof a&&null!==a)switch(a.$$typeof){case Ba:g=10;break a;case Ca:g=9;break a;case Da:g=11;
break a;case Ga:g=14;break a;case Ha:g=16;d=null;break a}throw Error(p(130,null==a?a:typeof a,""));}b=Bg(g,c,b,e);b.elementType=a;b.type=d;b.lanes=f;return b}function Tg(a,b,c,d){a=Bg(7,a,d,b);a.lanes=c;return a}function pj(a,b,c,d){a=Bg(22,a,d,b);a.elementType=Ia;a.lanes=c;a.stateNode={isHidden:!1};return a}function Qg(a,b,c){a=Bg(6,a,null,b);a.lanes=c;return a}
function Sg(a,b,c){b=Bg(4,null!==a.children?a.children:[],a.key,b);b.lanes=c;b.stateNode={containerInfo:a.containerInfo,pendingChildren:null,implementation:a.implementation};return b}
function al(a,b,c,d,e){this.tag=b;this.containerInfo=a;this.finishedWork=this.pingCache=this.current=this.pendingChildren=null;this.timeoutHandle=-1;this.callbackNode=this.pendingContext=this.context=null;this.callbackPriority=0;this.eventTimes=zc(0);this.expirationTimes=zc(-1);this.entangledLanes=this.finishedLanes=this.mutableReadLanes=this.expiredLanes=this.pingedLanes=this.suspendedLanes=this.pendingLanes=0;this.entanglements=zc(0);this.identifierPrefix=d;this.onRecoverableError=e;this.mutableSourceEagerHydrationData=
null;}function bl(a,b,c,d,e,f,g,h,k){a=new al(a,b,c,h,k);1===b?(b=1,!0===f&&(b|=8)):b=0;f=Bg(3,null,null,b);a.current=f;f.stateNode=a;f.memoizedState={element:d,isDehydrated:c,cache:null,transitions:null,pendingSuspenseBoundaries:null};kh(f);return a}function cl(a,b,c){var d=3<arguments.length&&void 0!==arguments[3]?arguments[3]:null;return {$$typeof:wa,key:null==d?null:""+d,children:a,containerInfo:b,implementation:c}}
function dl(a){if(!a)return Vf;a=a._reactInternals;a:{if(Vb(a)!==a||1!==a.tag)throw Error(p(170));var b=a;do{switch(b.tag){case 3:b=b.stateNode.context;break a;case 1:if(Zf(b.type)){b=b.stateNode.__reactInternalMemoizedMergedChildContext;break a}}b=b.return;}while(null!==b);throw Error(p(171));}if(1===a.tag){var c=a.type;if(Zf(c))return bg(a,c,b)}return b}
function el(a,b,c,d,e,f,g,h,k){a=bl(c,d,!0,a,e,f,g,h,k);a.context=dl(null);c=a.current;d=R();e=yi(c);f=mh(d,e);f.callback=void 0!==b&&null!==b?b:null;nh(c,f,e);a.current.lanes=e;Ac(a,e,d);Dk(a,d);return a}function fl(a,b,c,d){var e=b.current,f=R(),g=yi(e);c=dl(c);null===b.context?b.context=c:b.pendingContext=c;b=mh(f,g);b.payload={element:a};d=void 0===d?null:d;null!==d&&(b.callback=d);a=nh(e,b,g);null!==a&&(gi(a,e,g,f),oh(a,e,g));return g}
function gl(a){a=a.current;if(!a.child)return null;switch(a.child.tag){case 5:return a.child.stateNode;default:return a.child.stateNode}}function hl(a,b){a=a.memoizedState;if(null!==a&&null!==a.dehydrated){var c=a.retryLane;a.retryLane=0!==c&&c<b?c:b;}}function il(a,b){hl(a,b);(a=a.alternate)&&hl(a,b);}function jl(){return null}var kl="function"===typeof reportError?reportError:function(a){console.error(a);};function ll(a){this._internalRoot=a;}
ml.prototype.render=ll.prototype.render=function(a){var b=this._internalRoot;if(null===b)throw Error(p(409));fl(a,b,null,null);};ml.prototype.unmount=ll.prototype.unmount=function(){var a=this._internalRoot;if(null!==a){this._internalRoot=null;var b=a.containerInfo;Rk(function(){fl(null,a,null,null);});b[uf]=null;}};function ml(a){this._internalRoot=a;}
ml.prototype.unstable_scheduleHydration=function(a){if(a){var b=Hc();a={blockedOn:null,target:a,priority:b};for(var c=0;c<Qc.length&&0!==b&&b<Qc[c].priority;c++);Qc.splice(c,0,a);0===c&&Vc(a);}};function nl(a){return !(!a||1!==a.nodeType&&9!==a.nodeType&&11!==a.nodeType)}function ol(a){return !(!a||1!==a.nodeType&&9!==a.nodeType&&11!==a.nodeType&&(8!==a.nodeType||" react-mount-point-unstable "!==a.nodeValue))}function pl(){}
function ql(a,b,c,d,e){if(e){if("function"===typeof d){var f=d;d=function(){var a=gl(g);f.call(a);};}var g=el(b,d,a,0,null,!1,!1,"",pl);a._reactRootContainer=g;a[uf]=g.current;sf(8===a.nodeType?a.parentNode:a);Rk();return g}for(;e=a.lastChild;)a.removeChild(e);if("function"===typeof d){var h=d;d=function(){var a=gl(k);h.call(a);};}var k=bl(a,0,!1,null,null,!1,!1,"",pl);a._reactRootContainer=k;a[uf]=k.current;sf(8===a.nodeType?a.parentNode:a);Rk(function(){fl(b,k,c,d);});return k}
function rl(a,b,c,d,e){var f=c._reactRootContainer;if(f){var g=f;if("function"===typeof e){var h=e;e=function(){var a=gl(g);h.call(a);};}fl(b,g,a,e);}else g=ql(c,b,a,e,d);return gl(g)}Ec=function(a){switch(a.tag){case 3:var b=a.stateNode;if(b.current.memoizedState.isDehydrated){var c=tc(b.pendingLanes);0!==c&&(Cc(b,c|1),Dk(b,B()),0===(K&6)&&(Gj=B()+500,jg()));}break;case 13:Rk(function(){var b=ih(a,1);if(null!==b){var c=R();gi(b,a,1,c);}}),il(a,1);}};
Fc=function(a){if(13===a.tag){var b=ih(a,134217728);if(null!==b){var c=R();gi(b,a,134217728,c);}il(a,134217728);}};Gc=function(a){if(13===a.tag){var b=yi(a),c=ih(a,b);if(null!==c){var d=R();gi(c,a,b,d);}il(a,b);}};Hc=function(){return C};Ic=function(a,b){var c=C;try{return C=a,b()}finally{C=c;}};
yb=function(a,b,c){switch(b){case "input":bb(a,c);b=c.name;if("radio"===c.type&&null!=b){for(c=a;c.parentNode;)c=c.parentNode;c=c.querySelectorAll("input[name="+JSON.stringify(""+b)+'][type="radio"]');for(b=0;b<c.length;b++){var d=c[b];if(d!==a&&d.form===a.form){var e=Db(d);if(!e)throw Error(p(90));Wa(d);bb(d,e);}}}break;case "textarea":ib(a,c);break;case "select":b=c.value,null!=b&&fb(a,!!c.multiple,b,!1);}};Gb=Qk;Hb=Rk;
var sl={usingClientEntryPoint:!1,Events:[Cb,ue,Db,Eb,Fb,Qk]},tl={findFiberByHostInstance:Wc,bundleType:0,version:"18.3.1",rendererPackageName:"react-dom"};
var ul={bundleType:tl.bundleType,version:tl.version,rendererPackageName:tl.rendererPackageName,rendererConfig:tl.rendererConfig,overrideHookState:null,overrideHookStateDeletePath:null,overrideHookStateRenamePath:null,overrideProps:null,overridePropsDeletePath:null,overridePropsRenamePath:null,setErrorHandler:null,setSuspenseHandler:null,scheduleUpdate:null,currentDispatcherRef:ua.ReactCurrentDispatcher,findHostInstanceByFiber:function(a){a=Zb(a);return null===a?null:a.stateNode},findFiberByHostInstance:tl.findFiberByHostInstance||
jl,findHostInstancesForRefresh:null,scheduleRefresh:null,scheduleRoot:null,setRefreshHandler:null,getCurrentFiber:null,reconcilerVersion:"18.3.1-next-f1338f8080-20240426"};if("undefined"!==typeof __REACT_DEVTOOLS_GLOBAL_HOOK__){var vl=__REACT_DEVTOOLS_GLOBAL_HOOK__;if(!vl.isDisabled&&vl.supportsFiber)try{kc=vl.inject(ul),lc=vl;}catch(a){}}reactDom_production_min.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=sl;
reactDom_production_min.createPortal=function(a,b){var c=2<arguments.length&&void 0!==arguments[2]?arguments[2]:null;if(!nl(b))throw Error(p(200));return cl(a,b,null,c)};reactDom_production_min.createRoot=function(a,b){if(!nl(a))throw Error(p(299));var c=!1,d="",e=kl;null!==b&&void 0!==b&&(!0===b.unstable_strictMode&&(c=!0),void 0!==b.identifierPrefix&&(d=b.identifierPrefix),void 0!==b.onRecoverableError&&(e=b.onRecoverableError));b=bl(a,1,!1,null,null,c,!1,d,e);a[uf]=b.current;sf(8===a.nodeType?a.parentNode:a);return new ll(b)};
reactDom_production_min.findDOMNode=function(a){if(null==a)return null;if(1===a.nodeType)return a;var b=a._reactInternals;if(void 0===b){if("function"===typeof a.render)throw Error(p(188));a=Object.keys(a).join(",");throw Error(p(268,a));}a=Zb(b);a=null===a?null:a.stateNode;return a};reactDom_production_min.flushSync=function(a){return Rk(a)};reactDom_production_min.hydrate=function(a,b,c){if(!ol(b))throw Error(p(200));return rl(null,a,b,!0,c)};
reactDom_production_min.hydrateRoot=function(a,b,c){if(!nl(a))throw Error(p(405));var d=null!=c&&c.hydratedSources||null,e=!1,f="",g=kl;null!==c&&void 0!==c&&(!0===c.unstable_strictMode&&(e=!0),void 0!==c.identifierPrefix&&(f=c.identifierPrefix),void 0!==c.onRecoverableError&&(g=c.onRecoverableError));b=el(b,null,a,1,null!=c?c:null,e,!1,f,g);a[uf]=b.current;sf(a);if(d)for(a=0;a<d.length;a++)c=d[a],e=c._getVersion,e=e(c._source),null==b.mutableSourceEagerHydrationData?b.mutableSourceEagerHydrationData=[c,e]:b.mutableSourceEagerHydrationData.push(c,
e);return new ml(b)};reactDom_production_min.render=function(a,b,c){if(!ol(b))throw Error(p(200));return rl(null,a,b,!1,c)};reactDom_production_min.unmountComponentAtNode=function(a){if(!ol(a))throw Error(p(40));return a._reactRootContainer?(Rk(function(){rl(null,null,a,!1,function(){a._reactRootContainer=null;a[uf]=null;});}),!0):!1};reactDom_production_min.unstable_batchedUpdates=Qk;
reactDom_production_min.unstable_renderSubtreeIntoContainer=function(a,b,c,d){if(!ol(c))throw Error(p(200));if(null==a||void 0===a._reactInternals)throw Error(p(38));return rl(a,b,c,!1,d)};reactDom_production_min.version="18.3.1-next-f1338f8080-20240426";

function checkDCE() {
  /* global __REACT_DEVTOOLS_GLOBAL_HOOK__ */
  if (
    typeof __REACT_DEVTOOLS_GLOBAL_HOOK__ === 'undefined' ||
    typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE !== 'function'
  ) {
    return;
  }
  try {
    // Verify that the code above has been dead code eliminated (DCE'd).
    __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(checkDCE);
  } catch (err) {
    // DevTools shouldn't crash React, no matter what.
    // We should still report in case we break this code.
    console.error(err);
  }
}

{
  // DCE check should happen before ReactDOM bundle executes so that
  // DevTools can report bad minification during injection.
  checkDCE();
  reactDom.exports = reactDom_production_min;
}

var reactDomExports = reactDom.exports;

var createRoot;

var m = reactDomExports;
{
  createRoot = m.createRoot;
  m.hydrateRoot;
}

// https://github.com/facebook/react/blob/master/packages/shared/ExecutionEnvironment.js
const canUseDOM = typeof window !== 'undefined' && typeof window.document !== 'undefined' && typeof window.document.createElement !== 'undefined';

function isWindow(element) {
  const elementString = Object.prototype.toString.call(element);
  return elementString === '[object Window]' || // In Electron context the Window object serializes to [object global]
  elementString === '[object global]';
}

function isNode(node) {
  return 'nodeType' in node;
}

function getWindow(target) {
  var _target$ownerDocument, _target$ownerDocument2;

  if (!target) {
    return window;
  }

  if (isWindow(target)) {
    return target;
  }

  if (!isNode(target)) {
    return window;
  }

  return (_target$ownerDocument = (_target$ownerDocument2 = target.ownerDocument) == null ? void 0 : _target$ownerDocument2.defaultView) != null ? _target$ownerDocument : window;
}

function isDocument(node) {
  const {
    Document
  } = getWindow(node);
  return node instanceof Document;
}

function isHTMLElement(node) {
  if (isWindow(node)) {
    return false;
  }

  return node instanceof getWindow(node).HTMLElement;
}

function isSVGElement(node) {
  return node instanceof getWindow(node).SVGElement;
}

function getOwnerDocument(target) {
  if (!target) {
    return document;
  }

  if (isWindow(target)) {
    return target.document;
  }

  if (!isNode(target)) {
    return document;
  }

  if (isDocument(target)) {
    return target;
  }

  if (isHTMLElement(target) || isSVGElement(target)) {
    return target.ownerDocument;
  }

  return document;
}

/**
 * A hook that resolves to useEffect on the server and useLayoutEffect on the client
 * @param callback {function} Callback function that is invoked when the dependencies of the hook change
 */

const useIsomorphicLayoutEffect = canUseDOM ? reactExports.useLayoutEffect : reactExports.useEffect;

function useEvent(handler) {
  const handlerRef = reactExports.useRef(handler);
  useIsomorphicLayoutEffect(() => {
    handlerRef.current = handler;
  });
  return reactExports.useCallback(function () {
    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    return handlerRef.current == null ? void 0 : handlerRef.current(...args);
  }, []);
}

function useInterval() {
  const intervalRef = reactExports.useRef(null);
  const set = reactExports.useCallback((listener, duration) => {
    intervalRef.current = setInterval(listener, duration);
  }, []);
  const clear = reactExports.useCallback(() => {
    if (intervalRef.current !== null) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
  }, []);
  return [set, clear];
}

function useLatestValue(value, dependencies) {
  if (dependencies === void 0) {
    dependencies = [value];
  }

  const valueRef = reactExports.useRef(value);
  useIsomorphicLayoutEffect(() => {
    if (valueRef.current !== value) {
      valueRef.current = value;
    }
  }, dependencies);
  return valueRef;
}

function useLazyMemo(callback, dependencies) {
  const valueRef = reactExports.useRef();
  return reactExports.useMemo(() => {
    const newValue = callback(valueRef.current);
    valueRef.current = newValue;
    return newValue;
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [...dependencies]);
}

function useNodeRef(onChange) {
  const onChangeHandler = useEvent(onChange);
  const node = reactExports.useRef(null);
  const setNodeRef = reactExports.useCallback(element => {
    if (element !== node.current) {
      onChangeHandler == null ? void 0 : onChangeHandler(element, node.current);
    }

    node.current = element;
  }, //eslint-disable-next-line
  []);
  return [node, setNodeRef];
}

function usePrevious(value) {
  const ref = reactExports.useRef();
  reactExports.useEffect(() => {
    ref.current = value;
  }, [value]);
  return ref.current;
}

let ids = {};
function useUniqueId(prefix, value) {
  return reactExports.useMemo(() => {
    if (value) {
      return value;
    }

    const id = ids[prefix] == null ? 0 : ids[prefix] + 1;
    ids[prefix] = id;
    return prefix + "-" + id;
  }, [prefix, value]);
}

function createAdjustmentFn(modifier) {
  return function (object) {
    for (var _len = arguments.length, adjustments = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      adjustments[_key - 1] = arguments[_key];
    }

    return adjustments.reduce((accumulator, adjustment) => {
      const entries = Object.entries(adjustment);

      for (const [key, valueAdjustment] of entries) {
        const value = accumulator[key];

        if (value != null) {
          accumulator[key] = value + modifier * valueAdjustment;
        }
      }

      return accumulator;
    }, { ...object
    });
  };
}

const add = /*#__PURE__*/createAdjustmentFn(1);
const subtract = /*#__PURE__*/createAdjustmentFn(-1);

function hasViewportRelativeCoordinates(event) {
  return 'clientX' in event && 'clientY' in event;
}

function isKeyboardEvent(event) {
  if (!event) {
    return false;
  }

  const {
    KeyboardEvent
  } = getWindow(event.target);
  return KeyboardEvent && event instanceof KeyboardEvent;
}

function isTouchEvent(event) {
  if (!event) {
    return false;
  }

  const {
    TouchEvent
  } = getWindow(event.target);
  return TouchEvent && event instanceof TouchEvent;
}

/**
 * Returns the normalized x and y coordinates for mouse and touch events.
 */

function getEventCoordinates(event) {
  if (isTouchEvent(event)) {
    if (event.touches && event.touches.length) {
      const {
        clientX: x,
        clientY: y
      } = event.touches[0];
      return {
        x,
        y
      };
    } else if (event.changedTouches && event.changedTouches.length) {
      const {
        clientX: x,
        clientY: y
      } = event.changedTouches[0];
      return {
        x,
        y
      };
    }
  }

  if (hasViewportRelativeCoordinates(event)) {
    return {
      x: event.clientX,
      y: event.clientY
    };
  }

  return null;
}

const CSS = /*#__PURE__*/Object.freeze({
  Translate: {
    toString(transform) {
      if (!transform) {
        return;
      }

      const {
        x,
        y
      } = transform;
      return "translate3d(" + (x ? Math.round(x) : 0) + "px, " + (y ? Math.round(y) : 0) + "px, 0)";
    }

  },
  Scale: {
    toString(transform) {
      if (!transform) {
        return;
      }

      const {
        scaleX,
        scaleY
      } = transform;
      return "scaleX(" + scaleX + ") scaleY(" + scaleY + ")";
    }

  },
  Transform: {
    toString(transform) {
      if (!transform) {
        return;
      }

      return [CSS.Translate.toString(transform), CSS.Scale.toString(transform)].join(' ');
    }

  },
  Transition: {
    toString(_ref) {
      let {
        property,
        duration,
        easing
      } = _ref;
      return property + " " + duration + "ms " + easing;
    }

  }
});

const SELECTOR = 'a,frame,iframe,input:not([type=hidden]):not(:disabled),select:not(:disabled),textarea:not(:disabled),button:not(:disabled),*[tabindex]';
function findFirstFocusableNode(element) {
  if (element.matches(SELECTOR)) {
    return element;
  }

  return element.querySelector(SELECTOR);
}

const hiddenStyles = {
  display: 'none'
};
function HiddenText(_ref) {
  let {
    id,
    value
  } = _ref;
  return React.createElement("div", {
    id: id,
    style: hiddenStyles
  }, value);
}

function LiveRegion(_ref) {
  let {
    id,
    announcement,
    ariaLiveType = "assertive"
  } = _ref;
  // Hide element visually but keep it readable by screen readers
  const visuallyHidden = {
    position: 'fixed',
    top: 0,
    left: 0,
    width: 1,
    height: 1,
    margin: -1,
    border: 0,
    padding: 0,
    overflow: 'hidden',
    clip: 'rect(0 0 0 0)',
    clipPath: 'inset(100%)',
    whiteSpace: 'nowrap'
  };
  return React.createElement("div", {
    id: id,
    style: visuallyHidden,
    role: "status",
    "aria-live": ariaLiveType,
    "aria-atomic": true
  }, announcement);
}

function useAnnouncement() {
  const [announcement, setAnnouncement] = reactExports.useState('');
  const announce = reactExports.useCallback(value => {
    if (value != null) {
      setAnnouncement(value);
    }
  }, []);
  return {
    announce,
    announcement
  };
}

const DndMonitorContext = /*#__PURE__*/reactExports.createContext(null);

function useDndMonitor(listener) {
  const registerListener = reactExports.useContext(DndMonitorContext);
  reactExports.useEffect(() => {
    if (!registerListener) {
      throw new Error('useDndMonitor must be used within a children of <DndContext>');
    }

    const unsubscribe = registerListener(listener);
    return unsubscribe;
  }, [listener, registerListener]);
}

function useDndMonitorProvider() {
  const [listeners] = reactExports.useState(() => new Set());
  const registerListener = reactExports.useCallback(listener => {
    listeners.add(listener);
    return () => listeners.delete(listener);
  }, [listeners]);
  const dispatch = reactExports.useCallback(_ref => {
    let {
      type,
      event
    } = _ref;
    listeners.forEach(listener => {
      var _listener$type;

      return (_listener$type = listener[type]) == null ? void 0 : _listener$type.call(listener, event);
    });
  }, [listeners]);
  return [dispatch, registerListener];
}

const defaultScreenReaderInstructions = {
  draggable: "\n    To pick up a draggable item, press the space bar.\n    While dragging, use the arrow keys to move the item.\n    Press space again to drop the item in its new position, or press escape to cancel.\n  "
};
const defaultAnnouncements = {
  onDragStart(_ref) {
    let {
      active
    } = _ref;
    return "Picked up draggable item " + active.id + ".";
  },

  onDragOver(_ref2) {
    let {
      active,
      over
    } = _ref2;

    if (over) {
      return "Draggable item " + active.id + " was moved over droppable area " + over.id + ".";
    }

    return "Draggable item " + active.id + " is no longer over a droppable area.";
  },

  onDragEnd(_ref3) {
    let {
      active,
      over
    } = _ref3;

    if (over) {
      return "Draggable item " + active.id + " was dropped over droppable area " + over.id;
    }

    return "Draggable item " + active.id + " was dropped.";
  },

  onDragCancel(_ref4) {
    let {
      active
    } = _ref4;
    return "Dragging was cancelled. Draggable item " + active.id + " was dropped.";
  }

};

function Accessibility(_ref) {
  let {
    announcements = defaultAnnouncements,
    container,
    hiddenTextDescribedById,
    screenReaderInstructions = defaultScreenReaderInstructions
  } = _ref;
  const {
    announce,
    announcement
  } = useAnnouncement();
  const liveRegionId = useUniqueId("DndLiveRegion");
  const [mounted, setMounted] = reactExports.useState(false);
  reactExports.useEffect(() => {
    setMounted(true);
  }, []);
  useDndMonitor(reactExports.useMemo(() => ({
    onDragStart(_ref2) {
      let {
        active
      } = _ref2;
      announce(announcements.onDragStart({
        active
      }));
    },

    onDragMove(_ref3) {
      let {
        active,
        over
      } = _ref3;

      if (announcements.onDragMove) {
        announce(announcements.onDragMove({
          active,
          over
        }));
      }
    },

    onDragOver(_ref4) {
      let {
        active,
        over
      } = _ref4;
      announce(announcements.onDragOver({
        active,
        over
      }));
    },

    onDragEnd(_ref5) {
      let {
        active,
        over
      } = _ref5;
      announce(announcements.onDragEnd({
        active,
        over
      }));
    },

    onDragCancel(_ref6) {
      let {
        active,
        over
      } = _ref6;
      announce(announcements.onDragCancel({
        active,
        over
      }));
    }

  }), [announce, announcements]));

  if (!mounted) {
    return null;
  }

  const markup = React.createElement(React.Fragment, null, React.createElement(HiddenText, {
    id: hiddenTextDescribedById,
    value: screenReaderInstructions.draggable
  }), React.createElement(LiveRegion, {
    id: liveRegionId,
    announcement: announcement
  }));
  return container ? reactDomExports.createPortal(markup, container) : markup;
}

var Action;

(function (Action) {
  Action["DragStart"] = "dragStart";
  Action["DragMove"] = "dragMove";
  Action["DragEnd"] = "dragEnd";
  Action["DragCancel"] = "dragCancel";
  Action["DragOver"] = "dragOver";
  Action["RegisterDroppable"] = "registerDroppable";
  Action["SetDroppableDisabled"] = "setDroppableDisabled";
  Action["UnregisterDroppable"] = "unregisterDroppable";
})(Action || (Action = {}));

function noop() {}

function useSensor(sensor, options) {
  return reactExports.useMemo(() => ({
    sensor,
    options: options != null ? options : {}
  }), // eslint-disable-next-line react-hooks/exhaustive-deps
  [sensor, options]);
}

function useSensors() {
  for (var _len = arguments.length, sensors = new Array(_len), _key = 0; _key < _len; _key++) {
    sensors[_key] = arguments[_key];
  }

  return reactExports.useMemo(() => [...sensors].filter(sensor => sensor != null), // eslint-disable-next-line react-hooks/exhaustive-deps
  [...sensors]);
}

const defaultCoordinates = /*#__PURE__*/Object.freeze({
  x: 0,
  y: 0
});

/**
 * Returns the distance between two points
 */
function distanceBetween(p1, p2) {
  return Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2));
}

function getRelativeTransformOrigin(event, rect) {
  const eventCoordinates = getEventCoordinates(event);

  if (!eventCoordinates) {
    return '0 0';
  }

  const transformOrigin = {
    x: (eventCoordinates.x - rect.left) / rect.width * 100,
    y: (eventCoordinates.y - rect.top) / rect.height * 100
  };
  return transformOrigin.x + "% " + transformOrigin.y + "%";
}

/**
 * Sort collisions from smallest to greatest value
 */
function sortCollisionsAsc(_ref, _ref2) {
  let {
    data: {
      value: a
    }
  } = _ref;
  let {
    data: {
      value: b
    }
  } = _ref2;
  return a - b;
}
/**
 * Sort collisions from greatest to smallest value
 */

function sortCollisionsDesc(_ref3, _ref4) {
  let {
    data: {
      value: a
    }
  } = _ref3;
  let {
    data: {
      value: b
    }
  } = _ref4;
  return b - a;
}
/**
 * Returns the coordinates of the corners of a given rectangle:
 * [TopLeft {x, y}, TopRight {x, y}, BottomLeft {x, y}, BottomRight {x, y}]
 */

function cornersOfRectangle(_ref5) {
  let {
    left,
    top,
    height,
    width
  } = _ref5;
  return [{
    x: left,
    y: top
  }, {
    x: left + width,
    y: top
  }, {
    x: left,
    y: top + height
  }, {
    x: left + width,
    y: top + height
  }];
}
function getFirstCollision(collisions, property) {
  if (!collisions || collisions.length === 0) {
    return null;
  }

  const [firstCollision] = collisions;
  return property ? firstCollision[property] : firstCollision;
}

/**
 * Returns the intersecting rectangle area between two rectangles
 */

function getIntersectionRatio(entry, target) {
  const top = Math.max(target.top, entry.top);
  const left = Math.max(target.left, entry.left);
  const right = Math.min(target.left + target.width, entry.left + entry.width);
  const bottom = Math.min(target.top + target.height, entry.top + entry.height);
  const width = right - left;
  const height = bottom - top;

  if (left < right && top < bottom) {
    const targetArea = target.width * target.height;
    const entryArea = entry.width * entry.height;
    const intersectionArea = width * height;
    const intersectionRatio = intersectionArea / (targetArea + entryArea - intersectionArea);
    return Number(intersectionRatio.toFixed(4));
  } // Rectangles do not overlap, or overlap has an area of zero (edge/corner overlap)


  return 0;
}
/**
 * Returns the rectangles that has the greatest intersection area with a given
 * rectangle in an array of rectangles.
 */

const rectIntersection = _ref => {
  let {
    collisionRect,
    droppableRects,
    droppableContainers
  } = _ref;
  const collisions = [];

  for (const droppableContainer of droppableContainers) {
    const {
      id
    } = droppableContainer;
    const rect = droppableRects.get(id);

    if (rect) {
      const intersectionRatio = getIntersectionRatio(rect, collisionRect);

      if (intersectionRatio > 0) {
        collisions.push({
          id,
          data: {
            droppableContainer,
            value: intersectionRatio
          }
        });
      }
    }
  }

  return collisions.sort(sortCollisionsDesc);
};

/**
 * Check if a given point is contained within a bounding rectangle
 */

function isPointWithinRect(point, rect) {
  const {
    top,
    left,
    bottom,
    right
  } = rect;
  return top <= point.y && point.y <= bottom && left <= point.x && point.x <= right;
}
/**
 * Returns the rectangles that the pointer is hovering over
 */


const pointerWithin = _ref => {
  let {
    droppableContainers,
    droppableRects,
    pointerCoordinates
  } = _ref;

  if (!pointerCoordinates) {
    return [];
  }

  const collisions = [];

  for (const droppableContainer of droppableContainers) {
    const {
      id
    } = droppableContainer;
    const rect = droppableRects.get(id);

    if (rect && isPointWithinRect(pointerCoordinates, rect)) {
      /* There may be more than a single rectangle intersecting
       * with the pointer coordinates. In order to sort the
       * colliding rectangles, we measure the distance between
       * the pointer and the corners of the intersecting rectangle
       */
      const corners = cornersOfRectangle(rect);
      const distances = corners.reduce((accumulator, corner) => {
        return accumulator + distanceBetween(pointerCoordinates, corner);
      }, 0);
      const effectiveDistance = Number((distances / 4).toFixed(4));
      collisions.push({
        id,
        data: {
          droppableContainer,
          value: effectiveDistance
        }
      });
    }
  }

  return collisions.sort(sortCollisionsAsc);
};

function adjustScale(transform, rect1, rect2) {
  return { ...transform,
    scaleX: rect1 && rect2 ? rect1.width / rect2.width : 1,
    scaleY: rect1 && rect2 ? rect1.height / rect2.height : 1
  };
}

function getRectDelta(rect1, rect2) {
  return rect1 && rect2 ? {
    x: rect1.left - rect2.left,
    y: rect1.top - rect2.top
  } : defaultCoordinates;
}

function createRectAdjustmentFn(modifier) {
  return function adjustClientRect(rect) {
    for (var _len = arguments.length, adjustments = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      adjustments[_key - 1] = arguments[_key];
    }

    return adjustments.reduce((acc, adjustment) => ({ ...acc,
      top: acc.top + modifier * adjustment.y,
      bottom: acc.bottom + modifier * adjustment.y,
      left: acc.left + modifier * adjustment.x,
      right: acc.right + modifier * adjustment.x
    }), { ...rect
    });
  };
}
const getAdjustedRect = /*#__PURE__*/createRectAdjustmentFn(1);

function parseTransform(transform) {
  if (transform.startsWith('matrix3d(')) {
    const transformArray = transform.slice(9, -1).split(/, /);
    return {
      x: +transformArray[12],
      y: +transformArray[13],
      scaleX: +transformArray[0],
      scaleY: +transformArray[5]
    };
  } else if (transform.startsWith('matrix(')) {
    const transformArray = transform.slice(7, -1).split(/, /);
    return {
      x: +transformArray[4],
      y: +transformArray[5],
      scaleX: +transformArray[0],
      scaleY: +transformArray[3]
    };
  }

  return null;
}

function inverseTransform(rect, transform, transformOrigin) {
  const parsedTransform = parseTransform(transform);

  if (!parsedTransform) {
    return rect;
  }

  const {
    scaleX,
    scaleY,
    x: translateX,
    y: translateY
  } = parsedTransform;
  const x = rect.left - translateX - (1 - scaleX) * parseFloat(transformOrigin);
  const y = rect.top - translateY - (1 - scaleY) * parseFloat(transformOrigin.slice(transformOrigin.indexOf(' ') + 1));
  const w = scaleX ? rect.width / scaleX : rect.width;
  const h = scaleY ? rect.height / scaleY : rect.height;
  return {
    width: w,
    height: h,
    top: y,
    right: x + w,
    bottom: y + h,
    left: x
  };
}

const defaultOptions = {
  ignoreTransform: false
};
/**
 * Returns the bounding client rect of an element relative to the viewport.
 */

function getClientRect(element, options) {
  if (options === void 0) {
    options = defaultOptions;
  }

  let rect = element.getBoundingClientRect();

  if (options.ignoreTransform) {
    const {
      transform,
      transformOrigin
    } = getWindow(element).getComputedStyle(element);

    if (transform) {
      rect = inverseTransform(rect, transform, transformOrigin);
    }
  }

  const {
    top,
    left,
    width,
    height,
    bottom,
    right
  } = rect;
  return {
    top,
    left,
    width,
    height,
    bottom,
    right
  };
}
/**
 * Returns the bounding client rect of an element relative to the viewport.
 *
 * @remarks
 * The ClientRect returned by this method does not take into account transforms
 * applied to the element it measures.
 *
 */

function getTransformAgnosticClientRect(element) {
  return getClientRect(element, {
    ignoreTransform: true
  });
}

function getWindowClientRect(element) {
  const width = element.innerWidth;
  const height = element.innerHeight;
  return {
    top: 0,
    left: 0,
    right: width,
    bottom: height,
    width,
    height
  };
}

function isFixed(node, computedStyle) {
  if (computedStyle === void 0) {
    computedStyle = getWindow(node).getComputedStyle(node);
  }

  return computedStyle.position === 'fixed';
}

function isScrollable(element, computedStyle) {
  if (computedStyle === void 0) {
    computedStyle = getWindow(element).getComputedStyle(element);
  }

  const overflowRegex = /(auto|scroll|overlay)/;
  const properties = ['overflow', 'overflowX', 'overflowY'];
  return properties.some(property => {
    const value = computedStyle[property];
    return typeof value === 'string' ? overflowRegex.test(value) : false;
  });
}

function getScrollableAncestors(element, limit) {
  const scrollParents = [];

  function findScrollableAncestors(node) {
    if (limit != null && scrollParents.length >= limit) {
      return scrollParents;
    }

    if (!node) {
      return scrollParents;
    }

    if (isDocument(node) && node.scrollingElement != null && !scrollParents.includes(node.scrollingElement)) {
      scrollParents.push(node.scrollingElement);
      return scrollParents;
    }

    if (!isHTMLElement(node) || isSVGElement(node)) {
      return scrollParents;
    }

    if (scrollParents.includes(node)) {
      return scrollParents;
    }

    const computedStyle = getWindow(element).getComputedStyle(node);

    if (node !== element) {
      if (isScrollable(node, computedStyle)) {
        scrollParents.push(node);
      }
    }

    if (isFixed(node, computedStyle)) {
      return scrollParents;
    }

    return findScrollableAncestors(node.parentNode);
  }

  if (!element) {
    return scrollParents;
  }

  return findScrollableAncestors(element);
}
function getFirstScrollableAncestor(node) {
  const [firstScrollableAncestor] = getScrollableAncestors(node, 1);
  return firstScrollableAncestor != null ? firstScrollableAncestor : null;
}

function getScrollableElement(element) {
  if (!canUseDOM || !element) {
    return null;
  }

  if (isWindow(element)) {
    return element;
  }

  if (!isNode(element)) {
    return null;
  }

  if (isDocument(element) || element === getOwnerDocument(element).scrollingElement) {
    return window;
  }

  if (isHTMLElement(element)) {
    return element;
  }

  return null;
}

function getScrollXCoordinate(element) {
  if (isWindow(element)) {
    return element.scrollX;
  }

  return element.scrollLeft;
}
function getScrollYCoordinate(element) {
  if (isWindow(element)) {
    return element.scrollY;
  }

  return element.scrollTop;
}
function getScrollCoordinates(element) {
  return {
    x: getScrollXCoordinate(element),
    y: getScrollYCoordinate(element)
  };
}

var Direction;

(function (Direction) {
  Direction[Direction["Forward"] = 1] = "Forward";
  Direction[Direction["Backward"] = -1] = "Backward";
})(Direction || (Direction = {}));

function isDocumentScrollingElement(element) {
  if (!canUseDOM || !element) {
    return false;
  }

  return element === document.scrollingElement;
}

function getScrollPosition(scrollingContainer) {
  const minScroll = {
    x: 0,
    y: 0
  };
  const dimensions = isDocumentScrollingElement(scrollingContainer) ? {
    height: window.innerHeight,
    width: window.innerWidth
  } : {
    height: scrollingContainer.clientHeight,
    width: scrollingContainer.clientWidth
  };
  const maxScroll = {
    x: scrollingContainer.scrollWidth - dimensions.width,
    y: scrollingContainer.scrollHeight - dimensions.height
  };
  const isTop = scrollingContainer.scrollTop <= minScroll.y;
  const isLeft = scrollingContainer.scrollLeft <= minScroll.x;
  const isBottom = scrollingContainer.scrollTop >= maxScroll.y;
  const isRight = scrollingContainer.scrollLeft >= maxScroll.x;
  return {
    isTop,
    isLeft,
    isBottom,
    isRight,
    maxScroll,
    minScroll
  };
}

const defaultThreshold = {
  x: 0.2,
  y: 0.2
};
function getScrollDirectionAndSpeed(scrollContainer, scrollContainerRect, _ref, acceleration, thresholdPercentage) {
  let {
    top,
    left,
    right,
    bottom
  } = _ref;

  if (acceleration === void 0) {
    acceleration = 10;
  }

  if (thresholdPercentage === void 0) {
    thresholdPercentage = defaultThreshold;
  }

  const {
    isTop,
    isBottom,
    isLeft,
    isRight
  } = getScrollPosition(scrollContainer);
  const direction = {
    x: 0,
    y: 0
  };
  const speed = {
    x: 0,
    y: 0
  };
  const threshold = {
    height: scrollContainerRect.height * thresholdPercentage.y,
    width: scrollContainerRect.width * thresholdPercentage.x
  };

  if (!isTop && top <= scrollContainerRect.top + threshold.height) {
    // Scroll Up
    direction.y = Direction.Backward;
    speed.y = acceleration * Math.abs((scrollContainerRect.top + threshold.height - top) / threshold.height);
  } else if (!isBottom && bottom >= scrollContainerRect.bottom - threshold.height) {
    // Scroll Down
    direction.y = Direction.Forward;
    speed.y = acceleration * Math.abs((scrollContainerRect.bottom - threshold.height - bottom) / threshold.height);
  }

  if (!isRight && right >= scrollContainerRect.right - threshold.width) {
    // Scroll Right
    direction.x = Direction.Forward;
    speed.x = acceleration * Math.abs((scrollContainerRect.right - threshold.width - right) / threshold.width);
  } else if (!isLeft && left <= scrollContainerRect.left + threshold.width) {
    // Scroll Left
    direction.x = Direction.Backward;
    speed.x = acceleration * Math.abs((scrollContainerRect.left + threshold.width - left) / threshold.width);
  }

  return {
    direction,
    speed
  };
}

function getScrollElementRect(element) {
  if (element === document.scrollingElement) {
    const {
      innerWidth,
      innerHeight
    } = window;
    return {
      top: 0,
      left: 0,
      right: innerWidth,
      bottom: innerHeight,
      width: innerWidth,
      height: innerHeight
    };
  }

  const {
    top,
    left,
    right,
    bottom
  } = element.getBoundingClientRect();
  return {
    top,
    left,
    right,
    bottom,
    width: element.clientWidth,
    height: element.clientHeight
  };
}

function getScrollOffsets(scrollableAncestors) {
  return scrollableAncestors.reduce((acc, node) => {
    return add(acc, getScrollCoordinates(node));
  }, defaultCoordinates);
}
function getScrollXOffset(scrollableAncestors) {
  return scrollableAncestors.reduce((acc, node) => {
    return acc + getScrollXCoordinate(node);
  }, 0);
}
function getScrollYOffset(scrollableAncestors) {
  return scrollableAncestors.reduce((acc, node) => {
    return acc + getScrollYCoordinate(node);
  }, 0);
}

function scrollIntoViewIfNeeded(element, measure) {
  if (measure === void 0) {
    measure = getClientRect;
  }

  if (!element) {
    return;
  }

  const {
    top,
    left,
    bottom,
    right
  } = measure(element);
  const firstScrollableAncestor = getFirstScrollableAncestor(element);

  if (!firstScrollableAncestor) {
    return;
  }

  if (bottom <= 0 || right <= 0 || top >= window.innerHeight || left >= window.innerWidth) {
    element.scrollIntoView({
      block: 'center',
      inline: 'center'
    });
  }
}

const properties = [['x', ['left', 'right'], getScrollXOffset], ['y', ['top', 'bottom'], getScrollYOffset]];
class Rect {
  constructor(rect, element) {
    this.rect = void 0;
    this.width = void 0;
    this.height = void 0;
    this.top = void 0;
    this.bottom = void 0;
    this.right = void 0;
    this.left = void 0;
    const scrollableAncestors = getScrollableAncestors(element);
    const scrollOffsets = getScrollOffsets(scrollableAncestors);
    this.rect = { ...rect
    };
    this.width = rect.width;
    this.height = rect.height;

    for (const [axis, keys, getScrollOffset] of properties) {
      for (const key of keys) {
        Object.defineProperty(this, key, {
          get: () => {
            const currentOffsets = getScrollOffset(scrollableAncestors);
            const scrollOffsetsDeltla = scrollOffsets[axis] - currentOffsets;
            return this.rect[key] + scrollOffsetsDeltla;
          },
          enumerable: true
        });
      }
    }

    Object.defineProperty(this, 'rect', {
      enumerable: false
    });
  }

}

class Listeners {
  constructor(target) {
    this.target = void 0;
    this.listeners = [];

    this.removeAll = () => {
      this.listeners.forEach(listener => {
        var _this$target;

        return (_this$target = this.target) == null ? void 0 : _this$target.removeEventListener(...listener);
      });
    };

    this.target = target;
  }

  add(eventName, handler, options) {
    var _this$target2;

    (_this$target2 = this.target) == null ? void 0 : _this$target2.addEventListener(eventName, handler, options);
    this.listeners.push([eventName, handler, options]);
  }

}

function getEventListenerTarget(target) {
  // If the `event.target` element is removed from the document events will still be targeted
  // at it, and hence won't always bubble up to the window or document anymore.
  // If there is any risk of an element being removed while it is being dragged,
  // the best practice is to attach the event listeners directly to the target.
  // https://developer.mozilla.org/en-US/docs/Web/API/EventTarget
  const {
    EventTarget
  } = getWindow(target);
  return target instanceof EventTarget ? target : getOwnerDocument(target);
}

function hasExceededDistance(delta, measurement) {
  const dx = Math.abs(delta.x);
  const dy = Math.abs(delta.y);

  if (typeof measurement === 'number') {
    return Math.sqrt(dx ** 2 + dy ** 2) > measurement;
  }

  if ('x' in measurement && 'y' in measurement) {
    return dx > measurement.x && dy > measurement.y;
  }

  if ('x' in measurement) {
    return dx > measurement.x;
  }

  if ('y' in measurement) {
    return dy > measurement.y;
  }

  return false;
}

var EventName;

(function (EventName) {
  EventName["Click"] = "click";
  EventName["DragStart"] = "dragstart";
  EventName["Keydown"] = "keydown";
  EventName["ContextMenu"] = "contextmenu";
  EventName["Resize"] = "resize";
  EventName["SelectionChange"] = "selectionchange";
  EventName["VisibilityChange"] = "visibilitychange";
})(EventName || (EventName = {}));

function preventDefault(event) {
  event.preventDefault();
}
function stopPropagation(event) {
  event.stopPropagation();
}

var KeyboardCode;

(function (KeyboardCode) {
  KeyboardCode["Space"] = "Space";
  KeyboardCode["Down"] = "ArrowDown";
  KeyboardCode["Right"] = "ArrowRight";
  KeyboardCode["Left"] = "ArrowLeft";
  KeyboardCode["Up"] = "ArrowUp";
  KeyboardCode["Esc"] = "Escape";
  KeyboardCode["Enter"] = "Enter";
  KeyboardCode["Tab"] = "Tab";
})(KeyboardCode || (KeyboardCode = {}));

const defaultKeyboardCodes = {
  start: [KeyboardCode.Space, KeyboardCode.Enter],
  cancel: [KeyboardCode.Esc],
  end: [KeyboardCode.Space, KeyboardCode.Enter, KeyboardCode.Tab]
};
const defaultKeyboardCoordinateGetter = (event, _ref) => {
  let {
    currentCoordinates
  } = _ref;

  switch (event.code) {
    case KeyboardCode.Right:
      return { ...currentCoordinates,
        x: currentCoordinates.x + 25
      };

    case KeyboardCode.Left:
      return { ...currentCoordinates,
        x: currentCoordinates.x - 25
      };

    case KeyboardCode.Down:
      return { ...currentCoordinates,
        y: currentCoordinates.y + 25
      };

    case KeyboardCode.Up:
      return { ...currentCoordinates,
        y: currentCoordinates.y - 25
      };
  }

  return undefined;
};

class KeyboardSensor {
  constructor(props) {
    this.props = void 0;
    this.autoScrollEnabled = false;
    this.referenceCoordinates = void 0;
    this.listeners = void 0;
    this.windowListeners = void 0;
    this.props = props;
    const {
      event: {
        target
      }
    } = props;
    this.props = props;
    this.listeners = new Listeners(getOwnerDocument(target));
    this.windowListeners = new Listeners(getWindow(target));
    this.handleKeyDown = this.handleKeyDown.bind(this);
    this.handleCancel = this.handleCancel.bind(this);
    this.attach();
  }

  attach() {
    this.handleStart();
    this.windowListeners.add(EventName.Resize, this.handleCancel);
    this.windowListeners.add(EventName.VisibilityChange, this.handleCancel);
    setTimeout(() => this.listeners.add(EventName.Keydown, this.handleKeyDown));
  }

  handleStart() {
    const {
      activeNode,
      onStart
    } = this.props;
    const node = activeNode.node.current;

    if (node) {
      scrollIntoViewIfNeeded(node);
    }

    onStart(defaultCoordinates);
  }

  handleKeyDown(event) {
    if (isKeyboardEvent(event)) {
      const {
        active,
        context,
        options
      } = this.props;
      const {
        keyboardCodes = defaultKeyboardCodes,
        coordinateGetter = defaultKeyboardCoordinateGetter,
        scrollBehavior = 'smooth'
      } = options;
      const {
        code
      } = event;

      if (keyboardCodes.end.includes(code)) {
        this.handleEnd(event);
        return;
      }

      if (keyboardCodes.cancel.includes(code)) {
        this.handleCancel(event);
        return;
      }

      const {
        collisionRect
      } = context.current;
      const currentCoordinates = collisionRect ? {
        x: collisionRect.left,
        y: collisionRect.top
      } : defaultCoordinates;

      if (!this.referenceCoordinates) {
        this.referenceCoordinates = currentCoordinates;
      }

      const newCoordinates = coordinateGetter(event, {
        active,
        context: context.current,
        currentCoordinates
      });

      if (newCoordinates) {
        const coordinatesDelta = subtract(newCoordinates, currentCoordinates);
        const scrollDelta = {
          x: 0,
          y: 0
        };
        const {
          scrollableAncestors
        } = context.current;

        for (const scrollContainer of scrollableAncestors) {
          const direction = event.code;
          const {
            isTop,
            isRight,
            isLeft,
            isBottom,
            maxScroll,
            minScroll
          } = getScrollPosition(scrollContainer);
          const scrollElementRect = getScrollElementRect(scrollContainer);
          const clampedCoordinates = {
            x: Math.min(direction === KeyboardCode.Right ? scrollElementRect.right - scrollElementRect.width / 2 : scrollElementRect.right, Math.max(direction === KeyboardCode.Right ? scrollElementRect.left : scrollElementRect.left + scrollElementRect.width / 2, newCoordinates.x)),
            y: Math.min(direction === KeyboardCode.Down ? scrollElementRect.bottom - scrollElementRect.height / 2 : scrollElementRect.bottom, Math.max(direction === KeyboardCode.Down ? scrollElementRect.top : scrollElementRect.top + scrollElementRect.height / 2, newCoordinates.y))
          };
          const canScrollX = direction === KeyboardCode.Right && !isRight || direction === KeyboardCode.Left && !isLeft;
          const canScrollY = direction === KeyboardCode.Down && !isBottom || direction === KeyboardCode.Up && !isTop;

          if (canScrollX && clampedCoordinates.x !== newCoordinates.x) {
            const newScrollCoordinates = scrollContainer.scrollLeft + coordinatesDelta.x;
            const canScrollToNewCoordinates = direction === KeyboardCode.Right && newScrollCoordinates <= maxScroll.x || direction === KeyboardCode.Left && newScrollCoordinates >= minScroll.x;

            if (canScrollToNewCoordinates && !coordinatesDelta.y) {
              // We don't need to update coordinates, the scroll adjustment alone will trigger
              // logic to auto-detect the new container we are over
              scrollContainer.scrollTo({
                left: newScrollCoordinates,
                behavior: scrollBehavior
              });
              return;
            }

            if (canScrollToNewCoordinates) {
              scrollDelta.x = scrollContainer.scrollLeft - newScrollCoordinates;
            } else {
              scrollDelta.x = direction === KeyboardCode.Right ? scrollContainer.scrollLeft - maxScroll.x : scrollContainer.scrollLeft - minScroll.x;
            }

            if (scrollDelta.x) {
              scrollContainer.scrollBy({
                left: -scrollDelta.x,
                behavior: scrollBehavior
              });
            }

            break;
          } else if (canScrollY && clampedCoordinates.y !== newCoordinates.y) {
            const newScrollCoordinates = scrollContainer.scrollTop + coordinatesDelta.y;
            const canScrollToNewCoordinates = direction === KeyboardCode.Down && newScrollCoordinates <= maxScroll.y || direction === KeyboardCode.Up && newScrollCoordinates >= minScroll.y;

            if (canScrollToNewCoordinates && !coordinatesDelta.x) {
              // We don't need to update coordinates, the scroll adjustment alone will trigger
              // logic to auto-detect the new container we are over
              scrollContainer.scrollTo({
                top: newScrollCoordinates,
                behavior: scrollBehavior
              });
              return;
            }

            if (canScrollToNewCoordinates) {
              scrollDelta.y = scrollContainer.scrollTop - newScrollCoordinates;
            } else {
              scrollDelta.y = direction === KeyboardCode.Down ? scrollContainer.scrollTop - maxScroll.y : scrollContainer.scrollTop - minScroll.y;
            }

            if (scrollDelta.y) {
              scrollContainer.scrollBy({
                top: -scrollDelta.y,
                behavior: scrollBehavior
              });
            }

            break;
          }
        }

        this.handleMove(event, add(subtract(newCoordinates, this.referenceCoordinates), scrollDelta));
      }
    }
  }

  handleMove(event, coordinates) {
    const {
      onMove
    } = this.props;
    event.preventDefault();
    onMove(coordinates);
  }

  handleEnd(event) {
    const {
      onEnd
    } = this.props;
    event.preventDefault();
    this.detach();
    onEnd();
  }

  handleCancel(event) {
    const {
      onCancel
    } = this.props;
    event.preventDefault();
    this.detach();
    onCancel();
  }

  detach() {
    this.listeners.removeAll();
    this.windowListeners.removeAll();
  }

}
KeyboardSensor.activators = [{
  eventName: 'onKeyDown',
  handler: (event, _ref, _ref2) => {
    let {
      keyboardCodes = defaultKeyboardCodes,
      onActivation
    } = _ref;
    let {
      active
    } = _ref2;
    const {
      code
    } = event.nativeEvent;

    if (keyboardCodes.start.includes(code)) {
      const activator = active.activatorNode.current;

      if (activator && event.target !== activator) {
        return false;
      }

      event.preventDefault();
      onActivation == null ? void 0 : onActivation({
        event: event.nativeEvent
      });
      return true;
    }

    return false;
  }
}];

function isDistanceConstraint(constraint) {
  return Boolean(constraint && 'distance' in constraint);
}

function isDelayConstraint(constraint) {
  return Boolean(constraint && 'delay' in constraint);
}

class AbstractPointerSensor {
  constructor(props, events, listenerTarget) {
    var _getEventCoordinates;

    if (listenerTarget === void 0) {
      listenerTarget = getEventListenerTarget(props.event.target);
    }

    this.props = void 0;
    this.events = void 0;
    this.autoScrollEnabled = true;
    this.document = void 0;
    this.activated = false;
    this.initialCoordinates = void 0;
    this.timeoutId = null;
    this.listeners = void 0;
    this.documentListeners = void 0;
    this.windowListeners = void 0;
    this.props = props;
    this.events = events;
    const {
      event
    } = props;
    const {
      target
    } = event;
    this.props = props;
    this.events = events;
    this.document = getOwnerDocument(target);
    this.documentListeners = new Listeners(this.document);
    this.listeners = new Listeners(listenerTarget);
    this.windowListeners = new Listeners(getWindow(target));
    this.initialCoordinates = (_getEventCoordinates = getEventCoordinates(event)) != null ? _getEventCoordinates : defaultCoordinates;
    this.handleStart = this.handleStart.bind(this);
    this.handleMove = this.handleMove.bind(this);
    this.handleEnd = this.handleEnd.bind(this);
    this.handleCancel = this.handleCancel.bind(this);
    this.handleKeydown = this.handleKeydown.bind(this);
    this.removeTextSelection = this.removeTextSelection.bind(this);
    this.attach();
  }

  attach() {
    const {
      events,
      props: {
        options: {
          activationConstraint,
          bypassActivationConstraint
        }
      }
    } = this;
    this.listeners.add(events.move.name, this.handleMove, {
      passive: false
    });
    this.listeners.add(events.end.name, this.handleEnd);

    if (events.cancel) {
      this.listeners.add(events.cancel.name, this.handleCancel);
    }

    this.windowListeners.add(EventName.Resize, this.handleCancel);
    this.windowListeners.add(EventName.DragStart, preventDefault);
    this.windowListeners.add(EventName.VisibilityChange, this.handleCancel);
    this.windowListeners.add(EventName.ContextMenu, preventDefault);
    this.documentListeners.add(EventName.Keydown, this.handleKeydown);

    if (activationConstraint) {
      if (bypassActivationConstraint != null && bypassActivationConstraint({
        event: this.props.event,
        activeNode: this.props.activeNode,
        options: this.props.options
      })) {
        return this.handleStart();
      }

      if (isDelayConstraint(activationConstraint)) {
        this.timeoutId = setTimeout(this.handleStart, activationConstraint.delay);
        this.handlePending(activationConstraint);
        return;
      }

      if (isDistanceConstraint(activationConstraint)) {
        this.handlePending(activationConstraint);
        return;
      }
    }

    this.handleStart();
  }

  detach() {
    this.listeners.removeAll();
    this.windowListeners.removeAll(); // Wait until the next event loop before removing document listeners
    // This is necessary because we listen for `click` and `selection` events on the document

    setTimeout(this.documentListeners.removeAll, 50);

    if (this.timeoutId !== null) {
      clearTimeout(this.timeoutId);
      this.timeoutId = null;
    }
  }

  handlePending(constraint, offset) {
    const {
      active,
      onPending
    } = this.props;
    onPending(active, constraint, this.initialCoordinates, offset);
  }

  handleStart() {
    const {
      initialCoordinates
    } = this;
    const {
      onStart
    } = this.props;

    if (initialCoordinates) {
      this.activated = true; // Stop propagation of click events once activation constraints are met

      this.documentListeners.add(EventName.Click, stopPropagation, {
        capture: true
      }); // Remove any text selection from the document

      this.removeTextSelection(); // Prevent further text selection while dragging

      this.documentListeners.add(EventName.SelectionChange, this.removeTextSelection);
      onStart(initialCoordinates);
    }
  }

  handleMove(event) {
    var _getEventCoordinates2;

    const {
      activated,
      initialCoordinates,
      props
    } = this;
    const {
      onMove,
      options: {
        activationConstraint
      }
    } = props;

    if (!initialCoordinates) {
      return;
    }

    const coordinates = (_getEventCoordinates2 = getEventCoordinates(event)) != null ? _getEventCoordinates2 : defaultCoordinates;
    const delta = subtract(initialCoordinates, coordinates); // Constraint validation

    if (!activated && activationConstraint) {
      if (isDistanceConstraint(activationConstraint)) {
        if (activationConstraint.tolerance != null && hasExceededDistance(delta, activationConstraint.tolerance)) {
          return this.handleCancel();
        }

        if (hasExceededDistance(delta, activationConstraint.distance)) {
          return this.handleStart();
        }
      }

      if (isDelayConstraint(activationConstraint)) {
        if (hasExceededDistance(delta, activationConstraint.tolerance)) {
          return this.handleCancel();
        }
      }

      this.handlePending(activationConstraint, delta);
      return;
    }

    if (event.cancelable) {
      event.preventDefault();
    }

    onMove(coordinates);
  }

  handleEnd() {
    const {
      onAbort,
      onEnd
    } = this.props;
    this.detach();

    if (!this.activated) {
      onAbort(this.props.active);
    }

    onEnd();
  }

  handleCancel() {
    const {
      onAbort,
      onCancel
    } = this.props;
    this.detach();

    if (!this.activated) {
      onAbort(this.props.active);
    }

    onCancel();
  }

  handleKeydown(event) {
    if (event.code === KeyboardCode.Esc) {
      this.handleCancel();
    }
  }

  removeTextSelection() {
    var _this$document$getSel;

    (_this$document$getSel = this.document.getSelection()) == null ? void 0 : _this$document$getSel.removeAllRanges();
  }

}

const events = {
  cancel: {
    name: 'pointercancel'
  },
  move: {
    name: 'pointermove'
  },
  end: {
    name: 'pointerup'
  }
};
class PointerSensor extends AbstractPointerSensor {
  constructor(props) {
    const {
      event
    } = props; // Pointer events stop firing if the target is unmounted while dragging
    // Therefore we attach listeners to the owner document instead

    const listenerTarget = getOwnerDocument(event.target);
    super(props, events, listenerTarget);
  }

}
PointerSensor.activators = [{
  eventName: 'onPointerDown',
  handler: (_ref, _ref2) => {
    let {
      nativeEvent: event
    } = _ref;
    let {
      onActivation
    } = _ref2;

    if (!event.isPrimary || event.button !== 0) {
      return false;
    }

    onActivation == null ? void 0 : onActivation({
      event
    });
    return true;
  }
}];

const events$1 = {
  move: {
    name: 'mousemove'
  },
  end: {
    name: 'mouseup'
  }
};
var MouseButton;

(function (MouseButton) {
  MouseButton[MouseButton["RightClick"] = 2] = "RightClick";
})(MouseButton || (MouseButton = {}));

class MouseSensor extends AbstractPointerSensor {
  constructor(props) {
    super(props, events$1, getOwnerDocument(props.event.target));
  }

}
MouseSensor.activators = [{
  eventName: 'onMouseDown',
  handler: (_ref, _ref2) => {
    let {
      nativeEvent: event
    } = _ref;
    let {
      onActivation
    } = _ref2;

    if (event.button === MouseButton.RightClick) {
      return false;
    }

    onActivation == null ? void 0 : onActivation({
      event
    });
    return true;
  }
}];

const events$2 = {
  cancel: {
    name: 'touchcancel'
  },
  move: {
    name: 'touchmove'
  },
  end: {
    name: 'touchend'
  }
};
class TouchSensor extends AbstractPointerSensor {
  constructor(props) {
    super(props, events$2);
  }

  static setup() {
    // Adding a non-capture and non-passive `touchmove` listener in order
    // to force `event.preventDefault()` calls to work in dynamically added
    // touchmove event handlers. This is required for iOS Safari.
    window.addEventListener(events$2.move.name, noop, {
      capture: false,
      passive: false
    });
    return function teardown() {
      window.removeEventListener(events$2.move.name, noop);
    }; // We create a new handler because the teardown function of another sensor
    // could remove our event listener if we use a referentially equal listener.

    function noop() {}
  }

}
TouchSensor.activators = [{
  eventName: 'onTouchStart',
  handler: (_ref, _ref2) => {
    let {
      nativeEvent: event
    } = _ref;
    let {
      onActivation
    } = _ref2;
    const {
      touches
    } = event;

    if (touches.length > 1) {
      return false;
    }

    onActivation == null ? void 0 : onActivation({
      event
    });
    return true;
  }
}];

var AutoScrollActivator;

(function (AutoScrollActivator) {
  AutoScrollActivator[AutoScrollActivator["Pointer"] = 0] = "Pointer";
  AutoScrollActivator[AutoScrollActivator["DraggableRect"] = 1] = "DraggableRect";
})(AutoScrollActivator || (AutoScrollActivator = {}));

var TraversalOrder;

(function (TraversalOrder) {
  TraversalOrder[TraversalOrder["TreeOrder"] = 0] = "TreeOrder";
  TraversalOrder[TraversalOrder["ReversedTreeOrder"] = 1] = "ReversedTreeOrder";
})(TraversalOrder || (TraversalOrder = {}));

function useAutoScroller(_ref) {
  let {
    acceleration,
    activator = AutoScrollActivator.Pointer,
    canScroll,
    draggingRect,
    enabled,
    interval = 5,
    order = TraversalOrder.TreeOrder,
    pointerCoordinates,
    scrollableAncestors,
    scrollableAncestorRects,
    delta,
    threshold
  } = _ref;
  const scrollIntent = useScrollIntent({
    delta,
    disabled: !enabled
  });
  const [setAutoScrollInterval, clearAutoScrollInterval] = useInterval();
  const scrollSpeed = reactExports.useRef({
    x: 0,
    y: 0
  });
  const scrollDirection = reactExports.useRef({
    x: 0,
    y: 0
  });
  const rect = reactExports.useMemo(() => {
    switch (activator) {
      case AutoScrollActivator.Pointer:
        return pointerCoordinates ? {
          top: pointerCoordinates.y,
          bottom: pointerCoordinates.y,
          left: pointerCoordinates.x,
          right: pointerCoordinates.x
        } : null;

      case AutoScrollActivator.DraggableRect:
        return draggingRect;
    }
  }, [activator, draggingRect, pointerCoordinates]);
  const scrollContainerRef = reactExports.useRef(null);
  const autoScroll = reactExports.useCallback(() => {
    const scrollContainer = scrollContainerRef.current;

    if (!scrollContainer) {
      return;
    }

    const scrollLeft = scrollSpeed.current.x * scrollDirection.current.x;
    const scrollTop = scrollSpeed.current.y * scrollDirection.current.y;
    scrollContainer.scrollBy(scrollLeft, scrollTop);
  }, []);
  const sortedScrollableAncestors = reactExports.useMemo(() => order === TraversalOrder.TreeOrder ? [...scrollableAncestors].reverse() : scrollableAncestors, [order, scrollableAncestors]);
  reactExports.useEffect(() => {
    if (!enabled || !scrollableAncestors.length || !rect) {
      clearAutoScrollInterval();
      return;
    }

    for (const scrollContainer of sortedScrollableAncestors) {
      if ((canScroll == null ? void 0 : canScroll(scrollContainer)) === false) {
        continue;
      }

      const index = scrollableAncestors.indexOf(scrollContainer);
      const scrollContainerRect = scrollableAncestorRects[index];

      if (!scrollContainerRect) {
        continue;
      }

      const {
        direction,
        speed
      } = getScrollDirectionAndSpeed(scrollContainer, scrollContainerRect, rect, acceleration, threshold);

      for (const axis of ['x', 'y']) {
        if (!scrollIntent[axis][direction[axis]]) {
          speed[axis] = 0;
          direction[axis] = 0;
        }
      }

      if (speed.x > 0 || speed.y > 0) {
        clearAutoScrollInterval();
        scrollContainerRef.current = scrollContainer;
        setAutoScrollInterval(autoScroll, interval);
        scrollSpeed.current = speed;
        scrollDirection.current = direction;
        return;
      }
    }

    scrollSpeed.current = {
      x: 0,
      y: 0
    };
    scrollDirection.current = {
      x: 0,
      y: 0
    };
    clearAutoScrollInterval();
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [acceleration, autoScroll, canScroll, clearAutoScrollInterval, enabled, interval, // eslint-disable-next-line react-hooks/exhaustive-deps
  JSON.stringify(rect), // eslint-disable-next-line react-hooks/exhaustive-deps
  JSON.stringify(scrollIntent), setAutoScrollInterval, scrollableAncestors, sortedScrollableAncestors, scrollableAncestorRects, // eslint-disable-next-line react-hooks/exhaustive-deps
  JSON.stringify(threshold)]);
}
const defaultScrollIntent = {
  x: {
    [Direction.Backward]: false,
    [Direction.Forward]: false
  },
  y: {
    [Direction.Backward]: false,
    [Direction.Forward]: false
  }
};

function useScrollIntent(_ref2) {
  let {
    delta,
    disabled
  } = _ref2;
  const previousDelta = usePrevious(delta);
  return useLazyMemo(previousIntent => {
    if (disabled || !previousDelta || !previousIntent) {
      // Reset scroll intent tracking when auto-scrolling is disabled
      return defaultScrollIntent;
    }

    const direction = {
      x: Math.sign(delta.x - previousDelta.x),
      y: Math.sign(delta.y - previousDelta.y)
    }; // Keep track of the user intent to scroll in each direction for both axis

    return {
      x: {
        [Direction.Backward]: previousIntent.x[Direction.Backward] || direction.x === -1,
        [Direction.Forward]: previousIntent.x[Direction.Forward] || direction.x === 1
      },
      y: {
        [Direction.Backward]: previousIntent.y[Direction.Backward] || direction.y === -1,
        [Direction.Forward]: previousIntent.y[Direction.Forward] || direction.y === 1
      }
    };
  }, [disabled, delta, previousDelta]);
}

function useCachedNode(draggableNodes, id) {
  const draggableNode = id != null ? draggableNodes.get(id) : undefined;
  const node = draggableNode ? draggableNode.node.current : null;
  return useLazyMemo(cachedNode => {
    var _ref;

    if (id == null) {
      return null;
    } // In some cases, the draggable node can unmount while dragging
    // This is the case for virtualized lists. In those situations,
    // we fall back to the last known value for that node.


    return (_ref = node != null ? node : cachedNode) != null ? _ref : null;
  }, [node, id]);
}

function useCombineActivators(sensors, getSyntheticHandler) {
  return reactExports.useMemo(() => sensors.reduce((accumulator, sensor) => {
    const {
      sensor: Sensor
    } = sensor;
    const sensorActivators = Sensor.activators.map(activator => ({
      eventName: activator.eventName,
      handler: getSyntheticHandler(activator.handler, sensor)
    }));
    return [...accumulator, ...sensorActivators];
  }, []), [sensors, getSyntheticHandler]);
}

var MeasuringStrategy;

(function (MeasuringStrategy) {
  MeasuringStrategy[MeasuringStrategy["Always"] = 0] = "Always";
  MeasuringStrategy[MeasuringStrategy["BeforeDragging"] = 1] = "BeforeDragging";
  MeasuringStrategy[MeasuringStrategy["WhileDragging"] = 2] = "WhileDragging";
})(MeasuringStrategy || (MeasuringStrategy = {}));

var MeasuringFrequency;

(function (MeasuringFrequency) {
  MeasuringFrequency["Optimized"] = "optimized";
})(MeasuringFrequency || (MeasuringFrequency = {}));

const defaultValue = /*#__PURE__*/new Map();
function useDroppableMeasuring(containers, _ref) {
  let {
    dragging,
    dependencies,
    config
  } = _ref;
  const [queue, setQueue] = reactExports.useState(null);
  const {
    frequency,
    measure,
    strategy
  } = config;
  const containersRef = reactExports.useRef(containers);
  const disabled = isDisabled();
  const disabledRef = useLatestValue(disabled);
  const measureDroppableContainers = reactExports.useCallback(function (ids) {
    if (ids === void 0) {
      ids = [];
    }

    if (disabledRef.current) {
      return;
    }

    setQueue(value => {
      if (value === null) {
        return ids;
      }

      return value.concat(ids.filter(id => !value.includes(id)));
    });
  }, [disabledRef]);
  const timeoutId = reactExports.useRef(null);
  const droppableRects = useLazyMemo(previousValue => {
    if (disabled && !dragging) {
      return defaultValue;
    }

    if (!previousValue || previousValue === defaultValue || containersRef.current !== containers || queue != null) {
      const map = new Map();

      for (let container of containers) {
        if (!container) {
          continue;
        }

        if (queue && queue.length > 0 && !queue.includes(container.id) && container.rect.current) {
          // This container does not need to be re-measured
          map.set(container.id, container.rect.current);
          continue;
        }

        const node = container.node.current;
        const rect = node ? new Rect(measure(node), node) : null;
        container.rect.current = rect;

        if (rect) {
          map.set(container.id, rect);
        }
      }

      return map;
    }

    return previousValue;
  }, [containers, queue, dragging, disabled, measure]);
  reactExports.useEffect(() => {
    containersRef.current = containers;
  }, [containers]);
  reactExports.useEffect(() => {
    if (disabled) {
      return;
    }

    measureDroppableContainers();
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [dragging, disabled]);
  reactExports.useEffect(() => {
    if (queue && queue.length > 0) {
      setQueue(null);
    }
  }, //eslint-disable-next-line react-hooks/exhaustive-deps
  [JSON.stringify(queue)]);
  reactExports.useEffect(() => {
    if (disabled || typeof frequency !== 'number' || timeoutId.current !== null) {
      return;
    }

    timeoutId.current = setTimeout(() => {
      measureDroppableContainers();
      timeoutId.current = null;
    }, frequency);
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [frequency, disabled, measureDroppableContainers, ...dependencies]);
  return {
    droppableRects,
    measureDroppableContainers,
    measuringScheduled: queue != null
  };

  function isDisabled() {
    switch (strategy) {
      case MeasuringStrategy.Always:
        return false;

      case MeasuringStrategy.BeforeDragging:
        return dragging;

      default:
        return !dragging;
    }
  }
}

function useInitialValue(value, computeFn) {
  return useLazyMemo(previousValue => {
    if (!value) {
      return null;
    }

    if (previousValue) {
      return previousValue;
    }

    return typeof computeFn === 'function' ? computeFn(value) : value;
  }, [computeFn, value]);
}

function useInitialRect(node, measure) {
  return useInitialValue(node, measure);
}

/**
 * Returns a new MutationObserver instance.
 * If `MutationObserver` is undefined in the execution environment, returns `undefined`.
 */

function useMutationObserver(_ref) {
  let {
    callback,
    disabled
  } = _ref;
  const handleMutations = useEvent(callback);
  const mutationObserver = reactExports.useMemo(() => {
    if (disabled || typeof window === 'undefined' || typeof window.MutationObserver === 'undefined') {
      return undefined;
    }

    const {
      MutationObserver
    } = window;
    return new MutationObserver(handleMutations);
  }, [handleMutations, disabled]);
  reactExports.useEffect(() => {
    return () => mutationObserver == null ? void 0 : mutationObserver.disconnect();
  }, [mutationObserver]);
  return mutationObserver;
}

/**
 * Returns a new ResizeObserver instance bound to the `onResize` callback.
 * If `ResizeObserver` is undefined in the execution environment, returns `undefined`.
 */

function useResizeObserver(_ref) {
  let {
    callback,
    disabled
  } = _ref;
  const handleResize = useEvent(callback);
  const resizeObserver = reactExports.useMemo(() => {
    if (disabled || typeof window === 'undefined' || typeof window.ResizeObserver === 'undefined') {
      return undefined;
    }

    const {
      ResizeObserver
    } = window;
    return new ResizeObserver(handleResize);
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [disabled]);
  reactExports.useEffect(() => {
    return () => resizeObserver == null ? void 0 : resizeObserver.disconnect();
  }, [resizeObserver]);
  return resizeObserver;
}

function defaultMeasure(element) {
  return new Rect(getClientRect(element), element);
}

function useRect(element, measure, fallbackRect) {
  if (measure === void 0) {
    measure = defaultMeasure;
  }

  const [rect, setRect] = reactExports.useState(null);

  function measureRect() {
    setRect(currentRect => {
      if (!element) {
        return null;
      }

      if (element.isConnected === false) {
        var _ref;

        // Fall back to last rect we measured if the element is
        // no longer connected to the DOM.
        return (_ref = currentRect != null ? currentRect : fallbackRect) != null ? _ref : null;
      }

      const newRect = measure(element);

      if (JSON.stringify(currentRect) === JSON.stringify(newRect)) {
        return currentRect;
      }

      return newRect;
    });
  }

  const mutationObserver = useMutationObserver({
    callback(records) {
      if (!element) {
        return;
      }

      for (const record of records) {
        const {
          type,
          target
        } = record;

        if (type === 'childList' && target instanceof HTMLElement && target.contains(element)) {
          measureRect();
          break;
        }
      }
    }

  });
  const resizeObserver = useResizeObserver({
    callback: measureRect
  });
  useIsomorphicLayoutEffect(() => {
    measureRect();

    if (element) {
      resizeObserver == null ? void 0 : resizeObserver.observe(element);
      mutationObserver == null ? void 0 : mutationObserver.observe(document.body, {
        childList: true,
        subtree: true
      });
    } else {
      resizeObserver == null ? void 0 : resizeObserver.disconnect();
      mutationObserver == null ? void 0 : mutationObserver.disconnect();
    }
  }, [element]);
  return rect;
}

function useRectDelta(rect) {
  const initialRect = useInitialValue(rect);
  return getRectDelta(rect, initialRect);
}

const defaultValue$1 = [];
function useScrollableAncestors(node) {
  const previousNode = reactExports.useRef(node);
  const ancestors = useLazyMemo(previousValue => {
    if (!node) {
      return defaultValue$1;
    }

    if (previousValue && previousValue !== defaultValue$1 && node && previousNode.current && node.parentNode === previousNode.current.parentNode) {
      return previousValue;
    }

    return getScrollableAncestors(node);
  }, [node]);
  reactExports.useEffect(() => {
    previousNode.current = node;
  }, [node]);
  return ancestors;
}

function useScrollOffsets(elements) {
  const [scrollCoordinates, setScrollCoordinates] = reactExports.useState(null);
  const prevElements = reactExports.useRef(elements); // To-do: Throttle the handleScroll callback

  const handleScroll = reactExports.useCallback(event => {
    const scrollingElement = getScrollableElement(event.target);

    if (!scrollingElement) {
      return;
    }

    setScrollCoordinates(scrollCoordinates => {
      if (!scrollCoordinates) {
        return null;
      }

      scrollCoordinates.set(scrollingElement, getScrollCoordinates(scrollingElement));
      return new Map(scrollCoordinates);
    });
  }, []);
  reactExports.useEffect(() => {
    const previousElements = prevElements.current;

    if (elements !== previousElements) {
      cleanup(previousElements);
      const entries = elements.map(element => {
        const scrollableElement = getScrollableElement(element);

        if (scrollableElement) {
          scrollableElement.addEventListener('scroll', handleScroll, {
            passive: true
          });
          return [scrollableElement, getScrollCoordinates(scrollableElement)];
        }

        return null;
      }).filter(entry => entry != null);
      setScrollCoordinates(entries.length ? new Map(entries) : null);
      prevElements.current = elements;
    }

    return () => {
      cleanup(elements);
      cleanup(previousElements);
    };

    function cleanup(elements) {
      elements.forEach(element => {
        const scrollableElement = getScrollableElement(element);
        scrollableElement == null ? void 0 : scrollableElement.removeEventListener('scroll', handleScroll);
      });
    }
  }, [handleScroll, elements]);
  return reactExports.useMemo(() => {
    if (elements.length) {
      return scrollCoordinates ? Array.from(scrollCoordinates.values()).reduce((acc, coordinates) => add(acc, coordinates), defaultCoordinates) : getScrollOffsets(elements);
    }

    return defaultCoordinates;
  }, [elements, scrollCoordinates]);
}

function useScrollOffsetsDelta(scrollOffsets, dependencies) {
  if (dependencies === void 0) {
    dependencies = [];
  }

  const initialScrollOffsets = reactExports.useRef(null);
  reactExports.useEffect(() => {
    initialScrollOffsets.current = null;
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  dependencies);
  reactExports.useEffect(() => {
    const hasScrollOffsets = scrollOffsets !== defaultCoordinates;

    if (hasScrollOffsets && !initialScrollOffsets.current) {
      initialScrollOffsets.current = scrollOffsets;
    }

    if (!hasScrollOffsets && initialScrollOffsets.current) {
      initialScrollOffsets.current = null;
    }
  }, [scrollOffsets]);
  return initialScrollOffsets.current ? subtract(scrollOffsets, initialScrollOffsets.current) : defaultCoordinates;
}

function useSensorSetup(sensors) {
  reactExports.useEffect(() => {
    if (!canUseDOM) {
      return;
    }

    const teardownFns = sensors.map(_ref => {
      let {
        sensor
      } = _ref;
      return sensor.setup == null ? void 0 : sensor.setup();
    });
    return () => {
      for (const teardown of teardownFns) {
        teardown == null ? void 0 : teardown();
      }
    };
  }, // TO-DO: Sensors length could theoretically change which would not be a valid dependency
  // eslint-disable-next-line react-hooks/exhaustive-deps
  sensors.map(_ref2 => {
    let {
      sensor
    } = _ref2;
    return sensor;
  }));
}

function useSyntheticListeners(listeners, id) {
  return reactExports.useMemo(() => {
    return listeners.reduce((acc, _ref) => {
      let {
        eventName,
        handler
      } = _ref;

      acc[eventName] = event => {
        handler(event, id);
      };

      return acc;
    }, {});
  }, [listeners, id]);
}

function useWindowRect(element) {
  return reactExports.useMemo(() => element ? getWindowClientRect(element) : null, [element]);
}

const defaultValue$2 = [];
function useRects(elements, measure) {
  if (measure === void 0) {
    measure = getClientRect;
  }

  const [firstElement] = elements;
  const windowRect = useWindowRect(firstElement ? getWindow(firstElement) : null);
  const [rects, setRects] = reactExports.useState(defaultValue$2);

  function measureRects() {
    setRects(() => {
      if (!elements.length) {
        return defaultValue$2;
      }

      return elements.map(element => isDocumentScrollingElement(element) ? windowRect : new Rect(measure(element), element));
    });
  }

  const resizeObserver = useResizeObserver({
    callback: measureRects
  });
  useIsomorphicLayoutEffect(() => {
    resizeObserver == null ? void 0 : resizeObserver.disconnect();
    measureRects();
    elements.forEach(element => resizeObserver == null ? void 0 : resizeObserver.observe(element));
  }, [elements]);
  return rects;
}

function getMeasurableNode(node) {
  if (!node) {
    return null;
  }

  if (node.children.length > 1) {
    return node;
  }

  const firstChild = node.children[0];
  return isHTMLElement(firstChild) ? firstChild : node;
}

function useDragOverlayMeasuring(_ref) {
  let {
    measure
  } = _ref;
  const [rect, setRect] = reactExports.useState(null);
  const handleResize = reactExports.useCallback(entries => {
    for (const {
      target
    } of entries) {
      if (isHTMLElement(target)) {
        setRect(rect => {
          const newRect = measure(target);
          return rect ? { ...rect,
            width: newRect.width,
            height: newRect.height
          } : newRect;
        });
        break;
      }
    }
  }, [measure]);
  const resizeObserver = useResizeObserver({
    callback: handleResize
  });
  const handleNodeChange = reactExports.useCallback(element => {
    const node = getMeasurableNode(element);
    resizeObserver == null ? void 0 : resizeObserver.disconnect();

    if (node) {
      resizeObserver == null ? void 0 : resizeObserver.observe(node);
    }

    setRect(node ? measure(node) : null);
  }, [measure, resizeObserver]);
  const [nodeRef, setRef] = useNodeRef(handleNodeChange);
  return reactExports.useMemo(() => ({
    nodeRef,
    rect,
    setRef
  }), [rect, nodeRef, setRef]);
}

const defaultSensors = [{
  sensor: PointerSensor,
  options: {}
}, {
  sensor: KeyboardSensor,
  options: {}
}];
const defaultData = {
  current: {}
};
const defaultMeasuringConfiguration = {
  draggable: {
    measure: getTransformAgnosticClientRect
  },
  droppable: {
    measure: getTransformAgnosticClientRect,
    strategy: MeasuringStrategy.WhileDragging,
    frequency: MeasuringFrequency.Optimized
  },
  dragOverlay: {
    measure: getClientRect
  }
};

class DroppableContainersMap extends Map {
  get(id) {
    var _super$get;

    return id != null ? (_super$get = super.get(id)) != null ? _super$get : undefined : undefined;
  }

  toArray() {
    return Array.from(this.values());
  }

  getEnabled() {
    return this.toArray().filter(_ref => {
      let {
        disabled
      } = _ref;
      return !disabled;
    });
  }

  getNodeFor(id) {
    var _this$get$node$curren, _this$get;

    return (_this$get$node$curren = (_this$get = this.get(id)) == null ? void 0 : _this$get.node.current) != null ? _this$get$node$curren : undefined;
  }

}

const defaultPublicContext = {
  activatorEvent: null,
  active: null,
  activeNode: null,
  activeNodeRect: null,
  collisions: null,
  containerNodeRect: null,
  draggableNodes: /*#__PURE__*/new Map(),
  droppableRects: /*#__PURE__*/new Map(),
  droppableContainers: /*#__PURE__*/new DroppableContainersMap(),
  over: null,
  dragOverlay: {
    nodeRef: {
      current: null
    },
    rect: null,
    setRef: noop
  },
  scrollableAncestors: [],
  scrollableAncestorRects: [],
  measuringConfiguration: defaultMeasuringConfiguration,
  measureDroppableContainers: noop,
  windowRect: null,
  measuringScheduled: false
};
const defaultInternalContext = {
  activatorEvent: null,
  activators: [],
  active: null,
  activeNodeRect: null,
  ariaDescribedById: {
    draggable: ''
  },
  dispatch: noop,
  draggableNodes: /*#__PURE__*/new Map(),
  over: null,
  measureDroppableContainers: noop
};
const InternalContext = /*#__PURE__*/reactExports.createContext(defaultInternalContext);
const PublicContext = /*#__PURE__*/reactExports.createContext(defaultPublicContext);

function getInitialState() {
  return {
    draggable: {
      active: null,
      initialCoordinates: {
        x: 0,
        y: 0
      },
      nodes: new Map(),
      translate: {
        x: 0,
        y: 0
      }
    },
    droppable: {
      containers: new DroppableContainersMap()
    }
  };
}
function reducer$1(state, action) {
  switch (action.type) {
    case Action.DragStart:
      return { ...state,
        draggable: { ...state.draggable,
          initialCoordinates: action.initialCoordinates,
          active: action.active
        }
      };

    case Action.DragMove:
      if (state.draggable.active == null) {
        return state;
      }

      return { ...state,
        draggable: { ...state.draggable,
          translate: {
            x: action.coordinates.x - state.draggable.initialCoordinates.x,
            y: action.coordinates.y - state.draggable.initialCoordinates.y
          }
        }
      };

    case Action.DragEnd:
    case Action.DragCancel:
      return { ...state,
        draggable: { ...state.draggable,
          active: null,
          initialCoordinates: {
            x: 0,
            y: 0
          },
          translate: {
            x: 0,
            y: 0
          }
        }
      };

    case Action.RegisterDroppable:
      {
        const {
          element
        } = action;
        const {
          id
        } = element;
        const containers = new DroppableContainersMap(state.droppable.containers);
        containers.set(id, element);
        return { ...state,
          droppable: { ...state.droppable,
            containers
          }
        };
      }

    case Action.SetDroppableDisabled:
      {
        const {
          id,
          key,
          disabled
        } = action;
        const element = state.droppable.containers.get(id);

        if (!element || key !== element.key) {
          return state;
        }

        const containers = new DroppableContainersMap(state.droppable.containers);
        containers.set(id, { ...element,
          disabled
        });
        return { ...state,
          droppable: { ...state.droppable,
            containers
          }
        };
      }

    case Action.UnregisterDroppable:
      {
        const {
          id,
          key
        } = action;
        const element = state.droppable.containers.get(id);

        if (!element || key !== element.key) {
          return state;
        }

        const containers = new DroppableContainersMap(state.droppable.containers);
        containers.delete(id);
        return { ...state,
          droppable: { ...state.droppable,
            containers
          }
        };
      }

    default:
      {
        return state;
      }
  }
}

function RestoreFocus(_ref) {
  let {
    disabled
  } = _ref;
  const {
    active,
    activatorEvent,
    draggableNodes
  } = reactExports.useContext(InternalContext);
  const previousActivatorEvent = usePrevious(activatorEvent);
  const previousActiveId = usePrevious(active == null ? void 0 : active.id); // Restore keyboard focus on the activator node

  reactExports.useEffect(() => {
    if (disabled) {
      return;
    }

    if (!activatorEvent && previousActivatorEvent && previousActiveId != null) {
      if (!isKeyboardEvent(previousActivatorEvent)) {
        return;
      }

      if (document.activeElement === previousActivatorEvent.target) {
        // No need to restore focus
        return;
      }

      const draggableNode = draggableNodes.get(previousActiveId);

      if (!draggableNode) {
        return;
      }

      const {
        activatorNode,
        node
      } = draggableNode;

      if (!activatorNode.current && !node.current) {
        return;
      }

      requestAnimationFrame(() => {
        for (const element of [activatorNode.current, node.current]) {
          if (!element) {
            continue;
          }

          const focusableNode = findFirstFocusableNode(element);

          if (focusableNode) {
            focusableNode.focus();
            break;
          }
        }
      });
    }
  }, [activatorEvent, disabled, draggableNodes, previousActiveId, previousActivatorEvent]);
  return null;
}

function applyModifiers(modifiers, _ref) {
  let {
    transform,
    ...args
  } = _ref;
  return modifiers != null && modifiers.length ? modifiers.reduce((accumulator, modifier) => {
    return modifier({
      transform: accumulator,
      ...args
    });
  }, transform) : transform;
}

function useMeasuringConfiguration(config) {
  return reactExports.useMemo(() => ({
    draggable: { ...defaultMeasuringConfiguration.draggable,
      ...(config == null ? void 0 : config.draggable)
    },
    droppable: { ...defaultMeasuringConfiguration.droppable,
      ...(config == null ? void 0 : config.droppable)
    },
    dragOverlay: { ...defaultMeasuringConfiguration.dragOverlay,
      ...(config == null ? void 0 : config.dragOverlay)
    }
  }), // eslint-disable-next-line react-hooks/exhaustive-deps
  [config == null ? void 0 : config.draggable, config == null ? void 0 : config.droppable, config == null ? void 0 : config.dragOverlay]);
}

function useLayoutShiftScrollCompensation(_ref) {
  let {
    activeNode,
    measure,
    initialRect,
    config = true
  } = _ref;
  const initialized = reactExports.useRef(false);
  const {
    x,
    y
  } = typeof config === 'boolean' ? {
    x: config,
    y: config
  } : config;
  useIsomorphicLayoutEffect(() => {
    const disabled = !x && !y;

    if (disabled || !activeNode) {
      initialized.current = false;
      return;
    }

    if (initialized.current || !initialRect) {
      // Return early if layout shift scroll compensation was already attempted
      // or if there is no initialRect to compare to.
      return;
    } // Get the most up to date node ref for the active draggable


    const node = activeNode == null ? void 0 : activeNode.node.current;

    if (!node || node.isConnected === false) {
      // Return early if there is no attached node ref or if the node is
      // disconnected from the document.
      return;
    }

    const rect = measure(node);
    const rectDelta = getRectDelta(rect, initialRect);

    if (!x) {
      rectDelta.x = 0;
    }

    if (!y) {
      rectDelta.y = 0;
    } // Only perform layout shift scroll compensation once


    initialized.current = true;

    if (Math.abs(rectDelta.x) > 0 || Math.abs(rectDelta.y) > 0) {
      const firstScrollableAncestor = getFirstScrollableAncestor(node);

      if (firstScrollableAncestor) {
        firstScrollableAncestor.scrollBy({
          top: rectDelta.y,
          left: rectDelta.x
        });
      }
    }
  }, [activeNode, x, y, initialRect, measure]);
}

const ActiveDraggableContext = /*#__PURE__*/reactExports.createContext({ ...defaultCoordinates,
  scaleX: 1,
  scaleY: 1
});
var Status;

(function (Status) {
  Status[Status["Uninitialized"] = 0] = "Uninitialized";
  Status[Status["Initializing"] = 1] = "Initializing";
  Status[Status["Initialized"] = 2] = "Initialized";
})(Status || (Status = {}));

const DndContext = /*#__PURE__*/reactExports.memo(function DndContext(_ref) {
  var _sensorContext$curren, _dragOverlay$nodeRef$, _dragOverlay$rect, _over$rect;

  let {
    id,
    accessibility,
    autoScroll = true,
    children,
    sensors = defaultSensors,
    collisionDetection = rectIntersection,
    measuring,
    modifiers,
    ...props
  } = _ref;
  const store = reactExports.useReducer(reducer$1, undefined, getInitialState);
  const [state, dispatch] = store;
  const [dispatchMonitorEvent, registerMonitorListener] = useDndMonitorProvider();
  const [status, setStatus] = reactExports.useState(Status.Uninitialized);
  const isInitialized = status === Status.Initialized;
  const {
    draggable: {
      active: activeId,
      nodes: draggableNodes,
      translate
    },
    droppable: {
      containers: droppableContainers
    }
  } = state;
  const node = activeId != null ? draggableNodes.get(activeId) : null;
  const activeRects = reactExports.useRef({
    initial: null,
    translated: null
  });
  const active = reactExports.useMemo(() => {
    var _node$data;

    return activeId != null ? {
      id: activeId,
      // It's possible for the active node to unmount while dragging
      data: (_node$data = node == null ? void 0 : node.data) != null ? _node$data : defaultData,
      rect: activeRects
    } : null;
  }, [activeId, node]);
  const activeRef = reactExports.useRef(null);
  const [activeSensor, setActiveSensor] = reactExports.useState(null);
  const [activatorEvent, setActivatorEvent] = reactExports.useState(null);
  const latestProps = useLatestValue(props, Object.values(props));
  const draggableDescribedById = useUniqueId("DndDescribedBy", id);
  const enabledDroppableContainers = reactExports.useMemo(() => droppableContainers.getEnabled(), [droppableContainers]);
  const measuringConfiguration = useMeasuringConfiguration(measuring);
  const {
    droppableRects,
    measureDroppableContainers,
    measuringScheduled
  } = useDroppableMeasuring(enabledDroppableContainers, {
    dragging: isInitialized,
    dependencies: [translate.x, translate.y],
    config: measuringConfiguration.droppable
  });
  const activeNode = useCachedNode(draggableNodes, activeId);
  const activationCoordinates = reactExports.useMemo(() => activatorEvent ? getEventCoordinates(activatorEvent) : null, [activatorEvent]);
  const autoScrollOptions = getAutoScrollerOptions();
  const initialActiveNodeRect = useInitialRect(activeNode, measuringConfiguration.draggable.measure);
  useLayoutShiftScrollCompensation({
    activeNode: activeId != null ? draggableNodes.get(activeId) : null,
    config: autoScrollOptions.layoutShiftCompensation,
    initialRect: initialActiveNodeRect,
    measure: measuringConfiguration.draggable.measure
  });
  const activeNodeRect = useRect(activeNode, measuringConfiguration.draggable.measure, initialActiveNodeRect);
  const containerNodeRect = useRect(activeNode ? activeNode.parentElement : null);
  const sensorContext = reactExports.useRef({
    activatorEvent: null,
    active: null,
    activeNode,
    collisionRect: null,
    collisions: null,
    droppableRects,
    draggableNodes,
    draggingNode: null,
    draggingNodeRect: null,
    droppableContainers,
    over: null,
    scrollableAncestors: [],
    scrollAdjustedTranslate: null
  });
  const overNode = droppableContainers.getNodeFor((_sensorContext$curren = sensorContext.current.over) == null ? void 0 : _sensorContext$curren.id);
  const dragOverlay = useDragOverlayMeasuring({
    measure: measuringConfiguration.dragOverlay.measure
  }); // Use the rect of the drag overlay if it is mounted

  const draggingNode = (_dragOverlay$nodeRef$ = dragOverlay.nodeRef.current) != null ? _dragOverlay$nodeRef$ : activeNode;
  const draggingNodeRect = isInitialized ? (_dragOverlay$rect = dragOverlay.rect) != null ? _dragOverlay$rect : activeNodeRect : null;
  const usesDragOverlay = Boolean(dragOverlay.nodeRef.current && dragOverlay.rect); // The delta between the previous and new position of the draggable node
  // is only relevant when there is no drag overlay

  const nodeRectDelta = useRectDelta(usesDragOverlay ? null : activeNodeRect); // Get the window rect of the dragging node

  const windowRect = useWindowRect(draggingNode ? getWindow(draggingNode) : null); // Get scrollable ancestors of the dragging node

  const scrollableAncestors = useScrollableAncestors(isInitialized ? overNode != null ? overNode : activeNode : null);
  const scrollableAncestorRects = useRects(scrollableAncestors); // Apply modifiers

  const modifiedTranslate = applyModifiers(modifiers, {
    transform: {
      x: translate.x - nodeRectDelta.x,
      y: translate.y - nodeRectDelta.y,
      scaleX: 1,
      scaleY: 1
    },
    activatorEvent,
    active,
    activeNodeRect,
    containerNodeRect,
    draggingNodeRect,
    over: sensorContext.current.over,
    overlayNodeRect: dragOverlay.rect,
    scrollableAncestors,
    scrollableAncestorRects,
    windowRect
  });
  const pointerCoordinates = activationCoordinates ? add(activationCoordinates, translate) : null;
  const scrollOffsets = useScrollOffsets(scrollableAncestors); // Represents the scroll delta since dragging was initiated

  const scrollAdjustment = useScrollOffsetsDelta(scrollOffsets); // Represents the scroll delta since the last time the active node rect was measured

  const activeNodeScrollDelta = useScrollOffsetsDelta(scrollOffsets, [activeNodeRect]);
  const scrollAdjustedTranslate = add(modifiedTranslate, scrollAdjustment);
  const collisionRect = draggingNodeRect ? getAdjustedRect(draggingNodeRect, modifiedTranslate) : null;
  const collisions = active && collisionRect ? collisionDetection({
    active,
    collisionRect,
    droppableRects,
    droppableContainers: enabledDroppableContainers,
    pointerCoordinates
  }) : null;
  const overId = getFirstCollision(collisions, 'id');
  const [over, setOver] = reactExports.useState(null); // When there is no drag overlay used, we need to account for the
  // window scroll delta

  const appliedTranslate = usesDragOverlay ? modifiedTranslate : add(modifiedTranslate, activeNodeScrollDelta);
  const transform = adjustScale(appliedTranslate, (_over$rect = over == null ? void 0 : over.rect) != null ? _over$rect : null, activeNodeRect);
  const activeSensorRef = reactExports.useRef(null);
  const instantiateSensor = reactExports.useCallback((event, _ref2) => {
    let {
      sensor: Sensor,
      options
    } = _ref2;

    if (activeRef.current == null) {
      return;
    }

    const activeNode = draggableNodes.get(activeRef.current);

    if (!activeNode) {
      return;
    }

    const activatorEvent = event.nativeEvent;
    const sensorInstance = new Sensor({
      active: activeRef.current,
      activeNode,
      event: activatorEvent,
      options,
      // Sensors need to be instantiated with refs for arguments that change over time
      // otherwise they are frozen in time with the stale arguments
      context: sensorContext,

      onAbort(id) {
        const draggableNode = draggableNodes.get(id);

        if (!draggableNode) {
          return;
        }

        const {
          onDragAbort
        } = latestProps.current;
        const event = {
          id
        };
        onDragAbort == null ? void 0 : onDragAbort(event);
        dispatchMonitorEvent({
          type: 'onDragAbort',
          event
        });
      },

      onPending(id, constraint, initialCoordinates, offset) {
        const draggableNode = draggableNodes.get(id);

        if (!draggableNode) {
          return;
        }

        const {
          onDragPending
        } = latestProps.current;
        const event = {
          id,
          constraint,
          initialCoordinates,
          offset
        };
        onDragPending == null ? void 0 : onDragPending(event);
        dispatchMonitorEvent({
          type: 'onDragPending',
          event
        });
      },

      onStart(initialCoordinates) {
        const id = activeRef.current;

        if (id == null) {
          return;
        }

        const draggableNode = draggableNodes.get(id);

        if (!draggableNode) {
          return;
        }

        const {
          onDragStart
        } = latestProps.current;
        const event = {
          activatorEvent,
          active: {
            id,
            data: draggableNode.data,
            rect: activeRects
          }
        };
        reactDomExports.unstable_batchedUpdates(() => {
          onDragStart == null ? void 0 : onDragStart(event);
          setStatus(Status.Initializing);
          dispatch({
            type: Action.DragStart,
            initialCoordinates,
            active: id
          });
          dispatchMonitorEvent({
            type: 'onDragStart',
            event
          });
          setActiveSensor(activeSensorRef.current);
          setActivatorEvent(activatorEvent);
        });
      },

      onMove(coordinates) {
        dispatch({
          type: Action.DragMove,
          coordinates
        });
      },

      onEnd: createHandler(Action.DragEnd),
      onCancel: createHandler(Action.DragCancel)
    });
    activeSensorRef.current = sensorInstance;

    function createHandler(type) {
      return async function handler() {
        const {
          active,
          collisions,
          over,
          scrollAdjustedTranslate
        } = sensorContext.current;
        let event = null;

        if (active && scrollAdjustedTranslate) {
          const {
            cancelDrop
          } = latestProps.current;
          event = {
            activatorEvent,
            active: active,
            collisions,
            delta: scrollAdjustedTranslate,
            over
          };

          if (type === Action.DragEnd && typeof cancelDrop === 'function') {
            const shouldCancel = await Promise.resolve(cancelDrop(event));

            if (shouldCancel) {
              type = Action.DragCancel;
            }
          }
        }

        activeRef.current = null;
        reactDomExports.unstable_batchedUpdates(() => {
          dispatch({
            type
          });
          setStatus(Status.Uninitialized);
          setOver(null);
          setActiveSensor(null);
          setActivatorEvent(null);
          activeSensorRef.current = null;
          const eventName = type === Action.DragEnd ? 'onDragEnd' : 'onDragCancel';

          if (event) {
            const handler = latestProps.current[eventName];
            handler == null ? void 0 : handler(event);
            dispatchMonitorEvent({
              type: eventName,
              event
            });
          }
        });
      };
    }
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [draggableNodes]);
  const bindActivatorToSensorInstantiator = reactExports.useCallback((handler, sensor) => {
    return (event, active) => {
      const nativeEvent = event.nativeEvent;
      const activeDraggableNode = draggableNodes.get(active);

      if ( // Another sensor is already instantiating
      activeRef.current !== null || // No active draggable
      !activeDraggableNode || // Event has already been captured
      nativeEvent.dndKit || nativeEvent.defaultPrevented) {
        return;
      }

      const activationContext = {
        active: activeDraggableNode
      };
      const shouldActivate = handler(event, sensor.options, activationContext);

      if (shouldActivate === true) {
        nativeEvent.dndKit = {
          capturedBy: sensor.sensor
        };
        activeRef.current = active;
        instantiateSensor(event, sensor);
      }
    };
  }, [draggableNodes, instantiateSensor]);
  const activators = useCombineActivators(sensors, bindActivatorToSensorInstantiator);
  useSensorSetup(sensors);
  useIsomorphicLayoutEffect(() => {
    if (activeNodeRect && status === Status.Initializing) {
      setStatus(Status.Initialized);
    }
  }, [activeNodeRect, status]);
  reactExports.useEffect(() => {
    const {
      onDragMove
    } = latestProps.current;
    const {
      active,
      activatorEvent,
      collisions,
      over
    } = sensorContext.current;

    if (!active || !activatorEvent) {
      return;
    }

    const event = {
      active,
      activatorEvent,
      collisions,
      delta: {
        x: scrollAdjustedTranslate.x,
        y: scrollAdjustedTranslate.y
      },
      over
    };
    reactDomExports.unstable_batchedUpdates(() => {
      onDragMove == null ? void 0 : onDragMove(event);
      dispatchMonitorEvent({
        type: 'onDragMove',
        event
      });
    });
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [scrollAdjustedTranslate.x, scrollAdjustedTranslate.y]);
  reactExports.useEffect(() => {
    const {
      active,
      activatorEvent,
      collisions,
      droppableContainers,
      scrollAdjustedTranslate
    } = sensorContext.current;

    if (!active || activeRef.current == null || !activatorEvent || !scrollAdjustedTranslate) {
      return;
    }

    const {
      onDragOver
    } = latestProps.current;
    const overContainer = droppableContainers.get(overId);
    const over = overContainer && overContainer.rect.current ? {
      id: overContainer.id,
      rect: overContainer.rect.current,
      data: overContainer.data,
      disabled: overContainer.disabled
    } : null;
    const event = {
      active,
      activatorEvent,
      collisions,
      delta: {
        x: scrollAdjustedTranslate.x,
        y: scrollAdjustedTranslate.y
      },
      over
    };
    reactDomExports.unstable_batchedUpdates(() => {
      setOver(over);
      onDragOver == null ? void 0 : onDragOver(event);
      dispatchMonitorEvent({
        type: 'onDragOver',
        event
      });
    });
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [overId]);
  useIsomorphicLayoutEffect(() => {
    sensorContext.current = {
      activatorEvent,
      active,
      activeNode,
      collisionRect,
      collisions,
      droppableRects,
      draggableNodes,
      draggingNode,
      draggingNodeRect,
      droppableContainers,
      over,
      scrollableAncestors,
      scrollAdjustedTranslate
    };
    activeRects.current = {
      initial: draggingNodeRect,
      translated: collisionRect
    };
  }, [active, activeNode, collisions, collisionRect, draggableNodes, draggingNode, draggingNodeRect, droppableRects, droppableContainers, over, scrollableAncestors, scrollAdjustedTranslate]);
  useAutoScroller({ ...autoScrollOptions,
    delta: translate,
    draggingRect: collisionRect,
    pointerCoordinates,
    scrollableAncestors,
    scrollableAncestorRects
  });
  const publicContext = reactExports.useMemo(() => {
    const context = {
      active,
      activeNode,
      activeNodeRect,
      activatorEvent,
      collisions,
      containerNodeRect,
      dragOverlay,
      draggableNodes,
      droppableContainers,
      droppableRects,
      over,
      measureDroppableContainers,
      scrollableAncestors,
      scrollableAncestorRects,
      measuringConfiguration,
      measuringScheduled,
      windowRect
    };
    return context;
  }, [active, activeNode, activeNodeRect, activatorEvent, collisions, containerNodeRect, dragOverlay, draggableNodes, droppableContainers, droppableRects, over, measureDroppableContainers, scrollableAncestors, scrollableAncestorRects, measuringConfiguration, measuringScheduled, windowRect]);
  const internalContext = reactExports.useMemo(() => {
    const context = {
      activatorEvent,
      activators,
      active,
      activeNodeRect,
      ariaDescribedById: {
        draggable: draggableDescribedById
      },
      dispatch,
      draggableNodes,
      over,
      measureDroppableContainers
    };
    return context;
  }, [activatorEvent, activators, active, activeNodeRect, dispatch, draggableDescribedById, draggableNodes, over, measureDroppableContainers]);
  return React.createElement(DndMonitorContext.Provider, {
    value: registerMonitorListener
  }, React.createElement(InternalContext.Provider, {
    value: internalContext
  }, React.createElement(PublicContext.Provider, {
    value: publicContext
  }, React.createElement(ActiveDraggableContext.Provider, {
    value: transform
  }, children)), React.createElement(RestoreFocus, {
    disabled: (accessibility == null ? void 0 : accessibility.restoreFocus) === false
  })), React.createElement(Accessibility, { ...accessibility,
    hiddenTextDescribedById: draggableDescribedById
  }));

  function getAutoScrollerOptions() {
    const activeSensorDisablesAutoscroll = (activeSensor == null ? void 0 : activeSensor.autoScrollEnabled) === false;
    const autoScrollGloballyDisabled = typeof autoScroll === 'object' ? autoScroll.enabled === false : autoScroll === false;
    const enabled = isInitialized && !activeSensorDisablesAutoscroll && !autoScrollGloballyDisabled;

    if (typeof autoScroll === 'object') {
      return { ...autoScroll,
        enabled
      };
    }

    return {
      enabled
    };
  }
});

const NullContext = /*#__PURE__*/reactExports.createContext(null);
const defaultRole = 'button';
const ID_PREFIX = 'Draggable';
function useDraggable(_ref) {
  let {
    id,
    data,
    disabled = false,
    attributes
  } = _ref;
  const key = useUniqueId(ID_PREFIX);
  const {
    activators,
    activatorEvent,
    active,
    activeNodeRect,
    ariaDescribedById,
    draggableNodes,
    over
  } = reactExports.useContext(InternalContext);
  const {
    role = defaultRole,
    roleDescription = 'draggable',
    tabIndex = 0
  } = attributes != null ? attributes : {};
  const isDragging = (active == null ? void 0 : active.id) === id;
  const transform = reactExports.useContext(isDragging ? ActiveDraggableContext : NullContext);
  const [node, setNodeRef] = useNodeRef();
  const [activatorNode, setActivatorNodeRef] = useNodeRef();
  const listeners = useSyntheticListeners(activators, id);
  const dataRef = useLatestValue(data);
  useIsomorphicLayoutEffect(() => {
    draggableNodes.set(id, {
      id,
      key,
      node,
      activatorNode,
      data: dataRef
    });
    return () => {
      const node = draggableNodes.get(id);

      if (node && node.key === key) {
        draggableNodes.delete(id);
      }
    };
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [draggableNodes, id]);
  const memoizedAttributes = reactExports.useMemo(() => ({
    role,
    tabIndex,
    'aria-disabled': disabled,
    'aria-pressed': isDragging && role === defaultRole ? true : undefined,
    'aria-roledescription': roleDescription,
    'aria-describedby': ariaDescribedById.draggable
  }), [disabled, role, tabIndex, isDragging, roleDescription, ariaDescribedById.draggable]);
  return {
    active,
    activatorEvent,
    activeNodeRect,
    attributes: memoizedAttributes,
    isDragging,
    listeners: disabled ? undefined : listeners,
    node,
    over,
    setNodeRef,
    setActivatorNodeRef,
    transform
  };
}

function useDndContext() {
  return reactExports.useContext(PublicContext);
}

const ID_PREFIX$1 = 'Droppable';
const defaultResizeObserverConfig = {
  timeout: 25
};
function useDroppable(_ref) {
  let {
    data,
    disabled = false,
    id,
    resizeObserverConfig
  } = _ref;
  const key = useUniqueId(ID_PREFIX$1);
  const {
    active,
    dispatch,
    over,
    measureDroppableContainers
  } = reactExports.useContext(InternalContext);
  const previous = reactExports.useRef({
    disabled
  });
  const resizeObserverConnected = reactExports.useRef(false);
  const rect = reactExports.useRef(null);
  const callbackId = reactExports.useRef(null);
  const {
    disabled: resizeObserverDisabled,
    updateMeasurementsFor,
    timeout: resizeObserverTimeout
  } = { ...defaultResizeObserverConfig,
    ...resizeObserverConfig
  };
  const ids = useLatestValue(updateMeasurementsFor != null ? updateMeasurementsFor : id);
  const handleResize = reactExports.useCallback(() => {
    if (!resizeObserverConnected.current) {
      // ResizeObserver invokes the `handleResize` callback as soon as `observe` is called,
      // assuming the element is rendered and displayed.
      resizeObserverConnected.current = true;
      return;
    }

    if (callbackId.current != null) {
      clearTimeout(callbackId.current);
    }

    callbackId.current = setTimeout(() => {
      measureDroppableContainers(Array.isArray(ids.current) ? ids.current : [ids.current]);
      callbackId.current = null;
    }, resizeObserverTimeout);
  }, //eslint-disable-next-line react-hooks/exhaustive-deps
  [resizeObserverTimeout]);
  const resizeObserver = useResizeObserver({
    callback: handleResize,
    disabled: resizeObserverDisabled || !active
  });
  const handleNodeChange = reactExports.useCallback((newElement, previousElement) => {
    if (!resizeObserver) {
      return;
    }

    if (previousElement) {
      resizeObserver.unobserve(previousElement);
      resizeObserverConnected.current = false;
    }

    if (newElement) {
      resizeObserver.observe(newElement);
    }
  }, [resizeObserver]);
  const [nodeRef, setNodeRef] = useNodeRef(handleNodeChange);
  const dataRef = useLatestValue(data);
  reactExports.useEffect(() => {
    if (!resizeObserver || !nodeRef.current) {
      return;
    }

    resizeObserver.disconnect();
    resizeObserverConnected.current = false;
    resizeObserver.observe(nodeRef.current);
  }, [nodeRef, resizeObserver]);
  reactExports.useEffect(() => {
    dispatch({
      type: Action.RegisterDroppable,
      element: {
        id,
        key,
        disabled,
        node: nodeRef,
        rect,
        data: dataRef
      }
    });
    return () => dispatch({
      type: Action.UnregisterDroppable,
      key,
      id
    });
  }, // eslint-disable-next-line react-hooks/exhaustive-deps
  [id]);
  reactExports.useEffect(() => {
    if (disabled !== previous.current.disabled) {
      dispatch({
        type: Action.SetDroppableDisabled,
        id,
        key,
        disabled
      });
      previous.current.disabled = disabled;
    }
  }, [id, key, disabled, dispatch]);
  return {
    active,
    rect,
    isOver: (over == null ? void 0 : over.id) === id,
    node: nodeRef,
    over,
    setNodeRef
  };
}

function AnimationManager(_ref) {
  let {
    animation,
    children
  } = _ref;
  const [clonedChildren, setClonedChildren] = reactExports.useState(null);
  const [element, setElement] = reactExports.useState(null);
  const previousChildren = usePrevious(children);

  if (!children && !clonedChildren && previousChildren) {
    setClonedChildren(previousChildren);
  }

  useIsomorphicLayoutEffect(() => {
    if (!element) {
      return;
    }

    const key = clonedChildren == null ? void 0 : clonedChildren.key;
    const id = clonedChildren == null ? void 0 : clonedChildren.props.id;

    if (key == null || id == null) {
      setClonedChildren(null);
      return;
    }

    Promise.resolve(animation(id, element)).then(() => {
      setClonedChildren(null);
    });
  }, [animation, clonedChildren, element]);
  return React.createElement(React.Fragment, null, children, clonedChildren ? reactExports.cloneElement(clonedChildren, {
    ref: setElement
  }) : null);
}

const defaultTransform = {
  x: 0,
  y: 0,
  scaleX: 1,
  scaleY: 1
};
function NullifiedContextProvider(_ref) {
  let {
    children
  } = _ref;
  return React.createElement(InternalContext.Provider, {
    value: defaultInternalContext
  }, React.createElement(ActiveDraggableContext.Provider, {
    value: defaultTransform
  }, children));
}

const baseStyles = {
  position: 'fixed',
  touchAction: 'none'
};

const defaultTransition = activatorEvent => {
  const isKeyboardActivator = isKeyboardEvent(activatorEvent);
  return isKeyboardActivator ? 'transform 250ms ease' : undefined;
};

const PositionedOverlay = /*#__PURE__*/reactExports.forwardRef((_ref, ref) => {
  let {
    as,
    activatorEvent,
    adjustScale,
    children,
    className,
    rect,
    style,
    transform,
    transition = defaultTransition
  } = _ref;

  if (!rect) {
    return null;
  }

  const scaleAdjustedTransform = adjustScale ? transform : { ...transform,
    scaleX: 1,
    scaleY: 1
  };
  const styles = { ...baseStyles,
    width: rect.width,
    height: rect.height,
    top: rect.top,
    left: rect.left,
    transform: CSS.Transform.toString(scaleAdjustedTransform),
    transformOrigin: adjustScale && activatorEvent ? getRelativeTransformOrigin(activatorEvent, rect) : undefined,
    transition: typeof transition === 'function' ? transition(activatorEvent) : transition,
    ...style
  };
  return React.createElement(as, {
    className,
    style: styles,
    ref
  }, children);
});

const defaultDropAnimationSideEffects = options => _ref => {
  let {
    active,
    dragOverlay
  } = _ref;
  const originalStyles = {};
  const {
    styles,
    className
  } = options;

  if (styles != null && styles.active) {
    for (const [key, value] of Object.entries(styles.active)) {
      if (value === undefined) {
        continue;
      }

      originalStyles[key] = active.node.style.getPropertyValue(key);
      active.node.style.setProperty(key, value);
    }
  }

  if (styles != null && styles.dragOverlay) {
    for (const [key, value] of Object.entries(styles.dragOverlay)) {
      if (value === undefined) {
        continue;
      }

      dragOverlay.node.style.setProperty(key, value);
    }
  }

  if (className != null && className.active) {
    active.node.classList.add(className.active);
  }

  if (className != null && className.dragOverlay) {
    dragOverlay.node.classList.add(className.dragOverlay);
  }

  return function cleanup() {
    for (const [key, value] of Object.entries(originalStyles)) {
      active.node.style.setProperty(key, value);
    }

    if (className != null && className.active) {
      active.node.classList.remove(className.active);
    }
  };
};

const defaultKeyframeResolver = _ref2 => {
  let {
    transform: {
      initial,
      final
    }
  } = _ref2;
  return [{
    transform: CSS.Transform.toString(initial)
  }, {
    transform: CSS.Transform.toString(final)
  }];
};

const defaultDropAnimationConfiguration = {
  duration: 250,
  easing: 'ease',
  keyframes: defaultKeyframeResolver,
  sideEffects: /*#__PURE__*/defaultDropAnimationSideEffects({
    styles: {
      active: {
        opacity: '0'
      }
    }
  })
};
function useDropAnimation(_ref3) {
  let {
    config,
    draggableNodes,
    droppableContainers,
    measuringConfiguration
  } = _ref3;
  return useEvent((id, node) => {
    if (config === null) {
      return;
    }

    const activeDraggable = draggableNodes.get(id);

    if (!activeDraggable) {
      return;
    }

    const activeNode = activeDraggable.node.current;

    if (!activeNode) {
      return;
    }

    const measurableNode = getMeasurableNode(node);

    if (!measurableNode) {
      return;
    }

    const {
      transform
    } = getWindow(node).getComputedStyle(node);
    const parsedTransform = parseTransform(transform);

    if (!parsedTransform) {
      return;
    }

    const animation = typeof config === 'function' ? config : createDefaultDropAnimation(config);
    scrollIntoViewIfNeeded(activeNode, measuringConfiguration.draggable.measure);
    return animation({
      active: {
        id,
        data: activeDraggable.data,
        node: activeNode,
        rect: measuringConfiguration.draggable.measure(activeNode)
      },
      draggableNodes,
      dragOverlay: {
        node,
        rect: measuringConfiguration.dragOverlay.measure(measurableNode)
      },
      droppableContainers,
      measuringConfiguration,
      transform: parsedTransform
    });
  });
}

function createDefaultDropAnimation(options) {
  const {
    duration,
    easing,
    sideEffects,
    keyframes
  } = { ...defaultDropAnimationConfiguration,
    ...options
  };
  return _ref4 => {
    let {
      active,
      dragOverlay,
      transform,
      ...rest
    } = _ref4;

    if (!duration) {
      // Do not animate if animation duration is zero.
      return;
    }

    const delta = {
      x: dragOverlay.rect.left - active.rect.left,
      y: dragOverlay.rect.top - active.rect.top
    };
    const scale = {
      scaleX: transform.scaleX !== 1 ? active.rect.width * transform.scaleX / dragOverlay.rect.width : 1,
      scaleY: transform.scaleY !== 1 ? active.rect.height * transform.scaleY / dragOverlay.rect.height : 1
    };
    const finalTransform = {
      x: transform.x - delta.x,
      y: transform.y - delta.y,
      ...scale
    };
    const animationKeyframes = keyframes({ ...rest,
      active,
      dragOverlay,
      transform: {
        initial: transform,
        final: finalTransform
      }
    });
    const [firstKeyframe] = animationKeyframes;
    const lastKeyframe = animationKeyframes[animationKeyframes.length - 1];

    if (JSON.stringify(firstKeyframe) === JSON.stringify(lastKeyframe)) {
      // The start and end keyframes are the same, infer that there is no animation needed.
      return;
    }

    const cleanup = sideEffects == null ? void 0 : sideEffects({
      active,
      dragOverlay,
      ...rest
    });
    const animation = dragOverlay.node.animate(animationKeyframes, {
      duration,
      easing,
      fill: 'forwards'
    });
    return new Promise(resolve => {
      animation.onfinish = () => {
        cleanup == null ? void 0 : cleanup();
        resolve();
      };
    });
  };
}

let key = 0;
function useKey(id) {
  return reactExports.useMemo(() => {
    if (id == null) {
      return;
    }

    key++;
    return key;
  }, [id]);
}

const DragOverlay = /*#__PURE__*/React.memo(_ref => {
  let {
    adjustScale = false,
    children,
    dropAnimation: dropAnimationConfig,
    style,
    transition,
    modifiers,
    wrapperElement = 'div',
    className,
    zIndex = 999
  } = _ref;
  const {
    activatorEvent,
    active,
    activeNodeRect,
    containerNodeRect,
    draggableNodes,
    droppableContainers,
    dragOverlay,
    over,
    measuringConfiguration,
    scrollableAncestors,
    scrollableAncestorRects,
    windowRect
  } = useDndContext();
  const transform = reactExports.useContext(ActiveDraggableContext);
  const key = useKey(active == null ? void 0 : active.id);
  const modifiedTransform = applyModifiers(modifiers, {
    activatorEvent,
    active,
    activeNodeRect,
    containerNodeRect,
    draggingNodeRect: dragOverlay.rect,
    over,
    overlayNodeRect: dragOverlay.rect,
    scrollableAncestors,
    scrollableAncestorRects,
    transform,
    windowRect
  });
  const initialRect = useInitialValue(activeNodeRect);
  const dropAnimation = useDropAnimation({
    config: dropAnimationConfig,
    draggableNodes,
    droppableContainers,
    measuringConfiguration
  }); // We need to wait for the active node to be measured before connecting the drag overlay ref
  // otherwise collisions can be computed against a mispositioned drag overlay

  const ref = initialRect ? dragOverlay.setRef : undefined;
  return React.createElement(NullifiedContextProvider, null, React.createElement(AnimationManager, {
    animation: dropAnimation
  }, active && key ? React.createElement(PositionedOverlay, {
    key: key,
    id: active.id,
    ref: ref,
    as: wrapperElement,
    activatorEvent: activatorEvent,
    adjustScale: adjustScale,
    className: className,
    transition: transition,
    rect: initialRect,
    style: {
      zIndex,
      ...style
    },
    transform: modifiedTransform
  }, children) : null));
});

const Locale = {};

function installLocale(dictionary, lang, dir) {
  for (const key of Object.keys(Locale))
    delete Locale[key];
  Object.assign(Locale, dictionary || {});
  const language = (lang || Locale.ui_language) === "ar" ? "ar" : "en";
  const direction = dir === "rtl" || dir === "ltr" ? dir : language === "ar" ? "rtl" : "ltr";
  const root = document.documentElement;
  root.lang = language;
  root.dir = direction;
  document.body.dir = direction;
  document.body.classList.toggle("is-rtl", direction === "rtl");
  document.title = Locale.ui_inventory || "Inventory";
}
function tr(key, fallback) {
  return Locale[key] || fallback || key;
}
function trf(key, fallback, ...values) {
  let value = tr(key, fallback);
  for (const replacement of values) {
    value = value.replace(/%[sd]/, () => String(replacement));
  }
  return value;
}

function N(v) {
  const n = parseFloat(v);
  return isNaN(n) ? 0 : n;
}
function rarity(it) {
  if (it?.metadata?.rarity)
    return it.metadata.rarity;
  const l = it?.limit;
  if (l !== void 0 && l !== null) {
    if (l <= 0)
      return "common";
    if (l <= 1)
      return "legendary";
    if (l <= 3)
      return "epic";
    if (l <= 5)
      return "rare";
    if (l <= 15)
      return "uncommon";
  }
  return "common";
}
function rarityLabel(r) {
  return tr(`ui_rarity_${r}`, r);
}
function fmtWeight(grams) {
  const kg = (Number(grams) || 0) / 1e3;
  return `${kg.toFixed(2)} ${tr("ui_weight_unit", "kg")}`;
}
function fmtType(t) {
  if (!t)
    return tr("ui_type_misc", "Miscellaneous");
  const map = {
    item_weapon: ["ui_type_weapon", "Weapon"],
    item_ammo: ["ui_type_ammo", "Ammo"],
    item_food: ["ui_type_food", "Food"],
    item_misc: ["ui_type_misc", "Miscellaneous"],
    item_collectables: ["ui_type_collectables", "Collectables"]
  };
  const translated = map[t];
  return translated ? tr(translated[0], translated[1]) : t.replace("type_", "").replace("item_", "").replace(/_/g, " ");
}
function categoryName(id) {
  if (id === "all")
    return tr("ui_category_all", "All");
  return fmtType(id);
}
function normalizeItem(it) {
  return {
    ...it,
    weight: N(it.weight),
    count: N(it.count) || 1,
    limit: N(it.limit)
  };
}
const CATEGORIES = [
  { id: "all", icon: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 22 12 18.27 5.82 22 7 14.14 2 9.27l6.91-1.01z" }) }) },
  { id: "item_ammo", icon: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M7 5h2V3H7v2zm0 8h2v-2H7v2zm0 8h2v-2H7v2zm4-4h2v-2h-2v2zm0 4h2v-2h-2v2zm-8 0h2v-2H3v2zm0-4h2v-2H3v2zm0-4h2v-2H3v2zm0-4h2V7H3v2zm0-4h2V3H3v2zm8 8h2v-2h-2v2zm8-8h2V3h-2v2zm0 4h2V7h-2v2zm-4-4h2V3h-2v2zm4 12h2v-2h-2v2zm-4 4h2v-2h-2v2zm0-8h2v-2h-2v2zm4 4h2v-2h-2v2zm0-4h2v-2h-2v2z" }) }) },
  { id: "item_food", icon: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M18.06 23h1.66c.84 0 1.53-.65 1.63-1.47L23 7h-5V1h-2v6h-5l1.65 14.53c.1.82.79 1.47 1.63 1.47h1.78zM1 22c0 .55.45 1 1 1h8c.55 0 1-.45 1-1V3H1v19z" }) }) },
  { id: "item_misc", icon: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M22 9V7h-2V5c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2v-2h2v-2h-2v-2h2v-2h-2V9h2zm-4 10H4V5h14v14zM6 13h5v4H6v-4zm6-6h4v3h-4V7zM6 7h5v5H6V7zm6 4h4v6h-4v-6z" }) }) },
  { id: "item_collectables", icon: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M19 3H5L2 9l10 12L22 9l-3-6zM9.62 8l1.5-3h1.76l1.5 3H9.62z" }) }) },
  { id: "item_weapon", icon: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M7.5 4C5.57 4 4 5.57 4 7.5S5.57 11 7.5 11 11 9.43 11 7.5 9.43 4 7.5 4zM18 2l-4 4h-2l-1.7 1.7A5.47 5.47 0 007.5 3C4.46 3 2 5.46 2 8.5S4.46 14 7.5 14c1.55 0 2.95-.64 3.95-1.68L22 2h-4z" }) }) }
];
const SVG_BAG = /* @__PURE__ */ jsxs("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: [
  /* @__PURE__ */ jsx("path", { d: "M3 13v6a2 2 0 002 2h14a2 2 0 002-2v-6H3zm8 4H7v-2h4v2zm6 0h-4v-2h4v2z" }),
  /* @__PURE__ */ jsx("path", { d: "M21 11V7a2 2 0 00-2-2h-3V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v1H5a2 2 0 00-2 2v4h18zM10 4h4v1h-4V4z", opacity: ".7" })
] });
const SVG_SATCHEL = /* @__PURE__ */ jsxs("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: [
  /* @__PURE__ */ jsx("path", { d: "M8.9 6.4V5.3A2.3 2.3 0 0 1 11.2 3h1.6a2.3 2.3 0 0 1 2.3 2.3v1.1h-1.8V5.4a.6.6 0 0 0-.6-.6h-1.4a.6.6 0 0 0-.6.6v1h-1.8z", opacity: ".8" }),
  /* @__PURE__ */ jsx("path", { d: "M4.5 11.9h15l-.5 5.9A2.7 2.7 0 0 1 16.3 21H7.7a2.7 2.7 0 0 1-2.7-3.2l-.5-5.9z", opacity: ".45" }),
  /* @__PURE__ */ jsx("path", { d: "M5.6 6.4h12.8a1.7 1.7 0 0 1 1.69 1.86l-.2 2.2a1.1 1.1 0 0 1-1.1 1H5.21a1.1 1.1 0 0 1-1.1-1l-.2-2.2A1.7 1.7 0 0 1 5.6 6.4z" }),
  /* @__PURE__ */ jsx("path", { d: "M10.75 10.9h2.5c.36 0 .65.29.65.65v1.6c0 .36-.29.65-.65.65h-2.5a.65.65 0 0 1-.65-.65v-1.6c0-.36.29-.65.65-.65z" })
] });
const SVG_X = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" }) });
const SVG_CASH = /* @__PURE__ */ jsx("span", { className: "cur-glyph cur-cash", "aria-hidden": "true", children: "$" });
const SVG_GOLD = /* @__PURE__ */ jsx("svg", { className: "cur-glyph cur-gold", viewBox: "0 0 24 24", fill: "currentColor", "aria-hidden": "true", children: /* @__PURE__ */ jsx("path", { fillRule: "evenodd", d: "M7.1 6.5h9.8L21 17.5H3zM8.2 9.6l-.5 1.3h8.6l-.5-1.3z" }) });
const SVG_EYE = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z" }) });
const COLS = 5;
const MIN_ROWS = 4;

const MIN_GRID_SIZE = 50;
const initial = {
  grid: new Array(MIN_GRID_SIZE).fill(null),
  maxWeight: 200,
  category: "all",
  search: "",
  selected: null,
  panel: "main",
  rightInventory: null,
  rightGrid: [],
  containerOpen: null,
  containerGrid: new Array(MIN_GRID_SIZE).fill(null),
  containerMaxWeight: 0,
  containerSlots: 15,
  containerLabel: "",
  inspecting: null,
  inspectPanel: "main",
  playerCash: 0,
  playerGold: 0,
  shopPaymentCurrency: "cash",
  goldPriceMultiplier: 1,
  itemAmount: 0,
  isBusy: false,
  additionalMetadata: [],
  wornClothingCategories: [],
  removedClothingCategories: [],
  tradeOpen: false,
  tradeCompleting: false,
  tradeId: null,
  tradePartner: "",
  myOffer: [],
  theirOffer: [],
  myConfirmed: false,
  theirConfirmed: false,
  tradeRequest: null
};
function describe(slot, data) {
  const meta = slot.metadata || {};
  if (typeof meta.descriptionKey === "string") {
    const args = Array.isArray(meta.descriptionArgs) ? meta.descriptionArgs : [];
    return trf(meta.descriptionKey, meta.description || meta.descriptionKey, ...args.map((a) => tr(String(a), String(a))));
  }
  const text = meta.description || data?.description;
  return typeof text === "string" ? tr(text, text) : text;
}
function slotToItem(slot, itemsDb) {
  if (!slot.name)
    return null;
  const data = itemsDb[slot.name];
  const curTime = Math.floor(Date.now() / 1e3);
  let durability = slot.metadata?.durability;
  if (durability !== void 0 && durability > 100 && slot.metadata?.degrade) {
    durability = (durability - curTime) / (60 * slot.metadata.degrade) * 100;
  }
  if (durability !== void 0 && durability < 0)
    durability = 0;
  return {
    slot: slot.slot,
    name: slot.name,
    label: slot.metadata?.label || data?.label || slot.name,
    count: slot.count ?? 1,
    weight: slot.weight ?? 0,
    limit: 0,
    type: data?.category || void 0,
    desc: describe(slot, data),
    canUse: data?.usable ?? false,
    percentage: durability ?? slot.durability ?? null,
    durability: durability ?? slot.durability,
    isWeapon: !!data?.weapon,
    equipped: false,
    isContainer: !!slot.metadata?.container,
    containerMaxWeight: slot.metadata?.containerMaxWeight,
    containerContentWeight: slot.metadata?.containerContentWeight,
    containerSlots: slot.metadata?.containerSlots,
    id: slot.metadata?.id ?? `${slot.name}-${slot.slot}`,
    price: slot.price,
    currency: slot.currency,
    ingredients: slot.ingredients,
    duration: slot.duration,
    grade: slot.grade,
    metadata: slot.metadata,
    ammo: slot.metadata?.ammo ? { default: slot.metadata.ammo } : void 0,
    weaponId: slot.metadata?.weaponId
  };
}
function inventoryToGrid(inv, itemsDb) {
  const size = Math.max(MIN_GRID_SIZE, inv.slots || 50);
  const grid = new Array(size).fill(null);
  if (!inv.items)
    return grid;
  const items = inv.items;
  if (Array.isArray(items)) {
    for (const slot of items) {
      if (!slot || !slot.name)
        continue;
      const idx = slot.slot - 1;
      if (idx >= 0 && idx < size) {
        grid[idx] = slotToItem(slot, itemsDb);
      }
    }
  } else if (typeof items === "object") {
    for (const key of Object.keys(items)) {
      const slot = items[key];
      if (!slot || !slot.name)
        continue;
      const slotNum = slot.slot ?? parseInt(key);
      const idx = slotNum - 1;
      if (idx >= 0 && idx < size) {
        grid[idx] = slotToItem(slot, itemsDb);
      }
    }
  }
  return grid;
}
function reducer(state, action) {
  switch (action.type) {
    case "SETUP_INVENTORY": {
      const itemsDb = window.__oxItems || {};
      const newState = { ...state };
      if (action.leftInventory) {
        const left = action.leftInventory;
        newState.grid = inventoryToGrid(left, itemsDb);
        newState.maxWeight = left.maxWeight ?? state.maxWeight;
        if (left.playerGold !== void 0)
          newState.playerGold = left.playerGold;
        if (left.playerCash !== void 0)
          newState.playerCash = left.playerCash;
        if (left.goldPriceMultiplier !== void 0)
          newState.goldPriceMultiplier = left.goldPriceMultiplier;
      }
      if (action.rightInventory) {
        const right = action.rightInventory;
        newState.rightInventory = {
          type: right.type,
          id: right.id,
          label: right.label || "",
          slots: right.slots,
          maxWeight: right.maxWeight,
          groups: right.groups
        };
        newState.rightGrid = inventoryToGrid(right, itemsDb);
      }
      if (action.wornClothingCategories)
        newState.wornClothingCategories = action.wornClothingCategories;
      if (action.removedClothingCategories !== void 0)
        newState.removedClothingCategories = action.removedClothingCategories;
      newState.selected = null;
      newState.isBusy = false;
      return newState;
    }
    case "REFRESH_SLOTS": {
      const itemsDb = window.__oxItems || {};
      const newGrid = [...state.grid];
      const newRightGrid = [...state.rightGrid];
      const newState = { ...state };
      if (action.items) {
        const items = Array.isArray(action.items) ? action.items : [action.items];
        for (const data of items) {
          if (!data?.item)
            continue;
          const slot = data.item;
          const idx = slot.slot - 1;
          const isRight = data.inventory && data.inventory !== "player";
          const isEmpty = !slot.name || slot.count === 0 || slot.count === "0";
          if (isRight) {
            if (idx >= 0 && idx < newRightGrid.length) {
              newRightGrid[idx] = isEmpty ? null : slotToItem(slot, itemsDb);
            }
          } else {
            if (idx >= 0 && idx < newGrid.length) {
              newGrid[idx] = isEmpty ? null : slotToItem(slot, itemsDb);
            }
          }
        }
        newState.grid = newGrid;
        newState.rightGrid = newRightGrid;
      }
      if (action.weightData) {
        const { inventoryId, maxWeight } = action.weightData;
        if (state.rightInventory && inventoryId === state.rightInventory.id) {
          newState.rightInventory = { ...state.rightInventory, maxWeight };
        } else {
          newState.maxWeight = maxWeight;
        }
      }
      if (action.slotsData) {
        const { inventoryId, slots } = action.slotsData;
        if (state.rightInventory && inventoryId === state.rightInventory.id) {
          newState.rightInventory = { ...state.rightInventory, slots };
        }
      }
      newState.isBusy = false;
      return newState;
    }
    case "RELABEL_ITEMS": {
      const itemsDb = window.__oxItems || {};
      const relabel = (it) => {
        if (!it || !it.name)
          return it;
        const data = itemsDb[it.name];
        if (!data)
          return it;
        return {
          ...it,
          label: it.metadata?.label || data.label || it.name,
          desc: describe({ slot: it.slot, name: it.name, metadata: it.metadata }, data)
        };
      };
      return {
        ...state,
        grid: state.grid.map(relabel),
        rightGrid: state.rightGrid.map(relabel),
        containerGrid: state.containerGrid.map(relabel)
      };
    }
    case "SET_CATEGORY":
      return { ...state, category: action.category, selected: null };
    case "SET_SEARCH":
      return { ...state, search: action.search };
    case "SELECT":
      return { ...state, selected: action.index, panel: action.panel };
    case "DESELECT":
      return { ...state, selected: null };
    case "DROP_ITEM":
    case "SWAP_ITEMS":
    case "MERGE_STACKS":
    case "MOVE_TO_EMPTY":
      return { ...state, isBusy: true, selected: null };
    case "OPEN_CONTAINER": {
      const it = state.grid[action.index];
      if (!it || !it.isContainer)
        return state;
      return {
        ...state,
        containerLabel: it.label || it.name,
        containerMaxWeight: N(it.containerMaxWeight) || 20,
        containerSlots: it.containerSlots || 15,
        containerOpen: it.id,
        containerGrid: new Array(MIN_GRID_SIZE).fill(null)
      };
    }
    case "CLOSE_CONTAINER":
      return {
        ...state,
        containerOpen: null,
        containerGrid: new Array(MIN_GRID_SIZE).fill(null),
        selected: null
      };
    case "SET_CONTAINER_ITEMS": {
      if (state.containerOpen !== action.containerItemId)
        return state;
      const items = (action.items || []).map(normalizeItem);
      const g = new Array(MIN_GRID_SIZE).fill(null);
      for (let i = 0; i < items.length && i < g.length; i++) {
        g[i] = items[i];
      }
      return { ...state, containerGrid: g };
    }
    case "INSPECT":
      return { ...state, inspecting: action.index, inspectPanel: action.panel };
    case "CLOSE_INSPECT":
      return { ...state, inspecting: null };
    case "SORT_ITEMS":
      return state;
    case "SET_CURRENCY":
      return {
        ...state,
        playerCash: action.cash !== void 0 ? action.cash : state.playerCash,
        playerGold: action.gold !== void 0 ? action.gold : state.playerGold
      };
    case "SET_ITEM_AMOUNT":
      return { ...state, itemAmount: action.amount };
    case "SET_SHOP_CURRENCY":
      return { ...state, shopPaymentCurrency: action.currency };
    case "SET_BUSY":
      return { ...state, isBusy: action.busy };
    case "SET_ADDITIONAL_METADATA": {
      const existing = state.additionalMetadata;
      const incoming = action.metadata;
      const newEntries = incoming.filter((e) => !existing.find((x) => x.value === e.value));
      return { ...state, additionalMetadata: [...existing, ...newEntries] };
    }
    case "SET_WORN_CLOTHING":
      return {
        ...state,
        wornClothingCategories: action.wornClothingCategories ?? state.wornClothingCategories,
        removedClothingCategories: action.removedClothingCategories !== void 0 ? action.removedClothingCategories : state.removedClothingCategories
      };
    case "TRADE_REQUEST":
      return { ...state, tradeRequest: { fromSrc: action.fromSrc, fromName: action.fromName, tradeId: action.tradeId } };
    case "TRADE_CLEAR_REQUEST":
      return { ...state, tradeRequest: null };
    case "TRADE_OPEN":
      return { ...state, tradeOpen: true, tradeCompleting: false, tradeId: action.tradeId, tradePartner: action.partnerName, myOffer: [], theirOffer: [], myConfirmed: false, theirConfirmed: false, tradeRequest: null };
    case "TRADE_UPDATE_THEIR":
      return { ...state, theirOffer: action.items || [], myConfirmed: false, theirConfirmed: false };
    case "TRADE_SET_MY_OFFER":
      return { ...state, myOffer: action.items || [], myConfirmed: false, theirConfirmed: false };
    case "TRADE_CONFIRM_RESET":
      return { ...state, myConfirmed: false, theirConfirmed: false };
    case "TRADE_MY_CONFIRM":
      return { ...state, myConfirmed: true };
    case "TRADE_PARTNER_CONFIRMED":
      return { ...state, theirConfirmed: true };
    case "TRADE_COMPLETING":
      return { ...state, tradeCompleting: true };
    case "TRADE_COMPLETE":
    case "TRADE_CANCELLED":
      return { ...state, tradeOpen: false, tradeCompleting: false, tradeId: null, tradePartner: "", myOffer: [], theirOffer: [], myConfirmed: false, theirConfirmed: false, tradeRequest: null };
    case "RESET":
      return {
        ...state,
        category: "all",
        search: "",
        selected: null,
        inspecting: null,
        rightInventory: null,
        rightGrid: [],
        containerOpen: null,
        containerGrid: new Array(MIN_GRID_SIZE).fill(null),
        tradeOpen: false,
        tradeCompleting: false,
        tradeId: null,
        tradePartner: "",
        myOffer: [],
        theirOffer: [],
        myConfirmed: false,
        theirConfirmed: false,
        tradeRequest: null
      };
    default:
      return state;
  }
}
function useInventory() {
  const [state, dispatch] = reactExports.useReducer(reducer, initial);
  const getGrid = reactExports.useCallback(
    (panel) => {
      if (panel === "container")
        return state.containerGrid;
      if (panel === "right")
        return state.rightGrid;
      return state.grid;
    },
    [state.grid, state.containerGrid, state.rightGrid]
  );
  const getItemsList = reactExports.useCallback(
    (panel) => getGrid(panel).filter((it) => it !== null),
    [getGrid]
  );
  return { state, dispatch, getGrid, getItemsList };
}

const isEnvBrowser = () => !Boolean(window.GetParentResourceName || window.invokeNative);

const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : "w_inventory";
let _imagepath = isEnvBrowser() ? "/images" : `https://cfx-nui-${resourceName}/web/images`;
function imageUrl(value) {
  if (value.startsWith("nui://"))
    return value.replace("nui://", "https://cfx-nui-");
  if (/^(https?:|data:|blob:)/i.test(value) || value.startsWith("/"))
    return value;
  const filename = /\.(png|webp|jpg|jpeg)(?:[?#]|$)/i.test(value) ? value : `${value}.png`;
  return `${_imagepath}/${filename}`;
}
function setImagePath(path) {
  if (path && path !== "")
    _imagepath = path.replace(/^nui:\/\//, "https://cfx-nui-").replace(/\/$/, "");
}
async function fetchNui(eventName, data) {
  if (isEnvBrowser())
    return void 0;
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 1e4);
  try {
    const resp = await fetch(`https://${resourceName}/${eventName}`, {
      method: "post",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify(data),
      signal: controller.signal
    });
    const text = await resp.text();
    return text ? JSON.parse(text) : void 0;
  } catch (e) {
    if (e.name === "AbortError") {
      console.warn(`[fetchNui] ${eventName} timed out after 10s`);
    }
    return void 0;
  } finally {
    clearTimeout(timer);
  }
}
function placeholderUrl() {
  return imageUrl("kit_pouch_kit.png");
}
function getItemUrl(item) {
  const name = typeof item === "string" ? item : item?.name;
  if (typeof name !== "string" || !name)
    return placeholderUrl();
  const lower = name.toLowerCase();
  const metadata = typeof item === "object" ? item.metadata : void 0;
  if (lower === "money" || lower === "cash")
    return imageUrl("money.png");
  if (metadata?.imageurl)
    return imageUrl(String(metadata.imageurl));
  if (metadata?.image)
    return imageUrl(String(metadata.image));
  const items = window.__oxItems || {};
  const definition = items[name] || items[lower] || items[name.toUpperCase()];
  const image = definition?.image || definition?.client?.image;
  return imageUrl(image || `${lower}.png`);
}
function itemImageError(target, item) {
  if (target.src === new URL(placeholderUrl(), window.location.href).href)
    return;
  const canonical = getItemUrl(typeof item === "string" ? item : item?.name);
  const fallback = target.src === new URL(canonical, window.location.href).href ? placeholderUrl() : canonical;
  if (target.src === new URL(fallback, window.location.href).href) {
    target.onerror = null;
    return;
  }
  target.src = fallback;
}

function useNui(dispatch, setVisible, addToast, hotbar, itemsDbRef) {
  const tradeTimerRef = reactExports.useRef(null);
  reactExports.useEffect(() => {
    function handler(event) {
      const msg = event.data;
      if (!msg || !msg.action)
        return;
      const payload = msg.data;
      switch (msg.action) {
        case "init": {
          if (payload.strings) {
            installLocale(payload.strings, payload.locale, payload.dir);
          }
          if (payload.items) {
            window.__oxItems = payload.items;
            itemsDbRef.current = payload.items;
            if (!payload.leftInventory)
              dispatch({ type: "RELABEL_ITEMS" });
          }
          if (payload.imagepath) {
            setImagePath(payload.imagepath);
          }
          if (payload.leftInventory) {
            dispatch({
              type: "SETUP_INVENTORY",
              leftInventory: payload.leftInventory,
              wornClothingCategories: payload.wornClothingCategories,
              removedClothingCategories: payload.removedClothingCategories
            });
          }
          break;
        }
        case "setupInventory": {
          dispatch({
            type: "SETUP_INVENTORY",
            leftInventory: payload.leftInventory,
            rightInventory: payload.rightInventory,
            wornClothingCategories: payload.wornClothingCategories,
            removedClothingCategories: payload.removedClothingCategories
          });
          setVisible(true);
          break;
        }
        case "setInventoryVisible":
          setVisible(payload);
          break;
        case "closeInventory":
          setVisible(false);
          dispatch({ type: "RESET" });
          break;
        case "refreshSlots":
          dispatch({
            type: "REFRESH_SLOTS",
            items: payload.items,
            itemCount: payload.itemCount,
            weightData: payload.weightData,
            slotsData: payload.slotsData
          });
          break;
        case "toggleHotbar":
          if (hotbar?.showHotbar)
            hotbar.showHotbar();
          break;
        case "updateCurrency":
          dispatch({ type: "SET_CURRENCY", cash: msg.cash, gold: msg.gold });
          break;
        case "displayMetadata":
          dispatch({ type: "SET_ADDITIONAL_METADATA", metadata: payload });
          break;
        case "setWornClothingCategories":
          dispatch({
            type: "SET_WORN_CLOTHING",
            wornClothingCategories: payload.wornClothingCategories,
            removedClothingCategories: payload.removedClothingCategories
          });
          break;
        case "itemNotify": {
          if (payload && Array.isArray(payload)) {
            const [slotData, text, count] = payload;
            const label = slotData?.label || slotData?.name || "";
            const localText = tr(text, text);
            const toastMsg = count ? `${localText} ${count}x ${label}` : `${localText} ${label}`;
            addToast(toastMsg.trim(), text === "ui_removed" ? "error" : "info");
          }
          break;
        }
        case "show":
          setVisible(true);
          break;
        case "hide":
          setVisible(false);
          dispatch({ type: "RESET" });
          break;
        case "setItems":
          dispatch({
            type: "SETUP_INVENTORY",
            leftInventory: {
              items: payload?.items || payload,
              maxWeight: payload?.maxWeight,
              slots: payload?.items?.length || 50,
              id: "player",
              type: "player"
            }
          });
          break;
        case "setContainerItems":
          dispatch({ type: "SET_CONTAINER_ITEMS", containerItemId: payload.containerItemId, items: payload.items });
          break;
        case "toast":
          addToast(payload.message, payload.type);
          break;
        case "loadHotbar":
          try {
            const parsed = JSON.parse(payload.slotsJson);
            if (hotbar?.loadSlots)
              hotbar.loadSlots(parsed);
          } catch (_) {
          }
          break;
        case "tradeRequest":
          dispatch({ type: "TRADE_REQUEST", fromSrc: payload.fromSrc, fromName: payload.fromName, tradeId: payload.tradeId });
          break;
        case "tradeAccepted":
          dispatch({ type: "TRADE_OPEN", tradeId: payload.tradeId, partnerName: payload.partnerName });
          break;
        case "tradeCancelled":
          dispatch({ type: "TRADE_CANCELLED" });
          addToast(payload.reason || tr("ui_trade_cancelled", "Trade cancelled."), "info");
          break;
        case "tradeUpdate":
          dispatch({ type: "TRADE_UPDATE_THEIR", items: payload.items });
          break;
        case "tradeConfirmReset":
          dispatch({ type: "TRADE_CONFIRM_RESET" });
          break;
        case "tradePartnerConfirmed":
          dispatch({ type: "TRADE_PARTNER_CONFIRMED" });
          addToast(tr("ui_trade_partner_confirmed", "The other player confirmed the trade."), "info");
          break;
        case "tradeComplete":
          dispatch({ type: "TRADE_COMPLETING" });
          if (tradeTimerRef.current)
            clearTimeout(tradeTimerRef.current);
          tradeTimerRef.current = setTimeout(() => {
            dispatch({ type: "TRADE_COMPLETE" });
            addToast(tr("ui_trade_complete", "Trade completed successfully!"), "success");
            tradeTimerRef.current = null;
          }, 2500);
          break;
      }
    }
    window.addEventListener("message", handler);
    return () => {
      window.removeEventListener("message", handler);
      if (tradeTimerRef.current)
        clearTimeout(tradeTimerRef.current);
    };
  }, [dispatch, setVisible, addToast, hotbar, itemsDbRef]);
}

const asset = (p) => typeof window !== "undefined" && typeof window.rsmAsset === "function" ? window.rsmAsset(p) : p;
const FILE = {
  open: "sounds/menu_open.mp3",
  close: "sounds/menu_close.mp3",
  pickup: "sounds/selected.mp3",
  drop: "sounds/button.mp3",
  equip: "sounds/coins.mp3",
  error: "sounds/button.mp3"
};
const VOL = {
  open: 0.6,
  close: 0.55,
  pickup: 0.5,
  drop: 0.45,
  equip: 0.75,
  error: 0.5
};
function useSound() {
  const poolRef = reactExports.useRef({});
  const play = reactExports.useCallback((name) => {
    try {
      const file = FILE[name];
      if (!file)
        return;
      let audio = poolRef.current[name];
      if (!audio) {
        audio = new Audio(asset(file));
        audio.preload = "auto";
        poolRef.current[name] = audio;
      }
      const node = audio.cloneNode(true);
      node.volume = VOL[name] ?? 0.4;
      node.play().catch(() => {
      });
    } catch (_) {
    }
  }, []);
  return play;
}

function useToast() {
  const [toasts, setToasts] = reactExports.useState([]);
  const idRef = reactExports.useRef(0);
  const timersRef = reactExports.useRef(/* @__PURE__ */ new Map());
  reactExports.useEffect(() => {
    return () => {
      for (const timers of timersRef.current.values()) {
        timers.forEach(clearTimeout);
      }
      timersRef.current.clear();
    };
  }, []);
  const addToast = reactExports.useCallback((message, type = "info") => {
    const id = ++idRef.current;
    setToasts((prev) => [...prev, { id, message, type, phase: "enter" }]);
    const timers = [];
    timers.push(setTimeout(() => {
      setToasts((prev) => prev.map((t) => t.id === id ? { ...t, phase: "show" } : t));
    }, 15));
    timers.push(setTimeout(() => {
      setToasts((prev) => prev.map((t) => t.id === id ? { ...t, phase: "fade-out" } : t));
      const removeTimer = setTimeout(() => {
        setToasts((prev) => prev.filter((t) => t.id !== id));
        timersRef.current.delete(id);
      }, 350);
      const existing = timersRef.current.get(id);
      if (existing)
        existing.push(removeTimer);
    }, 2800));
    timersRef.current.set(id, timers);
  }, []);
  return { toasts, addToast };
}

function wsScale() {
  const h = window.innerHeight || 1080;
  const w = window.innerWidth || 1920;
  return Math.max(0.6667, Math.min(h / 1080, w / 1920));
}
const wsPx = (n) => n * wsScale();
function wsGutter() {
  const h = window.innerHeight || 1080;
  const w = window.innerWidth || 1920;
  return Math.max(0, (w - h * 16 / 9) / 2);
}

function usePanelPosition(ref, preferred, active, extraWidth = 0) {
  const [size, setSize] = reactExports.useState({ width: 0, height: 0, screenW: window.innerWidth, screenH: window.innerHeight });
  reactExports.useLayoutEffect(() => {
    const element = ref.current;
    if (!active || !element)
      return;
    const measure = () => {
      const next = { width: element.offsetWidth, height: element.offsetHeight, screenW: window.innerWidth, screenH: window.innerHeight };
      setSize((old) => Object.keys(next).every((key) => old[key] === next[key]) ? old : next);
    };
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(element);
    window.addEventListener("resize", measure);
    return () => {
      observer.disconnect();
      window.removeEventListener("resize", measure);
    };
  }, [active, ref]);
  if (!preferred)
    return null;
  const m = wsPx(8);
  return {
    x: Math.max(m, Math.min(preferred.x, size.screenW - size.width - extraWidth - m)),
    y: Math.max(m, Math.min(preferred.y, size.screenH - size.height - m))
  };
}

const PANEL_W_REM = 24;
const CONTAINER_W_REM = 19;
const DETAIL_W_REM = 16;
const PANEL_GAP_REM = 0.75;
function remPx(n = 1) {
  const base = parseFloat(getComputedStyle(document.documentElement).fontSize);
  return n * (Number.isFinite(base) && base > 0 ? base : 16);
}
function savePanelPos(key, p) {
  const s = wsScale();
  try {
    localStorage.setItem(key, JSON.stringify({ x: (p.x - wsGutter()) / s, y: p.y / s, u: "design" }));
  } catch {
  }
}
function loadPanelPos(key) {
  try {
    const raw = localStorage.getItem(key);
    if (!raw)
      return null;
    const p = JSON.parse(raw);
    if (typeof p.x !== "number" || typeof p.y !== "number")
      return null;
    if (p.u !== "design")
      return { x: p.x, y: p.y };
    const s = wsScale();
    return { x: p.x * s + wsGutter(), y: p.y * s };
  } catch {
  }
  return null;
}

const HOTBAR_SIZE = 5;
function itemToHotbarSlot(item) {
  return {
    id: item.id || `${item.name}-${item.slot}`,
    name: item.name,
    label: item.label,
    isWeapon: !!item.isWeapon,
    weaponId: item.weaponId,
    canUse: !!item.canUse,
    equipped: !!item.equipped,
    slot: item.slot
  };
}
function useHotbar() {
  const [slots, setSlots] = reactExports.useState(() => new Array(HOTBAR_SIZE).fill(null));
  const [hotbarVisible, setHotbarVisible] = reactExports.useState(false);
  const hideTimer = reactExports.useRef(null);
  const slotsRef = reactExports.useRef(slots);
  slotsRef.current = slots;
  reactExports.useEffect(() => {
    return () => {
      if (hideTimer.current)
        clearTimeout(hideTimer.current);
    };
  }, []);
  const showHotbar = reactExports.useCallback(() => {
    setHotbarVisible(true);
    if (hideTimer.current)
      clearTimeout(hideTimer.current);
    hideTimer.current = setTimeout(() => {
      setHotbarVisible(false);
      hideTimer.current = null;
    }, 2500);
  }, []);
  const setVisible = reactExports.useCallback((visible) => {
    if (hideTimer.current) {
      clearTimeout(hideTimer.current);
      hideTimer.current = null;
    }
    setHotbarVisible(visible);
  }, []);
  const syncWithGrid = reactExports.useCallback((grid) => {
    setSlots((prev) => {
      const next = [];
      let changed = false;
      for (let i = 0; i < HOTBAR_SIZE; i++) {
        const gridItem = i < grid.length ? grid[i] : null;
        const prevSlot = prev[i] ?? null;
        if (!gridItem) {
          if (prevSlot !== null)
            changed = true;
          next.push(null);
        } else {
          const newSlot = itemToHotbarSlot(gridItem);
          if (!prevSlot || prevSlot.name !== newSlot.name || prevSlot.slot !== newSlot.slot || prevSlot.label !== newSlot.label || prevSlot.equipped !== newSlot.equipped) {
            changed = true;
          }
          next.push(newSlot);
        }
      }
      return changed ? next : prev;
    });
  }, []);
  const useSlot = reactExports.useCallback((slotIdx) => {
    const item = slotsRef.current[slotIdx];
    if (!item)
      return;
    fetchNui("useItem", item.slot);
  }, []);
  const loadSlots = reactExports.useCallback((_savedSlots) => {
  }, []);
  const resetSlots = reactExports.useCallback(() => {
    setSlots(new Array(HOTBAR_SIZE).fill(null));
  }, []);
  return { slots, hotbarVisible, showHotbar, setVisible, syncWithGrid, useSlot, loadSlots, resetSlots };
}

function formatCompact(n) {
  n = Number(n) || 0;
  if (n < 0)
    return "-" + formatCompact(-n);
  if (n < 1e3)
    return n % 1 === 0 ? n.toString() : n.toFixed(2);
  if (n < 1e6) {
    const k = n / 1e3;
    return k % 1 === 0 ? `${k}K` : `${parseFloat(k.toFixed(1))}K`;
  }
  if (n < 1e9) {
    const m = n / 1e6;
    return m % 1 === 0 ? `${m}M` : `${parseFloat(m.toFixed(1))}M`;
  }
  const b = n / 1e9;
  return b % 1 === 0 ? `${b}B` : `${parseFloat(b.toFixed(1))}B`;
}

function Slot({ item, idx, gridIndex, selected, panel, hotbarIndex, dimmed, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave }) {
  const { active } = useDndContext();
  const currentlyDragging = !!active;
  const isHotbarAssigned = hotbarIndex != null && hotbarIndex >= 0;
  const dragId = `drag:${panel}:${gridIndex}`;
  const dropId = item ? `drop:filled:${panel}:${gridIndex}` : `drop:empty:${panel}:${gridIndex}`;
  const draggable = useDraggable({
    id: dragId,
    disabled: !item || !!dimmed,
    data: { item, idx: gridIndex, panel, type: "item" }
  });
  const droppable = useDroppable({
    id: dropId,
    data: { item, idx: gridIndex, gridIndex, panel, filled: !!item }
  });
  if (!item) {
    return /* @__PURE__ */ jsx(
      "div",
      {
        className: `slot wf-slot${droppable.isOver ? " drag-over is-over" : ""}`,
        ref: droppable.setNodeRef,
        "data-grid-index": gridIndex,
        children: /* @__PURE__ */ jsx("div", { className: "slot-inner" })
      }
    );
  }
  const r = rarity(item);
  const cls = [
    "slot filled wf-slot is-filled",
    r,
    selected ? "selected is-picked" : "",
    draggable.isDragging ? "drag-source" : "",
    droppable.isOver ? "drag-over is-over" : "",
    item.isWeapon && item.equipped ? "weapon-equipped" : "",
    isHotbarAssigned ? "hotbar-assigned" : "",
    dimmed ? "filter-dimmed" : ""
  ].filter(Boolean).join(" ");
  const delay = Math.min(gridIndex * 0.025, 0.4);
  const pct = item.percentage != null ? item.percentage : null;
  let durClass = "high";
  if (pct !== null) {
    if (pct <= 25)
      durClass = "low";
    else if (pct <= 60)
      durClass = "mid";
  }
  return /* @__PURE__ */ jsx(
    "div",
    {
      className: cls,
      ref: (el) => {
        draggable.setNodeRef(el);
        droppable.setNodeRef(el);
      },
      "data-idx": gridIndex,
      "data-grid-index": gridIndex,
      style: { animationDelay: `${delay}s` },
      onClick: (e) => onSelect(gridIndex, panel, e),
      onDoubleClick: () => onDoubleClick(gridIndex, item),
      onContextMenu: (e) => onContextMenu(e, gridIndex, panel),
      onMouseOver: currentlyDragging ? void 0 : () => onMouseOver(gridIndex, panel),
      onMouseLeave: currentlyDragging ? void 0 : onMouseLeave,
      ...draggable.listeners,
      ...draggable.attributes,
      children: /* @__PURE__ */ jsxs("div", { className: "slot-inner", children: [
        item.isContainer && /* @__PURE__ */ jsx("div", { className: "bag-icon", children: SVG_BAG }),
        isHotbarAssigned && /* @__PURE__ */ jsx("div", { className: "hotbar-badge", children: hotbarIndex + 1 }),
        item.isWeapon && item.equipped && /* @__PURE__ */ jsx("div", { className: "equipped-badge", children: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", width: "10", height: "10", children: /* @__PURE__ */ jsx("path", { d: "M12 2L9 9H2l6 4.5L5.5 22 12 17l6.5 5L16 13.5 22 9h-7z" }) }) }),
        /* @__PURE__ */ jsx(
          "img",
          {
            src: getItemUrl(item),
            onError: (e) => {
              itemImageError(e.currentTarget, item);
            },
            draggable: false,
            alt: ""
          }
        ),
        item.count > 1 && /* @__PURE__ */ jsx("div", { className: "count", children: formatCompact(item.count) }),
        pct !== null && /* @__PURE__ */ jsx("div", { className: "durability-bar", children: /* @__PURE__ */ jsx("div", { className: `durability-fill ${durClass}`, style: { width: `${pct}%` } }) }),
        item.price != null && item.price > 0 && /* @__PURE__ */ jsx("div", { className: `price-badge${item.currency && item.currency !== "money" ? " currency-item" : ""}`, children: !item.currency || item.currency === "money" ? /* @__PURE__ */ jsxs("span", { className: "price-cash", children: [
          "$",
          formatCompact(item.price)
        ] }) : /* @__PURE__ */ jsx("span", { className: "price-custom", children: formatCompact(item.price) }) })
      ] })
    }
  );
}

function InventoryGrid({ grid, category, search, selected, panel, selectedPanel, inventorySlots, hotbarSlots, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave }) {
  const isFiltering = category !== "all" || search && search.length > 0;
  const hotbarMap = reactExports.useMemo(() => {
    const map = /* @__PURE__ */ new Map();
    if (panel === "main" && hotbarSlots) {
      for (let hi = 0; hi < hotbarSlots.length; hi++) {
        const hs = hotbarSlots[hi];
        if (!hs)
          continue;
        for (let gi = 0; gi < grid.length; gi++) {
          const it = grid[gi];
          if (it && it.slot === hs.slot && it.name === hs.name && !map.has(gi)) {
            map.set(gi, hi);
            break;
          }
        }
      }
    }
    return map;
  }, [panel, hotbarSlots, grid]);
  const filterSet = reactExports.useMemo(() => {
    if (!isFiltering)
      return null;
    const q = (search || "").toLowerCase();
    const matches = /* @__PURE__ */ new Set();
    for (let gi = 0; gi < grid.length; gi++) {
      const item = grid[gi];
      if (!item)
        continue;
      if (category !== "all" && (item.type || "item_misc") !== category)
        continue;
      if (q && (item.label || item.name).toLowerCase().indexOf(q) === -1)
        continue;
      matches.add(gi);
    }
    return matches;
  }, [grid, category, search, isFiltering]);
  const rendered = reactExports.useMemo(() => {
    let lastFilled = -1;
    for (let i = grid.length - 1; i >= 0; i--) {
      if (grid[i] !== null) {
        lastFilled = i;
        break;
      }
    }
    const minSlots = MIN_ROWS * COLS;
    const needed = Math.max(lastFilled + 1, minSlots, inventorySlots || 0);
    const totalSlots = Math.ceil(needed / COLS) * COLS;
    const slots = [];
    for (let gi = 0; gi < totalSlots; gi++) {
      const item = grid[gi] || null;
      const dimmed = filterSet !== null && item !== null && !filterSet.has(gi);
      slots.push(
        /* @__PURE__ */ jsx(
          Slot,
          {
            item,
            idx: gi,
            gridIndex: gi,
            selected: selectedPanel === panel && selected === gi,
            panel,
            hotbarIndex: hotbarMap.get(gi) ?? null,
            dimmed,
            onSelect,
            onContextMenu,
            onDoubleClick,
            onMouseOver,
            onMouseLeave
          },
          `s-${panel}-${gi}`
        )
      );
    }
    return slots;
  }, [grid, selected, selectedPanel, panel, hotbarMap, filterSet, inventorySlots, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave]);
  const hasItems = grid.some((it) => it !== null);
  return /* @__PURE__ */ jsxs(Fragment, { children: [
    /* @__PURE__ */ jsx("div", { className: "inv-grid", id: panel === "container" ? "container-grid" : panel === "right" ? "right-grid" : "inv-grid", style: { display: "grid" }, children: rendered }),
    panel === "main" && !hasItems && /* @__PURE__ */ jsxs("div", { id: "inv-empty", style: { display: "flex", pointerEvents: "none" }, children: [
      /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M20 6h-4V4c0-1.1-.9-2-2-2h-4c-1.1 0-2 .9-2 2v2H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm-6 0h-4V4h4v2z" }) }),
      /* @__PURE__ */ jsx("div", { className: "empty-text", children: tr("ui_bag_empty", "Your inventory is empty") }),
      /* @__PURE__ */ jsx("div", { className: "empty-hint", children: tr("ui_items_appear_here", "Your items will appear here") })
    ] })
  ] });
}

const setClipboard = (value) => {
  const clipElem = document.createElement("input");
  clipElem.value = value;
  document.body.appendChild(clipElem);
  clipElem.select();
  document.execCommand("copy");
  document.body.removeChild(clipElem);
};

function iso(value) {
  return "⁨" + String(value) + "⁩";
}
function kgShort(grams) {
  const kg = (Number(grams) || 0) / 1e3;
  const fixed = kg >= 10 ? kg.toFixed(0) : kg >= 1 ? kg.toFixed(1) : kg.toFixed(2);
  return String(parseFloat(fixed));
}
function itemsWord(n) {
  if (n <= 0)
    return tr("ui_nb_items_0", "empty");
  if (n === 1)
    return tr("ui_nb_items_1", "1 item");
  if (n === 2)
    return tr("ui_nb_items_2", "2 items");
  if (n <= 10)
    return trf("ui_nb_items_few", "%s items", iso(n));
  return trf("ui_nb_items_many", "%s items", iso(n));
}
function durabilityWord(pct) {
  if (pct <= 0)
    return tr("ui_nb_dur_broken", "Broken");
  if (pct <= 25)
    return tr("ui_nb_dur_low", "Nearly worn out");
  if (pct <= 60)
    return tr("ui_nb_dur_mid", "Worn");
  return tr("ui_nb_dur_high", "Good");
}
function fullnessWord(pct) {
  if (pct >= 100)
    return tr("ui_nb_full", "full");
  if (pct >= 85)
    return tr("ui_nb_near_full", "almost full");
  return "";
}

function Ready({ missing, note, fix, onFix }) {
  if (missing) {
    return /* @__PURE__ */ jsxs("div", { className: "nb-ready is-missing", children: [
      /* @__PURE__ */ jsx("span", { className: "nb-ready-text", children: missing }),
      onFix && /* @__PURE__ */ jsx("button", { type: "button", className: "nb-fix", onClick: onFix, children: fix })
    ] });
  }
  return /* @__PURE__ */ jsx("div", { className: "nb-ready", children: /* @__PURE__ */ jsx("span", { className: "nb-ready-text", children: note }) });
}
function Fold({ title, children }) {
  const [open, setOpen] = reactExports.useState(false);
  return /* @__PURE__ */ jsxs("div", { className: "nb-fold" + (open ? " is-open" : ""), children: [
    /* @__PURE__ */ jsxs("button", { type: "button", className: "nb-fold-head", onClick: () => setOpen((v) => !v), "aria-expanded": open, children: [
      /* @__PURE__ */ jsx("span", { children: title }),
      /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "none", stroke: "currentColor", strokeWidth: "2.2", "aria-hidden": "true", children: /* @__PURE__ */ jsx("path", { d: "M6 9l6 6 6-6" }) })
    ] }),
    open && /* @__PURE__ */ jsx("div", { className: "nb-fold-body", children })
  ] });
}
function Keys({ keys }) {
  return /* @__PURE__ */ jsx("div", { className: "nb-keys", children: keys.map(([key, label]) => /* @__PURE__ */ jsxs("span", { className: "nb-key", children: [
    /* @__PURE__ */ jsx("kbd", { className: "nb-keychip", children: key }),
    /* @__PURE__ */ jsx("span", { children: label })
  ] }, key + label)) });
}

function sameText(a, b) {
  const norm = (s) => String(s ?? "").normalize("NFKC").replace(/[\u200e\u200f\u061c]/g, "").replace(/[\s.\u06d4\u2026!?\u061f,\u060c:;\-\u2013\u2014]+/g, " ").trim().toLowerCase();
  const left = norm(a);
  return left !== "" && left === norm(b);
}
const SHOWN_META = /* @__PURE__ */ new Set([
  "label",
  "description",
  "descriptionKey",
  "descriptionArgs",
  "durability",
  "ammo",
  "serial",
  "serial_number",
  "container",
  "containerMaxWeight",
  "containerContentWeight",
  "containerSlots",
  "image",
  "imageurl"
]);
function metaRows(meta) {
  if (!meta || typeof meta !== "object")
    return [];
  const rows = [];
  for (const [key, value] of Object.entries(meta)) {
    if (SHOWN_META.has(key) || value == null || value === "")
      continue;
    let text = typeof value === "object" ? JSON.stringify(value) : String(value);
    if (text.length > 48)
      text = text.slice(0, 47) + "…";
    rows.push([key, text]);
    if (rows.length >= 12)
      break;
  }
  return rows;
}
function DetailPanel({ item, panel, containerOpen, panelPos }) {
  const panelRef = reactExports.useRef(null);
  const bodyRef = reactExports.useRef(null);
  const [fade, setFade] = reactExports.useState({ top: false, bottom: false });
  const extra = PANEL_W_REM + PANEL_GAP_REM + (containerOpen !== null ? CONTAINER_W_REM + PANEL_GAP_REM : 0);
  const fitted = usePanelPosition(panelRef, panelPos ? { x: panelPos.x + remPx(extra), y: panelPos.y } : null, !!item);
  const itemKey = item ? `${panel}:${item.slot}:${item.name}` : "";
  reactExports.useLayoutEffect(() => {
    if (bodyRef.current)
      bodyRef.current.scrollTop = 0;
  }, [itemKey]);
  reactExports.useLayoutEffect(() => {
    const body = bodyRef.current;
    if (!body)
      return;
    const measure = () => {
      const top = body.scrollTop > 1;
      const bottom = body.scrollTop + body.clientHeight < body.scrollHeight - 1;
      setFade((old) => old.top === top && old.bottom === bottom ? old : { top, bottom });
    };
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(body);
    Array.from(body.children).forEach((child) => observer.observe(child));
    body.addEventListener("scroll", measure, { passive: true });
    return () => {
      observer.disconnect();
      body.removeEventListener("scroll", measure);
    };
  }, [item]);
  if (!item)
    return /* @__PURE__ */ jsx("div", { id: "inventory-detail", style: { display: "none" } });
  const r = rarity(item);
  const shifted = containerOpen !== null;
  const ammoEntries = item.ammo ? Object.entries(item.ammo).filter(([, v]) => v > 0) : [];
  const pctRound = item.percentage != null ? Math.round(item.percentage) : null;
  const title = item.label || item.name;
  const desc = item.desc && !sameText(item.desc, title) && !sameText(item.desc, item.name) ? item.desc : null;
  const unitGrams = item.count > 1 ? N(item.weight) / item.count : N(item.weight);
  const plain = item.count > 1 ? trf("ui_nb_detail_many", "You have %s · %s kg each, %s kg in all.", iso(item.count), iso(kgShort(unitGrams)), iso(kgShort(N(item.weight)))) : trf("ui_nb_detail_one", "It weighs %s kg.", iso(kgShort(unitGrams)));
  const serialRaw = item.isWeapon ? item.metadata?.serial || item.metadata?.serial_number : null;
  const serial = serialRaw ? String(serialRaw) : null;
  const rawMeta = metaRows(item.metadata);
  const posStyle = fitted ? {
    left: `${fitted.x}px`,
    top: `${fitted.y}px`,
    transform: "none"
  } : {};
  return /* @__PURE__ */ jsxs(
    "div",
    {
      id: "inventory-detail",
      ref: panelRef,
      className: "wf-shell" + (fitted ? " positioned" : shifted ? " shifted" : ""),
      style: { display: "flex", ...posStyle },
      onWheel: (e) => {
        const body = bodyRef.current;
        if (body && !body.contains(e.target))
          body.scrollTop += e.deltaY;
      },
      children: [
        /* @__PURE__ */ jsxs("div", { className: `detail-hero ${r}`, children: [
          /* @__PURE__ */ jsx("div", { className: "detail-img-wrap", children: /* @__PURE__ */ jsx(
            "img",
            {
              src: getItemUrl(item),
              onError: (e) => {
                itemImageError(e.currentTarget, item);
              },
              alt: ""
            }
          ) }),
          /* @__PURE__ */ jsx("div", { className: "detail-name", children: title }),
          /* @__PURE__ */ jsx("div", { className: `detail-rarity ${r}`, children: rarityLabel(r) })
        ] }),
        /* @__PURE__ */ jsx("div", { className: "detail-sep" }),
        /* @__PURE__ */ jsxs("div", { ref: bodyRef, className: "detail-body" + (fade.top ? " fade-top" : "") + (fade.bottom ? " fade-bottom" : ""), children: [
          desc && /* @__PURE__ */ jsx("div", { className: "detail-desc", children: desc }),
          /* @__PURE__ */ jsx("div", { className: "detail-plain", children: plain }),
          /* @__PURE__ */ jsxs("div", { className: "detail-stats", children: [
            item.isContainer && /* @__PURE__ */ jsxs("div", { className: "detail-stat", children: [
              /* @__PURE__ */ jsx("span", { className: "lbl", children: tr("ui_storage", "Storage") }),
              /* @__PURE__ */ jsxs("span", { className: "val", children: [
                fmtWeight(N(item.containerContentWeight)),
                "/",
                fmtWeight(N(item.containerMaxWeight))
              ] })
            ] }),
            item.isWeapon && /* @__PURE__ */ jsxs("div", { className: "detail-stat", children: [
              /* @__PURE__ */ jsx("span", { className: "lbl", children: tr("ui_status", "Status") }),
              /* @__PURE__ */ jsx("span", { className: `val nb-words ${item.equipped ? "equipped-text" : ""}`, children: item.equipped ? tr("ui_equipped", "Equipped") : tr("ui_in_bag", "In bag") })
            ] }),
            ammoEntries.map(([type, count]) => /* @__PURE__ */ jsxs("div", { className: "detail-stat", children: [
              /* @__PURE__ */ jsx("span", { className: "lbl", children: tr("ui_ammo", "Ammo") }),
              /* @__PURE__ */ jsx("span", { className: "val", children: count })
            ] }, type)),
            pctRound != null && /* @__PURE__ */ jsxs("div", { className: "detail-stat", children: [
              /* @__PURE__ */ jsx("span", { className: "lbl", children: tr("ui_durability", "Durability") }),
              /* @__PURE__ */ jsxs("span", { className: `val nb-words dur-${pctRound <= 25 ? "low" : pctRound <= 60 ? "mid" : "high"}`, children: [
                durabilityWord(pctRound),
                " · ",
                iso(pctRound + "%")
              ] })
            ] })
          ] }),
          /* @__PURE__ */ jsx(Fold, { title: tr("ui_nb_advanced", "Advanced options"), children: /* @__PURE__ */ jsxs("div", { className: "detail-stats nb-adv", children: [
            /* @__PURE__ */ jsxs("div", { className: "detail-stat", children: [
              /* @__PURE__ */ jsx("span", { className: "lbl", children: tr("ui_nb_item_id", "Item id") }),
              /* @__PURE__ */ jsx("span", { className: "val", children: item.name })
            ] }),
            /* @__PURE__ */ jsxs("div", { className: "detail-stat", children: [
              /* @__PURE__ */ jsx("span", { className: "lbl", children: tr("ui_nb_slot", "Slot") }),
              /* @__PURE__ */ jsx("span", { className: "val", children: item.slot })
            ] }),
            serial && /* @__PURE__ */ jsxs(
              "div",
              {
                className: "detail-stat",
                style: { cursor: "pointer" },
                title: tr("ui_click_copy_serial", "Click to copy serial number"),
                onClick: () => setClipboard(serial),
                children: [
                  /* @__PURE__ */ jsx("span", { className: "lbl", children: tr("ui_serial", "Serial number") }),
                  /* @__PURE__ */ jsxs("span", { className: "val", style: { fontSize: ".42rem", letterSpacing: ".04em" }, children: [
                    serial,
                    " ⧉"
                  ] })
                ]
              }
            ),
            rawMeta.map(([key, value]) => /* @__PURE__ */ jsxs("div", { className: "detail-stat", children: [
              /* @__PURE__ */ jsx("span", { className: "lbl nb-raw", children: key }),
              /* @__PURE__ */ jsx("span", { className: "val nb-raw", children: value })
            ] }, key))
          ] }) }, itemKey)
        ] }),
        /* @__PURE__ */ jsx("div", { className: "detail-sep" }),
        /* @__PURE__ */ jsxs("div", { className: "detail-hint", children: [
          /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", style: { width: ".5rem", height: ".5rem", opacity: 0.4 }, children: /* @__PURE__ */ jsx("path", { d: "M2 12C2 6.48 6.48 2 12 2s10 4.48 10 10-4.48 10-10 10S2 17.52 2 12zm11-1v6h-2v-6h2zm0-4v2h-2V7h2z" }) }),
          tr("ui_right_click_options", "Right-click for options")
        ] })
      ]
    }
  );
}

const SVG_LOCK = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM9 8V6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9z" }) });
const SVG_UNLOCK = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6h2c0-1.66 1.34-3 3-3s3 1.34 3 3v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2z" }) });
const SVG_WEIGHT = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", style: { width: ".55rem", height: ".55rem" }, children: /* @__PURE__ */ jsx("path", { d: "M12 3a4 4 0 0 0-3.46 2H4l1.5 13.5C5.73 20.44 7.41 21 8 21h8c.59 0 2.27-.56 2.5-2.5L20 5h-4.54A4 4 0 0 0 12 3zm0 2a2 2 0 1 1 0 4 2 2 0 0 1 0-4z" }) });
function ContainerPanel({ containerOpen, containerGrid, containerLabel, containerMaxWeight, containerSlots, selected, selectedPanel, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave, onClose, panelPos }) {
  const [entered, setEntered] = reactExports.useState(false);
  const panelRef = reactExports.useRef(null);
  const fitted = usePanelPosition(panelRef, panelPos ? { x: panelPos.x + remPx(PANEL_W_REM + PANEL_GAP_REM), y: panelPos.y } : null, containerOpen !== null);
  reactExports.useEffect(() => {
    if (containerOpen !== null) {
      requestAnimationFrame(() => requestAnimationFrame(() => setEntered(true)));
    } else {
      setEntered(false);
    }
  }, [containerOpen]);
  const { cw, itemCount } = reactExports.useMemo(() => {
    let w = 0, n = 0;
    for (const it of containerGrid) {
      if (!it)
        continue;
      w += N(it.weight) * it.count;
      n++;
    }
    return { cw: w, itemCount: n };
  }, [containerGrid]);
  if (containerOpen === null)
    return /* @__PURE__ */ jsx("div", { id: "container-panel", style: { display: "none" } });
  const wp = containerMaxWeight > 0 ? Math.min(100, cw / containerMaxWeight * 100) : 0;
  const weightZone = wp > 90 ? "critical" : wp > 70 ? "warn" : "ok";
  const slotPct = containerSlots > 0 ? Math.min(100, itemCount / containerSlots * 100) : 0;
  const cpPosStyle = fitted ? {
    left: `${fitted.x}px`,
    top: `${fitted.y}px`,
    transform: entered ? "none" : "translateX(-10px) scale(.97)"
  } : {};
  return /* @__PURE__ */ jsxs("div", { id: "container-panel", ref: panelRef, className: "wf-shell" + (entered ? " cp-entered" : ""), style: { display: "flex", ...cpPosStyle }, children: [
    /* @__PURE__ */ jsxs("div", { className: "cp-header", children: [
      /* @__PURE__ */ jsxs("div", { className: "cp-title-area", children: [
        /* @__PURE__ */ jsx("div", { className: "cp-icon", children: SVG_BAG }),
        /* @__PURE__ */ jsxs("div", { className: "cp-title-text", children: [
          /* @__PURE__ */ jsx("div", { className: "cp-title", children: containerLabel }),
          /* @__PURE__ */ jsx("div", { className: "cp-subtitle", children: (itemCount === 0 ? tr("ui_nb_side_empty", "Nothing inside") : trf("ui_nb_side_has", "Holds %s", itemsWord(itemCount))) + (containerMaxWeight > 0 ? " · " + trf("ui_nb_kg_of", "%s of %s kg", iso(kgShort(cw)), iso(kgShort(containerMaxWeight))) : "") })
        ] })
      ] }),
      /* @__PURE__ */ jsx("div", { className: "cp-close", onClick: onClose, children: SVG_X })
    ] }),
    /* @__PURE__ */ jsxs("div", { className: "cp-metrics", children: [
      /* @__PURE__ */ jsxs("div", { className: `cp-metric ${weightZone}`, children: [
        /* @__PURE__ */ jsxs("div", { className: "cp-metric-header", children: [
          SVG_WEIGHT,
          /* @__PURE__ */ jsx("span", { className: "cp-metric-label", children: tr("ui_weight", "Weight") }),
          /* @__PURE__ */ jsxs("span", { className: "cp-metric-value", children: [
            fmtWeight(cw),
            " / ",
            fmtWeight(containerMaxWeight)
          ] })
        ] }),
        /* @__PURE__ */ jsxs("div", { className: "cp-bar", children: [
          /* @__PURE__ */ jsx("div", { className: "cp-bar-fill", style: { width: `${wp}%` } }),
          wp > 70 && /* @__PURE__ */ jsx("div", { className: "cp-bar-marker", style: { left: "70%" } }),
          wp > 90 && /* @__PURE__ */ jsx("div", { className: "cp-bar-marker warn", style: { left: "90%" } })
        ] })
      ] }),
      /* @__PURE__ */ jsxs("div", { className: "cp-metric", children: [
        /* @__PURE__ */ jsxs("div", { className: "cp-metric-header", children: [
          /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", style: { width: ".55rem", height: ".55rem" }, children: /* @__PURE__ */ jsx("path", { d: "M4 8h4V4H4v4zm6 12h4v-4h-4v4zm-6 0h4v-4H4v4zm0-6h4v-4H4v4zm6 0h4v-4h-4v4zm6-10v4h4V4h-4zm-6 4h4V4h-4v4zm6 6h4v-4h-4v4zm0 6h4v-4h-4v4z" }) }),
          /* @__PURE__ */ jsx("span", { className: "cp-metric-label", children: tr("ui_slots", "Slots") }),
          /* @__PURE__ */ jsxs("span", { className: "cp-metric-value", children: [
            itemCount,
            " / ",
            containerSlots
          ] })
        ] }),
        /* @__PURE__ */ jsx("div", { className: "cp-bar", children: /* @__PURE__ */ jsx("div", { className: "cp-bar-fill slots", style: { width: `${slotPct}%` } }) })
      ] })
    ] }),
    /* @__PURE__ */ jsx("div", { className: "cp-divider" }),
    itemCount === 0 ? /* @__PURE__ */ jsxs("div", { className: "cp-empty", children: [
      /* @__PURE__ */ jsx("div", { className: "cp-empty-icon", children: SVG_UNLOCK }),
      /* @__PURE__ */ jsx("div", { className: "cp-empty-text", children: tr("ui_empty", "Empty") }),
      /* @__PURE__ */ jsx("div", { className: "cp-empty-hint", children: tr("ui_container_empty_hint", "Drag items here or right-click to store") })
    ] }) : /* @__PURE__ */ jsx(
      InventoryGrid,
      {
        grid: containerGrid,
        category: "all",
        search: "",
        selected,
        panel: "container",
        selectedPanel,
        onSelect,
        onContextMenu,
        onDoubleClick,
        onMouseOver,
        onMouseLeave
      }
    ),
    /* @__PURE__ */ jsxs("div", { className: "cp-footer", children: [
      /* @__PURE__ */ jsx("div", { className: "cp-footer-lock", children: itemCount > 0 ? SVG_LOCK : SVG_UNLOCK }),
      /* @__PURE__ */ jsx("span", { children: tr("ui_drag_between_panels", "Drag items between panels") })
    ] })
  ] });
}

const RIGHT_POS_KEY = "w_inv_right_pos";
const SVG_SHOP = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M12 2a5 5 0 0 0-5 5H4l-1 13a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2L20 7h-3a5 5 0 0 0-5-5zm0 2a3 3 0 0 1 3 3H9a3 3 0 0 1 3-3zm-3 7a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm6 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z" }) });
const SVG_CRAFT = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M13.7 8.3 6.4 15.6l-1.4-1.4a2 2 0 0 0-2.8 2.8l4.8 4.8a2 2 0 0 0 2.8-2.8l-1.4-1.4 7.3-7.3-2-2zM22 5.6 18.4 2l-2.1 2.1-1-1a1 1 0 0 0-1.5 0l-1.6 1.6a1 1 0 0 0 0 1.4l5.7 5.7a1 1 0 0 0 1.4 0l1.6-1.6a1 1 0 0 0 0-1.5l-1-1L22 5.6z" }) });
function loadRightPos() {
  return loadPanelPos(RIGHT_POS_KEY);
}
function RightInventoryPanel({
  rightInventory,
  rightGrid,
  selected,
  selectedPanel,
  onSelect,
  onContextMenu,
  onDoubleClick,
  onMouseOver,
  onMouseLeave,
  playerCash,
  playerGold,
  shopPaymentCurrency,
  onSetPaymentCurrency,
  itemAmount,
  onSetItemAmount
}) {
  const [rightPos, setRightPos] = reactExports.useState(loadRightPos);
  const [rpAnimating, setRpAnimating] = reactExports.useState(false);
  const rightRef = reactExports.useRef(null);
  const dragRef = reactExports.useRef(null);
  const isOpen = !!(rightInventory && rightInventory.type !== "newdrop");
  const fittedRightPos = usePanelPosition(rightRef, rightPos, isOpen);
  reactExports.useEffect(() => {
    if (isOpen) {
      setRpAnimating(false);
      requestAnimationFrame(() => {
        requestAnimationFrame(() => setRpAnimating(true));
      });
    } else {
      setRpAnimating(false);
    }
  }, [isOpen]);
  const handleDragStart = reactExports.useCallback((e) => {
    e.preventDefault();
    const el = rightRef.current;
    if (!el)
      return;
    const rect = el.getBoundingClientRect();
    dragRef.current = { startX: e.clientX, startY: e.clientY, origX: rect.left, origY: rect.top };
    const onMove = (ev) => {
      if (!dragRef.current)
        return;
      setRightPos({
        x: dragRef.current.origX + (ev.clientX - dragRef.current.startX),
        y: dragRef.current.origY + (ev.clientY - dragRef.current.startY)
      });
    };
    const onUp = () => {
      document.removeEventListener("mousemove", onMove);
      document.removeEventListener("mouseup", onUp);
      setRightPos((cur) => {
        if (cur)
          savePanelPos(RIGHT_POS_KEY, cur);
        return cur;
      });
      dragRef.current = null;
    };
    document.addEventListener("mousemove", onMove);
    document.addEventListener("mouseup", onUp);
  }, []);
  const { totalWeight, itemCount } = reactExports.useMemo(() => {
    let w = 0, n = 0;
    for (const it of rightGrid) {
      if (!it)
        continue;
      w += N(it.weight) * it.count;
      n++;
    }
    return { totalWeight: w, itemCount: n };
  }, [rightGrid]);
  if (!rightInventory || rightInventory.type === "newdrop")
    return null;
  const isShop = rightInventory.type === "shop";
  const isCrafting = rightInventory.type === "crafting";
  const maxW = rightInventory.maxWeight != null ? Number(rightInventory.maxWeight) : 0;
  const sidePct = maxW > 0 ? totalWeight / maxW * 100 : 0;
  const sideFull = fullnessWord(sidePct);
  const sideLead = (itemCount === 0 ? tr("ui_nb_side_empty", "Nothing inside") : trf("ui_nb_side_has", "Holds %s", itemsWord(itemCount))) + (maxW > 0 ? " · " + trf("ui_nb_kg_of", "%s of %s kg", iso(kgShort(totalWeight)), iso(kgShort(maxW))) : "") + (sideFull ? " · " + sideFull : "");
  const posStyle = fittedRightPos ? {
    position: "fixed",
    left: `${fittedRightPos.x}px`,
    top: `${fittedRightPos.y}px`,
    right: "auto",
    opacity: rpAnimating ? 1 : 0,
    transform: rpAnimating ? "none" : "scale(.8)"
  } : {
    opacity: rpAnimating ? 1 : 0,
    transform: rpAnimating ? "translateY(-50%)" : "translateY(-50%) scale(.8)"
  };
  return /* @__PURE__ */ jsxs("div", { id: "right-inventory-panel", className: "wf-shell", ref: rightRef, style: { display: "flex", ...posStyle }, children: [
    /* @__PURE__ */ jsxs("div", { className: "rp-header", onMouseDown: handleDragStart, style: { cursor: "grab" }, children: [
      /* @__PURE__ */ jsx("div", { className: "inv-badge", children: isShop ? SVG_SHOP : isCrafting ? SVG_CRAFT : SVG_BAG }),
      /* @__PURE__ */ jsxs("div", { className: "rp-title-area", children: [
        /* @__PURE__ */ jsx("div", { className: "rp-title", children: rightInventory.label || tr(`ui_inv_${rightInventory.type}`, rightInventory.type) }),
        /* @__PURE__ */ jsx("div", { className: "rp-subtitle", children: isShop ? tr("ui_shop_drag_hint", "Drag items to your inventory to purchase") : isCrafting ? tr("ui_crafting_drag_hint", "Drag items to your inventory to craft") : sideLead })
      ] })
    ] }),
    isShop && /* @__PURE__ */ jsxs("div", { className: "rp-shop-controls", children: [
      /* @__PURE__ */ jsxs("div", { className: "rp-currency-toggle", children: [
        /* @__PURE__ */ jsxs(
          "button",
          {
            type: "button",
            className: `rp-currency-btn ${shopPaymentCurrency === "cash" ? "active" : ""}`,
            onClick: () => onSetPaymentCurrency("cash"),
            children: [
              /* @__PURE__ */ jsx("span", { className: "rp-currency-icon", children: SVG_CASH }),
              /* @__PURE__ */ jsx("span", { children: formatCompact(playerCash) })
            ]
          }
        ),
        /* @__PURE__ */ jsxs(
          "button",
          {
            type: "button",
            className: `rp-currency-btn gold ${shopPaymentCurrency === "gold" ? "active" : ""}`,
            onClick: () => onSetPaymentCurrency("gold"),
            children: [
              /* @__PURE__ */ jsx("span", { className: "rp-currency-icon gold", children: SVG_GOLD }),
              /* @__PURE__ */ jsx("span", { children: formatCompact(playerGold) })
            ]
          }
        )
      ] }),
      /* @__PURE__ */ jsxs("div", { className: "rp-amount-control", children: [
        /* @__PURE__ */ jsx("label", { className: "rp-amount-label", children: tr("ui_quantity", "Quantity") }),
        /* @__PURE__ */ jsx(
          "input",
          {
            type: "number",
            className: "rp-amount-input",
            value: itemAmount || "",
            min: 0,
            onChange: (e) => onSetItemAmount(parseInt(e.target.value) || 0),
            placeholder: "0"
          }
        )
      ] })
    ] }),
    !isShop && !isCrafting && /* @__PURE__ */ jsxs("div", { className: "rp-amount-row", children: [
      /* @__PURE__ */ jsx("label", { className: "rp-amount-label", children: tr("ui_quantity", "Quantity") }),
      /* @__PURE__ */ jsx(
        "input",
        {
          type: "number",
          className: "rp-amount-input",
          value: itemAmount || "",
          min: 0,
          onChange: (e) => onSetItemAmount(parseInt(e.target.value) || 0),
          placeholder: "0"
        }
      )
    ] }),
    !isShop && rightInventory.maxWeight != null && /* @__PURE__ */ jsx("div", { className: "rp-weight-bar", title: `${fmtWeight(totalWeight)} / ${fmtWeight(rightInventory.maxWeight)}`, children: /* @__PURE__ */ jsx("div", { className: "rp-bar", children: /* @__PURE__ */ jsx(
      "div",
      {
        className: "rp-bar-fill" + (sidePct >= 85 ? " critical" : ""),
        style: { width: `${Math.min(100, totalWeight / (rightInventory.maxWeight || 1) * 100)}%` }
      }
    ) }) }),
    /* @__PURE__ */ jsx(
      InventoryGrid,
      {
        grid: rightGrid,
        category: "all",
        search: "",
        selected,
        panel: "right",
        selectedPanel,
        inventorySlots: rightInventory.slots,
        onSelect,
        onContextMenu,
        onDoubleClick,
        onMouseOver,
        onMouseLeave
      }
    )
  ] });
}

const SVG_USE = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M8 5v14l11-7z" }) });
const SVG_SPLIT = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M14 4l2.29 2.29-2.88 2.88 1.42 1.42 2.88-2.88L20 10V4h-6zm-4 0H4v6l2.29-2.29 4.71 4.7V20h2v-8.41l-5.29-5.3L10 4z" }) });
const SVG_STORE = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-2 10h-4v4h-2v-4H7v-2h4V7h2v4h4v2z" }) });
const SVG_DROP = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z" }) });
const SVG_TAKE = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M19 12v7H5v-7H3v7c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zm-6 .67l2.59-2.58L17 11.5l-5 5-5-5 1.41-1.41L11 12.67V3h2v9.67z" }) });
const SVG_GIVE = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" }) });
const SVG_UNLOAD = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M7 3h10v2H7V3zm1 4h8l2 4v8a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2v-8l2-4zm2 3-1 2v6h6v-6l-1-2h-4zm-7 1h2v8H3v-8zm16 0h2v8h-2v-8z" }) });
function ContextMenu({ visible, x, y, item, idx, panel, containerOpen, onClose, onUse, onDrop, onGive, onInspect, onOpenContainer, onStoreIn, onTakeOut, onSplit, onRemoveAmmo, customButtons, onCustomButton, giveCount }) {
  const ref = reactExports.useRef(null);
  reactExports.useEffect(() => {
    if (!visible)
      return;
    function handler(e) {
      if (ref.current && !ref.current.contains(e.target))
        onClose();
    }
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, [visible, onClose]);
  reactExports.useEffect(() => {
    if (visible && ref.current) {
      ref.current.style.opacity = "0";
      const m = wsPx(8);
      ref.current.style.left = `${Math.max(m, Math.min(x, window.innerWidth - ref.current.offsetWidth - m))}px`;
      ref.current.style.top = `${Math.max(m, Math.min(y, window.innerHeight - ref.current.offsetHeight - m))}px`;
      requestAnimationFrame(() => {
        if (ref.current)
          ref.current.style.opacity = "1";
      });
    }
  }, [visible, x, y]);
  if (!visible || !item || idx === null)
    return /* @__PURE__ */ jsx("div", { id: "inventory-options" });
  const sections = [];
  if (panel === "main") {
    const primary = [];
    if (item.isContainer) {
      primary.push(
        /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
          onOpenContainer(idx);
          onClose();
        }, children: [
          SVG_BAG,
          " ",
          /* @__PURE__ */ jsx("span", { children: tr("ui_open", "Open") }),
          " ",
          /* @__PURE__ */ jsx("kbd", { className: "opt-key", children: tr("ui_double_click", "Double-click") })
        ] }, "open")
      );
    } else {
      primary.push(
        /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
          onUse(idx);
          onClose();
        }, children: [
          SVG_USE,
          " ",
          /* @__PURE__ */ jsx("span", { children: tr("ui_use", "Use") }),
          " ",
          /* @__PURE__ */ jsx("kbd", { className: "opt-key", children: tr("ui_double_click", "Double-click") })
        ] }, "use")
      );
    }
    primary.push(
      /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
        onInspect(idx, "main");
        onClose();
      }, children: [
        SVG_EYE,
        " ",
        /* @__PURE__ */ jsx("span", { children: tr("ui_inspect", "Inspect") })
      ] }, "inspect")
    );
    if (primary.length > 0)
      sections.push(primary);
    const secondary = [];
    if (item.count > 1) {
      secondary.push(
        /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
          onSplit(idx, panel);
          onClose();
        }, children: [
          SVG_SPLIT,
          " ",
          /* @__PURE__ */ jsx("span", { children: tr("ui_split", "Split") })
        ] }, "split")
      );
    }
    if (containerOpen !== null && !item.isContainer) {
      secondary.push(
        /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
          onStoreIn(idx);
          onClose();
        }, children: [
          SVG_STORE,
          " ",
          /* @__PURE__ */ jsx("span", { children: tr("ui_store_container", "Store in container") })
        ] }, "store")
      );
    }
    if (Number(item.metadata?.ammo || 0) > 0) {
      secondary.push(
        /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
          onRemoveAmmo(idx);
          onClose();
        }, children: [
          SVG_UNLOAD,
          " ",
          /* @__PURE__ */ jsx("span", { children: tr("ui_remove_ammo", "Remove ammo") })
        ] }, "unload-ammo")
      );
    }
    if (customButtons && customButtons.length > 0 && onCustomButton) {
      for (const btn of customButtons) {
        secondary.push(
          /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
            onCustomButton(idx, btn.id);
            onClose();
          }, children: [
            SVG_USE,
            " ",
            /* @__PURE__ */ jsx("span", { children: btn.label })
          ] }, `btn-${btn.id}-${btn.label}`)
        );
      }
    }
    if (secondary.length > 0)
      sections.push(secondary);
    const danger = [];
    danger.push(
      /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
        onGive(idx);
        onClose();
      }, children: [
        SVG_GIVE,
        " ",
        /* @__PURE__ */ jsxs("span", { children: [
          tr("ui_give", "Give"),
          giveCount != null && giveCount > 0 && item && /* @__PURE__ */ jsx("small", { className: "nb-opt-sub", children: trf("ui_nb_give_to", "you give %s %s to the player beside you", iso(giveCount), item.label || item.name) })
        ] })
      ] }, "give")
    );
    danger.push(
      /* @__PURE__ */ jsxs("div", { className: "option danger", onClick: () => {
        onDrop(idx);
        onClose();
      }, children: [
        SVG_DROP,
        " ",
        /* @__PURE__ */ jsx("span", { children: tr("ui_drop", "Drop") })
      ] }, "drop")
    );
    sections.push(danger);
  } else if (panel === "container") {
    sections.push([
      /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
        onTakeOut(idx);
        onClose();
      }, children: [
        SVG_TAKE,
        " ",
        /* @__PURE__ */ jsx("span", { children: tr("ui_take_out", "Take out") })
      ] }, "takeout"),
      /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
        onInspect(idx, "container");
        onClose();
      }, children: [
        SVG_EYE,
        " ",
        /* @__PURE__ */ jsx("span", { children: tr("ui_inspect", "Inspect") })
      ] }, "inspect")
    ]);
  } else if (panel === "right") {
    sections.push([
      /* @__PURE__ */ jsxs("div", { className: "option", onClick: () => {
        onInspect(idx, "right");
        onClose();
      }, children: [
        SVG_EYE,
        " ",
        /* @__PURE__ */ jsx("span", { children: tr("ui_inspect", "Inspect") })
      ] }, "inspect")
    ]);
  }
  const elements = [];
  sections.forEach((sec, si) => {
    if (si > 0)
      elements.push(/* @__PURE__ */ jsx("div", { className: "opt-sep" }, `sep-${si}`));
    sec.forEach((el) => elements.push(el));
  });
  return /* @__PURE__ */ jsxs(
    "div",
    {
      id: "inventory-options",
      ref,
      className: "show wf-shell is-small",
      style: { left: x, top: y, opacity: 0 },
      onMouseDown: (e) => e.stopPropagation(),
      children: [
        /* @__PURE__ */ jsx("div", { className: "opt-header", children: item.label || item.name }),
        elements
      ]
    }
  );
}

function Tooltip({ item, anchorRect }) {
  const ref = reactExports.useRef(null);
  reactExports.useEffect(() => {
    if (item && ref.current) {
      ref.current.style.opacity = "0";
      ref.current.style.display = "block";
      if (anchorRect) {
        const width = ref.current.offsetWidth;
        const height = ref.current.offsetHeight;
        const m = wsPx(8);
        const center = Math.max(width / 2 + m, Math.min(anchorRect.x + anchorRect.width / 2, window.innerWidth - width / 2 - m));
        const above = anchorRect.y - height - m >= m;
        const top = above ? anchorRect.y - m : Math.min(anchorRect.bottom + m, window.innerHeight - height - m);
        ref.current.style.left = `${center}px`;
        ref.current.style.top = `${Math.max(m, top)}px`;
        ref.current.style.transform = above ? "translate(-50%,-100%)" : "translateX(-50%)";
        ref.current.dataset.placement = above ? "above" : "below";
      }
      requestAnimationFrame(() => {
        if (ref.current)
          ref.current.style.opacity = "1";
      });
    }
  }, [item, anchorRect]);
  if (!item || !anchorRect)
    return /* @__PURE__ */ jsx("div", { id: "inventory-tooltip" });
  const r = rarity(item);
  const ammoEntries = item.ammo ? Object.entries(item.ammo).filter(([, v]) => v > 0) : [];
  const pctRound = item.percentage != null ? Math.round(item.percentage) : null;
  return /* @__PURE__ */ jsxs(
    "div",
    {
      id: "inventory-tooltip",
      className: "wf-shell is-small",
      ref,
      style: {
        display: "block",
        left: anchorRect.x + anchorRect.width / 2,
        top: anchorRect.y - wsPx(8),
        transform: "translate(-50%,-100%)",
        opacity: 0
      },
      children: [
        /* @__PURE__ */ jsx("div", { className: "tt-arrow" }),
        /* @__PURE__ */ jsx("div", { className: `tt-name ${r}`, children: item.label || item.name }),
        /* @__PURE__ */ jsx("div", { className: `tt-rarity-dot ${r}` }),
        item.desc && /* @__PURE__ */ jsx("div", { className: "tt-desc", children: item.desc }),
        /* @__PURE__ */ jsxs("div", { className: "tt-stats", children: [
          item.weight > 0 && /* @__PURE__ */ jsxs("div", { className: "tt-stat", children: [
            /* @__PURE__ */ jsx("span", { className: "tt-stat-l", children: tr("ui_weight", "Weight") }),
            /* @__PURE__ */ jsx("span", { className: "tt-stat-v", children: fmtWeight(N(item.weight)) })
          ] }),
          item.count > 1 && /* @__PURE__ */ jsxs("div", { className: "tt-stat", children: [
            /* @__PURE__ */ jsx("span", { className: "tt-stat-l", children: tr("ui_quantity", "Quantity") }),
            /* @__PURE__ */ jsx("span", { className: "tt-stat-v", children: item.count })
          ] }),
          item.isContainer && /* @__PURE__ */ jsxs("div", { className: "tt-stat", children: [
            /* @__PURE__ */ jsx("span", { className: "tt-stat-l", children: tr("ui_storage", "Storage") }),
            /* @__PURE__ */ jsxs("span", { className: "tt-stat-v", children: [
              fmtWeight(N(item.containerContentWeight)),
              "/",
              fmtWeight(N(item.containerMaxWeight))
            ] })
          ] }),
          pctRound != null && /* @__PURE__ */ jsxs("div", { className: "tt-stat", children: [
            /* @__PURE__ */ jsx("span", { className: "tt-stat-l", children: tr("ui_durability", "Durability") }),
            /* @__PURE__ */ jsxs("span", { className: `tt-stat-v dur-${pctRound <= 25 ? "low" : pctRound <= 60 ? "mid" : "high"}`, children: [
              pctRound,
              "%"
            ] })
          ] }),
          item.isWeapon && /* @__PURE__ */ jsxs("div", { className: "tt-stat", children: [
            /* @__PURE__ */ jsx("span", { className: "tt-stat-l", children: tr("ui_status", "Status") }),
            /* @__PURE__ */ jsx("span", { className: `tt-stat-v ${item.equipped ? "dur-high" : ""}`, children: item.equipped ? tr("ui_equipped", "Equipped") : tr("ui_in_bag", "In bag") })
          ] }),
          ammoEntries.map(([type, count]) => /* @__PURE__ */ jsxs("div", { className: "tt-stat", children: [
            /* @__PURE__ */ jsx("span", { className: "tt-stat-l", children: tr("ui_ammo", "Ammo") }),
            /* @__PURE__ */ jsx("span", { className: "tt-stat-v", children: count })
          ] }, type))
        ] }),
        /* @__PURE__ */ jsx("div", { className: "tt-hint", children: item.isWeapon ? tr("ui_hint_weapon", "Double-click to equip/unequip · Right-click for more") : item.isContainer ? tr("ui_hint_container", "Double-click to open · Right-click for more") : item.canUse ? tr("ui_hint_usable", "Double-click to use · Right-click for more") : tr("ui_hint_move", "Drag to move · Right-click for more") })
      ]
    }
  );
}

function InspectOverlay({ item, onClose }) {
  const bgRef = reactExports.useRef(null);
  const barsRef = reactExports.useRef(null);
  const bodyRef = reactExports.useRef(null);
  const closeTimers = reactExports.useRef([]);
  reactExports.useEffect(() => {
    if (!item)
      return;
    const t1 = setTimeout(() => {
      bgRef.current?.classList.add("active");
      barsRef.current?.classList.add("active");
    }, 25);
    const t2 = setTimeout(() => {
      bodyRef.current?.classList.add("active");
    }, 180);
    return () => {
      clearTimeout(t1);
      clearTimeout(t2);
    };
  }, [item]);
  reactExports.useEffect(() => {
    return () => {
      closeTimers.current.forEach(clearTimeout);
    };
  }, []);
  const handleClose = reactExports.useCallback(() => {
    closeTimers.current.forEach(clearTimeout);
    closeTimers.current = [];
    bodyRef.current?.classList.remove("active");
    if (bodyRef.current)
      bodyRef.current.style.transition = "opacity .25s,transform .25s";
    barsRef.current?.classList.remove("active");
    closeTimers.current.push(setTimeout(() => bgRef.current?.classList.remove("active"), 80));
    closeTimers.current.push(setTimeout(() => onClose(), 500));
  }, [onClose]);
  if (!item)
    return /* @__PURE__ */ jsx("div", { id: "inspect-overlay" });
  const r = rarity(item);
  return /* @__PURE__ */ jsxs("div", { id: "inspect-overlay", style: { display: "flex" }, children: [
    /* @__PURE__ */ jsx("div", { className: "inspect-bg", ref: bgRef }),
    /* @__PURE__ */ jsxs("div", { className: "inspect-bars", ref: barsRef, children: [
      /* @__PURE__ */ jsx("div", { className: "bar-t" }),
      /* @__PURE__ */ jsx("div", { className: "bar-b" })
    ] }),
    /* @__PURE__ */ jsxs("div", { className: "inspect-body", ref: bodyRef, children: [
      /* @__PURE__ */ jsx(
        "img",
        {
          className: "inspect-img",
          src: getItemUrl(item),
          onError: (e) => {
            itemImageError(e.currentTarget, item);
          },
          alt: ""
        }
      ),
      /* @__PURE__ */ jsx("div", { className: "inspect-label", children: item.label || item.name }),
      /* @__PURE__ */ jsx("div", { className: `inspect-rarity detail-rarity ${r}`, children: rarityLabel(r) }),
      /* @__PURE__ */ jsx("div", { className: "inspect-sep" }),
      /* @__PURE__ */ jsx("div", { className: "inspect-desc", children: item.desc || tr("ui_no_description", "No description.") }),
      /* @__PURE__ */ jsxs("div", { className: "inspect-stats", children: [
        /* @__PURE__ */ jsxs("div", { className: "inspect-s", children: [
          /* @__PURE__ */ jsx("div", { className: "inspect-sv", children: fmtWeight(N(item.weight)) }),
          /* @__PURE__ */ jsx("div", { className: "inspect-sl", children: tr("ui_weight", "Weight") })
        ] }),
        /* @__PURE__ */ jsxs("div", { className: "inspect-s", children: [
          /* @__PURE__ */ jsx("div", { className: "inspect-sv", children: item.count }),
          /* @__PURE__ */ jsx("div", { className: "inspect-sl", children: tr("ui_quantity", "Quantity") })
        ] }),
        /* @__PURE__ */ jsxs("div", { className: "inspect-s", children: [
          /* @__PURE__ */ jsx("div", { className: "inspect-sv", children: fmtType(item.type) }),
          /* @__PURE__ */ jsx("div", { className: "inspect-sl", children: tr("ui_type", "Type") })
        ] }),
        item.isContainer && /* @__PURE__ */ jsxs("div", { className: "inspect-s", children: [
          /* @__PURE__ */ jsx("div", { className: "inspect-sv", children: fmtWeight(N(item.containerMaxWeight)) }),
          /* @__PURE__ */ jsx("div", { className: "inspect-sl", children: tr("ui_capacity", "Capacity") })
        ] })
      ] }),
      /* @__PURE__ */ jsxs("div", { className: "inspect-x", onClick: handleClose, children: [
        "[ ",
        tr("ui_esc_close", "ESC TO CLOSE"),
        " ]"
      ] })
    ] })
  ] });
}

function CategoryBar({ active, onChange, grid }) {
  const [hovered, setHovered] = reactExports.useState(null);
  const counts = reactExports.useMemo(() => {
    let total = 0;
    const c = {};
    for (const it of grid) {
      if (!it)
        continue;
      total++;
      const t = it.type || "item_misc";
      c[t] = (c[t] || 0) + 1;
    }
    c.all = total;
    return c;
  }, [grid]);
  return /* @__PURE__ */ jsx("div", { className: "categories", id: "inv-cats", children: CATEGORIES.map((c) => {
    const count = counts[c.id] || 0;
    const name = categoryName(c.id);
    return /* @__PURE__ */ jsxs(
      "div",
      {
        className: `category${c.id === active ? " active" : ""}${c.id !== "all" && count === 0 ? " dim" : ""}`,
        onClick: () => onChange(c.id),
        onMouseEnter: () => setHovered(c.id),
        onMouseLeave: () => setHovered(null),
        children: [
          c.icon,
          c.id !== "all" && count > 0 && /* @__PURE__ */ jsx("span", { className: "cat-count", children: count }),
          hovered === c.id && /* @__PURE__ */ jsxs("div", { className: "cat-tooltip", children: [
            name,
            " (",
            count,
            ")"
          ] })
        ]
      },
      c.id
    );
  }) });
}

function useGridWeight(grid) {
  return reactExports.useMemo(() => {
    let t = 0;
    for (const it of grid) {
      if (!it)
        continue;
      t += N(it.weight);
      if (it.isContainer && it.containerContentWeight)
        t += N(it.containerContentWeight);
    }
    return t;
  }, [grid]);
}
function WeightBar({ grid, maxWeight, cash }) {
  const total = useGridWeight(grid);
  const pct = maxWeight > 0 ? total / maxWeight * 100 : 0;
  const full = fullnessWord(pct);
  const lead = trf("ui_nb_bag_lead", "Your bag · %s of %s kg", iso(kgShort(total)), iso(kgShort(maxWeight)));
  const money = cash != null ? trf("ui_nb_bag_cash", "you carry %s", iso("$" + formatCompact(cash))) : "";
  return /* @__PURE__ */ jsx("div", { className: "sub-info nb-lead", title: `${fmtWeight(total)} / ${fmtWeight(maxWeight)}`, children: /* @__PURE__ */ jsxs("span", { className: "nb-lead-text", children: [
    lead,
    money && /* @__PURE__ */ jsxs(Fragment, { children: [
      " · ",
      money
    ] }),
    full && /* @__PURE__ */ jsxs(Fragment, { children: [
      " · ",
      /* @__PURE__ */ jsx("b", { className: "nb-critical", children: full })
    ] })
  ] }) });
}
function WeightProgress({ grid, maxWeight }) {
  const progressRef = reactExports.useRef(null);
  const total = useGridWeight(grid);
  const pct = Math.min(100, total / maxWeight * 100);
  const tier = pct >= 85 ? "critical" : pct >= 60 ? "warning" : "normal";
  const heavy = pct > 75;
  reactExports.useEffect(() => {
    if (heavy && progressRef.current) {
      progressRef.current.classList.add("weight-shake");
      const t = setTimeout(() => progressRef.current?.classList.remove("weight-shake"), 400);
      return () => clearTimeout(t);
    }
  }, [heavy]);
  return /* @__PURE__ */ jsx("div", { className: "progress", ref: progressRef, children: /* @__PURE__ */ jsx(
    "div",
    {
      className: `progress-bar ${tier}`,
      style: { width: `${pct}%` }
    }
  ) });
}

function ToastContainer({ toasts }) {
  return /* @__PURE__ */ jsx("div", { id: "inv-toasts", children: toasts.map((t) => /* @__PURE__ */ jsx("div", { className: `inv-toast ${t.type} ${t.phase === "show" ? "show" : ""} ${t.phase === "fade-out" ? "fade-out" : ""}`, children: /* @__PURE__ */ jsx("span", { className: "toast-text", children: t.message }) }, t.id)) });
}

function DragGhost({ item }) {
  if (!item)
    return null;
  const r = rarity(item);
  return /* @__PURE__ */ jsxs("div", { id: "inv-drag-ghost", style: { display: "flex" }, className: r, children: [
    /* @__PURE__ */ jsx(
      "img",
      {
        src: getItemUrl(item),
        onError: (e) => {
          itemImageError(e.currentTarget, item);
        },
        alt: ""
      }
    ),
    item.count > 1 && /* @__PURE__ */ jsx("span", { className: "ghost-count", children: item.count })
  ] });
}

function DropZone({ active }) {
  const { setNodeRef, isOver } = useDroppable({
    id: "ground-drop",
    data: { type: "ground" }
  });
  return /* @__PURE__ */ jsxs(
    "div",
    {
      id: "inv-ground-zone",
      ref: setNodeRef,
      className: `${active ? "active" : ""} ${isOver ? "hover" : ""}`,
      children: [
        /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", children: /* @__PURE__ */ jsx("path", { d: "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 14l-4-4h3V8h2v4h3l-4 4z" }) }),
        tr("ui_drop_ground", "Drop on the ground")
      ]
    }
  );
}

function Toolbar({ onSort, onQuickStack, containerOpen }) {
  return /* @__PURE__ */ jsxs("div", { className: "inv-toolbar", children: [
    /* @__PURE__ */ jsxs("div", { className: "tb-btn", onClick: onSort, title: tr("ui_sort_title", "Sort by type and rarity (S)"), children: [
      /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M3 18h6v-2H3v2zM3 6v2h18V6H3zm0 7h12v-2H3v2z" }) }),
      tr("ui_sort", "Sort"),
      /* @__PURE__ */ jsx("kbd", { className: "tb-key", children: "S" })
    ] }),
    containerOpen !== null && onQuickStack && /* @__PURE__ */ jsxs("div", { className: "tb-btn", onClick: onQuickStack, title: tr("ui_quick_stack_title", "Move matching items to the container"), children: [
      /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9h-4v4h-2v-4H9V9h4V5h2v4h4v2z" }) }),
      tr("ui_quick_stack", "Quick stack")
    ] })
  ] });
}

function SplitDialog({ item, visible, onConfirm, onCancel }) {
  const [amount, setAmount] = reactExports.useState(1);
  reactExports.useEffect(() => {
    if (visible && item) {
      setAmount(Math.max(1, Math.floor(item.count / 2)));
    }
  }, [visible, item]);
  const handleConfirm = reactExports.useCallback(() => {
    if (!item)
      return;
    if (amount > 0 && amount < item.count) {
      onConfirm(amount);
    }
  }, [amount, item, onConfirm]);
  reactExports.useEffect(() => {
    if (!visible)
      return;
    const onKey = (e) => {
      if (e.key !== "Enter")
        return;
      e.preventDefault();
      handleConfirm();
    };
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, [visible, handleConfirm]);
  if (!visible || !item)
    return null;
  const max = item.count - 1;
  const keepAmount = item.count - amount;
  const fill = max > 1 ? (amount - 1) / (max - 1) * 100 : 100;
  const ready = amount > 0 && amount < item.count;
  const name = item.label || item.name;
  const fixAmount = () => setAmount(Math.max(1, Math.floor(item.count / 2)));
  return /* @__PURE__ */ jsxs(Fragment, { children: [
    /* @__PURE__ */ jsx("div", { className: "split-backdrop", onClick: onCancel }),
    /* @__PURE__ */ jsxs("div", { id: "inv-split-dialog", className: "wf-shell", style: { display: "flex" }, children: [
      /* @__PURE__ */ jsxs("div", { className: "split-header", children: [
        /* @__PURE__ */ jsx(
          "img",
          {
            src: getItemUrl(item),
            onError: (e) => {
              itemImageError(e.currentTarget, item);
            },
            alt: "",
            className: "split-icon"
          }
        ),
        /* @__PURE__ */ jsx("div", { className: "split-title", children: trf("ui_split_title", "Split %s", item.label || item.name) })
      ] }),
      /* @__PURE__ */ jsxs("div", { className: "split-preview", children: [
        /* @__PURE__ */ jsxs("div", { className: "split-stack", children: [
          /* @__PURE__ */ jsx("span", { className: "split-stack-num", children: keepAmount }),
          /* @__PURE__ */ jsx("span", { className: "split-stack-label", children: tr("ui_keep", "Keep") })
        ] }),
        /* @__PURE__ */ jsx("div", { className: "split-arrow", children: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M16.01 11H4v2h12.01v3L20 12l-3.99-4z" }) }) }),
        /* @__PURE__ */ jsxs("div", { className: "split-stack", children: [
          /* @__PURE__ */ jsx("span", { className: "split-stack-num highlight", children: amount }),
          /* @__PURE__ */ jsx("span", { className: "split-stack-label", children: tr("ui_split", "Split") })
        ] })
      ] }),
      /* @__PURE__ */ jsxs("div", { className: "split-slider-wrap", children: [
        /* @__PURE__ */ jsx("span", { className: "split-adj", onClick: () => setAmount((a) => Math.max(1, a - 1)), children: "−" }),
        /* @__PURE__ */ jsx(
          "input",
          {
            type: "range",
            className: "split-slider",
            style: { "--w-fill": `${fill}%` },
            min: 1,
            max,
            value: amount,
            onChange: (e) => setAmount(parseInt(e.target.value) || 1)
          }
        ),
        /* @__PURE__ */ jsx("span", { className: "split-adj", onClick: () => setAmount((a) => Math.min(max, a + 1)), children: "+" })
      ] }),
      /* @__PURE__ */ jsx(
        Ready,
        {
          missing: ready ? void 0 : item.count < 2 ? tr("ui_nb_split_one", "Missing: a stack of two or more") : tr("ui_nb_split_missing", "Missing: the amount"),
          fix: tr("ui_nb_fix", "Fix it"),
          onFix: item.count >= 2 ? fixAmount : void 0,
          note: trf("ui_nb_split_ready", "%s stay here and %s %s move to a new slot.", iso(keepAmount), iso(amount), name)
        }
      ),
      /* @__PURE__ */ jsxs("div", { className: "split-actions", children: [
        /* @__PURE__ */ jsx("div", { className: "split-btn", onClick: onCancel, children: tr("ui_cancel", "Cancel") }),
        /* @__PURE__ */ jsx("div", { className: "split-btn confirm", onClick: handleConfirm, children: tr("ui_split", "Split") })
      ] }),
      /* @__PURE__ */ jsx(Keys, { keys: [["Enter", tr("ui_split", "Split")], ["Esc", tr("ui_cancel", "Cancel")]] })
    ] })
  ] });
}

function HotBar({ slots, visible, onUseSlot }) {
  const [hoveredSlot, setHoveredSlot] = reactExports.useState(null);
  return /* @__PURE__ */ jsx("div", { id: "hotbar", className: visible ? "hb-visible" : "", children: slots.map((slot, i) => {
    const r = slot ? rarity(slot) : "";
    return /* @__PURE__ */ jsxs(
      "div",
      {
        className: `hb-slot${slot ? " hb-filled" : ""}${slot?.equipped ? " hb-equipped" : ""} ${r}`,
        onClick: () => slot && onUseSlot(i),
        onMouseEnter: () => slot && setHoveredSlot(i),
        onMouseLeave: () => setHoveredSlot(null),
        children: [
          /* @__PURE__ */ jsx("div", { className: "hb-key", children: i + 1 }),
          slot ? /* @__PURE__ */ jsxs(Fragment, { children: [
            /* @__PURE__ */ jsx(
              "img",
              {
                src: getItemUrl(slot),
                onError: (e) => {
                  itemImageError(e.currentTarget, slot);
                },
                draggable: false,
                alt: ""
              }
            ),
            /* @__PURE__ */ jsx("div", { className: "hb-label", children: slot.label || slot.name }),
            slot.isWeapon && slot.equipped && /* @__PURE__ */ jsx("div", { className: "hb-equip-dot" })
          ] }) : /* @__PURE__ */ jsx("div", { className: "hb-empty-text", children: tr("ui_empty", "Empty") }),
          hoveredSlot === i && slot && /* @__PURE__ */ jsxs("div", { className: "hb-tooltip", children: [
            /* @__PURE__ */ jsx("div", { className: "hb-tooltip-name", children: slot.label || slot.name }),
            /* @__PURE__ */ jsx("div", { className: "hb-tooltip-hint", children: trf("ui_hotbar_hint", "Press %s to %s", i + 1, slot.isWeapon ? slot.equipped ? tr("ui_unequip", "unequip") : tr("ui_equip", "equip") : tr("ui_use_action", "use")) })
          ] })
        ]
      },
      i
    );
  }) });
}

function offerWords(list) {
  if (!list || list.length === 0)
    return "";
  if (list.length === 1) {
    const it = list[0] || {};
    const label = it.label || window.__oxItems?.[it.name]?.label || it.name || "";
    return `${iso(it.count || 1)} ${label}`;
  }
  return itemsWord(list.length);
}
const SVG_CHECK = /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" }) });
const SVG_HANDSHAKE = /* @__PURE__ */ jsxs("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: [
  /* @__PURE__ */ jsx("path", { d: "M16.48 7.58c-.28.28-.67.28-.95 0L12.7 4.76a.67.67 0 0 0-.95 0L9.53 6.97l3.3 3.3a2 2 0 0 1 0 2.83l-.71.71a2 2 0 0 1-2.83 0L6.97 11.5l-1.2 1.2a.67.67 0 0 0 0 .96l2.82 2.82c.28.28.28.67 0 .95L7.64 18.4a.67.67 0 0 0 0 .95l1.41 1.41c.28.28.67.28.95 0l.95-.95c.28-.28.67-.28.95 0l.95.95c.28.28.67.28.95 0l1.41-1.41a.67.67 0 0 0 0-.95l-.95-.95a.67.67 0 0 1 0-.95l1.2-1.2 2.3 2.3c.79.79 2.05.79 2.84 0s.79-2.05 0-2.84L16.48 7.58z" }),
  /* @__PURE__ */ jsx("path", { d: "M21.71 7.13l-3.54-3.54a1 1 0 0 0-.7-.29h-2.83L18.17 6.83l3.54 3.54V7.83a1 1 0 0 0-.29-.7zM2.29 7.13a1 1 0 0 0-.29.7v2.54L5.54 6.83 9.07 3.3H6.24a1 1 0 0 0-.7.29L2.29 7.13z", opacity: ".45" })
] });
function TradeSlot({ item, onClick, removable }) {
  if (!item)
    return /* @__PURE__ */ jsx("div", { className: "trade-slot trade-slot-empty" });
  const r = rarity(item);
  return /* @__PURE__ */ jsxs("div", { className: `trade-slot trade-slot-filled ${r}`, onClick, children: [
    /* @__PURE__ */ jsx("img", { src: getItemUrl(item), onError: (e) => {
      itemImageError(e.currentTarget, item);
    }, draggable: false, alt: "" }),
    item.count > 1 && /* @__PURE__ */ jsx("div", { className: "trade-slot-count", children: item.count }),
    removable && /* @__PURE__ */ jsx("div", { className: "trade-slot-remove", children: SVG_X })
  ] });
}
function TradeDropZone({ children, myConfirmed }) {
  const { setNodeRef, isOver } = useDroppable({
    id: "drop:trade-offer",
    data: { type: "trade-offer" },
    disabled: myConfirmed
  });
  return /* @__PURE__ */ jsx("div", { ref: setNodeRef, className: `trade-col-drop${isOver ? " trade-drop-hover" : ""}`, children });
}
function TradeRequest({ request, onAccept, onDecline }) {
  if (!request)
    return null;
  return /* @__PURE__ */ jsx("div", { className: "trade-request-overlay", children: /* @__PURE__ */ jsx("div", { className: "trade-request-note", children: /* @__PURE__ */ jsxs("div", { className: "wf-note-plate trade-request-card", role: "dialog", "aria-modal": "true", children: [
    /* @__PURE__ */ jsx("div", { className: "trade-request-icon", children: SVG_HANDSHAKE }),
    /* @__PURE__ */ jsx("div", { className: "wf-note-kicker trade-request-title", children: tr("ui_trade_request", "Trade request") }),
    /* @__PURE__ */ jsx("div", { className: "wf-note-q trade-request-name", children: request.fromName }),
    /* @__PURE__ */ jsx("div", { className: "wf-note-sub trade-request-sub", children: tr("ui_trade_wants", "wants to trade with you") }),
    /* @__PURE__ */ jsxs("div", { className: "wf-note-row trade-request-actions", children: [
      /* @__PURE__ */ jsx("button", { className: "wf-choice trade-req-btn accept", onClick: onAccept, children: tr("ui_accept", "Accept") }),
      /* @__PURE__ */ jsx("button", { className: "wf-choice trade-req-btn decline", onClick: onDecline, children: tr("ui_decline", "Decline") })
    ] })
  ] }) }) });
}
function TradePanel({ tradeOpen, tradePartner, myOffer, theirOffer, myConfirmed, theirConfirmed, tradeCompleting, onRemoveFromOffer, onConfirm, onCancel }) {
  const [pos, setPos] = reactExports.useState({ x: 0, y: 0 });
  const dragging = reactExports.useRef(false);
  const offset = reactExports.useRef({ x: 0, y: 0 });
  const onMouseDown = reactExports.useCallback((e) => {
    if (e.target.closest(".trade-close") || e.target.closest(".trade-btn") || e.target.closest(".trade-slot") || e.target.closest("button"))
      return;
    dragging.current = true;
    offset.current = { x: e.clientX - (pos.x ?? 0), y: e.clientY - (pos.y ?? 0) };
    e.preventDefault();
  }, [pos]);
  reactExports.useEffect(() => {
    function onMove(e) {
      if (!dragging.current)
        return;
      setPos({ x: e.clientX - offset.current.x, y: e.clientY - offset.current.y });
    }
    function onUp() {
      dragging.current = false;
    }
    document.addEventListener("mousemove", onMove);
    document.addEventListener("mouseup", onUp);
    return () => {
      document.removeEventListener("mousemove", onMove);
      document.removeEventListener("mouseup", onUp);
    };
  }, []);
  if (!tradeOpen)
    return null;
  const mySlots = [];
  for (let i = 0; i < 8; i++) {
    const item = myOffer[i] || null;
    mySlots.push(/* @__PURE__ */ jsx(TradeSlot, { item, removable: !!item && !myConfirmed, onClick: item && !myConfirmed ? () => onRemoveFromOffer(item.id) : void 0 }, `my-${i}`));
  }
  const theirSlots = [];
  for (let i = 0; i < 8; i++) {
    const item = theirOffer[i] || null;
    theirSlots.push(/* @__PURE__ */ jsx(TradeSlot, { item }, `their-${i}`));
  }
  const bothEmpty = myOffer.length === 0 && theirOffer.length === 0;
  const plan = (myOffer.length === 0 ? trf("ui_nb_trade_give_none", "You give %s nothing", tradePartner) : trf("ui_nb_trade_give", "You give %s to %s", offerWords(myOffer), tradePartner)) + " " + (theirOffer.length === 0 ? tr("ui_nb_trade_take_none", "and take nothing.") : trf("ui_nb_trade_take", "and take %s.", offerWords(theirOffer)));
  const waiting = myConfirmed && !theirConfirmed ? trf("ui_nb_trade_wait_them", "Waiting for %s to confirm.", tradePartner) : !myConfirmed && theirConfirmed ? trf("ui_nb_trade_wait_you", "%s confirmed; your confirmation is left.", tradePartner) : !myConfirmed ? tr("ui_nb_trade_wait_both", "Both sides still have to confirm.") : "";
  const useCustomPos = pos.x !== 0 || pos.y !== 0;
  const style = useCustomPos ? { position: "fixed", left: pos.x, top: pos.y, transform: "none", right: "auto" } : {};
  return /* @__PURE__ */ jsxs("div", { id: "trade-panel", className: "wf-shell", style, onMouseDown, children: [
    /* @__PURE__ */ jsxs("div", { className: "trade-header trade-drag-handle", children: [
      /* @__PURE__ */ jsx("div", { className: "trade-header-icon", children: SVG_HANDSHAKE }),
      /* @__PURE__ */ jsxs("div", { className: "trade-header-text", children: [
        /* @__PURE__ */ jsx("div", { className: "trade-title", children: tr("ui_trade", "Trade") }),
        /* @__PURE__ */ jsx("div", { className: "trade-partner", children: trf("ui_trade_with", "With %s", tradePartner) })
      ] }),
      /* @__PURE__ */ jsx("div", { className: "trade-drag-hint", children: /* @__PURE__ */ jsx("svg", { viewBox: "0 0 24 24", fill: "currentColor", children: /* @__PURE__ */ jsx("path", { d: "M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z" }) }) }),
      /* @__PURE__ */ jsx("div", { className: "trade-close", onClick: onCancel, children: SVG_X })
    ] }),
    /* @__PURE__ */ jsxs("div", { className: "trade-columns", children: [
      /* @__PURE__ */ jsxs("div", { className: `trade-col${myConfirmed ? " trade-confirmed" : ""}`, children: [
        /* @__PURE__ */ jsx("div", { className: "trade-col-label", children: tr("ui_your_offer", "Your offer") }),
        /* @__PURE__ */ jsxs(TradeDropZone, { myConfirmed, children: [
          /* @__PURE__ */ jsx("div", { className: "trade-col-grid", children: mySlots }),
          !myConfirmed && myOffer.length === 0 && /* @__PURE__ */ jsx("div", { className: "trade-drop-hint", children: tr("ui_drag_items_here", "Drag items here") })
        ] })
      ] }),
      /* @__PURE__ */ jsx("div", { className: "trade-divider", children: /* @__PURE__ */ jsx("div", { className: "trade-arrows", children: SVG_HANDSHAKE }) }),
      /* @__PURE__ */ jsxs("div", { className: `trade-col${theirConfirmed ? " trade-confirmed" : ""}`, children: [
        /* @__PURE__ */ jsx("div", { className: "trade-col-label", children: tr("ui_their_offer", "Their offer") }),
        /* @__PURE__ */ jsx("div", { className: "trade-col-grid", children: theirSlots })
      ] })
    ] }),
    !tradeCompleting && /* @__PURE__ */ jsx(
      Ready,
      {
        missing: bothEmpty ? tr("ui_nb_trade_empty", "Missing: an item in one of the offers - drag one into yours") : void 0,
        note: /* @__PURE__ */ jsxs(Fragment, { children: [
          plan,
          " ",
          waiting
        ] })
      }
    ),
    !tradeCompleting && /* @__PURE__ */ jsxs("div", { className: "trade-footer", children: [
      /* @__PURE__ */ jsx("button", { className: "trade-btn cancel", onClick: onCancel, children: tr("ui_cancel", "Cancel") }),
      /* @__PURE__ */ jsx("button", { className: `trade-btn confirm${myConfirmed ? " confirmed" : ""}`, onClick: onConfirm, disabled: myConfirmed, children: myConfirmed ? /* @__PURE__ */ jsxs(Fragment, { children: [
        SVG_CHECK,
        " ",
        tr("ui_confirmed", "Confirmed")
      ] }) : tr("ui_confirm_trade", "Confirm trade") })
    ] }),
    !tradeCompleting && /* @__PURE__ */ jsx(Keys, { keys: [[tr("ui_nb_key_drag", "Drag"), tr("ui_nb_key_offer", "add to your offer")], [tr("ui_nb_key_click", "Click"), tr("ui_nb_key_take_back", "take back")], ["Esc", tr("ui_cancel", "Cancel")]] }),
    tradeCompleting && /* @__PURE__ */ jsxs("div", { className: "trade-completing-overlay", children: [
      /* @__PURE__ */ jsx("div", { className: "trade-completing-icon", children: SVG_HANDSHAKE }),
      /* @__PURE__ */ jsx("div", { className: "trade-completing-text", children: tr("ui_completing_trade", "Completing trade") }),
      /* @__PURE__ */ jsx("div", { className: "trade-completing-bar-track", children: /* @__PURE__ */ jsx("div", { className: "trade-completing-bar-fill" }) }),
      /* @__PURE__ */ jsx("div", { className: "trade-completing-sub", children: tr("ui_exchanging_items", "Exchanging items...") })
    ] })
  ] });
}

const Cartridge = () => /* @__PURE__ */ jsxs("svg", { viewBox: "0 0 32 64", "aria-hidden": "true", children: [
  /* @__PURE__ */ jsx("path", { d: "M11 3h10l3 8v30l-4 12v7H12v-7L8 41V11l3-8Z" }),
  /* @__PURE__ */ jsx("path", { d: "M9 15h14M9 39h14M12 53h8" })
] });
function AmmoPicker({ data, busy, onSelect, onUnload, onSetPreferred, onClose }) {
  const defaultSlot = reactExports.useMemo(() => {
    if (!data?.options?.length)
      return null;
    return (data.options.find((option) => option.active) || data.options[0]).slot;
  }, [data]);
  const [selectedSlot, setSelectedSlot] = reactExports.useState(defaultSlot);
  reactExports.useEffect(() => setSelectedSlot(defaultSlot), [defaultSlot]);
  reactExports.useEffect(() => {
    if (!data)
      return;
    const onKeyDown = (event) => {
      if (event.key === "Escape") {
        event.preventDefault();
        event.stopPropagation();
        onClose();
      } else if (event.key === "Enter" && selectedSlot !== null && !busy) {
        event.preventDefault();
        onSelect(data.weaponSlot, selectedSlot);
      }
    };
    document.addEventListener("keydown", onKeyDown, true);
    return () => document.removeEventListener("keydown", onKeyDown, true);
  }, [data, selectedSlot, busy, onSelect, onClose]);
  if (!data)
    return null;
  const loaded = Math.max(0, Number(data.loaded) || 0);
  const capacity = Math.max(1, Number(data.capacity) || 1);
  const loadPercent = Math.min(100, loaded / capacity * 100);
  const selected = data.options.find((option) => option.slot === selectedSlot);
  const selectedLocked = loaded > 0 && selected && !selected.active;
  return /* @__PURE__ */ jsx(
    "div",
    {
      className: "ammo-picker-backdrop",
      onMouseDown: (event) => {
        if (event.target === event.currentTarget && !busy)
          onClose();
      },
      children: /* @__PURE__ */ jsxs(
        "section",
        {
          id: "inv-ammo-picker",
          className: "wf-shell",
          role: "dialog",
          "aria-modal": "true",
          "aria-labelledby": "ammo-picker-title",
          onMouseDown: (event) => event.stopPropagation(),
          children: [
            /* @__PURE__ */ jsx("div", { className: "ammo-picker-rail" }),
            /* @__PURE__ */ jsxs("header", { className: "ammo-picker-header", children: [
              /* @__PURE__ */ jsx("div", { className: "ammo-picker-emblem", children: /* @__PURE__ */ jsx(Cartridge, {}) }),
              /* @__PURE__ */ jsxs("div", { className: "ammo-picker-heading", children: [
                /* @__PURE__ */ jsx("span", { className: "ammo-picker-kicker", children: data.weaponLabel }),
                /* @__PURE__ */ jsx("h2", { id: "ammo-picker-title", children: tr("ui_ammo_select_title", "Choose ammunition") }),
                /* @__PURE__ */ jsx("p", { children: tr("ui_ammo_select_subtitle", "Select the rounds to load into this weapon") })
              ] }),
              /* @__PURE__ */ jsx("button", { className: "ammo-picker-close", type: "button", onClick: onClose, disabled: busy, "aria-label": tr("ui_cancel", "Cancel"), children: "×" })
            ] }),
            /* @__PURE__ */ jsxs("div", { className: "ammo-picker-load", children: [
              /* @__PURE__ */ jsxs("div", { className: "ammo-picker-load-copy", children: [
                /* @__PURE__ */ jsx("span", { children: tr("ui_ammo_loaded", "Loaded") }),
                /* @__PURE__ */ jsxs("strong", { children: [
                  loaded,
                  /* @__PURE__ */ jsxs("small", { children: [
                    " / ",
                    capacity
                  ] })
                ] })
              ] }),
              /* @__PURE__ */ jsx("div", { className: "ammo-picker-load-track", children: /* @__PURE__ */ jsx("i", { style: { width: `${loadPercent}%` } }) })
            ] }),
            /* @__PURE__ */ jsx("div", { className: "ammo-picker-options", role: "radiogroup", children: data.options.map((option, index) => {
              const chosen = option.slot === selectedSlot;
              const locked = loaded > 0 && !option.active;
              return /* @__PURE__ */ jsxs(
                "button",
                {
                  type: "button",
                  role: "radio",
                  "aria-checked": chosen,
                  className: `ammo-picker-option${chosen ? " selected" : ""}${locked ? " locked" : ""}`,
                  onClick: () => setSelectedSlot(option.slot),
                  onContextMenu: (event) => {
                    event.preventDefault();
                    if (!busy)
                      onSetPreferred(data.weaponSlot, option.item);
                  },
                  disabled: busy,
                  title: tr("ui_ammo_preferred_hint", "Select a type, then Load rounds · Right-click to mark a favorite"),
                  children: [
                    /* @__PURE__ */ jsx("span", { className: "ammo-picker-index", children: String(index + 1).padStart(2, "0") }),
                    /* @__PURE__ */ jsx("span", { className: "ammo-picker-cartridge", children: /* @__PURE__ */ jsx(Cartridge, {}) }),
                    /* @__PURE__ */ jsxs("span", { className: "ammo-picker-option-copy", children: [
                      /* @__PURE__ */ jsx("strong", { children: option.label || option.item }),
                      /* @__PURE__ */ jsxs("small", { children: [
                        tr("ui_ammo_available", "Available"),
                        " · ",
                        option.count
                      ] })
                    ] }),
                    option.preferred && /* @__PURE__ */ jsx("span", { className: "ammo-picker-preferred", children: tr("ui_ammo_preferred", "Preferred") }),
                    option.active && /* @__PURE__ */ jsx("span", { className: "ammo-picker-current", children: tr("ui_ammo_current", "Current") }),
                    /* @__PURE__ */ jsx("span", { className: "ammo-picker-radio", children: /* @__PURE__ */ jsx("i", {}) })
                  ]
                },
                `${option.slot}:${option.item}`
              );
            }) }),
            selectedLocked && /* @__PURE__ */ jsxs("div", { className: "ammo-picker-warning", children: [
              /* @__PURE__ */ jsx("span", { children: tr("ammo_switch_loaded", "Unload the current rounds before switching ammo type") }),
              /* @__PURE__ */ jsx("button", { className: "ammo-picker-unload", type: "button", onClick: () => onUnload(data.weaponSlot), disabled: busy, children: tr("ui_ammo_unload", "Unload current rounds") })
            ] }),
            /* @__PURE__ */ jsx("p", { className: "ammo-picker-hint", children: tr("ui_ammo_preferred_hint", "Select a type, then Load rounds · Right-click to mark a favorite") }),
            /* @__PURE__ */ jsxs("footer", { className: "ammo-picker-actions", children: [
              /* @__PURE__ */ jsx("button", { type: "button", className: "ammo-picker-cancel", onClick: onClose, disabled: busy, children: tr("ui_cancel", "Cancel") }),
              /* @__PURE__ */ jsxs(
                "button",
                {
                  type: "button",
                  className: "ammo-picker-confirm",
                  onClick: () => selectedSlot !== null && onSelect(data.weaponSlot, selectedSlot),
                  disabled: busy || selectedSlot === null || !!selectedLocked,
                  children: [
                    /* @__PURE__ */ jsx(Cartridge, {}),
                    /* @__PURE__ */ jsx("span", { children: busy ? "…" : tr("ui_ammo_load", "Load rounds") })
                  ]
                }
              )
            ] })
          ]
        }
      )
    }
  );
}

function Glyph({
  tex,
  className,
  style
}) {
  const mask = {
    WebkitMaskImage: `var(--tex-${tex})`,
    maskImage: `var(--tex-${tex})`,
    ...style
  };
  return /* @__PURE__ */ jsx("span", { className: `wc-glyph${className ? ` ${className}` : ""}`, style: mask, "aria-hidden": "true" });
}

function parseDropId(id) {
  if (!id || typeof id !== "string")
    return null;
  if (id === "ground-drop")
    return { type: "ground" };
  if (id === "drop:trade-offer")
    return { type: "trade-offer" };
  if (id.startsWith("drop:filled:")) {
    const parts = id.split(":");
    return { type: "filled", panel: parts[2], idx: parseInt(parts[3]) };
  }
  if (id.startsWith("drop:empty:")) {
    const parts = id.split(":");
    return { type: "empty", panel: parts[2], gridIndex: parseInt(parts[3]) };
  }
  return null;
}
function App() {
  const [visible, setVisible] = reactExports.useState(false);
  const [animating, setAnimating] = reactExports.useState(false);
  const { state, dispatch, getGrid, getItemsList } = useInventory();
  const { toasts, addToast } = useToast();
  const hotbar = useHotbar();
  const playSound = useSound();
  const itemsDbRef = reactExports.useRef({});
  const busyFetch = reactExports.useCallback((eventName, data) => {
    dispatch({ type: "SET_BUSY", busy: true });
    return fetchNui(eventName, data).then((res) => {
      setTimeout(() => dispatch({ type: "SET_BUSY", busy: false }), 100);
      return res;
    }).catch(() => {
      dispatch({ type: "SET_BUSY", busy: false });
      return void 0;
    });
  }, [dispatch]);
  const [ctx, setCtx] = reactExports.useState({ visible: false, x: 0, y: 0, idx: null, panel: "main" });
  const [tooltip, setTooltip] = reactExports.useState({ item: null, rect: null });
  const [split, setSplit] = reactExports.useState({ visible: false, idx: null, panel: "main" });
  const [ammoPicker, setAmmoPicker] = reactExports.useState(null);
  const [ammoPickerBusy, setAmmoPickerBusy] = reactExports.useState(false);
  const [dragItem, setDragItem] = reactExports.useState(null);
  const [isDragging, setIsDragging] = reactExports.useState(false);
  const lastUsedRef = reactExports.useRef({});
  const busyTimerRef = reactExports.useRef(null);
  reactExports.useEffect(() => {
    if (state.isBusy) {
      if (busyTimerRef.current)
        clearTimeout(busyTimerRef.current);
      busyTimerRef.current = setTimeout(() => {
        dispatch({ type: "SET_BUSY", busy: false });
        busyTimerRef.current = null;
      }, 5e3);
    } else {
      if (busyTimerRef.current) {
        clearTimeout(busyTimerRef.current);
        busyTimerRef.current = null;
      }
    }
  }, [state.isBusy, dispatch]);
  const wrapperRef = reactExports.useRef(null);
  const PANEL_POS_KEY = "w_inv_panel_pos";
  const loadSavedPos = reactExports.useCallback(() => loadPanelPos(PANEL_POS_KEY), []);
  const [panelPos, setPanelPos] = reactExports.useState(loadSavedPos);
  const attachedWidth = (state.containerOpen !== null ? CONTAINER_W_REM + PANEL_GAP_REM : 0) + (state.selected !== null ? DETAIL_W_REM + PANEL_GAP_REM : 0);
  const fittedPanelPos = usePanelPosition(wrapperRef, panelPos, visible, remPx(attachedWidth));
  const panelDragRef = reactExports.useRef(null);
  const handlePanelDragStart = reactExports.useCallback((e) => {
    if (e.target.closest("#inv-close-btn"))
      return;
    e.preventDefault();
    const wrapper = wrapperRef.current;
    if (!wrapper)
      return;
    const rect = wrapper.getBoundingClientRect();
    panelDragRef.current = {
      startX: e.clientX,
      startY: e.clientY,
      origX: rect.left,
      origY: rect.top
    };
    const onMove = (ev) => {
      if (!panelDragRef.current)
        return;
      const dx = ev.clientX - panelDragRef.current.startX;
      const dy = ev.clientY - panelDragRef.current.startY;
      const nx = panelDragRef.current.origX + dx;
      const ny = panelDragRef.current.origY + dy;
      setPanelPos({ x: nx, y: ny });
    };
    const onUp = () => {
      document.removeEventListener("mousemove", onMove);
      document.removeEventListener("mouseup", onUp);
      setPanelPos((cur) => {
        if (cur) {
          savePanelPos(PANEL_POS_KEY, cur);
        }
        return cur;
      });
      panelDragRef.current = null;
    };
    document.addEventListener("mousemove", onMove);
    document.addEventListener("mouseup", onUp);
  }, []);
  const sensors = useSensors(
    useSensor(MouseSensor, { activationConstraint: { distance: 5 } })
  );
  reactExports.useMemo(() => {
    let n = 0;
    for (const it of state.grid)
      if (it)
        n++;
    return n;
  }, [state.grid]);
  const closeTimerRef = reactExports.useRef(null);
  reactExports.useEffect(() => {
    return () => {
      if (closeTimerRef.current)
        clearTimeout(closeTimerRef.current);
      if (busyTimerRef.current)
        clearTimeout(busyTimerRef.current);
    };
  }, []);
  const stableSetVisible = reactExports.useCallback((v) => {
    if (v) {
      if (closeTimerRef.current) {
        clearTimeout(closeTimerRef.current);
        closeTimerRef.current = null;
      }
      setVisible(true);
      setAnimating(false);
      playSound("open");
      requestAnimationFrame(() => {
        requestAnimationFrame(() => setAnimating(true));
      });
    } else {
      setAnimating(false);
      playSound("close");
      if (closeTimerRef.current) {
        clearTimeout(closeTimerRef.current);
      }
      closeTimerRef.current = setTimeout(() => {
        setVisible(false);
        closeTimerRef.current = null;
      }, 400);
    }
  }, [playSound]);
  useNui(dispatch, stableSetVisible, addToast, hotbar, itemsDbRef);
  reactExports.useEffect(() => {
    const prevent = (e) => e.preventDefault();
    window.addEventListener("dragstart", prevent);
    return () => window.removeEventListener("dragstart", prevent);
  }, []);
  reactExports.useEffect(() => {
    if (!isEnvBrowser()) {
      fetchNui("uiLoaded", {});
    }
  }, []);
  reactExports.useEffect(() => {
    hotbar.syncWithGrid(state.grid);
  }, [state.grid, hotbar.syncWithGrid]);
  reactExports.useEffect(() => {
    function handler(event) {
      const data = event.data;
      if (!data)
        return;
      if (data.action === "showHotbar")
        hotbar.showHotbar();
      if (data.action === "setHotbarVisible")
        hotbar.setVisible(data.visible === true);
      if (data.action === "useHotbarSlot") {
        const si = data.slot;
        if (si >= 0 && si < 5) {
          hotbar.useSlot(si);
          hotbar.showHotbar();
        }
      }
      if (data.action === "openAmmoPicker" && data.data) {
        setCtx((current) => ({ ...current, visible: false }));
        setTooltip({ item: null, rect: null });
        setAmmoPickerBusy(false);
        setAmmoPicker(data.data);
      }
    }
    window.addEventListener("message", handler);
    return () => window.removeEventListener("message", handler);
  }, [hotbar.setVisible, hotbar.showHotbar, hotbar.useSlot]);
  function checkUseCooldown(itemName) {
    const now = Date.now();
    const last = lastUsedRef.current[itemName] || 0;
    if (now - last < 2e3) {
      addToast(tr("ui_item_cooldown", "This item is on cooldown"), "error");
      playSound("error");
      return false;
    }
    lastUsedRef.current[itemName] = now;
    return true;
  }
  function handleDragStart(event) {
    if (state.isBusy) {
      event.cancel?.();
      return;
    }
    const data = event.active.data.current;
    if (data?.item) {
      setDragItem(data.item);
      setIsDragging(true);
      setTooltip({ item: null, rect: null });
      setCtx((c) => ({ ...c, visible: false }));
      playSound("pickup");
    }
  }
  function handleDragEnd(event) {
    const { active, over } = event;
    setDragItem(null);
    setIsDragging(false);
    if (!over || !active)
      return;
    if (state.isBusy)
      return;
    const src = active.data.current;
    if (!src?.item)
      return;
    const dst = parseDropId(over.id);
    if (!dst)
      return;
    if (dst.type === "trade-offer") {
      if (!state.tradeOpen || state.myConfirmed)
        return;
      if (src.panel !== "main")
        return;
      if (state.rightInventory?.type === "shop" || state.rightInventory?.type === "crafting") {
        if (src.panel === "right")
          return;
      }
      handleTradeAddItem(src.item);
      playSound("drop");
      return;
    }
    if (dst.type === "ground") {
      if (src.panel !== "main") {
        addToast(tr("ui_cannot_place_here", "You cannot place items here"), "error");
        playSound("error");
        return;
      }
      busyFetch("swapItems", {
        fromSlot: src.item.slot,
        toSlot: 1,
        fromType: "player",
        toType: "newdrop",
        count: state.itemAmount > 0 ? state.itemAmount : src.item.count
      });
      playSound("drop");
      return;
    }
    if (dst.type === "filled" || dst.type === "empty") {
      const dstIdx = dst.type === "filled" ? dst.idx : dst.gridIndex;
      const srcPanel = src.panel;
      const dstPanel = dst.type === "filled" ? dst.panel : dst.panel;
      const dstItem = dst.type === "filled" ? over.data.current?.item : null;
      let resolvedToSlot;
      if (dstItem) {
        resolvedToSlot = dstItem.slot;
      } else {
        resolvedToSlot = dstIdx + 1;
      }
      if (src.item.slot === resolvedToSlot && srcPanel === dstPanel)
        return;
      if (srcPanel === dstPanel) {
        if (srcPanel === "right" && (state.rightInventory?.type === "shop" || state.rightInventory?.type === "crafting")) {
          return;
        }
        const fromType = srcPanel === "right" ? state.rightInventory?.type || "player" : "player";
        busyFetch("swapItems", {
          fromSlot: src.item.slot,
          toSlot: resolvedToSlot,
          fromType,
          toType: fromType,
          count: state.itemAmount > 0 ? state.itemAmount : src.item.count
        });
      } else {
        const fromType = srcPanel === "right" ? state.rightInventory?.type || "player" : "player";
        const toType = dstPanel === "right" ? state.rightInventory?.type || "player" : "player";
        const crossToSlot = resolvedToSlot;
        if ((state.rightInventory?.type === "shop" || state.rightInventory?.type === "crafting") && dstPanel === "right" && srcPanel === "main") {
          addToast(tr("ui_cannot_place_here", "You cannot place items here"), "error");
          playSound("error");
          return;
        }
        if (state.rightInventory?.type === "shop" && srcPanel === "right") {
          busyFetch("buyItem", {
            fromSlot: src.item.slot,
            toSlot: crossToSlot,
            fromType,
            toType,
            count: state.itemAmount > 0 ? state.itemAmount : 1,
            paymentCurrency: state.shopPaymentCurrency
          });
        } else if (state.rightInventory?.type === "crafting" && srcPanel === "right") {
          busyFetch("craftItem", {
            fromSlot: src.item.slot,
            toSlot: crossToSlot,
            fromType,
            toType,
            count: state.itemAmount > 0 ? state.itemAmount : 1
          });
        } else {
          const count = state.itemAmount > 0 ? state.itemAmount : src.item.count;
          busyFetch("swapItems", {
            fromSlot: src.item.slot,
            toSlot: crossToSlot,
            fromType,
            toType,
            count
          });
        }
      }
      playSound("drop");
      return;
    }
  }
  const handleClose = reactExports.useCallback(() => {
    setCtx((c) => ({ ...c, visible: false }));
    setTooltip({ item: null, rect: null });
    setSplit({ visible: false, idx: null, panel: "main" });
    setAmmoPicker(null);
    setAmmoPickerBusy(false);
    setDragItem(null);
    setIsDragging(false);
    if (state.tradeOpen) {
      fetchNui("cancelTrade", { tradeId: state.tradeId });
    }
    dispatch({ type: "RESET" });
    fetchNui("exit");
    stableSetVisible(false);
  }, [dispatch, stableSetVisible, state.tradeOpen, state.tradeId]);
  const handleSelect = reactExports.useCallback((idx, panel, event) => {
    if (isDragging)
      return;
    setCtx((c) => ({ ...c, visible: false }));
    dispatch({ type: "SELECT", index: idx, panel });
  }, [dispatch, isDragging]);
  const handleContextMenu = reactExports.useCallback((e, idx, panel) => {
    if (isDragging || state.isBusy)
      return;
    e.preventDefault();
    e.stopPropagation();
    dispatch({ type: "SELECT", index: idx, panel });
    setCtx({ visible: true, x: e.clientX, y: e.clientY, idx, panel });
  }, [dispatch, isDragging, state.isBusy]);
  const handleDoubleClick = reactExports.useCallback((idx, item) => {
    if (state.isBusy)
      return;
    if (item.isContainer) {
      dispatch({ type: "OPEN_CONTAINER", index: idx });
    } else {
      if (!checkUseCooldown(item.name))
        return;
      fetchNui("useItem", item.slot);
    }
  }, [dispatch, state.isBusy]);
  const handleMouseOver = reactExports.useCallback((idx, panel) => {
    if (isDragging)
      return;
    const grid = getGrid(panel);
    const it = grid[idx];
    if (!it)
      return;
    const gridId = panel === "container" ? "container-grid" : panel === "right" ? "right-grid" : "inv-grid";
    const el = document.querySelector(`#${gridId} .slot[data-idx="${idx}"]`);
    if (el) {
      setTooltip({ item: it, rect: el.getBoundingClientRect() });
    }
  }, [getGrid, isDragging]);
  const handleMouseLeave = reactExports.useCallback(() => {
    setTooltip({ item: null, rect: null });
  }, []);
  const handleUseItem = reactExports.useCallback((idx) => {
    if (state.isBusy)
      return;
    const it = state.grid[idx];
    if (!it)
      return;
    if (!checkUseCooldown(it.name))
      return;
    fetchNui("useItem", it.slot);
  }, [state.grid, state.isBusy]);
  const handleDropItem = reactExports.useCallback((idx) => {
    if (state.isBusy)
      return;
    const it = state.grid[idx];
    if (!it)
      return;
    busyFetch("swapItems", {
      fromSlot: it.slot,
      toSlot: 1,
      fromType: "player",
      toType: "newdrop",
      count: state.itemAmount > 0 ? state.itemAmount : it.count
    });
    playSound("drop");
  }, [state.grid, state.isBusy, state.itemAmount, busyFetch, playSound]);
  const handleGiveItem = reactExports.useCallback((idx) => {
    if (state.isBusy)
      return;
    const it = state.grid[idx];
    if (!it)
      return;
    busyFetch("giveItem", { slot: it.slot, count: state.itemAmount > 0 ? state.itemAmount : it.count });
  }, [state.grid, state.isBusy, state.itemAmount, busyFetch]);
  const handleInspect = reactExports.useCallback((idx, panel) => {
    dispatch({ type: "INSPECT", index: idx, panel });
  }, [dispatch]);
  const handleOpenContainer = reactExports.useCallback((idx) => {
    const it = state.grid[idx];
    if (!it || !it.isContainer)
      return;
    dispatch({ type: "OPEN_CONTAINER", index: idx });
  }, [state.grid, dispatch]);
  const handleStoreIn = reactExports.useCallback((idx) => {
    if (state.isBusy)
      return;
    const it = state.grid[idx];
    if (!it || state.containerOpen === null || it.isContainer)
      return;
    busyFetch("swapItems", {
      fromSlot: it.slot,
      toSlot: 0,
      fromType: "player",
      toType: "container",
      count: state.itemAmount > 0 ? state.itemAmount : it.count
    });
  }, [state.grid, state.isBusy, state.containerOpen, busyFetch]);
  const handleTakeOut = reactExports.useCallback((idx) => {
    if (state.isBusy)
      return;
    const it = state.containerGrid[idx];
    if (!it || state.containerOpen === null)
      return;
    busyFetch("swapItems", {
      fromSlot: it.slot,
      toSlot: 0,
      fromType: "container",
      toType: "player",
      count: it.count
    });
  }, [state.containerGrid, state.isBusy, state.containerOpen, busyFetch]);
  const handleCloseContainer = reactExports.useCallback(() => {
    dispatch({ type: "CLOSE_CONTAINER" });
  }, [dispatch]);
  const handleCloseInspect = reactExports.useCallback(() => {
    dispatch({ type: "CLOSE_INSPECT" });
  }, [dispatch]);
  const handleCategoryChange = reactExports.useCallback((cat) => {
    dispatch({ type: "SET_CATEGORY", category: cat });
  }, [dispatch]);
  const handleSearchChange = reactExports.useCallback((e) => {
    dispatch({ type: "SET_SEARCH", search: e.target.value });
  }, [dispatch]);
  const handleSearchClear = reactExports.useCallback(() => {
    dispatch({ type: "SET_SEARCH", search: "" });
  }, [dispatch]);
  const handleSort = reactExports.useCallback(async () => {
    if (state.isBusy)
      return;
    const gridSize = state.grid.length;
    const items = [];
    for (const it of state.grid) {
      if (it && it.slot >= 1 && it.slot <= gridSize) {
        items.push({ slot: it.slot, count: it.count, name: it.name, type: it.type || "item_misc", label: it.label || it.name });
      }
    }
    if (items.length <= 1)
      return;
    const order = { item_weapon: 0, item_ammo: 1, item_food: 2, item_misc: 3, item_collectables: 4 };
    const sorted = [...items].sort((a, b) => {
      if (a.type !== b.type)
        return (order[a.type] ?? 6) - (order[b.type] ?? 6);
      return a.label.localeCompare(b.label);
    });
    const pos = /* @__PURE__ */ new Map();
    for (const it of items)
      pos.set(it.slot, it.slot);
    const swaps = [];
    for (let i = 0; i < sorted.length; i++) {
      const targetSlot = i + 1;
      const wanted = sorted[i].slot;
      const currentPos = pos.get(wanted);
      if (currentPos === targetSlot)
        continue;
      let evictedOrig = null;
      for (const [orig, cur] of pos) {
        if (cur === targetSlot) {
          evictedOrig = orig;
          break;
        }
      }
      swaps.push({ fromSlot: currentPos, toSlot: targetSlot });
      pos.set(wanted, targetSlot);
      if (evictedOrig !== null)
        pos.set(evictedOrig, currentPos);
    }
    if (swaps.length === 0) {
      addToast(tr("ui_already_sorted", "Inventory is already sorted"), "info");
      return;
    }
    dispatch({ type: "SET_BUSY", busy: true });
    addToast(tr("ui_sorting", "Sorting inventory..."), "info");
    for (const swap of swaps) {
      await fetchNui("swapItems", {
        fromSlot: swap.fromSlot,
        toSlot: swap.toSlot,
        fromType: "player",
        toType: "player",
        count: 9999
      });
    }
    addToast(tr("ui_sorted", "Inventory sorted"), "info");
  }, [state.grid, state.isBusy, dispatch, addToast]);
  const handleQuickStack = reactExports.useCallback(() => {
    if (state.containerOpen === null)
      return;
    addToast(tr("ui_quick_stack", "Quick stack"), "info");
  }, [state.containerOpen, addToast]);
  const handleSplitRequest = reactExports.useCallback((idx, panel) => {
    if (state.isBusy)
      return;
    const grid = getGrid(panel);
    const it = grid[idx];
    if (!it || it.count <= 1)
      return;
    setSplit({ visible: true, idx, panel });
  }, [state.isBusy, getGrid]);
  const handleSplitConfirm = reactExports.useCallback((amount) => {
    if (state.isBusy)
      return;
    if (split.idx === null)
      return;
    const grid = getGrid(split.panel);
    const it = grid[split.idx];
    if (!it) {
      setSplit({ visible: false, idx: null, panel: "main" });
      return;
    }
    if (amount <= 0 || amount >= it.count) {
      addToast(tr("ui_invalid_amount", "Invalid amount"), "error");
      setSplit({ visible: false, idx: null, panel: "main" });
      return;
    }
    const fromType = split.panel === "right" ? state.rightInventory?.type || "player" : "player";
    const emptySlot = grid.findIndex((slot, i) => slot === null && i !== split.idx);
    if (emptySlot === -1) {
      addToast(tr("ui_no_empty_slot", "No empty slot is available"), "error");
      setSplit({ visible: false, idx: null, panel: "main" });
      return;
    }
    busyFetch("swapItems", {
      fromSlot: it.slot,
      toSlot: emptySlot + 1,
      fromType,
      toType: fromType,
      count: amount
    });
    setSplit({ visible: false, idx: null, panel: "main" });
    addToast(trf("ui_split_complete", "Split %s x %s", amount, it.label || it.name), "info");
  }, [split, state.isBusy, getGrid, addToast, busyFetch, state.rightInventory]);
  const handleSplitCancel = reactExports.useCallback(() => {
    setSplit({ visible: false, idx: null, panel: "main" });
  }, []);
  const handleAmmoPickerClose = reactExports.useCallback(() => {
    if (ammoPickerBusy)
      return;
    setAmmoPicker(null);
  }, [ammoPickerBusy]);
  const handleAmmoPickerSelect = reactExports.useCallback(async (weaponSlot, ammoSlot) => {
    if (ammoPickerBusy)
      return;
    setAmmoPickerBusy(true);
    const accepted = await fetchNui("reloadWeapon", { weaponSlot, ammoSlot });
    setAmmoPickerBusy(false);
    if (accepted !== false)
      setAmmoPicker(null);
  }, [ammoPickerBusy]);
  const handleAmmoPickerUnload = reactExports.useCallback(async (weaponSlot) => {
    if (ammoPickerBusy)
      return;
    setAmmoPickerBusy(true);
    await fetchNui("removeAmmo", weaponSlot);
    setAmmoPickerBusy(false);
    setAmmoPicker(null);
  }, [ammoPickerBusy]);
  const handleAmmoPickerPreferred = reactExports.useCallback(async (weaponSlot, item) => {
    if (ammoPickerBusy)
      return;
    const reply = await fetchNui("setPreferredAmmo", { weaponSlot, item });
    if (!reply?.ok)
      return;
    setAmmoPicker((current) => current && current.weaponSlot === weaponSlot ? { ...current, options: current.options.map((option) => ({ ...option, preferred: option.item === reply.preferred })) } : current);
  }, [ammoPickerBusy]);
  const handleCustomButton = reactExports.useCallback((idx, buttonId) => {
    const it = state.grid[idx];
    if (!it)
      return;
    fetchNui("useButton", { id: buttonId, slot: it.slot });
  }, [state.grid]);
  const handleRemoveAmmo = reactExports.useCallback((idx) => {
    const it = state.grid[idx];
    if (!it || Number(it.metadata?.ammo || 0) <= 0)
      return;
    fetchNui("removeAmmo", it.slot);
  }, [state.grid]);
  const handleSetPaymentCurrency = reactExports.useCallback((c) => {
    dispatch({ type: "SET_SHOP_CURRENCY", currency: c });
  }, [dispatch]);
  const handleSetItemAmount = reactExports.useCallback((n) => {
    dispatch({ type: "SET_ITEM_AMOUNT", amount: n });
  }, [dispatch]);
  const handleTradeAccept = reactExports.useCallback(() => {
    if (!state.tradeRequest)
      return;
    fetchNui("acceptTrade", { tradeId: state.tradeRequest.tradeId });
    dispatch({ type: "TRADE_CLEAR_REQUEST" });
  }, [state.tradeRequest, dispatch]);
  const handleTradeDecline = reactExports.useCallback(() => {
    if (!state.tradeRequest)
      return;
    fetchNui("declineTrade", { tradeId: state.tradeRequest.tradeId });
    dispatch({ type: "TRADE_CLEAR_REQUEST" });
  }, [state.tradeRequest, dispatch]);
  const handleTradeAddItem = reactExports.useCallback((item) => {
    if (state.myOffer.some((o) => o.id === item.id)) {
      addToast(tr("ui_trade_item_exists", "This item is already in the offer"), "error");
      return;
    }
    const newOffer = [...state.myOffer, { id: item.id, name: item.name, label: item.label, count: item.count, weight: item.weight }];
    dispatch({ type: "TRADE_SET_MY_OFFER", items: newOffer });
    fetchNui("offerTradeItems", { tradeId: state.tradeId, items: newOffer });
  }, [state.myOffer, state.tradeId, dispatch, addToast]);
  const handleTradeRemoveItem = reactExports.useCallback((itemId) => {
    const newOffer = state.myOffer.filter((o) => o.id !== itemId);
    dispatch({ type: "TRADE_SET_MY_OFFER", items: newOffer });
    fetchNui("offerTradeItems", { tradeId: state.tradeId, items: newOffer });
  }, [state.myOffer, state.tradeId, dispatch]);
  const handleTradeConfirm = reactExports.useCallback(() => {
    dispatch({ type: "TRADE_MY_CONFIRM" });
    fetchNui("confirmTrade", { tradeId: state.tradeId });
  }, [state.tradeId, dispatch]);
  const handleTradeCancel = reactExports.useCallback(() => {
    fetchNui("cancelTrade", { tradeId: state.tradeId });
  }, [state.tradeId]);
  reactExports.useEffect(() => {
    function onKeyDown(e) {
      if (!visible)
        return;
      const tag = document.activeElement?.tagName || "";
      const typing = tag === "INPUT" || tag === "TEXTAREA";
      if (e.key === "Escape") {
        if (ammoPicker) {
          handleAmmoPickerClose();
          e.preventDefault();
          return;
        }
        if (state.tradeOpen) {
          handleTradeCancel();
          e.preventDefault();
          return;
        }
        if (split.visible) {
          handleSplitCancel();
          e.preventDefault();
          return;
        }
        if (state.inspecting !== null) {
          handleCloseInspect();
          e.preventDefault();
          return;
        }
        if (state.containerOpen !== null) {
          handleCloseContainer();
          e.preventDefault();
          return;
        }
        if (typing) {
          document.activeElement.blur();
          e.preventDefault();
          return;
        }
        handleClose();
        e.preventDefault();
      }
      if (typing)
        return;
      if (e.key === "i" || e.key === "I") {
        handleClose();
        e.preventDefault();
      }
      if (e.key >= "1" && e.key <= "6") {
        const cats = ["all", "item_ammo", "item_food", "item_misc", "item_collectables", "item_weapon"];
        handleCategoryChange(cats[parseInt(e.key) - 1]);
        e.preventDefault();
      }
      if (e.key === "s" || e.key === "S") {
        handleSort();
        e.preventDefault();
      }
    }
    document.addEventListener("keydown", onKeyDown);
    return () => document.removeEventListener("keydown", onKeyDown);
  }, [visible, state.inspecting, state.containerOpen, state.tradeOpen, split.visible, ammoPicker, handleAmmoPickerClose, handleCloseInspect, handleCloseContainer, handleClose, handleCategoryChange, handleSort, handleSplitCancel, handleTradeCancel]);
  const selectedItem = state.selected !== null ? getGrid(state.panel)[state.selected] : null;
  const ctxItem = ctx.visible && ctx.idx !== null ? getGrid(ctx.panel)[ctx.idx] : null;
  const inspectItem = state.inspecting !== null ? getGrid(state.inspectPanel)[state.inspecting] : null;
  const splitItem = split.visible && split.idx !== null ? getGrid(split.panel)[split.idx] : null;
  const customButtons = reactExports.useMemo(() => {
    if (!ctxItem?.name)
      return void 0;
    const data = itemsDbRef.current[ctxItem.name];
    return data?.buttons?.map((button, index) => ({
      ...typeof button === "string" ? { label: button } : button,
      id: index + 1
    }));
  }, [ctxItem]);
  if (!visible)
    return /* @__PURE__ */ jsxs(Fragment, { children: [
      /* @__PURE__ */ jsx(HotBar, { slots: hotbar.slots, visible: hotbar.hotbarVisible, onUseSlot: hotbar.useSlot }),
      /* @__PURE__ */ jsx(ToastContainer, { toasts })
    ] });
  return /* @__PURE__ */ jsxs(DndContext, { sensors, collisionDetection: pointerWithin, onDragStart: handleDragStart, onDragEnd: handleDragEnd, children: [
    /* @__PURE__ */ jsxs("div", { id: "inventory", style: { display: "block" }, children: [
      /* @__PURE__ */ jsxs(
        "div",
        {
          id: "inventory-wrapper",
          className: "wf-shell",
          ref: wrapperRef,
          style: {
            opacity: animating ? 1 : 0,
            ...fittedPanelPos ? {
              left: `${fittedPanelPos.x}px`,
              top: `${fittedPanelPos.y}px`,
              transform: animating ? "none" : "scale(.8)"
            } : {
              transform: animating ? "translateY(-50%)" : "translateY(-50%) scale(.8)"
            }
          },
          children: [
            /* @__PURE__ */ jsxs("div", { className: "top", onMouseDown: handlePanelDragStart, style: { cursor: "grab" }, children: [
              /* @__PURE__ */ jsx("div", { className: "inv-badge", children: SVG_SATCHEL }),
              /* @__PURE__ */ jsx("div", { className: "inv-titles", children: /* @__PURE__ */ jsx("span", { className: "title", id: "inv-title", children: tr("ui_inventory", "Inventory") }) }),
              /* @__PURE__ */ jsx("div", { id: "inv-close-btn", onClick: handleClose, children: SVG_X })
            ] }),
            /* @__PURE__ */ jsxs("div", { className: "inv-weight-block", children: [
              /* @__PURE__ */ jsx(WeightBar, { grid: state.grid, maxWeight: state.maxWeight, cash: state.playerCash }),
              /* @__PURE__ */ jsx(WeightProgress, { grid: state.grid, maxWeight: state.maxWeight })
            ] }),
            /* @__PURE__ */ jsx("div", { className: "inv-hr" }),
            /* @__PURE__ */ jsxs("div", { id: "inv-currency-row", children: [
              /* @__PURE__ */ jsxs("div", { className: "inv-currency cash", children: [
                /* @__PURE__ */ jsx("span", { className: "inv-currency-icon", children: SVG_CASH }),
                /* @__PURE__ */ jsx("span", { className: "inv-currency-val", children: formatCompact(state.playerCash) })
              ] }),
              /* @__PURE__ */ jsxs("div", { className: "inv-currency gold", children: [
                /* @__PURE__ */ jsx("span", { className: "inv-currency-icon", children: SVG_GOLD }),
                /* @__PURE__ */ jsx("span", { className: "inv-currency-val", children: formatCompact(state.playerGold) })
              ] })
            ] }),
            /* @__PURE__ */ jsxs("div", { id: "inv-search-row", children: [
              /* @__PURE__ */ jsxs("div", { className: "inv-search", children: [
                /* @__PURE__ */ jsx(
                  "input",
                  {
                    type: "text",
                    className: "search-bar",
                    id: "inv-search",
                    placeholder: tr("ui_search_items", "Search items..."),
                    value: state.search,
                    onChange: handleSearchChange,
                    spellCheck: false,
                    autoComplete: "off"
                  }
                ),
                state.search ? /* @__PURE__ */ jsx(
                  "button",
                  {
                    type: "button",
                    className: "inv-search-clear",
                    onClick: handleSearchClear,
                    "aria-label": tr("ui_cancel", "Cancel"),
                    children: /* @__PURE__ */ jsx(Glyph, { tex: "cross" })
                  }
                ) : null
              ] }),
              /* @__PURE__ */ jsx("div", { id: "inv-amount-row", children: /* @__PURE__ */ jsx(
                "input",
                {
                  type: "number",
                  className: "inv-amount-input",
                  value: state.itemAmount || "",
                  min: 0,
                  onChange: (e) => handleSetItemAmount(parseInt(e.target.value) || 0),
                  placeholder: "0",
                  title: tr("ui_quantity", "Quantity"),
                  "aria-label": tr("ui_quantity", "Quantity")
                }
              ) })
            ] }),
            /* @__PURE__ */ jsx(
              InventoryGrid,
              {
                grid: state.grid,
                category: state.category,
                search: state.search,
                selected: state.selected,
                panel: "main",
                selectedPanel: state.panel,
                hotbarSlots: hotbar.slots,
                onSelect: handleSelect,
                onContextMenu: handleContextMenu,
                onDoubleClick: handleDoubleClick,
                onMouseOver: handleMouseOver,
                onMouseLeave: handleMouseLeave
              }
            ),
            /* @__PURE__ */ jsx(
              Toolbar,
              {
                onSort: handleSort,
                onQuickStack: handleQuickStack,
                containerOpen: state.containerOpen
              }
            ),
            /* @__PURE__ */ jsx(CategoryBar, { active: state.category, onChange: handleCategoryChange, grid: state.grid }),
            /* @__PURE__ */ jsx(Keys, { keys: [
              ["Esc", tr("ui_nb_key_close", "close")],
              ["1-6", tr("ui_nb_key_tabs", "sections")],
              [tr("ui_nb_key_rmb", "Right click"), tr("ui_nb_key_options", "options")]
            ] })
          ]
        }
      ),
      /* @__PURE__ */ jsx(
        DetailPanel,
        {
          item: selectedItem,
          panel: state.panel,
          containerOpen: state.containerOpen,
          panelPos: fittedPanelPos
        }
      ),
      /* @__PURE__ */ jsx(
        ContainerPanel,
        {
          containerOpen: state.containerOpen,
          containerGrid: state.containerGrid,
          containerLabel: state.containerLabel,
          containerMaxWeight: state.containerMaxWeight,
          containerSlots: state.containerSlots,
          selected: state.selected,
          selectedPanel: state.panel,
          onSelect: handleSelect,
          onContextMenu: handleContextMenu,
          onDoubleClick: handleDoubleClick,
          onMouseOver: handleMouseOver,
          onMouseLeave: handleMouseLeave,
          onClose: handleCloseContainer,
          panelPos: fittedPanelPos
        }
      ),
      /* @__PURE__ */ jsx(
        RightInventoryPanel,
        {
          rightInventory: state.rightInventory,
          rightGrid: state.rightGrid,
          selected: state.selected,
          selectedPanel: state.panel,
          onSelect: handleSelect,
          onContextMenu: handleContextMenu,
          onDoubleClick: handleDoubleClick,
          onMouseOver: handleMouseOver,
          onMouseLeave: handleMouseLeave,
          playerCash: state.playerCash,
          playerGold: state.playerGold,
          shopPaymentCurrency: state.shopPaymentCurrency,
          onSetPaymentCurrency: handleSetPaymentCurrency,
          itemAmount: state.itemAmount,
          onSetItemAmount: handleSetItemAmount
        }
      ),
      /* @__PURE__ */ jsx(
        ContextMenu,
        {
          visible: ctx.visible,
          x: ctx.x,
          y: ctx.y,
          item: ctxItem,
          idx: ctx.idx,
          panel: ctx.panel,
          containerOpen: state.containerOpen,
          onClose: () => setCtx((c) => ({ ...c, visible: false })),
          onUse: handleUseItem,
          onDrop: handleDropItem,
          onGive: handleGiveItem,
          giveCount: ctxItem ? Math.min(ctxItem.count, state.itemAmount > 0 ? state.itemAmount : ctxItem.count) : void 0,
          onInspect: handleInspect,
          onOpenContainer: handleOpenContainer,
          onStoreIn: handleStoreIn,
          onTakeOut: handleTakeOut,
          onSplit: handleSplitRequest,
          onRemoveAmmo: handleRemoveAmmo,
          customButtons,
          onCustomButton: handleCustomButton
        }
      ),
      /* @__PURE__ */ jsx(Tooltip, { item: tooltip.item, anchorRect: tooltip.rect }),
      /* @__PURE__ */ jsx(InspectOverlay, { item: inspectItem, onClose: handleCloseInspect }),
      /* @__PURE__ */ jsx(
        SplitDialog,
        {
          item: splitItem,
          visible: split.visible,
          onConfirm: handleSplitConfirm,
          onCancel: handleSplitCancel
        }
      ),
      /* @__PURE__ */ jsx(
        AmmoPicker,
        {
          data: ammoPicker,
          busy: ammoPickerBusy,
          onSelect: handleAmmoPickerSelect,
          onUnload: handleAmmoPickerUnload,
          onSetPreferred: handleAmmoPickerPreferred,
          onClose: handleAmmoPickerClose
        }
      ),
      /* @__PURE__ */ jsx(DropZone, { active: isDragging && !!dragItem }),
      /* @__PURE__ */ jsx(
        TradeRequest,
        {
          request: state.tradeRequest,
          onAccept: handleTradeAccept,
          onDecline: handleTradeDecline
        }
      ),
      /* @__PURE__ */ jsx(
        TradePanel,
        {
          tradeOpen: state.tradeOpen,
          tradePartner: state.tradePartner,
          myOffer: state.myOffer,
          theirOffer: state.theirOffer,
          myConfirmed: state.myConfirmed,
          theirConfirmed: state.theirConfirmed,
          tradeCompleting: state.tradeCompleting,
          onRemoveFromOffer: handleTradeRemoveItem,
          onConfirm: handleTradeConfirm,
          onCancel: handleTradeCancel
        }
      )
    ] }),
    /* @__PURE__ */ jsx(DragOverlay, { dropAnimation: null, children: dragItem ? /* @__PURE__ */ jsx(DragGhost, { item: dragItem }) : null }),
    /* @__PURE__ */ jsx(HotBar, { slots: hotbar.slots, visible: hotbar.hotbarVisible, onUseSlot: hotbar.useSlot }),
    /* @__PURE__ */ jsx(ToastContainer, { toasts })
  ] });
}

const kit = '';

const shopKit = '';

const index = '';

const global = '';

const skin = '';

try {
  const base = new URL("./", window.location.href).href;
  const FONTS = `${base}fonts/`;
  const AR = "U+0600-06FF,U+0750-077F,U+0870-088E,U+0890-0891,U+0897-08E1,U+08E3-08FF,U+FB50-FDFF,U+FE70-FE74,U+FE76-FEFC,U+200C-200E,U+2010-2011,U+0660-0669";
  const style = document.createElement("style");
  style.textContent = `
    @font-face { font-family: "EB Garamond"; font-style: normal; font-weight: 400 800; src: url("${FONTS}EBGaramond-latin.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "EB Garamond"; font-style: italic; font-weight: 400 800; src: url("${FONTS}EBGaramond-Italic-latin.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "Amiri"; font-weight: 400; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "Amiri"; font-weight: 700; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "Lalezar"; font-weight: 100 900; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "RDR Lino"; font-weight: 100 900; src: url("${FONTS}RDRLino-Regular.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "RDR Catalogue"; font-weight: 100 900; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "Noto Sans Arabic"; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); font-weight: 100 900; font-display: swap; }
    @font-face { font-family: "Tajawal"; font-weight: 400; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "Tajawal"; font-weight: 700; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
  `;
  document.head.appendChild(style);
  const rs = document.documentElement.style;
  rs.setProperty("--tex-tear", `url("${base}tex/ui/tear.png")`);
  rs.setProperty("--tex-grain", `url("${base}tex/ui/grain.png")`);
  rs.setProperty("--tex-band", `url("${base}tex/ui/band.png")`);
  rs.setProperty("--tex-band-sm", `url("${base}tex/ui/band-sm.png")`);
} catch {
}
(() => {
  const BASE = {"BASE_URL":"./","MODE":"production","DEV":false,"PROD":true,"SSR":false}?.BASE_URL ;
  const ABS_BASE = new URL(BASE, document.baseURI).href;
  window.rsmAsset = (p) => ABS_BASE + p;
  const tex = (p) => `url("${ABS_BASE}${p}")`;
  const rs = document.documentElement.style;
  const UI = [
    "crafting_highlight_t",
    "crafting_highlight_b",
    "crafting_highlight_l",
    "crafting_highlight_r",
    "crafting_highlight_tl",
    "crafting_highlight_tr",
    "crafting_highlight_bl",
    "crafting_highlight_br",
    "crafting_outline",
    "divider_line",
    "title_divider",
    "vertical_divider_line",
    "list_item_h_line_narrow",
    "menu_header_1a",
    "selection_box_bg_1a",
    "selection_box_bg_1c",
    "toast_bg",
    "help_text_bg",
    "lock",
    "menu_icon_rank",
    "star",
    "rating_star",
    "cross",
    "tick",
    "selection_arrow_left",
    "selection_arrow_right",
    "weapon_stats_bar",
    "weapon_stats_bar_mask",
    "menu_bar",
    "swatch_bg_1a",
    "counter_bg_1a"
  ];
  UI.forEach((n) => rs.setProperty(`--tex-${n}`, tex(`tex/ui/${n}.png`)));
})();
(() => {
  const asset = (p) => window.rsmAsset ? window.rsmAsset(p) : p;
  const cache = {};
  let lastHover = 0;
  const play = (file, vol, throttle = false) => {
    if (throttle) {
      const now = typeof performance !== "undefined" ? performance.now() : Date.now();
      if (now - lastHover < 70)
        return;
      lastHover = now;
    }
    try {
      let a = cache[file];
      if (!a) {
        a = new Audio(asset("sounds/" + file));
        a.preload = "auto";
        cache[file] = a;
      }
      const node = a.cloneNode(true);
      node.volume = vol;
      void node.play().catch(() => {
      });
    } catch {
    }
  };
  const hit = (el) => {
    const t = el;
    return t && typeof t.closest === "function" && t.closest(
      'button,[role="button"],[role="menuitem"],[class*="menu" i] li,.context-menu-list li,.slot.filled,.hb-slot.hb-filled,#inv-close-btn,.inv-toolbar .tb-btn,#inventory .category,#inventory-options .option,.split-btn,.split-adj,.trade-btn,.trade-req-btn,#container-panel .cp-close,.trade-close,.trade-slot-filled'
    );
  };
  document.addEventListener("pointerover", (e) => {
    if (hit(e.target))
      play("button.mp3", 0.2, true);
  }, true);
  document.addEventListener("pointerdown", (e) => {
    if (hit(e.target))
      play("selected.mp3", 0.38);
  }, true);
})();
const root = document.getElementById("root");
createRoot(root).render(
  /* @__PURE__ */ jsx(React.StrictMode, { children: /* @__PURE__ */ jsx(App, {}) })
);
