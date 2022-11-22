DAY=$(notdir $(CURDIR))
YEAR=$(notdir $(patsubst %/,%,$(dir $(CURDIR))))
HERE=$(YEAR)/$(DAY)

CC=clang++-12
CR_DIR=/usr
CR_LIB=$(CR_DIR)/share/crystal/src:../../lib-cr
CR=$(CR_DIR)/bin/crystal
NIM=$(HOME)/Tmp/nim-1.6.6/bin/nim

ifneq (,$(wildcard main.go))
ALL += aoc-go
CLEAN += aoc-go gocpu.out cover.out
TEST += test-go
HYPERFINE += aoc-go
endif
ifneq (,$(wildcard aoc.pl))
ALL += aoc.pl
HYPERFINE += aoc.pl
TEST += test-pl
endif
ifneq (,$(wildcard aoc.zig))
ALL += aoc-zig
CLEAN += aoc-zig aoc-zig-rel aoc-lib.zig zig-cpu.svg
CLEAN_DIR += zig-cache
TEST += test-zig
HYPERFINE += aoc-zig-rel
endif
ifneq (,$(wildcard aoc.d))
ALL += aoc-d
CLEAN += aoc-d aoc-d.o aoc-d-rel aoc-d-rel.o
HYPERFINE += aoc-d-rel
endif
ifneq (,$(wildcard aoc.cr))
ALL += aoc-cr
CLEAN += aoc-cr aoc-cr-rel cr-cpu.svg
HYPERFINE += aoc-cr-rel
endif
ifneq (,$(wildcard aoc.nim))
ALL += aoc-nim
CLEAN += aoc-nim
HYPERFINE += aoc-nim-rel
endif
ifneq (,$(wildcard cpp/aoc.cpp))
ALL += aoc-cpp
CLEAN += aoc-cpp
HYPERFINE += aoc-cpp-rel
endif
ifneq (,$(wildcard aoc.hs))
ALL += aoc-hs
CLEAN += aoc-hs aoc-hs-rel
HYPERFINE += aoc-hs-rel
endif

# TODO: fix rust builds
RS_SRC=../../aoc-rust/src/bin/aoc-$(YEAR)-$(DAY).rs
RS_BIN=$(subst src/bin,target/debug,${RS_SRC:.rs=})
RS_REL=$(subst src/bin,target/release,${RS_SRC:.rs=})
ifneq (,$(wildcard $(RS_SRC)))
ALL += aoc-rs
CLEAN += aoc-rs
HYPERFINE += aoc-rs-rel
TEST += test-rs
endif

ifneq (,$(wildcard aoc.jq))
ALL += aoc.jq
endif
TIMES=$(addsuffix -time,${ALL})

EXTRA=aoc-gccgo out.perf-folded perf.data perf.data.old
FG_HOME=$(HOME)/git/github/brendangregg/FlameGraph

all: input.txt ${ALL}

clean:
	-rm -f ${CLEAN} $(notdir $(CURDIR)).test ${EXTRA} *.err *.log *.chk
	-rm -rf ${CLEAN_DIR} nytprof nytprof.out _Inline
	-find . -name '*~' -print0 |xargs -0 rm -f

times: input.txt ${TIMES}

%-time: %
	@echo $<
	@/usr/bin/time ./$<
	@echo

hyperfine: ${HYPERFINE}
	hyperfine --warmup 1 $(addprefix ./,${HYPERFINE})

input.txt:
	aoc-dump

