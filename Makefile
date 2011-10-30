#-------------------------------------------------------------------------------
# Copyright (c) 2011 Patrick Mueller, http://muellerware.org
# licensed under the MIT license: http://pmuellr.mit-license.org/
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
all: help

#-------------------------------------------------------------------------------
build:
	node_modules/.bin/coffee -c -o lib     source/imfs.coffee
	node_modules/.bin/coffee -c -o test/js test/*.coffee

#-------------------------------------------------------------------------------
clean:
	rm -rf node_modules
	rm -rf vendor
	rm     test/js/*

#-------------------------------------------------------------------------------
watch:
	python vendor/run-when-changed.py "make build" *

#-------------------------------------------------------------------------------
vendor: \
	mkdir_vendor \
	npm_coffee \
	vendor/qunit.js \
	vendor/qunit.css \
	vendor/run-when-changed.py

#-------------------------------------------------------------------------------
mkdir_vendor:
	-@mkdir vendor 2> /dev/null

#-------------------------------------------------------------------------------
npm_coffee:
	npm install coffee-script

#-------------------------------------------------------------------------------
npm_qunit:
	npm install qunit

#-------------------------------------------------------------------------------
vendor/qunit.css:
	curl https://raw.github.com/jquery/qunit/1.1.0/qunit/qunit.css > $@

#-------------------------------------------------------------------------------
vendor/qunit.js:
	curl https://raw.github.com/jquery/qunit/1.1.0/qunit/qunit.js > $@

#-------------------------------------------------------------------------------
vendor/run-when-changed.py:
	curl https://raw.github.com/gist/240922/0f5bedfc42b3422d0dee81fb794afde9f58ed1a6/run-when-changed.py > $@

#-------------------------------------------------------------------------------
help:
	@echo available targets:
	@echo "   all     - do everything"
	@echo "   build   - run a build"
	@echo "   vendor  - get vendor files"
	@echo "   watch   - build continuously"
	@echo "   clean   - remove transient files"
