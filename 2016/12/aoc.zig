const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Op = enum { CpyReg, Load, Inc, Dec, Jnz, Jmp };

const Inst = struct {
    op: Op,
    lit: isize,
    reg: u8,
    out: u8,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var b = try std.BoundedArray(Inst, 32).init(0);
    var i: usize = 0;
    while (i < inp.len) {
        switch (inp[i]) {
            'c' => {
                if (inp[i + 4] < 64) {
                    i += 4;
                    const l = try aoc.chompInt(isize, inp, &i);
                    try b.append(Inst{ .op = Op.Load, .lit = l, .reg = inp[i + 1] - 'a', .out = 0 });
                    i += 3;
                } else {
                    try b.append(Inst{ .op = Op.CpyReg, .lit = 0, .reg = inp[i + 4] - 'a', .out = inp[i + 6] - 'a' });
                    i += 8;
                }
            },
            'i' => {
                try b.append(Inst{ .op = Op.Inc, .lit = 0, .reg = inp[i + 4] - 'a', .out = 0 });
                i += 6;
            },
            'd' => {
                try b.append(Inst{ .op = Op.Dec, .lit = 0, .reg = inp[i + 4] - 'a', .out = 0 });
                i += 6;
            },
            'j' => {
                const v = inp[i + 4];
                i += 6;
                const o = try aoc.chompInt(isize, inp, &i);
                if (v == '1') {
                    try b.append(Inst{ .op = Op.Jmp, .lit = o, .reg = 0, .out = 0 });
                } else {
                    try b.append(Inst{ .op = Op.Jnz, .lit = o, .reg = v - 'a', .out = 0 });
                }
                i += 1;
            },
            else => unreachable,
        }
    }
    const prog = b.slice();
    const n: usize = @as(usize, @intCast(prog[16].lit * prog[17].lit));
    const fib26: usize = 317811;
    const fib33: usize = 9227465;
    return [2]usize{ fib26 + n, fib33 + n };
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
