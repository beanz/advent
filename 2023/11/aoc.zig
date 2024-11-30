const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    const t1 = try parts(aoc.test1file);
    try aoc.assertEq([2]usize{ 374, 82000210 }, t1);
    const p = try parts(aoc.inputfile);
    try aoc.assertEq([2]usize{ 9918828, 692506533832 }, p);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const mul: usize = 1000000;
    const w: usize = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const h = inp.len / (w + 1);
    var cx = std.mem.zeroes([140]u8);
    var cy = std.mem.zeroes([140]u8);
    var gc: usize = 0;
    var xmax: usize = 0;
    var xmin: usize = w + 1;
    var ymax: usize = 0;
    var ymin: usize = h + 1;
    for (0..h) |y| {
        for (0..w) |x| {
            if (inp[y * (w + 1) + x] != '.') {
                gc += 1;
                cx[x] += 1;
                if (x > xmax) {
                    xmax = x;
                }
                if (x < xmin) {
                    xmin = x;
                }
                cy[y] += 1;
            }
        }
        if (cy[y] > 0) {
            if (y > ymax) {
                ymax = y;
            }
            if (y < ymin) {
                ymin = y;
            }
        }
    }
    const dx = dist(gc, xmin, xmax, cx, mul);
    const dy = dist(gc, ymin, ymax, cy, mul);
    const p1: usize = dx[0] + dy[0];
    const p2: usize = dx[1] + dy[1];
    return [2]usize{ p1, p2 };
}

fn dist(gc: usize, min: usize, max: usize, v: [140]u8, mul: usize) [2]usize {
    var exp: [2]usize = [2]usize{ 0, 0 };
    var d: [2]usize = [2]usize{ 0, 0 };
    var px: usize = min;
    var nx: usize = @intCast(v[min]);
    var x: usize = min + 1;
    while (x <= max) : (x += 1) {
        if (v[x] > 0) {
            d[0] += (x - px + exp[0]) * nx * (gc - nx);
            d[1] += (x - px + exp[1]) * nx * (gc - nx);
            nx += v[x];
            px = x;
            exp[0] = 0;
            exp[1] = 0;
        } else {
            exp[0] += 1;
            exp[1] += mul - 1;
        }
    }
    return d;
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
