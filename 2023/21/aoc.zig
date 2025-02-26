const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var m1, var m2 = parse: {
        var m1: [131]u131 = .{0} ** 131;
        var m2: [131]u131 = .{0} ** 131;
        var bit: u131 = 1;
        var y: usize = 0;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {
                    bit = 1;
                    y += 1;
                    continue;
                },
                '#' => {
                    m1[y] |= bit;
                    m2[y] |= bit;
                },
                '.' => {},
                'S' => {},
                else => unreachable,
            }
            bit <<= 1;
        }
        break :parse .{ m1, m2 };
    };
    m2[0] |= 1;
    const start = [1]Pos{Pos{ .x = 65, .y = 65 }};
    const bfs1 = try bfs(&m1, &start, 130);
    const corners = [4]Pos{ Pos{ .x = 0, .y = 0 }, Pos{ .x = 130, .y = 0 }, Pos{ .x = 0, .y = 130 }, Pos{ .x = 130, .y = 130 } };
    const bfs2 = try bfs(&m2, &corners, 64);

    const even_full = bfs1[0] + bfs1[1];
    const odd_full = bfs1[2] + bfs1[3];
    const remove_corners = bfs1[3];
    const n = 202300;
    const first = n * n * even_full;
    const second = (n + 1) * (n + 1) * odd_full;
    const third = n * bfs2[0];
    const fourth = (n + 1) * remove_corners;
    const p2 = first + second + third - fourth;
    return [2]usize{ bfs1[0], p2 };
}

const Int = u32;
const Pos = struct {
    x: Int,
    y: Int,
};

fn bfs(m: []u131, s: []const Pos, max: Int) ![4]usize {
    var count: [4]usize = .{0} ** 4;
    var back: [512][3]Int = undefined;
    var work = aoc.Deque([3]Int).init(back[0..]);
    for (s) |p| {
        try work.push([3]Int{ p.x, p.y, 0 });
        m[p.y] |= @as(u131, 1) << @as(u8, @intCast(p.x));
    }
    while (work.pop()) |cur| {
        const x = cur[0];
        const y = cur[1];
        const st = cur[2];
        if (st & 1 == 0) {
            if (st <= 64) {
                count[0] += 1;
            } else {
                count[1] += 1;
            }
        } else {
            if ((if (x > 65) x - 65 else 65 - x) + (if (y > 65) y - 65 else 65 - y) <= 65) {
                count[2] += 1;
            } else {
                count[3] += 1;
            }
        }

        if (st == max) {
            continue;
        }
        if (x > 0) {
            const bit = @as(u131, 1) << @as(u8, @intCast(x - 1));
            if (m[y] & bit == 0) {
                m[y] |= bit;
                try work.push([3]Int{ x - 1, y, st + 1 });
            }
        }
        if (x < 130) {
            const bit = @as(u131, 1) << @as(u8, @intCast(x + 1));
            if (m[y] & bit == 0) {
                m[y] |= bit;
                try work.push([3]Int{ x + 1, y, st + 1 });
            }
        }
        const bit = @as(u131, 1) << @as(u8, @intCast(x));
        if (y > 0) {
            if (m[y - 1] & bit == 0) {
                m[y - 1] |= bit;
                try work.push([3]Int{ x, y - 1, st + 1 });
            }
        }
        if (y < 130) {
            if (m[y + 1] & bit == 0) {
                m[y + 1] |= bit;
                try work.push([3]Int{ x, y + 1, st + 1 });
            }
        }
    }
    return count;
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
