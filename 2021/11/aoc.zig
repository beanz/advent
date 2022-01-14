const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn parts(alloc: std.mem.Allocator, in: []const u8, p1Days: usize) ![2]usize {
    var oct: []u8 = try alloc.dupe(u8, in);
    defer alloc.free(oct);
    var w: usize = 0;
    while (in[w] != '\n') : (w += 1) {}
    var h = in.len / (w + 1);
    var r = [2]usize{ 0, 0 };
    var c: usize = 0;
    var day: usize = 1;
    while (true) : (day += 1) {
        for (oct) |ch, i| {
            if (ch != '\n') {
                oct[i] += 1;
            }
        }
        //aoc.print("{s}\n", .{oct}) catch unreachable;
        for (oct) |ch, i| {
            if (ch > '9' and ch != '~') {
                flash(oct, i, w, h);
            }
        }
        var p2: usize = 0;
        for (oct) |ch, i| {
            if (ch != '~') {
                continue;
            }
            oct[i] = '0';
            p2 += 1;
        }
        //aoc.print("{}: {}\n{s}\n", .{ day, p2, oct }) catch unreachable;
        c += p2;
        if (day == p1Days) {
            r[0] = c;
        }
        if (p2 == w * h) {
            r[1] = day;
            return r;
        }
    }
    return r;
}

fn flash(oct: []u8, i: usize, w: usize, h: usize) void {
    var x = @intCast(isize, i % (w + 1));
    var y = @intCast(isize, i / (w + 1));
    //aoc.print("flash {},{}\n{s}\n", .{ x, y, oct }) catch unreachable;
    oct[i] = '~';
    for ([3]isize{ x - 1, x, x + 1 }) |nx| {
        for ([3]isize{ y - 1, y, y + 1 }) |ny| {
            if (x == nx and y == ny) {
                continue;
            }
            if (nx < 0 or ny < 0 or nx >= w or ny >= h) {
                continue;
            }
            var ni = @intCast(usize, nx) + @intCast(usize, ny) * (w + 1);
            if (oct[ni] == '~') {
                continue;
            }
            oct[ni] += 1;
            if (oct[ni] > '9') {
                flash(oct, ni, w, h);
            }
        }
    }
}

test "examples" {
    var test0 = try parts(aoc.talloc, aoc.test0file, 1);
    var test1 = try parts(aoc.talloc, aoc.test1file, 100);
    var real = try parts(aoc.talloc, aoc.inputfile, 100);
    try aoc.assertEq(@as(usize, 9), test0[0]);
    try aoc.assertEq(@as(usize, 1656), test1[0]);
    try aoc.assertEq(@as(usize, 1652), real[0]);
    try aoc.assertEq(@as(usize, 6), test0[1]);
    try aoc.assertEq(@as(usize, 195), test1[1]);
    try aoc.assertEq(@as(usize, 220), real[1]);
}

fn day11(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(aoc.halloc, inp, 100);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day11);
}
