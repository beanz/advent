const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const HQ: [6]i32 = [6]i32{ 0, 1, 1, 0, -1, -1 };
const HR: [6]i32 = [6]i32{ -1, -1, 0, 1, 1, 0 };

fn parts(inp: []const u8) anyerror![2]usize {
    var q: i32 = 0;
    var r: i32 = 0;
    var i: usize = 0;
    var p2: usize = 0;
    while (i < inp.len) : (i += 2) {
        switch (inp[i]) {
            'n' => {
                switch (inp[i + 1]) {
                    'e' => {
                        q += 1;
                        r -= 1;
                        i += 1;
                    },
                    'w' => {
                        q -= 1;
                        i += 1;
                    },
                    else => {
                        r -= 1;
                    },
                }
            },
            's' => {
                switch (inp[i + 1]) {
                    'e' => {
                        q += 1;
                        i += 1;
                    },
                    'w' => {
                        q -= 1;
                        r += 1;
                        i += 1;
                    },
                    else => {
                        r += 1;
                    },
                }
            },
            else => unreachable,
        }
        p2 = @max(p2, hex_dist(q, r));
    }
    return [2]usize{ hex_dist(q, r), p2 };
}

fn hex_dist(q: i32, r: i32) usize {
    return @intCast((@abs(q) + @abs(q + r) + @abs(r)) / 2);
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
