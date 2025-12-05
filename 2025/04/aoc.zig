const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const OFFSETS = [8][2]isize{ .{ -1, -1 }, .{ 0, -1 }, .{ 1, -1 }, .{ -1, 0 }, .{ 1, 0 }, .{ -1, 1 }, .{ 0, 1 }, .{ 1, 1 } };

fn parts(inp: []const u8) anyerror![2]usize {
    var grid: [20480]u4 = .{0} ** 20480;
    var p1: usize = 0;
    var p2: usize = 0;
    const w: usize = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const h = inp.len / (w + 1);
    var rolls = try std.BoundedArray(usize, 16384).init(0);
    {
        for (0..h) |y| {
            for (0..w) |x| {
                const ch = inp[x + y * (w + 1)];
                if (ch == '@') {
                    var c: u4 = 0;
                    for (OFFSETS) |o| {
                        const nx: isize = o[0] + @as(isize, @intCast(x));
                        const ny: isize = o[1] + @as(isize, @intCast(y));
                        if (nx < 0 or ny < 0) {
                            continue;
                        }
                        const unx: usize = @intCast(nx);
                        const uny: usize = @intCast(ny);
                        if (unx >= w or uny >= h) {
                            continue;
                        }
                        if (inp[unx + uny * (w + 1)] == '@') {
                            c += 1;
                        }
                    }
                    if (c < 4) {
                        p1 += 1;
                        if (c == 0) {
                            p2 += 1;
                        }
                    }
                    if (c != 0) {
                        const gi = 1 + x + (1 + y) * (w + 2);
                        grid[gi] = c;
                        try rolls.append(gi);
                    }
                }
            }
        }
    }
    {
        var r = rolls.slice();
        var l = r.len;
        const gw = w + 2;
        const gwi: isize = @intCast(gw);
        const offsets = [8]isize{ -1 - gwi, -gwi, 1 - gwi, -1, 1, -1 + gwi, gwi, 1 + gwi };
        var done: bool = false;
        while (!done) {
            done = true;
            var j: usize = 0;
            while (j < l) {
                const i = r[j];
                const c = grid[i];
                if (c >= 4) {
                    j += 1;
                    continue;
                }
                done = false;
                l -= 1;
                r[j] = r[l];
                p2 += 1;
                grid[i] = 0;
                for (offsets) |o| {
                    const ni: usize = @intCast(o + @as(isize, @intCast(i)));
                    if (grid[ni] > 1) {
                        grid[ni] -= 1;
                    }
                }
            }
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
