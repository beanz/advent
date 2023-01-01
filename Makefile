DIRS=$(sort $(wildcard ????/??/))

PRIVATE_INPUTS=$(sort $(wildcard input/????/??/*.txt))
INPUTS=$(subst input/,,${PRIVATE_INPUTS})

PERL_SRC=$(sort $(wildcard ????/??/aoc.pl))
PERL_CHK=$(subst /aoc.pl,/aoc.pl.chk,${PERL_SRC})
PERL_LOG=$(subst /aoc.pl,/aoc.pl.log,${PERL_SRC})
PERL_ERR=$(subst /aoc.pl,/aoc.pl.err,${PERL_SRC})

GO_SRC=$(sort $(wildcard ????/??/main.go))
GO_TEST=$(sort $(wildcard ????/??/main_test.go))
GO_BIN=$(subst /main.go,/aoc-go,${GO_SRC})
GO_LOG=$(subst /main.go,/aoc-go.log,${GO_SRC})
GO_ERR=$(subst /main.go,/aoc-go.err,${GO_SRC})
GO_BENCH=$(subst /main.go,/aoc-go.ns,${GO_SRC})

RS_SRC=$(sort $(wildcard aoc-rust/src/bin/aoc-????-??.rs))
RS_BIN=$(subst src/bin,target/release,${RS_SRC:.rs=})
RS_LOG=$(addsuffix .log,${RS_BIN})
RS_ERR=$(addsuffix .err,${RS_BIN})
RS_BENCH=$(addsuffix .ns,${RS_BIN})

ZIG_SRC=$(sort $(wildcard ????/??/aoc.zig))
ZIG_BIN=$(subst /aoc.zig,/aoc-zig,${ZIG_SRC})
ZIG_LOG=$(subst /aoc.zig,/aoc-zig.log,${ZIG_SRC})
ZIG_ERR=$(subst /aoc.zig,/aoc-zig.err,${ZIG_SRC})
ZIG_REL=$(subst /aoc.zig,/aoc-zig-rel,${ZIG_SRC})
ZIG_BENCH=$(subst /aoc.zig,/aoc-zig.ns,${ZIG_SRC})

NIM_SRC=$(sort $(wildcard ????/??/aoc.nim))
NIM_BIN=$(subst /aoc.nim,/aoc-nim,${NIM_SRC})
NIM_LOG=$(subst /aoc.nim,/aoc-nim.log,${NIM_SRC})
NIM_ERR=$(subst /aoc.nim,/aoc-nim.err,${NIM_SRC})
NIM_BENCH=$(subst /aoc.nim,/aoc-nim.ns,${ZIG_SRC})

CR_SRC=$(sort $(wildcard ????/??/aoc.cr))
CR_BIN=$(subst /aoc.cr,/aoc-cr,${CR_SRC})
CR_LOG=$(subst /aoc.cr,/aoc-cr.log,${CR_SRC})
CR_ERR=$(subst /aoc.cr,/aoc-cr.err,${CR_SRC})
CR_REL=$(subst /aoc.cr,/aoc-cr-rel,${CR_SRC})
CR_BENCH=$(subst /aoc.cr,/aoc-cr.ns,${CR_SRC})

HS_SRC=$(sort $(wildcard ????/??/aoc.hs))
HS_BIN=$(subst /aoc.hs,/aoc-hs,${HS_SRC})
HS_LOG=$(subst /aoc.hs,/aoc-hs.log,${HS_SRC})
HS_ERR=$(subst /aoc.hs,/aoc-hs.err,${HS_SRC})
HS_REL=$(subst /aoc.hs,/aoc-hs-rel,${HS_SRC})
HS_BENCH=$(subst /aoc.hs,/aoc-hs.ns,${HS_SRC})

CPP_SRC=$(sort $(wildcard ????/??/cpp/aoc.cpp))
CPP_BIN=$(subst /cpp/aoc.cpp,/aoc-cpp,${CPP_SRC})
CPP_LOG=$(subst /cpp/aoc.cpp,/aoc-cpp.log,${CPP_SRC})
CPP_ERR=$(subst /cpp/aoc.cpp,/aoc-cpp.err,${CPP_SRC})
CPP_REL=$(subst /cpp/aoc.cpp,/aoc-cpp-rel,${CPP_SRC})
CPP_BENCH=$(subst /cpp/aoc.cpp,/aoc-cpp.ns,${CPP_SRC})

CC=clang++-14
#CC=g++-7
CR_DIR=/usr
CR_LIB=$(CR_DIR)/share/crystal/src:../../lib-cr
CR=$(CR_DIR)/bin/crystal
NIM=$(HOME)/Tmp/nim-1.6.6/bin/nim

TIME=../../bin/time

.DELETE_ON_ERROR: /bin/true

all: ${INPUTS} ${GO_BIN} ${CPP_BIN} ${NIM_BIN} ${ZIG_BIN} ${CR_BIN} ${PERL_CHK} ${RS_BIN}
run: ${GO_LOG} ${CPP_LOG} ${NIM_LOG} ${ZIG_LOG} ${CR_LOG} ${PERL_LOG} ${RS_LOG}

todo:
	@bin/missing.sh |sort -R|head -1

todo-%:
	@bin/missing.sh |fgrep ".$(subst todo-,,$@) " | sort -R| head -1

missing:
	@bin/missing.sh

missing-%:
	@bin/missing.sh | grep $(subst missing-,,$@)

build: cpp-build cr-build go-build nim-build perl-build zig--build

cpp-build: ${CPP_BIN}
cpp: ${CPP_LOG} ${CPP_BIN}

cr-build: ${CR_BIN}
cr: ${CR_LOG} ${CR_BIN}

go-build: ${GO_BIN}
go: ${GO_LOG} ${GO_BIN}
go-bench: ${GO_BENCH}
go-test: ${GO_SRC}
	for f in ${GO_SRC} ; do ( cd $${f%/*} && make test-go ); done

go-test-fast: ${GO_SRC}
	for f in ${GO_SRC} ; do ( cd $${f%/*} && make test-go-fast ); done

bench: ${INPUTS} benchmarks/README.md

benchmarks/README.md: benchmarks/README.template.md benchmarks/benchmarks.md
	cat $^ > $@

benchmarks/benchmarks.md: $(GO_BENCH) $(RS_BENCH) $(CPP_BENCH) $(ZIG_BENCH) $(CR_BENCH) $(HS_BENCH) benchmarks/main.go
	cd benchmarks && go run . ..

nim-build: ${NIM_BIN}
nim: ${NIM_LOG} ${NIM_BIN}

perl: ${PERL_LOG}
perl-build: ${PERL_CHK}

zig-build: ${ZIG_BIN}
zig: ${ZIG_LOG} ${ZIG_BIN}

rs-build: ${RS_BIN}
rs: ${RS_LOG} ${RS_BIN}
rs-bench: ${RS_BENCH}

aoc-rust/target/release/aoc-%: aoc-rust/src/bin/aoc-%.rs
	cd aoc-rust && cargo build --release --bin "*$(@F)"

%/aoc.pl.chk: %/aoc.pl
	(cd $(dir $@) && perl -c aoc.pl && touch $(notdir $@)) || exit 1

%/aoc-go: %/main.go %/input.txt
	cd $(dir $@) && go build -o aoc-go main.go

%/aoc-cpp: %/cpp/aoc.cpp %/cpp/input.h
	$(CC) -I$(dir $@)../../lib-cpp -o $@ $<

%/aoc-cpp-rel: %/cpp/aoc.cpp %/cpp/input.h
	$(CC) -I$(dir $@)../../lib-cpp -O3 -o $@ $<

%/cpp/input.h: %/input.txt
	cd $(dir $<) && xxd -i $(notdir $<) cpp/$(notdir $@)

%/aoc-nim: %/aoc.nim %/input.txt
	$(NIM) c --opt:speed -d:release -p:$(dir $@)../../lib-nim $<
	mv $(dir $@)/aoc $@

%/aoc-nim-rel: %/aoc.nim %/input.txt
	$(NIM) c --checks:off --assertions:off --opt:speed -d:release \
	  -p:$(dir $@)../../lib-nim $<
	mv $(dir $@)/aoc $@

%/aoc-cr: %/aoc.cr %/input.txt
	cd $(dir $@) && \
	  CRYSTAL_PATH=$(CR_LIB) $(CR) build --debug \
	  -o $(notdir $@) $(notdir $<)

%/aoc-cr-rel: %/aoc.cr %/input.txt
	cd $(dir $@) && \
	  CRYSTAL_PATH=$(CR_LIB) $(CR) build --release \
	  -o $(notdir $@) $(notdir $<)

%/aoc-hs: %/aoc.hs %/input.txt
	cd $(dir $@) && \
	  ghc -i ../../lib-hs/Utils.hs -o $(notdir $@) $(notdir $<)

%/aoc-hs-rel: %/aoc.hs %/input.txt
	cd $(dir $@) && \
	  ghc -i ../../lib-hs/Utils.hs -O3 -o $(notdir $@) $(notdir $<)

%/aoc-zig: %/aoc.zig %/input.txt %/aoc-lib.zig
	cd $(dir $@) && zig build-exe --name $(notdir $@) $(notdir $<)

%/aoc-lib.zig: lib-zig/aoc-lib.zig
	ln -s ../../lib-zig/aoc-lib.zig $@

%/aoc-zig-rel: %/aoc.zig %/input.txt
	cd $(dir $@) && zig build-exe -O ReleaseFast \
		--name $(notdir $@) $(notdir $<)

%/aoc-cpp.log: %/aoc-cpp
	cd $(dir $@) && \
	  ( ( ${TIME} ./$(notdir $<) <input.txt | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

%/aoc-nim.log: %/aoc-nim
	cd $(dir $@) && \
	  ( ( ${TIME} ./$(notdir $<) <input.txt | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

aoc-rust/target/release/%.log: aoc-rust/target/release/%
	cd $(dir $@) && \
	  ( ( ../${TIME} ./$(notdir $<) ../../../$(addsuffix /input.txt,$(subst -,/,$(subst aoc-rust/target/release/aoc-,,$<))) | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

aoc-rust/target/release/%.ns: aoc-rust/target/release/%
	(cd $(dir $<) && \
	   AoC_BENCH=1 ./$(notdir $<) \
               ../../../$(addsuffix /input.txt,$(subst -,/,$(subst aoc-rust/target/release/aoc-,,$<))) ) | tee /dev/stderr > $@

%.log: %
	cd $(dir $@) && \
	  ( ( ${TIME} ./$(notdir $<) input.txt | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

%/aoc-zig.log: %/aoc-zig
	cd $(dir $@) && \
	  ( ( ${TIME} ./$(notdir $<) | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

%/aoc-zig.ns: %/aoc-zig-rel
	( cd $* && AoC_BENCH=1 ./$(notdir $<) 2>&1 | tee /dev/stderr ) >$@

%/aoc-cpp.ns: %/aoc-cpp-rel
	( cd $* && AoC_BENCH=1 ./$(notdir $<) | tee /dev/stderr ) >$@

%/aoc-cr.ns: %/aoc-cr-rel
	( cd $* && AoC_BENCH=1 ./$(notdir $<) | tee /dev/stderr ) >$@

%/aoc-hs.ns: %/aoc-hs-rel
	( cd $* && AoC_BENCH=1 ./$(notdir $<) | tee /dev/stderr | awk '/^time/ {print $$2 $$3}' ) >$@

%/aoc-nim.ns: %/aoc-nim-rel
	( cd $* && AoC_BENCH=1 ./$(notdir $<) | tee /dev/stderr ) >$@

%/aoc-go.ns: %/aoc-go
	(cd $* && go test -run=XXX -benchmem -benchtime=5s -bench=BenchmarkMain . ) | \
	  tee /dev/stderr | grep "BenchmarkMain-" > $@

%/aoc.pl.log: %/aoc.pl
	cd $(dir $@) && \
	  ( ( ${TIME} perl aoc.pl input.txt | tee aoc.pl.log ) 2>&1 1>&3 | \
	     tee aoc.pl.err ) 3>&1 1>&2

clean: clean-perl clean-go clean-zig clean-nim clean-cr clean-cpp clean-misc

clean-rs:
	rm -f ${RS_LOG} ${RS_ERR} ${RS_BIN} ????/??/aoc-rs
	rm -rf aoc-rust/target

clean-perl:
	rm -f ${PERL_LOG} ${PERL_ERR} ${PERL_CHK}
	find . -type d -name '_Inline' -print0| xargs -r -0 rm -rf

clean-go:
	rm -f ${GO_LOG} ${GO_ERR} ${GO_BENCH} ${GO_BIN} \
		benchmark/results benchmarks/benchmarks.md

clean-cpp:
	rm -f ${CPP_LOG} ${CPP_ERR} ${CPP_BIN}

clean-cr:
	rm -f ${CR_LOG} ${CR_ERR} ${CR_BIN}

clean-nim:
	rm -f ${NIM_LOG} ${NIM_ERR} ${NIM_BIN}

clean-zig:
	rm -f ${ZIG_LOG} ${ZIG_ERR} ${ZIG_BIN}
	find . -type d -name 'zig-cache' -print0| xargs -r -0 rm -rf

clean-misc:
	find . -name '*~' -print0|xargs -r -0 rm -f

build2015: go2015-build zig2015-build nim2015-build cr2015-build cpp2015-build perl2015-build
build2016: go2016-build zig2016-build nim2016-build cr2016-build cpp2016-build perl2016-build
build2017: go2017-build zig2017-build nim2017-build cr2017-build cpp2017-build perl2017-build
build2018: go2018-build zig2018-build nim2018-build cr2018-build cpp2018-build perl2018-build
build2019: go2019-build zig2019-build nim2019-build cr2019-build cpp2019-build perl2019-build
build2020: go2020-build zig2020-build nim2020-build cr2020-build cpp2020-build perl2020-build
build2021: go2021-build zig2021-build nim2021-build cr2021-build cpp2021-build perl2021-build
build2022: go2022-build zig2022-build nim2022-build cr2022-build cpp2022-build perl2022-build

cpp2015-build: $(filter 2015/%,${CPP_BIN})
cpp2015: $(filter 2015/%,${CPP_LOG})
cpp2016-build: $(filter 2016/%,${CPP_BIN})
cpp2016: $(filter 2016/%,${CPP_LOG})
cpp2017-build: $(filter 2017/%,${CPP_BIN})
cpp2017: $(filter 2017/%,${CPP_LOG})
cpp2018-build: $(filter 2018/%,${CPP_BIN})
cpp2018: $(filter 2018/%,${CPP_LOG})
cpp2019-build: $(filter 2019/%,${CPP_BIN})
cpp2019: $(filter 2019/%,${CPP_LOG})
cpp2020-build: $(filter 2020/%,${CPP_BIN})
cpp2020: $(filter 2020/%,${CPP_LOG})
cpp2021-build: $(filter 2021/%,${CPP_BIN})
cpp2021: $(filter 2021/%,${CPP_LOG})
cpp2022-build: $(filter 2022/%,${CPP_BIN})
cpp2022: $(filter 2022/%,${CPP_LOG})

cr2015-build: $(filter 2015/%,${CR_BIN})
cr2015: $(filter 2015/%,${CR_LOG})
cr2016-build: $(filter 2016/%,${CR_BIN})
cr2016: $(filter 2016/%,${CR_LOG})
cr2017-build: $(filter 2017/%,${CR_BIN})
cr2017: $(filter 2017/%,${CR_LOG})
cr2018-build: $(filter 2018/%,${CR_BIN})
cr2018: $(filter 2018/%,${CR_LOG})
cr2019-build: $(filter 2019/%,${CR_BIN})
cr2019: $(filter 2019/%,${CR_LOG})
cr2020-build: $(filter 2020/%,${CR_BIN})
cr2020: $(filter 2020/%,${CR_LOG})
cr2021-build: $(filter 2021/%,${CR_BIN})
cr2021: $(filter 2021/%,${CR_LOG})
cr2022-build: $(filter 2022/%,${CR_BIN})
cr2022: $(filter 2022/%,${CR_LOG})

go2015-build: $(filter 2015/%,${GO_BIN})
go2015: $(filter 2015/%,${GO_LOG})
go2015-bench: $(filter benchmarks/results/2015/%,${GO_BENCH})

go2016-build: $(filter 2016/%,${GO_BIN})
go2016: $(filter 2016/%,${GO_LOG})
go2016-bench: $(filter benchmarks/results/2016/%,${GO_BENCH})

go2017-build: $(filter benchmarks/results/2017/%,${GO_BIN})
go2017: $(filter 2017/%,${GO_LOG})
go2017-bench: $(filter benchmarks/results/2017/%,${GO_BENCH})

go2018-build: $(filter 2018/%,${GO_BIN})
go2018: $(filter 2018/%,${GO_LOG})
go2018-bench: $(filter benchmarks/results/2018/%,${GO_BENCH})

go2019-build: $(filter 2019/%,${GO_BIN})
go2019: $(filter 2019/%,${GO_LOG})
go2019-bench: $(filter benchmarks/results/2019/%,${GO_BENCH})

go2020-build: $(filter 2020/%,${GO_BIN})
go2020: $(filter 2020/%,${GO_LOG})
go2020-bench: $(filter benchmarks/results/2020/%,${GO_BENCH})

go2021-build: $(filter 2021/%,${GO_BIN})
go2021: $(filter 2021/%,${GO_LOG})
go2021-bench: $(filter benchmarks/results/2021/%,${GO_BENCH})

go2022-build: $(filter 2022/%,${GO_BIN})
go2022: $(filter 2022/%,${GO_LOG})
go2022-bench: $(filter benchmarks/results/2022/%,${GO_BENCH})

nim2015-build: $(filter 2015/%,${NIM_BIN})
nim2015: $(filter 2015/%,${NIM_LOG})
nim2016-build: $(filter 2016/%,${NIM_BIN})
nim2016: $(filter 2016/%,${NIM_LOG})
nim2017-build: $(filter 2017/%,${NIM_BIN})
nim2017: $(filter 2017/%,${NIM_LOG})
nim2018-build: $(filter 2018/%,${NIM_BIN})
nim2018: $(filter 2018/%,${NIM_LOG})
nim2019-build: $(filter 2019/%,${NIM_BIN})
nim2019: $(filter 2019/%,${NIM_LOG})
nim2020-build: $(filter 2020/%,${NIM_BIN})
nim2020: $(filter 2020/%,${NIM_LOG})
nim2021-build: $(filter 2021/%,${NIM_BIN})
nim2021: $(filter 2021/%,${NIM_LOG})
nim2022-build: $(filter 2022/%,${NIM_BIN})
nim2022: $(filter 2022/%,${NIM_LOG})

perl2015: $(filter 2015/%,${PERL_LOG})
perl2016: $(filter 2016/%,${PERL_LOG})
perl2017: $(filter 2017/%,${PERL_LOG})
perl2018: $(filter 2018/%,${PERL_LOG})
perl2019: $(filter 2019/%,${PERL_LOG})
perl2020: $(filter 2020/%,${PERL_LOG})
perl2021: $(filter 2021/%,${PERL_LOG})
perl2022: $(filter 2022/%,${PERL_LOG})
perl2015-build: $(filter 2015/%,${PERL_CHK})
perl2016-build: $(filter 2016/%,${PERL_CHK})
perl2017-build: $(filter 2017/%,${PERL_CHK})
perl2018-build: $(filter 2018/%,${PERL_CHK})
perl2019-build: $(filter 2019/%,${PERL_CHK})
perl2020-build: $(filter 2020/%,${PERL_CHK})
perl2021-build: $(filter 2021/%,${PERL_CHK})
perl2022-build: $(filter 2022/%,${PERL_CHK})

zig-test: zig2015-test zig2016-test zig2017-test zig2018-test zig2019-test zig2020-test zig2021-test
zig2015-test: $(filter 2015/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2015-build: $(filter 2015/%,${ZIG_BIN})
zig2015: $(filter 2015/%,${ZIG_LOG})

zig2016-test: $(filter 2016/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2016-build: $(filter 2016/%,${ZIG_BIN})
zig2016: $(filter 2016/%,${ZIG_LOG})

zig2017-test: $(filter 2017/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2017-build: $(filter 2017/%,${ZIG_BIN})
zig2017: $(filter 2017/%,${ZIG_LOG})

zig2018-test: $(filter 2018/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2018-build: $(filter 2018/%,${ZIG_BIN})
zig2018: $(filter 2018/%,${ZIG_LOG})

zig2019-test: $(filter 2019/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2019-build: $(filter 2019/%,${ZIG_BIN})
zig2019: $(filter 2019/%,${ZIG_LOG})

zig2020-test: $(filter 2020/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2020-build: $(filter 2020/%,${ZIG_BIN})
zig2020: $(filter 2020/%,${ZIG_LOG})

zig2021-test: $(filter 2021/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2021-build: $(filter 2021/%,${ZIG_BIN})
zig2021: $(filter 2021/%,${ZIG_LOG})

zig2022-test: $(filter 2022/%,${ZIG_SRC})
	@for f in $^ ; do echo -n "$$f: "; zig test $$f ;done
zig2022-build: $(filter 2022/%,${ZIG_BIN})
zig2022: $(filter 2022/%,${ZIG_LOG})

rs2015-build: $(filter aoc-rust/target/release/aoc-2015-%,${RS_BIN})
rs2015: $(filter aoc-rust/target/release/aoc-2015-%,${RS_LOG})
rs2016-build: $(filter aoc-rust/target/release/aoc-2016-%,${RS_BIN})
rs2016: $(filter aoc-rust/target/release/aoc-2016-%,${RS_LOG})
rs2017-build: $(filter aoc-rust/target/release/aoc-2017-%,${RS_BIN})
rs2017: $(filter aoc-rust/target/release/aoc-2017-%,${RS_LOG})
rs2018-build: $(filter aoc-rust/target/release/aoc-2018-%,${RS_BIN})
rs2018: $(filter aoc-rust/target/release/aoc-2018-%,${RS_LOG})
rs2019-build: $(filter aoc-rust/target/release/aoc-2019-%,${RS_BIN})
rs2019: $(filter aoc-rust/target/release/aoc-2019-%,${RS_LOG})
rs2020-build: $(filter aoc-rust/target/release/aoc-2020-%,${RS_BIN})
rs2020: $(filter aoc-rust/target/release/aoc-2020-%,${RS_LOG})
rs2021-build: $(filter aoc-rust/target/release/aoc-2021-%,${RS_BIN})
rs2021: $(filter aoc-rust/target/release/aoc-2021-%,${RS_LOG})
rs2022-build: $(filter aoc-rust/target/release/aoc-2022-%,${RS_BIN})
rs2022: $(filter aoc-rust/target/release/aoc-2022-%,${RS_LOG})

# Private input targets
%/input.txt: input/%/input.txt
	cp $< $@
%/input2.txt: input/%/input2.txt
	cp $< $@
%/input3.txt: input/%/input3.txt
	cp $< $@
%/input-amf.txt: input/%/input-amf.txt
	cp $< $@
%/maze.txt: input/%/maze.txt
	cp $< $@
%/monster.txt: input/%/monster.txt
	cp $< $@
%/p2answer.txt: input/%/p2answer.txt
	cp $< $@
%/shop.txt: input/%/shop.txt
	cp $< $@
%/tape.txt: input/%/tape.txt
	cp $< $@
%/test.txt: input/%/test.txt
	cp $< $@
%/test0.txt: input/%/test0.txt
	cp $< $@
%/test0a.txt: input/%/test0a.txt
	cp $< $@
%/test0b.txt: input/%/test0b.txt
	cp $< $@
%/test1.txt: input/%/test1.txt
	cp $< $@
%/test1a.txt: input/%/test1a.txt
	cp $< $@
%/test1b.txt: input/%/test1b.txt
	cp $< $@
%/test1c.txt: input/%/test1c.txt
	cp $< $@
%/test1d.txt: input/%/test1d.txt
	cp $< $@
%/test1e.txt: input/%/test1e.txt
	cp $< $@
%/test1f.txt: input/%/test1f.txt
	cp $< $@
%/test1g.txt: input/%/test1g.txt
	cp $< $@
%/test1h.txt: input/%/test1h.txt
	cp $< $@
%/test2.txt: input/%/test2.txt
	cp $< $@
%/test2a.txt: input/%/test2a.txt
	cp $< $@
%/test2b.txt: input/%/test2b.txt
	cp $< $@
%/test2c.txt: input/%/test2c.txt
	cp $< $@
%/test2d.txt: input/%/test2d.txt
	cp $< $@
%/test2e.txt: input/%/test2e.txt
	cp $< $@
%/test2f.txt: input/%/test2f.txt
	cp $< $@
%/test2g.txt: input/%/test2g.txt
	cp $< $@
%/test2h.txt: input/%/test2h.txt
	cp $< $@
%/test3a.txt: input/%/test3a.txt
	cp $< $@
%/test3b.txt: input/%/test3b.txt
	cp $< $@
%/test3.txt: input/%/test3.txt
	cp $< $@
%/test4.txt: input/%/test4.txt
	cp $< $@
%/test5.txt: input/%/test5.txt
	cp $< $@
%/test6.txt: input/%/test6.txt
	cp $< $@
%/test7.txt: input/%/test7.txt
	cp $< $@
%/test8.txt: input/%/test8.txt
	cp $< $@
%/test9.txt: input/%/test9.txt
	cp $< $@
