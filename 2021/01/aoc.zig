const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    var pt = try parts(aoc.test1file);
    try aoc.assertEq(@as(u32, 7), pt[0]);
    try aoc.assertEq(@as(u32, 5), pt[1]);
    var p = try parts(aoc.inputfile);
    try aoc.assertEq(@as(u32, 1342), p[0]);
    try aoc.assertEq(@as(u32, 1378), p[1]);
}

fn calc(exp: []const u32, n: u32) u32 {
    var i: usize = n;
    var c: u32 = 0;
    while (i < exp.len) : (i += 1) {
        if (exp[i - n] < exp[i]) {
            c += 1;
        }
    }
    return c;
}

fn parts(inp: []const u8) ![2]u32 {
    var b = try std.BoundedArray(u32, 2048).init(0);
    var exp = try aoc.BoundedInts(u32, &b, inp);
    return [2]u32{ calc(exp, 1), calc(exp, 3) };
}

fn day01(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day01);
}

test "vector" {
    //var ex = [_]u32{
    //    199, 200, 208, 210, 200, 207, 240, 269, 260, 263,
    //};
    var v1: std.meta.Vector(9, u32) = [_]u32{
        199, 200, 208, 210, 200, 207, 240, 269, 260,
    };
    aoc.print("v1={}\n", .{v1});
    var v2: std.meta.Vector(9, u32) = [_]u32{
        200, 208, 210, 200, 207, 240, 269, 260, 263,
    };
    aoc.print("v2={}\n", .{v2});
    var v3 = v1 < v2;
    aoc.print("v3={}\n", .{v3});
    var zeros: std.meta.Vector(9, u16) = @splat(@as(u16, 0));
    var ones: std.meta.Vector(9, u16) = @splat(@as(u16, 1));
    var sel = @select(u16, v3, ones, zeros);
    aoc.print("sel={}\n", .{sel});
    try aoc.assertEq(@as(u32, 7), @reduce(.Add, sel));
}
