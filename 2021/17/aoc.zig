const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn launch(target: []i32, svx: i32, svy: i32) bool {
    var x: i32 = 0;
    var y: i32 = 0;
    var vx = svx;
    var vy = svy;
    while (true) {
        x += vx;
        y += vy;
        if (vx > 0) {
            vx -= 1;
        }
        vy -= 1;
        if (y < target[2]) {
            return false;
        }
        if (target[0] <= x and x <= target[1]) {
            if (y <= target[3]) {
                return true;
            }
        } else if (vx == 0) {
            return false;
        }
    }
}

pub fn parts(_: std.mem.Allocator, inp: []const u8) ![2]usize {
    var b = try std.BoundedArray(i32, 4).init(0);
    var target = try aoc.BoundedSignedInts(i32, &b, inp);
    var p2: usize = 0;
    var ry = target[2];
    if (ry < 0) {
        ry = -ry;
    }
    var vx: i32 = 0;
    var x: i32 = 0;
    while (x < target[0]) : (x += vx) {
        vx += 1;
    }
    while (vx <= target[1]) : (vx += 1) {
        var vy = -ry;
        while (vy <= ry) : (vy += 1) {
            if (launch(target, vx, vy)) {
                p2 += 1;
            }
        }
    }
    return [2]usize{ @intCast(usize, @divFloor(target[2] * (target[2] + 1), 2)), p2 };
}

test "parts" {
    var t1 = try parts(aoc.talloc, aoc.test1file);
    try aoc.assertEq(@as(usize, 45), t1[0]);
    var r = try parts(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(usize, 2850), r[0]);
    try aoc.assertEq(@as(usize, 112), t1[1]);
    try aoc.assertEq(@as(usize, 1117), r[1]);
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(aoc.halloc, inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
