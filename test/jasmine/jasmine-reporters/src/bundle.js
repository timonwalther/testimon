(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

},{}],2:[function(require,module,exports){
(function (process){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

// resolves . and .. elements in a path array with directory names there
// must be no slashes, empty elements, or device names (c:\) in the array
// (so also no leading and trailing slashes - it does not distinguish
// relative and absolute paths)
function normalizeArray(parts, allowAboveRoot) {
  // if the path tries to go above the root, `up` ends up > 0
  var up = 0;
  for (var i = parts.length - 1; i >= 0; i--) {
    var last = parts[i];
    if (last === '.') {
      parts.splice(i, 1);
    } else if (last === '..') {
      parts.splice(i, 1);
      up++;
    } else if (up) {
      parts.splice(i, 1);
      up--;
    }
  }

  // if the path is allowed to go above the root, restore leading ..s
  if (allowAboveRoot) {
    for (; up--; up) {
      parts.unshift('..');
    }
  }

  return parts;
}

// Split a filename into [root, dir, basename, ext], unix version
// 'root' is just a slash, or nothing.
var splitPathRe =
    /^(\/?|)([\s\S]*?)((?:\.{1,2}|[^\/]+?|)(\.[^.\/]*|))(?:[\/]*)$/;
var splitPath = function(filename) {
  return splitPathRe.exec(filename).slice(1);
};

// path.resolve([from ...], to)
// posix version
exports.resolve = function() {
  var resolvedPath = '',
      resolvedAbsolute = false;

  for (var i = arguments.length - 1; i >= -1 && !resolvedAbsolute; i--) {
    var path = (i >= 0) ? arguments[i] : process.cwd();

    // Skip empty and invalid entries
    if (typeof path !== 'string') {
      throw new TypeError('Arguments to path.resolve must be strings');
    } else if (!path) {
      continue;
    }

    resolvedPath = path + '/' + resolvedPath;
    resolvedAbsolute = path.charAt(0) === '/';
  }

  // At this point the path should be resolved to a full absolute path, but
  // handle relative paths to be safe (might happen when process.cwd() fails)

  // Normalize the path
  resolvedPath = normalizeArray(filter(resolvedPath.split('/'), function(p) {
    return !!p;
  }), !resolvedAbsolute).join('/');

  return ((resolvedAbsolute ? '/' : '') + resolvedPath) || '.';
};

// path.normalize(path)
// posix version
exports.normalize = function(path) {
  var isAbsolute = exports.isAbsolute(path),
      trailingSlash = substr(path, -1) === '/';

  // Normalize the path
  path = normalizeArray(filter(path.split('/'), function(p) {
    return !!p;
  }), !isAbsolute).join('/');

  if (!path && !isAbsolute) {
    path = '.';
  }
  if (path && trailingSlash) {
    path += '/';
  }

  return (isAbsolute ? '/' : '') + path;
};

// posix version
exports.isAbsolute = function(path) {
  return path.charAt(0) === '/';
};

// posix version
exports.join = function() {
  var paths = Array.prototype.slice.call(arguments, 0);
  return exports.normalize(filter(paths, function(p, index) {
    if (typeof p !== 'string') {
      throw new TypeError('Arguments to path.join must be strings');
    }
    return p;
  }).join('/'));
};


// path.relative(from, to)
// posix version
exports.relative = function(from, to) {
  from = exports.resolve(from).substr(1);
  to = exports.resolve(to).substr(1);

  function trim(arr) {
    var start = 0;
    for (; start < arr.length; start++) {
      if (arr[start] !== '') break;
    }

    var end = arr.length - 1;
    for (; end >= 0; end--) {
      if (arr[end] !== '') break;
    }

    if (start > end) return [];
    return arr.slice(start, end - start + 1);
  }

  var fromParts = trim(from.split('/'));
  var toParts = trim(to.split('/'));

  var length = Math.min(fromParts.length, toParts.length);
  var samePartsLength = length;
  for (var i = 0; i < length; i++) {
    if (fromParts[i] !== toParts[i]) {
      samePartsLength = i;
      break;
    }
  }

  var outputParts = [];
  for (var i = samePartsLength; i < fromParts.length; i++) {
    outputParts.push('..');
  }

  outputParts = outputParts.concat(toParts.slice(samePartsLength));

  return outputParts.join('/');
};

exports.sep = '/';
exports.delimiter = ':';

exports.dirname = function(path) {
  var result = splitPath(path),
      root = result[0],
      dir = result[1];

  if (!root && !dir) {
    // No dirname whatsoever
    return '.';
  }

  if (dir) {
    // It has a dirname, strip trailing slash
    dir = dir.substr(0, dir.length - 1);
  }

  return root + dir;
};


exports.basename = function(path, ext) {
  var f = splitPath(path)[2];
  // TODO: make this comparison case-insensitive on windows?
  if (ext && f.substr(-1 * ext.length) === ext) {
    f = f.substr(0, f.length - ext.length);
  }
  return f;
};


exports.extname = function(path) {
  return splitPath(path)[3];
};

function filter (xs, f) {
    if (xs.filter) return xs.filter(f);
    var res = [];
    for (var i = 0; i < xs.length; i++) {
        if (f(xs[i], i, xs)) res.push(xs[i]);
    }
    return res;
}

// String.prototype.substr - negative index don't work in IE8
var substr = 'ab'.substr(-1) === 'b'
    ? function (str, start, len) { return str.substr(start, len) }
    : function (str, start, len) {
        if (start < 0) start = str.length + start;
        return str.substr(start, len);
    }
;

}).call(this,require('_process'))
},{"_process":3}],3:[function(require,module,exports){
// shim for using process in browser
var process = module.exports = {};

// cached from whatever global is present so that test runners that stub it
// don't break things.  But we need to wrap it in a try catch in case it is
// wrapped in strict mode code which doesn't define any globals.  It's inside a
// function because try/catches deoptimize in certain engines.

var cachedSetTimeout;
var cachedClearTimeout;

function defaultSetTimout() {
    throw new Error('setTimeout has not been defined');
}
function defaultClearTimeout () {
    throw new Error('clearTimeout has not been defined');
}
(function () {
    try {
        if (typeof setTimeout === 'function') {
            cachedSetTimeout = setTimeout;
        } else {
            cachedSetTimeout = defaultSetTimout;
        }
    } catch (e) {
        cachedSetTimeout = defaultSetTimout;
    }
    try {
        if (typeof clearTimeout === 'function') {
            cachedClearTimeout = clearTimeout;
        } else {
            cachedClearTimeout = defaultClearTimeout;
        }
    } catch (e) {
        cachedClearTimeout = defaultClearTimeout;
    }
} ())
function runTimeout(fun) {
    if (cachedSetTimeout === setTimeout) {
        //normal enviroments in sane situations
        return setTimeout(fun, 0);
    }
    // if setTimeout wasn't available but was latter defined
    if ((cachedSetTimeout === defaultSetTimout || !cachedSetTimeout) && setTimeout) {
        cachedSetTimeout = setTimeout;
        return setTimeout(fun, 0);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedSetTimeout(fun, 0);
    } catch(e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't trust the global object when called normally
            return cachedSetTimeout.call(null, fun, 0);
        } catch(e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error
            return cachedSetTimeout.call(this, fun, 0);
        }
    }


}
function runClearTimeout(marker) {
    if (cachedClearTimeout === clearTimeout) {
        //normal enviroments in sane situations
        return clearTimeout(marker);
    }
    // if clearTimeout wasn't available but was latter defined
    if ((cachedClearTimeout === defaultClearTimeout || !cachedClearTimeout) && clearTimeout) {
        cachedClearTimeout = clearTimeout;
        return clearTimeout(marker);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedClearTimeout(marker);
    } catch (e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't  trust the global object when called normally
            return cachedClearTimeout.call(null, marker);
        } catch (e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error.
            // Some versions of I.E. have different rules for clearTimeout vs setTimeout
            return cachedClearTimeout.call(this, marker);
        }
    }



}
var queue = [];
var draining = false;
var currentQueue;
var queueIndex = -1;

