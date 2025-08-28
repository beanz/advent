const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const DX: [4]isize = .{ 0, 1, 0, -1 };
const DY: [4]isize = .{ -1, 0, 1, 0 };

fn parts(inp: []const u8) anyerror![2]usize {
    var w1: usize = 0;
    while (inp[w1] != '\n') : (w1 += 1) {}
    const w = w1;
    w1 += 1;
    const h = inp.len / w1;
    var p1: usize = 0;
    var p2: usize = 0;
    var seen: [20480]bool = .{false} ** 20480;
    const Rec = struct { x: usize, y: usize };
    for (0..h) |y| {
        for (0..w1 - 1) |x| {
            if (seen[x + y * w]) {
                continue;
            }
            const ch = inp[x + y * w1];
            var area: usize = 0;
            var sides: usize = 0;
            var perimeter: usize = 0;
            var todo = try std.BoundedArray(Rec, 1024).init(0);
            try todo.append(Rec{ .x = x, .y = y });
            while (todo.pop()) |cur| {
                if (seen[cur.x + cur.y * w]) {
                    continue;
                }
                seen[cur.x + cur.y * w] = true;
                area += 1;
                for (0..4) |dir| {
                    const ix: isize = @intCast(cur.x);
                    const iy: isize = @intCast(cur.y);
                    const nch = get(inp, ix + DX[dir], iy + DY[dir], w, h);
                    if (nch == ch) {
                        try todo.append(Rec{ .x = @as(usize, @intCast(ix + DX[dir])), .y = @as(usize, @intCast(iy + DY[dir])) });
                        continue;
                    }
                    perimeter += 1;
                    if (get(inp, ix + DX[dir] - DY[dir], iy + DY[dir] - DX[dir], w, h) == ch or
                        get(inp, ix - DY[dir], iy - DX[dir], w, h) != ch)
                    {
                        sides += 1;
                    }
                }
            }
            p1 += area * perimeter;
            p2 += area * sides;
        }
    }
    return [2]usize{ p1, p2 };
}

fn get(inp: []const u8, x: isize, y: isize, w: usize, h: usize) u8 {
    if (0 <= x and x < @as(isize, @bitCast(w)) and
        0 <= y and y < @as(isize, @bitCast(h)))
    {
        const ux: usize = @intCast(x);
        const uy: usize = @intCast(y);
        return inp[ux + uy * (w + 1)];
    } else {
        return '~';
    }
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
