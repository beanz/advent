const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var thing: [32768]bool = .{false} ** 32768;
    var mx: usize = 0;
    var my: usize = 0;
    var mz: usize = 0;
    var sub: usize = 0;
    var count: usize = 0;
    {
        var it = aoc.uintIter(usize, inp);
        while (it.next()) |xx| {
            const x = xx + 2;
            const y = it.next().? + 2;
            const z = it.next().? + 2;
            mx = @max(mx, x);
            my = @max(my, y);
            mz = @max(mz, z);
            const i = (x << 10) + (y << 5) + z;
            thing[i] = true;
            if (thing[i - 1024]) {
                sub += 2;
            }
            if (thing[i + 1024]) {
                sub += 2;
            }
            if (thing[i - 32]) {
                sub += 2;
            }
            if (thing[i + 32]) {
                sub += 2;
            }
            if (thing[i - 1]) {
                sub += 2;
            }
            if (thing[i + 1]) {
                sub += 2;
            }
            count += 1;
        }
    }
    const p1 = count * 6 - sub;
    var p2: usize = 0;
    var visit: [32768]bool = .{false} ** 32768;
    var back: [768][3]u8 = undefined;
    var work = aoc.Deque([3]u8).init(back[0..]);
    try work.push([3]u8{ @intCast(mx + 1), @intCast(my + 1), @intCast(mz + 1) });
    while (work.pop()) |cur| {
        const x: usize = @intCast(cur[0]);
        const y: usize = @intCast(cur[1]);
        const z: usize = @intCast(cur[2]);
        const i = (x << 10) + (y << 5) + z;
        if (thing[i] or visit[i]) {
            continue;
        }
        visit[i] = true;
        if (thing[i - 1024]) {
            p2 += 1;
        } else if (!visit[i - 1024] and x > 1) {
            try work.push([3]u8{ cur[0] - 1, cur[1], cur[2] });
        }
        if (thing[i + 1024]) {
            p2 += 1;
        } else if (!visit[i + 1024] and x < mx) {
            try work.push([3]u8{ cur[0] + 1, cur[1], cur[2] });
        }
        if (thing[i - 32]) {
            p2 += 1;
        } else if (!visit[i - 32] and y > 1) {
            try work.push([3]u8{ cur[0], cur[1] - 1, cur[2] });
        }
        if (thing[i + 32]) {
            p2 += 1;
        } else if (!visit[i + 32] and y < my) {
            try work.push([3]u8{ cur[0], cur[1] + 1, cur[2] });
        }
        if (thing[i - 1]) {
            p2 += 1;
        } else if (!visit[i - 1] and z > 1) {
            try work.push([3]u8{ cur[0], cur[1], cur[2] - 1 });
        }
        if (thing[i + 1]) {
            p2 += 1;
        } else if (!visit[i + 1] and z < mz) {
            try work.push([3]u8{ cur[0], cur[1], cur[2] + 1 });
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
