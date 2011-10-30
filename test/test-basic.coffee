#-------------------------------------------------------------------------------
# Copyright (c) 2011 Patrick Mueller, http://muellerware.org
# licensed under the MIT license: http://pmuellr.mit-license.org/
#-------------------------------------------------------------------------------

afs      = null
filename = 'a.txt'
contents = 'sample file contents'

module 'basic',
    setup: ->
        afs = new IMfs

test 'stat', ->
    expect 3

    afs.writeFileSync filename, contents
    stat = afs.statSync filename

    ok stat.isFile()
    ok not stat.isDirectory()
    ok stat.size is contents.length

test 'realpath', ->
    expect 1

    result = afs.realpathSync filename
    ok result is "/#{filename}"

test 'unlink', ->
    expect 2

    afs.writeFileSync filename, contents
    stat = afs.statSync filename
    ok stat.isFile()

    afs.unlinkSync filename
    stat = afs.statSync filename
    ok not stat.isFile()

test 'readdir', ->
    expect 2

    afs.writeFileSync filename, contents

    result = afs.readdirSync '/'
    ok result.length is 1
    ok result[0] is filename

test 'readFile', ->
    expect 1

    afs.writeFileSync filename, contents

    result = afs.readFileSync filename
    ok true if result is contents

test 'writeFile', ->
    expect 1

    afs.writeFileSync filename, contents
    ok true
