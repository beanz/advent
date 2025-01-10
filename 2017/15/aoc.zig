const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const MOD: usize = 2147483647;

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 24;
    const a = try aoc.chompUint(usize, inp, &i);
    i += 25;
    const b = try aoc.chompUint(usize, inp, &i);
    var p1: usize = 0;
    {
        var gen_a = gen(usize, 16807, a);
        var gen_b = gen(usize, 48271, b);
        for (0..40000000) |_| {
            const va = gen_a.next().?;
            const vb = gen_b.next().?;
            p1 += @intFromBool(va & 0xffff == vb & 0xffff);
        }
    }
    var p2: usize = 0;
    {
        var gen_a = gen_mult(usize, 16807, a, 4);
        var gen_b = gen_mult(usize, 48271, b, 8);
        for (0..5000000) |_| {
            const va = gen_a.next().?;
            const vb = gen_b.next().?;
            p2 += @intFromBool(va & 0xffff == vb & 0xffff);
        }
    }
    return [2]usize{ p1, p2 };
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

fn gen(comptime T: type, factor: usize, n: usize) genIter(T) {
    return genIter(T){ .v = n, .factor = factor };
}

fn genIter(comptime T: type) type {
    return struct {
        factor: usize,
        v: usize,

        const Self = @This();

        fn next(self: *Self) ?T {
            self.v *= self.factor;
            self.v %= MOD;
            return self.v;
        }
    };
}

fn gen_mult(comptime T: type, factor: usize, n: usize, x: usize) genMultiIter(T) {
    return genMultiIter(T){ .v = n, .factor = factor, .mul = x };
}

fn genMultiIter(comptime T: type) type {
    return struct {
        factor: usize,
        v: usize,
        mul: usize,

        const Self = @This();

        fn next(self: *Self) ?T {
            while (true) {
                self.v *= self.factor;
                self.v %= MOD;
                if (self.v % self.mul == 0) {
                    break;
                }
            }
            return self.v;
        }
    };
}
