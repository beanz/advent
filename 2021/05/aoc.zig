const std = @import("std");
const aoc = @import("aoc-lib.zig");

const X1: usize = 0;
const Y1: usize = 1;
const X2: usize = 2;
const Y2: usize = 3;

pub fn parts(inp: anytype) ![2]usize {
    var b = try std.BoundedArray(u16, 2048).init(0);
    const lines = try aoc.BoundedInts(u16, &b, inp);
    var m1: [1048576]u2 = undefined;
    @memset(m1[0..], 0);
    var c1: usize = 0;
    var m2: [1048576]u2 = undefined;
    @memset(m2[0..], 0);
    var c2: usize = 0;
    var i: usize = 0;
    while (i < lines.len) : (i += 4) {
        const x1 = lines[i + X1];
        const y1 = lines[i + Y1];
        const x2 = lines[i + X2];
        const y2 = lines[i + Y2];
        var x = x1;
        var y = y1;
        const p1 = x1 == x2 or y1 == y2;
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
    const p = parts(aoc.test1file) catch unreachable;
    try aoc.assertEq(@as(usize, 5), p[0]);
    try aoc.assertEq(@as(usize, 12), p[1]);
    const pi = parts(aoc.inputfile) catch unreachable;
    try aoc.assertEq(@as(usize, 6005), pi[0]);
    try aoc.assertEq(@as(usize, 23864), pi[1]);
}

fn day05(inp: []const u8, bench: bool) anyerror!void {
    const p = parts(inp) catch unreachable;
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day05);
}
