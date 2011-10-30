(function() {
  var IMfs, IMfsStats, IMfsWatcher, OnNextTick, func, name, _ref;
  IMfs = (function() {
    function IMfs() {
      this.files = {};
    }
    IMfs.prototype.stat = function(path, callback) {
      return this.__callSync(this, this.statSync, callback, arguments);
    };
    IMfs.prototype.statSync = function(path) {
      var file, isDir, isFile, len;
      path = this.__normalize(path);
      file = this.files[path];
      len = 0;
      if (file) {
        len = file.length;
      }
      isFile = !!file;
      isDir = this.__isDir(path);
      return new IMfsStats(isFile, isDir, len);
    };
    IMfs.prototype.realpath = function(path, callback) {
      return this.__callSync(this, this.realpathSync, callback, arguments);
    };
    IMfs.prototype.realpathSync = function(path) {
      return this.__normalize(path);
    };
    IMfs.prototype.unlink = function(path, callback) {
      return this.__callSync(this, this.unlinkSync, callback, arguments);
    };
    IMfs.prototype.unlinkSync = function(path) {
      path = this.__normalize(path);
      return delete this.files[path];
    };
    IMfs.prototype.readdir = function(path, callback) {
      return this.__callSync(this, this.readdirSync, callback, arguments);
    };
    IMfs.prototype.readdirSync = function(path) {
      var data, length, name, rest, result, _ref;
      path = "" + (this.__normalize(path));
      if (path !== '/') {
        path = "" + path + "/";
      }
      length = path.length;
      result = [];
      _ref = this.files;
      for (name in _ref) {
        data = _ref[name];
        if (path !== name.substr(0, length)) {
          continue;
        }
        rest = name.substr(length);
        if (-1 === rest.indexOf('/')) {
          result.push(rest);
        }
      }
      return result;
    };
    IMfs.prototype.readFile = function(filename, encoding, callback) {
      if (encoding == null) {
        encoding = 'utf8';
      }
      if (typeof encoding === 'function') {
        callback = encoding;
      }
      return this.__callSync(this, this.readFileSync, callback, arguments);
    };
    IMfs.prototype.readFileSync = function(filename, encoding) {
      if (encoding == null) {
        encoding = 'utf8';
      }
      filename = this.__normalize(filename);
      if (this.files.hasOwnProperty(filename)) {
        return this.files[filename];
      }
      throw "file not found: '" + filename + "'";
    };
    IMfs.prototype.writeFile = function(filename, data, encoding, callback) {
      if (encoding == null) {
        encoding = 'utf8';
      }
      if (typeof encoding === 'function') {
        callback = encoding;
      }
      return this.__callSync(this, this.writeFileSync, callback, arguments);
    };
    IMfs.prototype.writeFileSync = function(filename, data, encoding) {
      if (encoding == null) {
        encoding = 'utf8';
      }
      filename = this.__normalize(filename);
      return this.files[filename] = data;
    };
    IMfs.prototype.__TBD = function(args) {
      throw "" + args.callee.displayName + " not yet implemented";
    };
    IMfs.prototype.__normalize = function(path) {
      var newParts, part, parts, _i, _len;
      parts = path.split('/');
      newParts = [];
      for (_i = 0, _len = parts.length; _i < _len; _i++) {
        part = parts[_i];
        if (part === '') {
          continue;
        }
        if (part === '.') {
          continue;
        }
        if (part === '..') {
          if (newParts.length > 0) {
            newParts.pop();
          }
          continue;
        }
        newParts.push(part);
      }
      return "/" + (newParts.join('/'));
    };
    IMfs.prototype.__isDir = function(path) {
      return false;
    };
    IMfs.prototype.__callSync = function(receiver, syncFunc, callback, args) {
      OnNextTick(function() {
        var e, result;
        e = null;
        result = null;
        try {
          return result = syncFunc.apply(receiver, args);
        } catch (ex) {
          return e = ex;
        } finally {
          if (typeof callback === "function") {
            callback(e, result);
          }
        }
      });
      return null;
    };
    return IMfs;
  })();
  OnNextTick = function(func) {
    return setTimeout(func, 0);
  };
  IMfsWatcher = (function() {
    function IMfsWatcher() {}
    return IMfsWatcher;
  })();
  IMfsStats = (function() {
    function IMfsStats(__isFile, __isDirectory, size) {
      this.__isFile = __isFile;
      this.__isDirectory = __isDirectory;
      this.size = size;
    }
    IMfsStats.prototype.isFile = function() {
      return this.__isFile;
    };
    IMfsStats.prototype.isDirectory = function() {
      return this.__isDirectory;
    };
    IMfsStats.prototype.isBlockDevice = function() {
      return false;
    };
    IMfsStats.prototype.isCharacterDevice = function() {
      return false;
    };
    IMfsStats.prototype.isSymbolicLink = function() {
      return false;
    };
    IMfsStats.prototype.isFIFO = function() {
      return false;
    };
    IMfsStats.prototype.isSocket = function() {
      return false;
    };
    return IMfsStats;
  })();
  _ref = IMfs.prototype;
  for (name in _ref) {
    func = _ref[name];
    func.displayName = "IMfs." + name;
  }
  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = IMfs;
  } else {
    window.IMfs = IMfs;
  }
}).call(this);
