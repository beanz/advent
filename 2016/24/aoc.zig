const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const WORK_SIZE = 256;

fn parts(inp: []const u8) anyerror![2]usize {
    var nums: [8][2]usize = .{[2]usize{ 0, 0 }} ** 8;
    var u: usize = 0;
    var l: usize = 0;
    {
        var x: usize = 0;
        var y: usize = 0;
        for (0..inp.len) |i| {
            switch (inp[i]) {
                '\n' => {
                    u = x;
                    y += 1;
                    x = 0;
                },
                '.' => {
                    x += 1;
                },
                '#' => {
                    x += 1;
                },
                '0'...'9' => |ch| {
                    const n: usize = @intCast(ch - '0');
                    nums[n] = [2]usize{ x, y };
                    if (n > l) {
                        l = n;
                    }
                    x += 1;
                },
                else => unreachable,
            }
        }
    }
    l += 1;
    const w = u;
    const w1 = u + 1;
    const h = inp.len / w1;

    var dist: [64]usize = .{0} ** 64;
    var back: [WORK_SIZE][3]usize = undefined;
    var todo = aoc.Deque([3]usize).init(back[0..]);
    var seen: [8000]u16 = .{0} ** 8000;
    var seen_val: u16 = 1;
    for (0..l) |i| {
        for (i + 1..l) |j| {
            try todo.push([3]usize{ nums[i][0], nums[i][1], 0 });
            var d: usize = 0;
            while (todo.pop()) |cur| {
                if (cur[0] == nums[j][0] and cur[1] == nums[j][1]) {
                    d = cur[2];
                    break;
                }
                const k = cur[0] + cur[1] * w1;
                if (seen[k] == seen_val) {
                    continue;
                }
                seen[k] = seen_val;
                if (cur[1] > 0 and inp[k - w1] != '#' and seen[k - w1] != seen_val) {
                    try todo.push([3]usize{ cur[0], cur[1] - 1, cur[2] + 1 });
                }
                if (cur[0] < w and inp[k + 1] != '#' and seen[k + 1] != seen_val) {
                    try todo.push([3]usize{ cur[0] + 1, cur[1], cur[2] + 1 });
                }
                if (cur[1] < h and inp[k + w1] != '#' and seen[k + w1] != seen_val) {
                    try todo.push([3]usize{ cur[0], cur[1] + 1, cur[2] + 1 });
                }
                if (cur[0] > 0 and inp[k - 1] != '#' and seen[k - 1] != seen_val) {
                    try todo.push([3]usize{ cur[0] - 1, cur[1], cur[2] + 1 });
                }
            }
            dist[i * 8 + j] = d;
            dist[j * 8 + i] = d;
            seen_val += 1;
            todo.clear();
        }
    }
    var p: [8]usize = .{ 0, 1, 2, 3, 4, 5, 6, 7 };
    var p1: usize = 10000000;
    var p2: usize = 10000000;
    var iter = aoc.permute(usize, p[1..l]);
    while (iter.next()) |o| {
        var d: usize = dist[o[0]];
        for (0..o.len - 1) |j| {
            d += dist[o[j] + o[j + 1] * 8];
        }
        if (d < p1) {
            p1 = d;
        }
        d += dist[o[o.len - 1]];
        if (d < p2) {
            p2 = d;
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