function cleanUpNextTick() {
    if (!draining || !currentQueue) {
        return;
    }
    draining = false;
    if (currentQueue.length) {
        queue = currentQueue.concat(queue);
    } else {
        queueIndex = -1;
    }
    if (queue.length) {
        drainQueue();
    }
}

function drainQueue() {
    if (draining) {
        return;
    }
    var timeout = runTimeout(cleanUpNextTick);
    draining = true;

    var len = queue.length;
    while(len) {
        currentQueue = queue;
        queue = [];
        while (++queueIndex < len) {
            if (currentQueue) {
                currentQueue[queueIndex].run();
            }
        }
        queueIndex = -1;
        len = queue.length;
    }
    currentQueue = null;
    draining = false;
    runClearTimeout(timeout);
}

process.nextTick = function (fun) {
    var args = new Array(arguments.length - 1);
    if (arguments.length > 1) {
        for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
        }
    }
    queue.push(new Item(fun, args));
    if (queue.length === 1 && !draining) {
        runTimeout(drainQueue);
    }
};

// v8 likes predictible objects
function Item(fun, array) {
    this.fun = fun;
    this.array = array;
}
Item.prototype.run = function () {
    this.fun.apply(null, this.array);
};
process.title = 'browser';
process.browser = true;
process.env = {};
process.argv = [];
process.version = ''; // empty string to avoid regexp issues
process.versions = {};