aoc-cpp: cpp/aoc.cpp ../../lib-cpp/*.hpp cpp/input.h
	$(CC) -I../../lib-cpp -o $@ $<

cpp/input.h: input.txt
	xxd -i $< $@

aoc-cr: aoc.cr ../../lib-cr/*.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build -o aoc-cr aoc.cr

aoc-cr-rel: aoc.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build --release --debug -o $@ $<

aoc-hs: aoc.hs
	ghc -i ../../lib-hs/Utils.hs -o $@ $<

aoc-hs-rel: aoc.hs
	ghc -i ../../lib-hs/Utils.hs -O3 -o $@ $<

aoc-nim: aoc.nim ../../lib-nim/*.nim
	$(NIM) c --path:../../lib-nim $<
	mv aoc $@

aoc-nim-rel: aoc.nim ../../lib-nim/*.nim
	$(NIM) c --checks:off --assertions:off --opt:speed -d:release \
	         --path:../../lib-nim $<
	mv aoc $@

aoc-lib.zig: ../../lib-zig/aoc-lib.zig
	ln -s $< $@

aoc-zig: aoc.zig aoc-lib.zig
	zig build-exe --name $@ $<

aoc-zig-rel: aoc.zig aoc-lib.zig
	zig build-exe -O ReleaseFast --name $@ $<

aoc-d: aoc.d
	dmd -J. -of=$@ $<

aoc-d-rel: aoc.d
	dmd -release -boundscheck=off -O -J. -of=$@ $<

aoc-go: main.go
	go build -o $@ $<

aoc-gccgo: main.go
	 go build -a -compiler gccgo -gccgoflags=all='-flto -Os -fdata-sections -ffunction-sections -Wl,--gc-sections,-s' $<
	mv main $@

gocpu.out: main.go
	go test $$(grep -q Bench *_test.go && echo "-run=XXX -benchtime=5s -bench .") -cpuprofile=$@

go-prof: gocpu.out
	go tool pprof -http=":9999" $<

go-cover: main.go main_test.go
	go test -coverprofile cover.out
	go tool cover -html=cover.out
	rm cover.out

cr-cpu.svg: aoc-cr-rel
	perf record -F 99 --call-graph dwarf ./$<
	perf script | $(FG_HOME)/stackcollapse-perf.pl >out.perf-folded
	$(FG_HOME)/flamegraph.pl out.perf-folded >$@
	-rm -f out.perf-folded perf.data perf.data.old

cr-prof: cr-cpu.svg
	google-chrome $<

zig-cpu.svg: aoc-zig
	perf record -F 99 --call-graph dwarf ./$<
	perf script | $(FG_HOME)/stackcollapse-perf.pl >out.perf-folded
	$(FG_HOME)/flamegraph.pl out.perf-folded >$@
	-rm -f out.perf-folded perf.data perf.data.old

zig-prof: zig-cpu.svg
	google-chrome $<

test: ${TEST}

test-zig: aoc-zig
	zig test aoc.zig

test-go:
	go test -v

test-go-fast:
	go test -short

test-pl:
	AoC_TEST=2 perl aoc.pl input.txt

perl-prof:
	perl -d:NYTProf aoc.pl input.txt
	nytprofhtml --open

check: ${ALL}
	@TT=$$(mktemp -d) ; \
	GOLD=$$TT/gold.log ; \
	./$< >$$GOLD ; \
	echo -n "$(HERE): " ; \
	for f in $^ ; do \
	  echo -n "$$f "; \
	  ./$$f >$$TT/$$f.log 2>&1 \
	    && diff -audBbw $$GOLD $$TT/$$f.log >$$TT/$$f.diff \
	    || ( echo ; echo $$f output differs ; cat $$TT/$$f.diff); \
	done && \
	  rm -rf $$TT ; \
	echo

aoc-rs: $(RS_SRC)
	( cd ../../aoc-rust && \
	  cargo build --bin "$(basename $(notdir $<))" ) && \
	mv $(RS_BIN) $@

aoc-rs-rel: $(RS_SRC)
	( cd ../../aoc-rust && \
	  cargo build --release --bin "$(basename $(notdir $<))" ) && \
	mv $(RS_REL) $@

test-rs: $(RS_SRC)
	( cd ../../aoc-rust && \
	  cargo test --bin "$(basename $(notdir $<))" )

clippy: $(RS_SRC)
	( cd ../../aoc-rust && cargo clippy )

template:
	@if [ ! -e Makefile ]; then ln -s ../../template/Makefile . ; fi ; \
	for f in aoc.pl main.go main_test.go ; do \
	  if [ ! -e $$f ]; then cp -p ../../template/$$f . ; fi \
	done
