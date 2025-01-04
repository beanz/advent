const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const UP1: [10]u8 = [10]u8{ 0, 1, 2, 3, 1, 2, 3, 4, 5, 6 };
const DOWN1: [10]u8 = [10]u8{ 0, 4, 5, 6, 7, 8, 9, 7, 8, 9 };
const LEFT1: [10]u8 = [10]u8{ 0, 1, 1, 2, 4, 4, 5, 7, 7, 8 };
const RIGHT1: [10]u8 = [10]u8{ 0, 2, 3, 3, 5, 6, 6, 8, 9, 9 };

const UP2: [14]u8 = [14]u8{ 0, 0x1, 0x2, 0x1, 0x4, 0x5, 0x2, 0x3, 0x4, 0x9, 0x6, 0x7, 0x8, 0xB };
const DOWN2: [14]u8 = [14]u8{ 0, 0x3, 0x6, 0x7, 0x8, 0x5, 0xA, 0xB, 0xC, 0x9, 0xA, 0xD, 0xC, 0xD };
const LEFT2: [14]u8 = [14]u8{ 0, 0x1, 0x2, 0x2, 0x3, 0x5, 0x5, 0x6, 0x7, 0x8, 0xA, 0xA, 0xB, 0xD };
const RIGHT2: [14]u8 = [14]u8{ 0, 0x1, 0x3, 0x4, 0x4, 0x6, 0x7, 0x8, 0x9, 0x9, 0xB, 0xC, 0xC, 0xD };

const KEY: [14]u8 = [14]u8{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D' };

fn parts(inp: []const u8) anyerror![2][5]u8 {
    var p1: [5]u8 = .{32} ** 5;
    var p2: [5]u8 = .{32} ** 5;
    var p1p: usize = 5;
    var p2p: usize = 5;
    var i: usize = 0;
    for (inp) |ch| {
        switch (ch) {
            'U' => {
                p1p = UP1[p1p];
                p2p = UP2[p2p];
            },
            'D' => {
                p1p = DOWN1[p1p];
                p2p = DOWN2[p2p];
            },
            'L' => {
                p1p = LEFT1[p1p];
                p2p = LEFT2[p2p];
            },
            'R' => {
                p1p = RIGHT1[p1p];
                p2p = RIGHT2[p2p];
            },
            '\n' => {
                p1[i] = KEY[p1p];
                p2[i] = KEY[p2p];
                i += 1;
            },
            else => {},
        }
    }
    return [2][5]u8{ p1, p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
