const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const CACHE: usize = 131072;

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var cache: [CACHE]usize = .{0} ** CACHE;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const n = try aoc.chompUint(usize, inp, &i);
        p1 += blink(&cache, n, 25);
        p2 += blink(&cache, n, 75);
    }
    return [2]usize{ p1, p2 };
}

fn blink(cache: *[CACHE]usize, s: usize, n: usize) usize {
    if (n == 0) {
        return 1;
    }
    const k = (s << 7) + n;
    if (k < cache.len) {
        if (cache[k] != 0) {
            return cache[k] - 1;
        }
    }
    var res: usize = undefined;
    if (s == 0) {
        res = blink(cache, 1, n - 1);
    } else {
        const l = std.math.log10_int(s) + 1;
        const m = std.math.powi(usize, 10, l / 2) catch unreachable;
        if (l & 1 == 0) {
            res = blink(cache, s / m, n - 1) + blink(cache, s % m, n - 1);
        } else {
            res = blink(cache, s * 2024, n - 1);
        }
    }
    if (k < cache.len) {
        cache[k] = 1 + res;
    }
    return res;
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
