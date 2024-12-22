const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var w1: usize = 0;
    while (inp[w1] != '\n') : (w1 += 1) {}
    const w: i32 = @intCast(w1);
    w1 += 1;
    const h: i32 = @intCast(inp.len / w1);
    var sx: i32 = 0;
    var sy: i32 = 0;
    var y: i32 = 0;
    while (y < h) : (y += 1) {
        var x: i32 = 0;
        while (x < w) : (x += 1) {
            if (inp[@as(usize, @abs(x)) + @as(usize, @abs(y)) * w1] == '^') {
                sx = x;
                sy = y;
            }
        }
    }
    var seen: [33410]bool = .{false} ** 33410;
    var cx = sx;
    var cy = sy;
    var dx: i32 = 0;
    var dy: i32 = -1;
    var p1: usize = 0;
    var path = try std.BoundedArray([2]i32, 6144).init(0);
    LOOP: while (0 <= cx and cx < w and 0 <= cy and cy < h) {
        const k: usize = @intCast((cx << 8) + cy);
        if (!seen[k]) {
            try path.append(.{ cx, cy });
            p1 += 1;
        }
        seen[k] = true;
        var nx: i32 = undefined;
        var ny: i32 = undefined;
        while (true) {
            nx = cx + dx;
            ny = cy + dy;
            if (!(0 <= nx and nx < w and 0 <= ny and ny < h)) {
                break :LOOP;
            }
            if (inp[@as(usize, @abs(nx)) + @as(usize, @abs(ny)) * w1] != '#') {
                break;
            }
            const tmp = dx;
            dx = -dy;
            dy = tmp;
        }
        cx = nx;
        cy = ny;
    }
    var p2: usize = 0;
    for (path.slice()) |p| {
        if (part2(inp, w1, w, h, sx, sy, p[0], p[1])) {
            p2 += 1;
        }
    }
    return [2]usize{ p1, p2 };
}

fn part2(inp: []const u8, w1: usize, w: i32, h: i32, sx: i32, sy: i32, ox: i32, oy: i32) bool {
    var seen: [1336343]bool = .{false} ** 1336343;
    var cx = sx;
    var cy = sy;
    var dx: i32 = 0;
    var dy: i32 = -1;
    var dir: u2 = 0;
    while (true) {
        const k: usize = @intCast((((cx << 8) + cy) << 2) + dir);
        if (seen[k]) {
            return true;
        }
        seen[k] = true;
        const nx = cx + dx;
        const ny = cy + dy;
        if (!(0 <= nx and nx < w and 0 <= ny and ny < h)) {
            return false;
        }
        if ((nx == ox and ny == oy) or (inp[@as(usize, @abs(nx)) + @as(usize, @abs(ny)) * w1] == '#')) {
            const tmp = dx;
            dir +%= 1;
            dx = -dy;
            dy = tmp;
            continue;
        }
        cx = nx;
        cy = ny;
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
