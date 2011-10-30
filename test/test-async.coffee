#-------------------------------------------------------------------------------
# Copyright (c) 2011 Patrick Mueller, http://muellerware.org
# licensed under the MIT license: http://pmuellr.mit-license.org/
#-------------------------------------------------------------------------------

afs      = null
filename = 'a.txt'
contents = 'sample file contents'

module 'async',
    setup: ->
        afs = new IMfs

test 'stat', ->
    expect 4

    afs.writeFile filename, contents

    stop()
    afs.stat filename, (err, stat) ->
        start()
        ok not err?
        ok stat.isFile()
        ok not stat.isDirectory()
        ok stat.size is contents.length


test 'realpath', ->
    expect 2

    stop()
    afs.realpath filename, (err, result) ->
        start()
        ok not err?
        ok result is "/#{filename}"

test 'unlink', ->
    expect 3

    afs.writeFileSync filename, contents
    stat = afs.statSync filename
    ok stat.isFile()

    stop()
    afs.unlink filename, (err) ->
        start()
        ok not err?
        stat = afs.statSync filename
        ok not stat.isFile()

test 'readdir', ->
    expect 2

    afs.writeFileSync filename, contents

    stop()
    afs.readdir '/', (err, result) ->
        start()
        ok result.length is 1
        ok result[0] is filename


test 'writeFile', ->
    expect 2

    stop()
    afs.writeFile filename, contents, (err) ->
        start()
        ok not err?
        result = afs.readFileSync filename
        ok result is contents

test 'readFile', ->
    expect 2

    afs.writeFileSync filename, contents

    stop()
    afs.readFile filename, (err, result) ->
        start()
        ok not err?
        ok contents is result
