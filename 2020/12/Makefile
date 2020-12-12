CC=clang++-6.0
ALL=aoc-go aoc-zig

all: input.txt ${ALL}

clean:
	-rm -f ${ALL} $(notdir $(CURDIR)).test
	-rm -rf zig-cache
	-find . -name '*~' -print0 |xargs -0 rm -f

times: ${ALL} input.txt
	@for f in ${ALL} ; do \
	  echo $$f ; \
	  time ./$$f <input.txt input.txt ; \
	  echo ; \
	done
	@echo aoc.pl
	@AoC_TEST=1 time perl aoc.pl input.txt
	@echo
	@echo aoc.jq
	time ./aoc.jq < input.txt
	@echo

input.txt:
	aoc-dump

aoc-zig: aoc.zig
	zig build-exe --name $@ $<

aoc-go: main.go
	go build $<
	mv main $@
