const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PROG_CAP: usize = 4096;
const WIDTH_ADDR: usize = 132;
const HEIGHT_ADDR: usize = 139;
const START_X_ADDR: usize = 1034;
const START_Y_ADDR: usize = 1035;
const OXY_X_ADDR: usize = 146;
const OXY_Y_ADDR: usize = 153;
const WALL_BASE_ADDR: usize = 252;
const WALL_CUTOFF_ADDR: usize = 212;

const Int = i64;
const Arity: [10]usize = [10]usize{ 0, 3, 3, 1, 1, 2, 2, 3, 3, 1 };

fn parts(inp: []const u8) anyerror![2]usize {
    var p: [PROG_CAP]Int = undefined;
    var l: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            p[l] = try aoc.chompInt(Int, inp, &i);
            l += 1;
        }
    }
    const prog = p[0..l];
    const sx: usize = @intCast(prog[START_X_ADDR]);
    const sy: usize = @intCast(prog[START_Y_ADDR]);
    const ox: usize = @intCast(prog[OXY_X_ADDR]);
    const oy: usize = @intCast(prog[OXY_Y_ADDR]);
    const w: usize = @intCast(prog[WIDTH_ADDR]);
    const h: usize = @intCast(prog[HEIGHT_ADDR]);
    var visited: [1640]bool = .{false} ** 1640;
    var back: [16][3]usize = undefined;
    var work = aoc.Deque([3]usize).init(back[0..]);
    try work.push([3]usize{ sx, sy, 0 });
    var p1: usize = 0;
    while (work.pop()) |cur| {
        const x = cur[0];
        const y = cur[1];
        const st = cur[2];
        const vi = x + y * w;
        if (visited[vi]) {
            continue;
        }
        visited[vi] = true;
        if (x == ox and y == oy) {
            p1 = st;
            break;
        }
        if (!isWall(prog[0..], x, y - 1, w, h) and !visited[vi - w * 2]) {
            try work.push([3]usize{ x, y - 2, st + 2 });
        }
        if (!isWall(prog[0..], x, y + 1, w, h) and !visited[vi + w * 2]) {
            try work.push([3]usize{ x, y + 2, st + 2 });
        }
        if (!isWall(prog[0..], x - 1, y, w, h) and !visited[vi - 2]) {
            try work.push([3]usize{ x - 2, y, st + 2 });
        }
        if (!isWall(prog[0..], x + 1, y, w, h) and !visited[vi + 2]) {
            try work.push([3]usize{ x + 2, y, st + 2 });
        }
    }
    var visited2: [1640]bool = .{false} ** 1640;
    work.clear();
    try work.push([3]usize{ ox, oy, 0 });
    var p2: usize = 0;
    while (work.shift()) |cur| {
        const x = cur[0];
        const y = cur[1];
        const st = cur[2];
        const vi = x + y * w;
        if (visited2[vi]) {
            continue;
        }
        visited2[vi] = true;
        if (p2 < st) {
            p2 = st;
        }
        if (!isWall(prog[0..], x, y - 1, w, h) and !visited2[vi - w * 2]) {
            try work.push([3]usize{ x, y - 2, st + 2 });
        }
        if (!isWall(prog[0..], x, y + 1, w, h) and !visited2[vi + w * 2]) {
            try work.push([3]usize{ x, y + 2, st + 2 });
        }
        if (!isWall(prog[0..], x - 1, y, w, h) and !visited2[vi - 2]) {
            try work.push([3]usize{ x - 2, y, st + 2 });
        }
        if (!isWall(prog[0..], x + 1, y, w, h) and !visited2[vi + 2]) {
            try work.push([3]usize{ x + 2, y, st + 2 });
        }
    }
    return [2]usize{ p1, p2 };
}

fn isWall(prog: []const Int, x: usize, y: usize, w: usize, h: usize) bool {
    if (x == 0 or y == 0 or x == w or y == h) {
        return true;
    }
    const mx = x & 1;
    const my = y & 1;
    if (mx == 0 and my == 0) {
        return true;
    }
    if (mx == 1 and my == 1) {
        return false;
    }
    const wy = (y - 1 + my) / 2;
    const wi = wy * 39 + x - 1;
    return prog[WALL_BASE_ADDR + wi] >= prog[WALL_CUTOFF_ADDR];
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
