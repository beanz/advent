const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;
const Arity: [10]usize = [10]usize{ 0, 3, 3, 1, 1, 2, 2, 3, 3, 1 };

fn parts(inp: []const u8) anyerror![2]usize {
    var p: [1024]Int = undefined;
    var l: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        p[l] = try aoc.chompInt(Int, inp, &i);
        l += 1;
    }
    const prog = p[0..l];
    var p1: Int = 0;
    {
        var phases: [5][]Int = undefined;
        for (0..5) |j| {
            const start = @as(usize, @intCast(prog[10 + j]));
            const end = @as(usize, @intCast(prog[11 + j]));
            phases[j] = prog[start + 2 .. end - 3];
        }
        var values: [5]usize = [5]usize{ 0, 1, 2, 3, 4 };
        var it = aoc.permute(usize, values[0..]);
        while (it.next()) |ph| {
            var acc: Int = 0;
            for (0..5) |j| {
                const phase = phases[ph[j]];
                var k: usize = 0;
                while (k < phase.len) : (k += 4) {
                    acc = runInst(phase[k], phase[k + 1], phase[k + 2], acc);
                }
            }
            if (acc > p1) {
                p1 = acc;
            }
        }
    }
    var p2: Int = 0;
    {
        var phases: [5][]Int = undefined;
        for (0..5) |j| {
            const start = @as(usize, @intCast(prog[15 + j]));
            const end = if (j == 4) prog.len else @as(usize, @intCast(prog[16 + j]));
            phases[j] = prog[start + 2 .. end];
        }
        var values: [5]usize = [5]usize{ 0, 1, 2, 3, 4 };
        var it = aoc.permute(usize, values[0..]);
        while (it.next()) |ph| {
            var acc: Int = 0;
            for (0..10) |n| {
                const k = n * 8;
                for (0..5) |j| {
                    const phase = phases[ph[j]];
                    acc = runInst(phase[k], phase[k + 1], phase[k + 2], acc);
                }
            }
            if (acc > p2) {
                p2 = acc;
            }
        }
    }
    return [2]usize{ @intCast(p1), @intCast(p2) };
}

inline fn runInst(op: Int, a: Int, b: Int, acc: Int) Int {
    const v = if (op > 1000) b else a;
    switch (op & 1) {
        0 => return acc * v,
        1 => return acc + v,
        else => unreachable,
    }
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
