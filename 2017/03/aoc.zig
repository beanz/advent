const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    const n = try aoc.chompUint(usize, inp, &i);
    var sq: usize = 1;
    while (sq * sq < n) {
        sq += 2;
    }
    var c: usize = sq * sq;
    var p1: usize = 0;
    while (true) : (c -= sq - 1) {
        const d = if (n > c) n - c else c - n;
        if (d <= (sq - 1) / 2) {
            p1 = sq - 1 - d;
            break;
        }
    }

    // https://oeis.org/A141481
    var g: [512]usize = .{0} ** 512;
    g[key(0, 0)] = 1;
    g[key(1, 0)] = 1;
    var x: isize = 0;
    var y: isize = 0;
    while (g[key(x, y)] <= n) {
        if (y > -x and x > y) {
            y += 1;
        } else if (y > -x and x <= y) {
            x -= 1;
        } else if (y <= -x and x < y) {
            y -= 1;
        } else {
            x += 1;
        }
        g[key(x, y)] = g[key(x - 1, y - 1)] + g[key(x, y - 1)] + g[key(x + 1, y - 1)] + g[key(x - 1, y)] + g[key(x + 1, y)] + g[key(x - 1, y + 1)] + g[key(x, y + 1)] + g[key(x + 1, y + 1)];
    }
    return [2]usize{ p1, g[key(x, y)] };
}

inline fn key(x: isize, y: isize) usize {
    return (@as(usize, @intCast(x + 8)) << 4) + @as(usize, @intCast(y + 8));
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