function noop() {}

process.on = noop;
process.addListener = noop;
process.once = noop;
process.off = noop;
process.removeListener = noop;
process.removeAllListeners = noop;
process.emit = noop;
process.prependListener = noop;
process.prependOnceListener = noop;

process.listeners = function (name) { return [] }

process.binding = function (name) {
    throw new Error('process.binding is not supported');
};

process.cwd = function () { return '/' };
process.chdir = function (dir) {
    throw new Error('process.chdir is not supported');
};
process.umask = function() { return 0; };

},{}],4:[function(require,module,exports){
(function (process){
var path = require('path');
var fs = require('fs');
var _0777 = parseInt('0777', 8);

module.exports = mkdirP.mkdirp = mkdirP.mkdirP = mkdirP;

function mkdirP (p, opts, f, made) {
    if (typeof opts === 'function') {
        f = opts;
        opts = {};
    }
    else if (!opts || typeof opts !== 'object') {
        opts = { mode: opts };
    }
    
    var mode = opts.mode;
    var xfs = opts.fs || fs;
    
    if (mode === undefined) {
        mode = _0777 & (~process.umask());
    }
    if (!made) made = null;
    
    var cb = f || function () {};
    p = path.resolve(p);
    
    xfs.mkdir(p, mode, function (er) {
        if (!er) {
            made = made || p;
            return cb(null, made);
        }
        switch (er.code) {
            case 'ENOENT':
                mkdirP(path.dirname(p), opts, function (er, made) {
                    if (er) cb(er, made);
                    else mkdirP(p, opts, cb, made);
                });
                break;

            // In the case of any other error, just see if there's a dir
            // there already.  If so, then hooray!  If not, then something
            // is borked.
            default:
                xfs.stat(p, function (er2, stat) {
                    // if the stat fails, then that's super weird.
                    // let the original error be the failure reason.
                    if (er2 || !stat.isDirectory()) cb(er, made)
                    else cb(null, made);
                });
                break;
        }
    });
}

mkdirP.sync = function sync (p, opts, made) {
    if (!opts || typeof opts !== 'object') {
        opts = { mode: opts };
    }
    
    var mode = opts.mode;
    var xfs = opts.fs || fs;
    
    if (mode === undefined) {
        mode = _0777 & (~process.umask());
    }
    if (!made) made = null;

    p = path.resolve(p);

    try {
        xfs.mkdirSync(p, mode);
        made = made || p;
    }
    catch (err0) {
        switch (err0.code) {
            case 'ENOENT' :
                made = sync(path.dirname(p), opts, made);
                sync(p, opts, made);
                break;

            // In the case of any other error, just see if there's a dir
            // there already.  If so, then hooray!  If not, then something
            // is borked.
            default:
                var stat;
                try {
                    stat = xfs.statSync(p);
                }
                catch (err1) {
                    throw err0;
                }
                if (!stat.isDirectory()) throw err0;
                break;
        }
    }

    return made;
};

}).call(this,require('_process'))
},{"_process":3,"fs":1,"path":2}],5:[function(require,module,exports){
(function (process){
/* global __phantom_writeFile */
(function(global) {
    var UNDEFINED,
        exportObject;

	
    if (typeof module !== "undefined" && module.exports) {
        
		exports = function (n) { return n * 111 } //add	 
		exportObject = exports;
    } else {
        exportObject = global.jasmineReporters = global.jasmineReporters || {};
    }

    function trim(str) { return str.replace(/^\s+/, "" ).replace(/\s+$/, "" ); }
    function elapsed(start, end) { return (end - start)/1000; }
    function isFailed(obj) { return obj.status === "failed"; }
    function isSkipped(obj) { return obj.status === "pending"; }
    function isDisabled(obj) { return obj.status === "disabled"; }
    function pad(n) { return n < 10 ? '0'+n : n; }
    function extend(dupe, obj) { // performs a shallow copy of all props of `obj` onto `dupe`
        for (var prop in obj) {
            if (obj.hasOwnProperty(prop)) {
                dupe[prop] = obj[prop];
            }
        }
        return dupe;
    }
    function ISODateString(d) {
        return d.getFullYear() + '-' +
            pad(d.getMonth()+1) + '-' +
            pad(d.getDate()) + 'T' +
            pad(d.getHours()) + ':' +
            pad(d.getMinutes()) + ':' +
            pad(d.getSeconds());
    }
    function escapeInvalidXmlChars(str) {
        return str.replace(/\&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/\>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/\'/g, "&apos;")
            .replace(/[\x1b]/g, ""); //Remove control character from Jasmine default output
    }
    function getQualifiedFilename(path, filename, separator) {
        if (path && path.substr(-1) !== separator && filename.substr(0) !== separator) {
            path += separator;
        }
        return path + filename;
    }
    function log(str) {
        var con = global.console || console;
        if (con && con.log) {
            con.log(str);
        }
    }
    /** Hooks into either process.stdout (node) or console.log, if that is not
     *  available (see https://gist.github.com/pguillory/729616).
     */
    function hook_stdout(callback) {
        var old_write;
        var useProcess;
        if(typeof(process)!=="undefined") {
            old_write = process.stdout.write;
            useProcess = true;
            process.stdout.write = (function(write) {
                return function(string, encoding, fd) {
                    write.apply(process.stdout, arguments);
                    callback(string, encoding, fd);
                };
            })(old_write);
        }
        else {
            old_write = console.log.bind(console);
            useProcess = false;
            console.log = (function(write) {
                return function(string) {
                    write.apply(string);
                    callback(string, 'utf8');
                };
            })(old_write);
        }
        return function() {
            if(useProcess) {
                process.stdout.write = old_write;
            }
            else {
                console.log = old_write;
            }
        };
    }

    /**
     * A delegate for letting the consumer
     * modify the suite name when it is used inside the junit report.
     * This is useful when running a test suite against multiple capabilities
     * because the report can have unique names for each combination of suite/spec
     * and capability/test environment.
     *
     * @callback modifySuiteName
     * @param {string} fullName
     * @param {object} suite
     */

    /**
     * A delegate for letting the consumer
     * modify the report filename when it is used inside the junit report.
     * This is useful when running a test suite against multiple capabilities
     * because the report can have unique names for each combination of suite/spec
     * and capability/test environment.
     *
     * @callback modifyReportFileName
     * @param {string} suggestedName
     * @param {object} suite
     */

    /**
     * Generates JUnit XML for the given spec run. There are various options
     * to control where the results are written, and the default values are
     * set to create as few .xml files as possible. It is possible to save a
     * single XML file, or an XML file for each top-level `describe`, or an
     * XML file for each `describe` regardless of nesting.
     *
     * Usage:
     *
     * jasmine.getEnv().addReporter(new jasmineReporters.JUnitXmlReporter(options));
     *
     * @param {object} [options]
     * @param {string} [savePath] directory to save the files (default: '')
     * @param {boolean} [consolidateAll] whether to save all test results in a
     *   single file (default: true)
     *   NOTE: if true, {filePrefix} is treated as the full filename (excluding
     *     extension)
     * @param {boolean} [consolidate] whether to save nested describes within the
     *   same file as their parent (default: true)
     *   NOTE: true does nothing if consolidateAll is also true.
     *   NOTE: false also sets consolidateAll to false.
     * @param {boolean} [useDotNotation] whether to separate suite names with
     *   dots instead of spaces, ie "Class.init" not "Class init" (default: true)
     * @param {boolean} [useFullTestName] whether to use the fully qualified Test
     *   name for the TestCase name attribute, ie "Suite Name Spec Name" not
     *   "Spec Name" (default: false)
     * @param {string} [filePrefix] is the string value that is prepended to the
     *   xml output file (default: junitresults-)
     *   NOTE: if consolidateAll is true, the default is simply "junitresults" and
     *     this becomes the actual filename, ie "junitresults.xml"
     * @param {string} [package] is the base package for all test suits that are
     *   handled by this report {default: none}
     * @param {function} [modifySuiteName] a delegate for letting the consumer
     *   modify the suite name when it is used inside the junit report.
     *   This is useful when running a test suite against multiple capabilities
     *   because the report can have unique names for each combination of suite/spec
     *   and capability/test environment.
     * @param {function} [modifyReportFileName] a delegate for letting the consumer
     *   modify the report filename.
     *   This is useful when running a test suite against multiple capabilities
     *   because the report can have unique names for each combination of suite/spec
     *   and capability/test environment.
     * @param {string} [stylesheetPath] is the string value that specifies a path
     *   to an XSLT stylesheet to add to the junit XML file so that it can be
     *   opened directly in a browser. (default: none, no xml-stylesheet tag is added)
     * @param {function} [systemOut] a delegate for letting the consumer add content
     *   to a <system-out> tag as part of each <testcase> spec output. If provided,
     *   it is invoked with the spec object and the fully qualified suite as filename.
     * @param {boolean} [captureStdout] enables capturing all output from stdout as spec output in the
     * xml-output elements of the junit reports {default: false}. If a systemOut delegate is defined and captureStdout
     * is true, the output of the spec can be accessed via spec._stdout
     */
    exportObject.JUnitXmlReporter = function(options) {
        var self = this;
        self.started = false;
        self.finished = false;
        // sanitize arguments
        options = options || {};
        self.savePath = options.savePath || '';
        self.consolidate = options.consolidate === UNDEFINED ? true : options.consolidate;
        self.consolidateAll = self.consolidate !== false && (options.consolidateAll === UNDEFINED ? true : options.consolidateAll);
        self.useDotNotation = options.useDotNotation === UNDEFINED ? true : options.useDotNotation;
        self.useFullTestName = options.useFullTestName === UNDEFINED ? false : options.useFullTestName;
        if (self.consolidateAll) {
            self.filePrefix = options.filePrefix || 'junitresults';
        } else {
            self.filePrefix = typeof options.filePrefix === 'string' ? options.filePrefix : 'junitresults-';
        }
        self.package = typeof(options.package) === 'string' ? escapeInvalidXmlChars(options.package) : UNDEFINED;
        self.stylesheetPath = typeof(options.stylesheetPath) === 'string' && options.stylesheetPath || UNDEFINED;

        if(options.modifySuiteName && typeof options.modifySuiteName !== 'function') {
            throw new Error('option "modifySuiteName" must be a function');
        }
        if(options.modifyReportFileName && typeof options.modifyReportFileName !== 'function') {
            throw new Error('option "modifyReportFileName" must be a function');
        }
        if(options.systemOut && typeof options.systemOut !== 'function') {
            throw new Error('option "systemOut" must be a function');
        }

        self.captureStdout = options.captureStdout || false;
        if(self.captureStdout && !options.systemOut) {
            options.systemOut = function (spec, specName) { // jshint ignore:line
                return spec._stdout;
            };
        }
        self.removeStdoutWrapper = undefined;

        var delegates = {};
        delegates.modifySuiteName = options.modifySuiteName;
        delegates.modifyReportFileName = options.modifyReportFileName;
        delegates.systemOut = options.systemOut;

        self.logEntries = [];

        var suites = [],
            currentSuite = null,
            totalSpecsExecuted = 0,
            totalSpecsDefined,
            // when use use fit, jasmine never calls suiteStarted / suiteDone, so make a fake one to use
            fakeFocusedSuite = {
                id: 'focused',
                description: 'focused specs',
                fullName: 'focused specs'
            };

        var __suites = {}, __specs = {};
        function getSuite(suite) {
            __suites[suite.id] = extend(__suites[suite.id] || {}, suite);
            return __suites[suite.id];
        }
        function getSpec(spec) {
            __specs[spec.id] = extend(__specs[spec.id] || {}, spec);
            return __specs[spec.id];
        }

        self.jasmineStarted = function(summary) {
            totalSpecsDefined = summary && summary.totalSpecsDefined || NaN;
            exportObject.startTime = new Date();
            self.started = true;
            if(self.captureStdout) {
                self.removeStdoutWrapper = hook_stdout(function(string, encoding, fd) { // jshint ignore:line
                    self.logEntries.push(string);
                });
            }
        };
        self.suiteStarted = function(suite) {
            suite = getSuite(suite);
            suite._startTime = new Date();
            suite._specs = [];
            suite._suites = [];
            suite._failures = 0;
            suite._skipped = 0;
            suite._disabled = 0;
            suite._parent = currentSuite;
            if (!currentSuite) {
                suites.push(suite);
            } else {
                currentSuite._suites.push(suite);
            }
            currentSuite = suite;
        };
        self.specStarted = function(spec) {
            if (!currentSuite) {
                // focused spec (fit) -- suiteStarted was never called
                self.suiteStarted(fakeFocusedSuite);
            }
            spec = getSpec(spec);
            spec._startTime = new Date();
            spec._suite = currentSuite;
            spec._stdout = "";
            currentSuite._specs.push(spec);
        };
        self.specDone = function(spec) {
            spec = getSpec(spec);
            spec._endTime = new Date();
            storeOutput(spec);
            if (isSkipped(spec)) { spec._suite._skipped++; }
            if (isDisabled(spec)) { spec._suite._disabled++; }
            if (isFailed(spec)) { spec._suite._failures += spec.failedExpectations.length; }
            totalSpecsExecuted++;
        };
        self.suiteDone = function(suite) {
            suite = getSuite(suite);
            if (suite._parent === UNDEFINED) {
                // disabled suite (xdescribe) -- suiteStarted was never called
                self.suiteStarted(suite);
            }
            suite._endTime = new Date();
            currentSuite = suite._parent;
        };
        self.jasmineDone = function() {
            if (currentSuite) {
                // focused spec (fit) -- suiteDone was never called
                self.suiteDone(fakeFocusedSuite);
            }
            var output = '';
            for (var i = 0; i < suites.length; i++) {
                output += self.getOrWriteNestedOutput(suites[i]);
            }
            // if we have anything to write here, write out the consolidated file
            if (output) {
                wrapOutputAndWriteFile(self.filePrefix, output);
            }
            //log("Specs skipped but not reported (entire suite skipped or targeted to specific specs)", totalSpecsDefined - totalSpecsExecuted + totalSpecsDisabled);

            self.finished = true;
            // this is so phantomjs-testrunner.js can tell if we're done executing
            exportObject.endTime = new Date();
            if(self.removeStdoutWrapper) {
                self.removeStdoutWrapper();
            }
        };

        self.getOrWriteNestedOutput = function(suite) {
            var output = suiteAsXml(suite);
            for (var i = 0; i < suite._suites.length; i++) {
                output += self.getOrWriteNestedOutput(suite._suites[i]);
            }
            if (self.consolidateAll || self.consolidate && suite._parent) {
                return output;
            } else {
                // if we aren't supposed to consolidate output, just write it now
                wrapOutputAndWriteFile(generateFilename(suite), output);
                return '';
            }
        };

        self.writeFile = function(filename, text) {
            var errors = [];
            var path = self.savePath;

            function phantomWrite(path, filename, text) {
                // turn filename into a qualified path
                filename = getQualifiedFilename(path, filename, window.fs_path_separator);
                // write via a method injected by phantomjs-testrunner.js
                __phantom_writeFile(filename, text);
            }

            function nodeWrite(path, filename, text) {
                var fs = require("fs");
                var nodejs_path = require("path");
                require("mkdirp").sync(path); // make sure the path exists
                var filepath = nodejs_path.join(path, filename);
                var xmlfile = fs.openSync(filepath, "w");
                fs.writeSync(xmlfile, text, 0);
                fs.closeSync(xmlfile);
                return;
            }
            // Attempt writing with each possible environment.
            // Track errors in case no write succeeds
            try {
                phantomWrite(path, filename, text);
                return;
            } catch (e) { errors.push('  PhantomJs attempt: ' + e.message); }
            try {
                nodeWrite(path, filename, text);
                return;
            } catch (f) { errors.push('  NodeJS attempt: ' + f.message); }

            // If made it here, no write succeeded.  Let user know.
            log("Warning: writing junit report failed for '" + path + "', '" +
                filename + "'. Reasons:\n" +
                errors.join("\n")
            );
        };

        /******** Helper functions with closure access for simplicity ********/
        function generateFilename(suite) {
            return self.filePrefix + getFullyQualifiedSuiteName(suite, true) + '.xml';
        }
        
        function getFullyQualifiedSuiteName(suite, isFilename) {
            var fullName;
            if (self.useDotNotation || isFilename) {
                fullName = suite.description;
                for (var parent = suite._parent; parent; parent = parent._parent) {
                    fullName = parent.description + '.' + fullName;
                }
            } else {
                fullName = suite.fullName;
            }

            // Either remove or escape invalid XML characters
            if (isFilename) {
                var fileName = "",
                    rFileChars = /[\w\.]/,
                    chr;
                while (fullName.length) {
                    chr = fullName[0];
                    fullName = fullName.substr(1);
                    if (rFileChars.test(chr)) {
                        fileName += chr;
                    }
                }
                if(delegates.modifyReportFileName) {
                    fileName = delegates.modifyReportFileName(fileName, suite);
                }
                return fileName;
            } else {

                if(delegates.modifySuiteName) {
                    fullName = delegates.modifySuiteName(fullName, suite);
                }

                return escapeInvalidXmlChars(fullName);
            }
        }

        function suiteAsXml(suite) {
            var xml = '\n <testsuite name="' + getFullyQualifiedSuiteName(suite) + '"';
            xml += ' timestamp="' + ISODateString(suite._startTime) + '"';
            xml += ' hostname="localhost"'; // many CI systems like Jenkins don't care about this, but junit spec says it is required
            xml += ' time="' + elapsed(suite._startTime, suite._endTime) + '"';
            xml += ' errors="0"';
            xml += ' tests="' + suite._specs.length + '"';
            xml += ' skipped="' + suite._skipped + '"';
            xml += ' disabled="' + suite._disabled + '"';
            // Because of JUnit's flat structure, only include directly failed tests (not failures for nested suites)
            xml += ' failures="' + suite._failures + '"';
            if (self.package) {
                xml += ' package="' + self.package + '"';
            }
            xml += '>';

            for (var i = 0; i < suite._specs.length; i++) {
                xml += specAsXml(suite._specs[i]);
            }
            xml += '\n </testsuite>';
            return xml;
        }
        function specAsXml(spec) {
            var testName = self.useFullTestName ? spec.fullName : spec.description;
            
            var xml = '\n  <testcase classname="' + getFullyQualifiedSuiteName(spec._suite) + '"';
            xml += ' name="' + escapeInvalidXmlChars(testName) + '"';
            xml += ' time="' + elapsed(spec._startTime, spec._endTime) + '"';

            var testCaseBody = '';
            if (isSkipped(spec) || isDisabled(spec)) {
                if (spec.pendingReason) {
                    testCaseBody = '\n   <skipped message="' + trim(escapeInvalidXmlChars(spec.pendingReason)) + '" />';
                } else {
                    testCaseBody = '\n   <skipped />';
                }
            } else if (isFailed(spec)) {
                for (var i = 0, failure; i < spec.failedExpectations.length; i++) {
                    failure = spec.failedExpectations[i];
                    testCaseBody += '\n   <failure type="' + (failure.matcherName || "exception") + '"';
                    testCaseBody += ' message="' + trim(escapeInvalidXmlChars(failure.message))+ '"';
                    testCaseBody += '>';
                    testCaseBody += '<![CDATA[' + trim(failure.stack || failure.message) + ']]>';
                    testCaseBody += '\n   </failure>';
                }
            }

            if (testCaseBody || delegates.systemOut) {
                xml += '>' + testCaseBody;
                if (delegates.systemOut) {
                    xml += '\n   <system-out>' + trim(escapeInvalidXmlChars(delegates.systemOut(spec, getFullyQualifiedSuiteName(spec._suite, true)))) + '</system-out>';
                }
                xml += '\n  </testcase>';
            } else {
                xml += ' />';
            }
            return xml;
        }
        function storeOutput(spec) {
            if(self.captureStdout && !isSkipped(spec)) {
                if(!isSkipped(spec) && !isDisabled(spec)) {
                    spec._stdout = self.logEntries.join("") + "\n";
                }
                self.logEntries.splice(0, self.logEntries.length);
            }
        }

        // To remove complexity and be more DRY about the silly preamble and <testsuites> element
        var prefix = '<?xml version="1.0" encoding="UTF-8" ?>';
        if (self.stylesheetPath) {
            prefix += '\n<?xml-stylesheet type="text/xsl" href="' + self.stylesheetPath + '" ?>';
        }
        prefix += '\n<testsuites>';
        var suffix = '\n</testsuites>';
        function wrapOutputAndWriteFile(filename, text) {
            if (filename.substr(-4) !== '.xml') { filename += '.xml'; }
            self.writeFile(filename, (prefix + text + suffix));
        }
    };
})(this);

}).call(this,require('_process'))
},{"_process":3,"fs":1,"mkdirp":4,"path":2}]},{},[5]);
