const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

fn parts(inp: []const u8) anyerror![2]usize {
    const P = struct { x: Int, y: Int, d: usize };
    var g: [128 * 128]?usize = .{null} ** (128 * 128);
    var s = try std.BoundedArray(P, 256).init(0);
    var p = P{ .x = 0, .y = 0, .d = 0 };
    for (inp[1 .. inp.len - 1]) |ch| {
        switch (ch) {
            '(' => {
                try s.append(P{ .x = p.x, .y = p.y, .d = p.d });
                continue;
            },
            ')' => {
                p = s.pop();
                continue;
            },
            '|' => {
                p = s.get(s.len - 1);
                continue;
            },
            'E' => p.x += 1,
            'W' => p.x -= 1,
            'N' => p.y -= 1,
            'S' => p.y += 1,
            '$' => {},
            else => {
                aoc.print("C: '{c}'\n", .{ch});
                unreachable;
            },
        }
        p.d += 1;
        const k: usize = @intCast(((64 + p.x) << 7) + (64 + p.y));
        if (g[k]) |pd| {
            if (p.d >= pd) {
                continue;
            }
        }
        g[k] = p.d;
    }
    var p1: usize = std.math.minInt(usize);
    var p2: usize = 0;
    for (g) |dist| {
        if (dist) |d| {
            p1 = @max(p1, d);
            p2 += @intFromBool(d >= 1000);
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
