const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Sample = struct {
    pre: [4]u16,
    op: [4]u16,
    post: [4]u16,

    fn consistent(self: Sample, i: usize) bool {
        var reg = [4]u16{ self.pre[0], self.pre[1], self.pre[2], self.pre[3] };
        const op: Op = @enumFromInt(i);
        op.do(&reg, self.op[1], self.op[2], self.op[3]);
        return self.post[0] == reg[0] and self.post[1] == reg[1] and self.post[2] == reg[2] and self.post[3] == reg[3];
    }
    fn matches(self: Sample) usize {
        var c: usize = 0;
        for (0..16) |i| {
            c += @intFromBool(self.consistent(i));
        }
        return c;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(Sample, 850).init(0);
    var s2 = try std.BoundedArray([4]u16, 1280).init(0);
    {
        var i: usize = 0;
        while (inp[i] == 'B') : (i += 3) {
            i += 9;
            const preA = try aoc.chompUint(u16, inp, &i);
            i += 2;
            const preB = try aoc.chompUint(u16, inp, &i);
            i += 2;
            const preC = try aoc.chompUint(u16, inp, &i);
            i += 2;
            const preD = try aoc.chompUint(u16, inp, &i);
            i += 2;
            const opA = try aoc.chompUint(u16, inp, &i);
            i += 1;
            const opB = try aoc.chompUint(u16, inp, &i);
            i += 1;
            const opC = try aoc.chompUint(u16, inp, &i);
            i += 1;
            const opD = try aoc.chompUint(u16, inp, &i);
            i += 10;
            const postA = try aoc.chompUint(u16, inp, &i);
            i += 2;
            const postB = try aoc.chompUint(u16, inp, &i);
            i += 2;
            const postC = try aoc.chompUint(u16, inp, &i);
            i += 2;
            const postD = try aoc.chompUint(u16, inp, &i);
            try s.append(Sample{
                .pre = [4]u16{ preA, preB, preC, preD },
                .op = [4]u16{ opA, opB, opC, opD },
                .post = [4]u16{ postA, postB, postC, postD },
            });
        }
        i += 2;
        while (i < inp.len) : (i += 1) {
            const opA = try aoc.chompUint(u16, inp, &i);
            i += 1;
            const opB = try aoc.chompUint(u16, inp, &i);
            i += 1;
            const opC = try aoc.chompUint(u16, inp, &i);
            i += 1;
            const opD = try aoc.chompUint(u16, inp, &i);
            try s2.append([4]u16{ opA, opB, opC, opD });
        }
    }
    const samples = s.slice();
    const prog = s2.slice();
    var p1: usize = 0;
    for (samples) |sample| {
        if (sample.matches() >= 3) {
            p1 += 1;
        }
    }
    var opt: [16]u16 = .{std.math.maxInt(u16)} ** 16;
    for (samples) |sample| {
        const inst = @as(usize, sample.op[0]);
        for (0..16) |i| {
            const bit = @as(u16, 1) << @as(u4, @intCast(i));
            if (opt[inst] & bit == 0) {
                continue;
            }
            if (!sample.consistent(i)) {
                opt[inst] ^= bit;
            }
        }
    }
    var done: usize = 0;
    var finished: [16]bool = .{false} ** 16;
    var opMap: [16]usize = .{0} ** 16;
    while (done != 16) {
        done = 0;
        for (0..16) |inst| {
            if (finished[inst]) {
                done += 1;
                continue;
            }
            if (@popCount(opt[inst]) == 1) {
                const bit = opt[inst];
                finished[inst] = true;
                opMap[inst] = @ctz(bit);
                for (0..16) |other| {
                    if (other != inst) {
                        opt[other] &= std.math.maxInt(u16) ^ bit;
                    }
                }
            }
        }
    }
    var reg = [4]u16{ 0, 0, 0, 0 };
    for (prog) |inst| {
        const o = opMap[@as(usize, @intCast(inst[0]))];
        const op: Op = @enumFromInt(o);
        op.do(&reg, inst[1], inst[2], inst[3]);
    }

    return [2]usize{ p1, @intCast(reg[0]) };
}

const Op = enum(u4) {
    addr,
    addi,
    mulr,
    muli,
    banr,
    bani,
    borr,
    bori,
    setr,
    seti,
    gtir,
    gtri,
    gtrr,
    eqir,
    eqri,
    eqrr,

    fn do(self: Op, reg: []u16, a: u16, b: u16, c: u16) void {
        switch (self) {
            Op.addr => {
                reg[@as(usize, c)] = reg[@as(usize, a)] + reg[@as(usize, b)];
            },
            Op.addi => {
                reg[@as(usize, c)] = reg[@as(usize, a)] + b;
            },
            Op.mulr => {
                reg[@as(usize, c)] = reg[@as(usize, a)] * reg[@as(usize, b)];
            },
            Op.muli => {
                reg[@as(usize, c)] = reg[@as(usize, a)] * b;
            },
            Op.banr => {
                reg[@as(usize, c)] = reg[@as(usize, a)] & reg[@as(usize, b)];
            },
            Op.bani => {
                reg[@as(usize, c)] = reg[@as(usize, a)] & b;
            },
            Op.borr => {
                reg[@as(usize, c)] = reg[@as(usize, a)] | reg[@as(usize, b)];
            },
            Op.bori => {
                reg[@as(usize, c)] = reg[@as(usize, a)] | b;
            },
            Op.setr => {
                reg[@as(usize, c)] = reg[@as(usize, a)];
            },
            Op.seti => {
                reg[@as(usize, c)] = a;
            },
            Op.gtir => {
                reg[@as(usize, c)] = @intFromBool(a > reg[@as(usize, b)]);
            },
            Op.gtri => {
                reg[@as(usize, c)] = @intFromBool(reg[@as(usize, a)] > b);
            },
            Op.gtrr => {
                reg[@as(usize, c)] = @intFromBool(reg[@as(usize, a)] > reg[@as(usize, b)]);
            },
            Op.eqir => {
                reg[@as(usize, c)] = @intFromBool(a == reg[@as(usize, b)]);
            },
            Op.eqri => {
                reg[@as(usize, c)] = @intFromBool(reg[@as(usize, a)] == b);
            },
            Op.eqrr => {
                reg[@as(usize, c)] = @intFromBool(reg[@as(usize, a)] == reg[@as(usize, b)]);
            },
        }
    }
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
