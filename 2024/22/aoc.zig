const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: [1048576]usize = .{0} ** 1048576;
    var m: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var n = try aoc.chompUint(usize, inp, &i);
        var prev: i8 = @intCast(n % 10);
        var k: usize = 0;
        var seen: [1048576]bool = .{false} ** 1048576;
        for (0..2000) |j| {
            n ^= n << 6;
            n &= 0xffffff;
            n ^= n >> 5;
            n &= 0xffffff;
            n ^= n << 11;
            n &= 0xffffff;
            const price = n % 10;
            const ip: i8 = @intCast(price);
            const diff: usize = @intCast((ip - prev) & 0x1f);
            prev = ip;
            k = ((k << 5) + diff) & 0xfffff;
            if (j < 4 or seen[k]) {
                continue;
            }
            seen[k] = true;
            p2[k] += price;
            if (m < p2[k]) {
                m = p2[k];
            }
        }
        p1 += n;
    }
    return [2]usize{ p1, m };
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
