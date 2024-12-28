const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const DX: [4]i32 = .{ 0, 1, 0, -1 };
const DY: [4]i32 = .{ -1, 0, 1, 0 };

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
    var corners: [133643]?usize = .{null} ** 133643;
    var cx = sx;
    var cy = sy;
    var dir: u2 = 0;
    var prev_key: usize = @intCast((((cx << 8) + cy) << 2) + dir);
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
        var ndir = dir;
        while (true) {
            nx = cx + DX[ndir];
            ny = cy + DY[ndir];
            if (!(0 <= nx and nx < w and 0 <= ny and ny < h)) {
                break :LOOP;
            }
            if (inp[@as(usize, @abs(nx)) + @as(usize, @abs(ny)) * w1] != '#') {
                break;
            }
            ndir +%= 1;
        }
        if (dir != ndir) {
            const nk: usize = @intCast(((((nx - DX[ndir]) << 8) + (ny - DY[ndir])) << 2) + dir);
            corners[prev_key] = nk;
            prev_key = nk;
        }
        cx = nx;
        cy = ny;
        dir = ndir;
    }
    var p2: usize = 0;
    for (path.slice()) |p| {
        if (part2(inp, w1, w, h, sx, sy, p[0], p[1], corners)) {
            p2 += 1;
        }
    }
    return [2]usize{ p1, p2 };
}

fn part2(inp: []const u8, w1: usize, w: i32, h: i32, sx: i32, sy: i32, ox: i32, oy: i32, corners: [133643]?usize) bool {
    var seen: [133643]bool = .{false} ** 133643;
    var cx = sx;
    var cy = sy;
    var dir: u2 = 0;
    while (true) {
        const k: usize = @intCast((((cx << 8) + cy) << 2) + dir);
        if (seen[k]) {
            return true;
        }
        seen[k] = true;
        var nx = cx + DX[dir];
        var ny = cy + DY[dir];
        var ndir = dir;
        const jump = corners[k];
        if (jump != null and cx != ox and cy != oy) {
            nx = @intCast(jump.? >> 10);
            ny = @intCast((jump.? >> 2) & 0xff);
            ndir = @intCast(jump.? & 3);
        } else {
            if (!(0 <= nx and nx < w and 0 <= ny and ny < h)) {
                return false;
            }
            if ((nx == ox and ny == oy) or (inp[@as(usize, @abs(nx)) + @as(usize, @abs(ny)) * w1] == '#')) {
                ndir +%= 1;
                nx = cx;
                ny = cy;
            }
        }
        cx = nx;
        cy = ny;
        dir = ndir;
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
