const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    var t1 = try parts(aoc.test1file);
    try aoc.assertEq([2]usize{ 374, 82000210 }, t1);
    var p = try parts(aoc.inputfile);
    try aoc.assertEq([2]usize{ 9918828, 692506533832 }, p);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var mul: usize = 1000000;
    var w: usize = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    var h = inp.len / (w + 1);
    var cx = std.mem.zeroes([140]bool);
    var cy = std.mem.zeroes([140]bool);
    for (0..h) |y| {
        for (0..w) |x| {
            if (inp[y * (w + 1) + x] != '.') {
                cy[y] = true;
                break;
            }
        }
    }
    for (0..w) |x| {
        for (0..h) |y| {
            if (inp[y * (w + 1) + x] != '.') {
                cx[x] = true;
                break;
            }
        }
    }
    var ax: usize = 0;
    var ay: usize = 0;
    var ax2: usize = 0;
    var ay2: usize = 0;
    var g = try std.BoundedArray([2]usize, 512).init(0);
    var g2 = try std.BoundedArray([2]usize, 512).init(0);
    for (0..h) |y| {
        for (0..w) |x| {
            if (inp[y * (w + 1) + x] != '.') {
                try g.append([2]usize{ ax, ay });
                try g2.append([2]usize{ ax2, ay2 });
            }
            ax += 1;
            ax2 += 1;
            if (!cx[x]) {
                ax += 1;
                ax2 += mul - 1;
            }
        }
        ax = 0;
        ax2 = 0;
        ay += 1;
        ay2 += 1;
        if (!cy[y]) {
            ay += 1;
            ay2 += mul - 1;
        }
    }
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..g.len) |i| {
        var a = g.get(i);
        var a2 = g2.get(i);
        for (i + 1..g.len) |j| {
            var b = g.get(j);
            var b2 = g2.get(j);
            p1 += abs_diff(a[0], b[0]) + abs_diff(a[1], b[1]);
            p2 += abs_diff(a2[0], b2[0]) + abs_diff(a2[1], b2[1]);
        }
    }
    return [2]usize{ p1, p2 };
}

fn abs_diff(a: usize, b: usize) usize {
    if (a > b) {
        return a - b;
    }
    return b - a;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
