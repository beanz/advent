const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PROG_CAP: usize = 4096;
const MAP_START: usize = 1182;
const MAP_END_1_ADDR: usize = 11;
const MAP_END_2_ADDR: usize = 12;
const WIDTH_ADDR: usize = 828;

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
    const mapEnd: usize = @intCast(prog[MAP_END_1_ADDR] + prog[MAP_END_2_ADDR]);
    const w: usize = @intCast(prog[WIDTH_ADDR]);
    var map: [2048]bool = .{false} ** 2048;
    var v = false;
    var len: usize = 0;
    for (MAP_START..mapEnd) |i| {
        for (0..@intCast(prog[i])) |_| {
            map[len] = v;
            len += 1;
        }
        v = !v;
    }
    const h = @divTrunc(len, w);
    var p1: usize = 0;
    var p2: usize = 0;
    var c: usize = 0;
    for (0..h) |y| {
        for (0..w) |x| {
            const i = x + y * w;
            if (!map[i]) {
                continue;
            }
            if (x > 1 and x < w - 1 and y > 1) {
                if (map[i - 1] and map[i + 1] and map[i - w]) {
                    p1 += x * y;
                }
            }
            c += 1;
            p2 += i + x * y;
        }
    }
    p2 += mapEnd * c + (1 + c) * c / 2;

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
