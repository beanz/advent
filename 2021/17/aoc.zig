const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

fn launch(target: []const Int, svx: Int, svy: Int) bool {
    var x: Int = 0;
    var y: Int = 0;
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

fn parts(inp: []const u8) anyerror![2]usize {
    const target = parse: {
        var i: usize = 15;
        const x0 = try aoc.chompUint(Int, inp, &i);
        i += 2;
        const x1 = try aoc.chompUint(Int, inp, &i);
        i += 5;
        const y0 = -1 * try aoc.chompUint(Int, inp, &i);
        i += 3;
        const y1 = -1 * try aoc.chompUint(Int, inp, &i);
        break :parse [4]Int{ x0, x1, y0, y1 };
    };
    var ry = target[2];
    if (ry < 0) {
        ry = -ry;
    }
    var vx: i32 = 0;
    var x: i32 = 0;
    while (x < target[0]) : (x += vx) {
        vx += 1;
    }
    var p2: usize = 0;
    while (vx <= target[1]) : (vx += 1) {
        var vy = -ry;
        while (vy <= ry) : (vy += 1) {
            if (launch(target[0..], vx, vy)) {
                p2 += 1;
            }
        }
    }
    return [2]usize{ @as(usize, @intCast(@divFloor(target[2] * (target[2] + 1), 2))), p2 };
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
