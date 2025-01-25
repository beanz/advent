const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PROG_CAP: usize = 4096;
const VAR_M_XX: usize = 80;
const VAR_M_YY: usize = 122;
const VAR_M_XY: usize = 160;

const Int = i64;
const Arity: [10]usize = [10]usize{ 0, 3, 3, 1, 1, 2, 2, 3, 3, 1 };

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
    const xx = value(prog[0..], VAR_M_XX);
    const yy = value(prog[0..], VAR_M_YY);
    const xy = value(prog[0..], VAR_M_XY);
    var p1: usize = 0;
    for (0..50) |y| {
        for (0..50) |x| {
            p1 += @intFromBool(inBeam(xx, yy, xy, @intCast(x), @intCast(y)));
        }
    }
    const mul: Int = 49;
    var ratio1: Int = 0;
    while (!inBeam(xx, yy, xy, ratio1, mul)) : (ratio1 += 1) {}
    var ratio2 = ratio1;
    while (inBeam(xx, yy, xy, ratio2, mul)) : (ratio2 += 1) {}
    const size: Int = 100 - 1;
    var upper: Int = 1;
    while (squareFitsY(xx, yy, xy, upper, size, ratio1, ratio2, mul) == 0) : (upper <<= 1) {}
    var lower = @divTrunc(upper, 2);
    while (true) {
        const mid = lower + @divTrunc(upper - lower, 2);
        if (mid == lower) {
            break;
        }
        if (squareFitsY(xx, yy, xy, mid, size, ratio1, ratio2, mul) > 0) {
            upper = mid;
        } else {
            lower = mid;
        }
    }
    var p2: usize = 0;
    var y = lower;
    while (y <= lower + 5) : (y += 1) {
        const x = squareFitsY(xx, yy, xy, y, size, ratio1, ratio2, mul);
        if (x > 0) {
            p2 = @intCast(x * 10000 + y);
            break;
        }
    }
    return [2]usize{ p1, p2 };
}

inline fn squareFitsY(xx: Int, yy: Int, xy: Int, y: Int, size: Int, ratio1: Int, ratio2: Int, mul: Int) Int {
    var x = @divTrunc(y * ratio1, mul);
    while (x <= @divTrunc(y * ratio2, mul)) : (x += 1) {
        if (squareFits(xx, yy, xy, x, y, size)) {
            return x;
        }
    }
    return 0;
}

inline fn squareFits(xx: Int, yy: Int, xy: Int, x: Int, y: Int, size: Int) bool {
    return inBeam(xx, yy, xy, x, y) and
        inBeam(xx, yy, xy, x + size, y) and
        inBeam(xx, yy, xy, x, y + size);
}

inline fn inBeam(xx: Int, yy: Int, xy: Int, x: Int, y: Int) bool {
    return @abs(xx * x * x - yy * y * y) <= xy * x * y;
}

inline fn value(prog: []Int, addr: usize) Int {
    return @intCast(switch (prog[addr]) {
        21101 => prog[addr + 1] + prog[addr + 2],
        21102 => prog[addr + 1] * prog[addr + 2],
        else => unreachable,
    });
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
