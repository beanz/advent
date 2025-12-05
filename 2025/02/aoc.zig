const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const s = try aoc.chompUint(usize, inp, &i);
        i += 1;
        const e = try aoc.chompUint(usize, inp, &i);
        for (s..e + 1) |n| {
            const l = std.math.log10_int(n) + 1;
            if (l & 1 == 0) {
                const max = try std.math.powi(usize, 10, l / 2);
                const second = @divFloor(n, max);
                if (n == second + second * max) {
                    p1 += n;
                    p2 += n;
                    continue;
                }
            }
            var j: usize = 3;
            while (j <= l) {
                if (l % j != 0) {
                    j += 2;
                    continue;
                }
                const k = @divExact(l, j);
                const m = try std.math.powi(usize, 10, k);
                const div = try std.math.powi(usize, 10, l - k);
                const first = @divFloor(n, div);
                var c: usize = 0;
                for (0..j) |_| {
                    c *= m;
                    c += first;
                }
                if (c == n) {
                    p2 += n;
                    break;
                }
                j += 2;
            }
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
