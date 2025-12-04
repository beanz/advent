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
                grid[1 + x + (1 + y) * (w + 2)] = c;
            }
        }
    }
    var done: bool = false;
    while (!done) {
        done = true;
        for (1..h + 1) |y| {
            const iy = y * (w + 2);
            for (1..w + 1) |x| {
                const i = x + iy;
                const c = grid[i];
                if (c == 0) {
                    continue;
                }
                if (c < 4) {
                    done = false;
                    p2 += 1;
                    grid[i] = 0;
                    for (OFFSETS) |o| {
                        const nx: usize = @intCast(o[0] + @as(isize, @intCast(x)));
                        const ny: usize = @intCast(o[1] + @as(isize, @intCast(y)));
                        if (grid[nx + ny * (w + 2)] > 1) {
                            grid[nx + ny * (w + 2)] -= 1;
                        }
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
