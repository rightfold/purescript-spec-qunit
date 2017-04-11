.PHONY: test
test:
	mkdir -p output
	pulp browserify -I test -m Test.Main > output/main.js
