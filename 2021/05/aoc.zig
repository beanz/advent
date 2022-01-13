const std = @import("std");
const aoc = @import("aoc-lib.zig");

const X1: usize = 0;
const Y1: usize = 1;
const X2: usize = 2;
const Y2: usize = 3;

pub fn parts(inp: anytype) ![2]usize {
    var b = try std.BoundedArray(u16, 2048).init(0);
    var lines = try aoc.BoundedInts(u16, &b, inp);
    var m1: [1048576]u2 = undefined;
    std.mem.set(u2, m1[0..], 0);
    var c1: usize = 0;
    var m2: [1048576]u2 = undefined;
    std.mem.set(u2, m2[0..], 0);
    var c2: usize = 0;
    var i: usize = 0;
    while (i < lines.len) : (i += 4) {
        var x1 = lines[i + X1];
        var y1 = lines[i + Y1];
        var x2 = lines[i + X2];
        var y2 = lines[i + Y2];
        var x = x1;
        var y = y1;
        var p1 = x1 == x2 or y1 == y2;
        while (true) {
            const k = @as(u32, x) + (@as(u32, y) * 1024);
            switch (m2[k]) {
                0 => {
                    m2[k] = 1;
                },
                1 => {
                    m2[k] = 2;
                    c2 += 1;
                },
                else => {},
            }
            if (p1) {
                switch (m1[k]) {
                    0 => {
                        m1[k] = 1;
                    },
                    1 => {
                        m1[k] = 2;
                        c1 += 1;
                    },
                    else => {},
                }
            }
            if (x == x2 and y == y2) {
                break;
            }
            if (x1 < x2) {
                x += 1;
            } else if (x1 > x2) {
                x -= 1;
            }
            if (y1 < y2) {
                y += 1;
            } else if (y1 > y2) {
                y -= 1;
            }
        }
    }
    return [2]usize{ c1, c2 };
}

test "examples" {
    var p = parts(aoc.test1file) catch unreachable;
    try aoc.assertEq(@as(usize, 5), p[0]);
    try aoc.assertEq(@as(usize, 12), p[1]);
    var pi = parts(aoc.inputfile) catch unreachable;
    try aoc.assertEq(@as(usize, 6005), pi[0]);
    try aoc.assertEq(@as(usize, 23864), pi[1]);
}

fn day05(inp: []const u8, bench: bool) anyerror!void {
    var p = parts(inp) catch unreachable;
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day05);
}
