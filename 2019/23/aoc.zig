const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PROG_CAP: usize = 4096;
const FN_TABLE: usize = 11;
const DATA_SLOTS: usize = 10;

const Op = enum { Add, Mul, Div, Head };
const Nic = struct {
    slotDiv: Int,
    op: Op,
    bufLen: usize,
    buf: [DATA_SLOTS]?Int,
    dstLen: usize,
    dst: [DATA_SLOTS][2]Int,
    ready: bool,
    pub fn run(self: *Nic) ?Int {
        if (!self.ready) {
            return null;
        }
        for (0..self.bufLen) |j| {
            if (self.buf[j] == null) {
                return null;
            }
        }
        self.ready = false;
        switch (self.op) {
            Op.Add => {
                var sum: Int = 0;
                for (0..self.bufLen) |j| {
                    sum += self.buf[j].?;
                }
                return sum;
            },
            Op.Mul => {
                var prod: Int = 1;
                for (0..self.bufLen) |j| {
                    prod *= self.buf[j].?;
                }
                return prod;
            },
            Op.Div => return @divTrunc(self.buf[0].?, self.buf[1].?),
            Op.Head => return self.buf[0],
        }
    }
};
const Int = i64;

fn parts(inp: []const u8) anyerror![2]usize {
    var p: [PROG_CAP]Int = undefined;
    var l: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            p[l] = try aoc.chompInt(Int, inp, &i);
            l += 1;
        }
    }
    const prog = p[0..l];
    var nics: [50]Nic = undefined;
    for (0..50) |i| {
        const addr: usize = @intCast(prog[FN_TABLE + i]);
        const slotDiv: Int = @intCast(value(prog[0..], addr));
        const bufLen: usize = @intCast(value(prog[0..], addr + 4));
        const bufAddr: usize = @intCast(value(prog[0..], addr + 8));
        var buf: [DATA_SLOTS]?Int = .{null} ** DATA_SLOTS;
        for (0..bufLen) |j| {
            buf[j] = if (prog[bufAddr + j * 2] == 0) null else prog[bufAddr + j * 2 + 1];
        }
        const op = switch (value(prog[0..], addr + 12)) {
            253 => Op.Add,
            302 => Op.Mul,
            351 => Op.Div,
            556 => Op.Head,
            else => unreachable,
        };
        var dst: [DATA_SLOTS][2]Int = .{[2]Int{ 0, 0 }} ** DATA_SLOTS;
        const dstLen: usize = @intCast(value(prog[0..], addr + 16));
        const dstAddr: usize = @intCast(value(prog[0..], addr + 20));
        for (0..dstLen) |j| {
            dst[j] = [2]Int{
                prog[dstAddr + j * 2],
                prog[dstAddr + j * 2 + 1],
            };
        }
        nics[i] = Nic{
            .ready = true,
            .slotDiv = slotDiv,
            .bufLen = bufLen,
            .buf = buf,
            .op = op,
            .dst = dst,
            .dstLen = dstLen,
        };
        //aoc.print("nics[{}]={any}\n", .{ i, nics[i] });
    }
    var p1: ?Int = null;
    var nat = [2]Int{ 0, 0 };
    var prev: Int = 0;
    while (true) {
        var busy = false;
        for (0..50) |i| {
            const out = nics[i].run();
            if (out) |v| {
                busy = true;
                //aoc.print("{}: sending {}\n", .{ i, v });
                for (0..nics[i].dstLen) |j| {
                    const k: usize = @intCast(nics[i].dst[j][0]);
                    const slot = nics[i].dst[j][1];
                    if (k == 255) {
                        if (p1 == null) {
                            p1 = v;
                        }
                        nat = [2]Int{ slot, v };
                        continue;
                    }
                    const slot_i: usize = @intCast(@divTrunc(slot, nics[k].slotDiv) - 1);
                    nics[k].buf[slot_i] = v;
                    nics[k].ready = true;
                }
            }
        }
        if (!busy) {
            if (nat[1] == prev) {
                break;
            }
            prev = nat[1];
            const slot: usize = @intCast(@divTrunc(nat[0], nics[0].slotDiv) - 1);
            nics[0].buf[slot] = nat[1];
            nics[0].ready = true;
        }
    }

    return [2]usize{ @intCast(p1.?), @intCast(nat[1]) };
}

inline fn value(prog: []Int, addr: usize) Int {
    return switch (prog[addr]) {
        21101, 1101 => prog[addr + 1] + prog[addr + 2],
        21102, 1102 => prog[addr + 1] * prog[addr + 2],
        else => unreachable,
    };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
