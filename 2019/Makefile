CR=$(HOME)/Tmp/crystal-0.31.1-1/bin/crystal
NIM=$(HOME)/Tmp/nim-1.0.4/bin/nim
CC=clang++-6.0
ALL=aoc-go aoc-cpp aoc-nim aoc-cr

all: input.txt ${ALL}

clean:
	-rm -f ${ALL} main aoc $(notdir $(CURDIR)).test
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

input.txt:
	aoc-dump

aoc-cpp: cpp/aoc.cpp ../lib/*.hpp
	$(CC) -I../lib -o $@ $<

aoc-nim: aoc.nim ../lib/*.nim
	$(NIM) c --opt:speed -d:release -p:../lib $<
	mv aoc $@

aoc-cr: aoc.cr
	$(CR) build -o $@ $<

aoc-go: main.go
	go build $<
	mv main $@
