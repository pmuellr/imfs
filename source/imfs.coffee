#-------------------------------------------------------------------------------
# imfs - in-memory file system for the browser, using node.js APIs
#-------------------------------------------------------------------------------
# Copyright (c) 2011 Patrick Mueller, http://muellerware.org
# licensed under the MIT license: http://pmuellr.mit-license.org/
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
class IMfs

    #-------------------------------------------------------------------------------
    constructor: ->
        @files = {}

    #-------------------------------------------------------------------------------
    stat: (path, callback) ->
        @__callSync @, @statSync, callback, arguments

    #-------------------------------------------------------------------------------
    statSync: (path) ->
        path = @__normalize(path)
        file = @files[path]

        len = 0
        len = file.length if file

        isFile = !!file
        isDir  = @__isDir(path)

        new IMfsStats(isFile, isDir, len)

    #-------------------------------------------------------------------------------
    realpath: (path, callback) ->
        @__callSync @, @realpathSync, callback, arguments

    #-------------------------------------------------------------------------------
    realpathSync: (path) ->
        return @__normalize(path)

    #-------------------------------------------------------------------------------
    unlink: (path, callback) ->
        @__callSync @, @unlinkSync, callback, arguments

    #-------------------------------------------------------------------------------
    unlinkSync: (path) ->
        path = @__normalize(path)
        delete @files[path]

    #-------------------------------------------------------------------------------
    readdir: (path, callback) ->
        @__callSync @, @readdirSync, callback, arguments

    #-------------------------------------------------------------------------------
    readdirSync: (path) ->
        path   = "#{@__normalize(path)}"
        path   = "#{path}/" unless path is '/'
        length = path.length

        result = []

        for name, data of @files
            continue unless path == name.substr(0,length)
            rest = name.substr(length)
            if -1 == rest.indexOf('/')
                result.push(rest)

        return result

    #-------------------------------------------------------------------------------
    readFile: (filename, encoding='utf8', callback) ->
        if typeof encoding is 'function'
            callback = encoding
        @__callSync @, @readFileSync, callback, arguments

    #-------------------------------------------------------------------------------
    readFileSync: (filename, encoding='utf8') ->
        filename = @__normalize(filename)
        return @files[filename] if @files.hasOwnProperty filename
        throw "file not found: '#{filename}'"

    #-------------------------------------------------------------------------------
    writeFile: (filename, data, encoding='utf8', callback) ->
        if typeof encoding is 'function'
            callback = encoding
        @__callSync @, @writeFileSync, callback, arguments

    #-------------------------------------------------------------------------------
    writeFileSync: (filename, data, encoding='utf8') ->
        filename = @__normalize(filename)
        @files[filename] = data

    #-------------------------------------------------------------------------------
    __TBD: (args) ->
        throw "#{args.callee.displayName} not yet implemented"

    #-------------------------------------------------------------------------------
    __normalize: (path) ->
        parts = path.split('/')
        newParts = []

        for part in parts
            continue if part is ''
            continue if part is '.'

            if part is '..'
                newParts.pop() if newParts.length > 0
                continue

            newParts.push(part)

        return "/#{newParts.join('/')}"

    #-------------------------------------------------------------------------------
    __isDir: (path) ->
        false

    #-------------------------------------------------------------------------------
    __callSync: (receiver, syncFunc, callback, args) ->
        OnNextTick ->
            e      = null
            result = null
            try
                result = syncFunc.apply(receiver, args)
            catch ex
                e = ex
            finally
                callback?(e,result)
        null

#-------------------------------------------------------------------------------
OnNextTick = (func) ->
    setTimeout(func,0)

#-------------------------------------------------------------------------------
class IMfsWatcher

#-------------------------------------------------------------------------------
class IMfsStats
    constructor: (@__isFile, @__isDirectory, @size) ->
    isFile: () -> @__isFile
    isDirectory: () -> @__isDirectory
    isBlockDevice: () -> false
    isCharacterDevice: () -> false
    isSymbolicLink: () -> false
    isFIFO: () -> false
    isSocket: () -> false

#-------------------------------------------------------------------------------
# set the names of the methods
#-------------------------------------------------------------------------------
for name, func of IMfs::
    func.displayName = "IMfs.#{name}"

#-------------------------------------------------------------------------------
# set the exports or window global
#-------------------------------------------------------------------------------
if module?.exports?
    module.exports = IMfs
else
    window.IMfs = IMfs