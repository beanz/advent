const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Rec = struct {
    x: usize,
    y: usize,
    z: u8,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var w1: usize = 0;
    while (inp[w1] != '\n') : (w1 += 1) {}
    w1 += 1;
    const hu = inp.len / w1;
    // 0 <= x and x < w and 0 <= y and y < h
    //   and inp[@as(usize,x)+@as(usize,y) * w1] == '#'
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..hu) |y| {
        for (0..w1 - 1) |x| {
            if (inp[x + y * w1] == '0') {
                p1 += try score(inp, hu, w1, x, y);
                p2 += try rank(inp, hu, w1, x, y, '0');
            }
        }
    }
    return [2]usize{ p1, p2 };
}

fn score(inp: []const u8, h: usize, w1: usize, x: usize, y: usize) anyerror!usize {
    var seen: [2048]bool = .{false} ** 2048;
    var todo = try std.BoundedArray(Rec, 1024).init(0);
    try todo.append(Rec{ .x = x, .y = y, .z = '0' });
    var s: usize = 0;
    while (todo.len > 0) {
        const cur = todo.pop();
        const k = cur.x + cur.y * w1;
        if (seen[k]) {
            continue;
        }
        seen[k] = true;
        if (cur.z == '9') {
            s += 1;
            continue;
        }
        const nz = cur.z + 1;
        if (cur.x > 0 and inp[cur.x - 1 + cur.y * w1] == nz) {
            try todo.append(Rec{ .x = cur.x - 1, .y = cur.y, .z = nz });
        }
        if (cur.x < w1 - 2 and inp[cur.x + 1 + cur.y * w1] == nz) {
            try todo.append(Rec{ .x = cur.x + 1, .y = cur.y, .z = nz });
        }
        if (cur.y > 0 and inp[cur.x + (cur.y - 1) * w1] == nz) {
            try todo.append(Rec{ .x = cur.x, .y = cur.y - 1, .z = nz });
        }
        if (cur.y < h - 1 and inp[cur.x + (cur.y + 1) * w1] == nz) {
            try todo.append(Rec{ .x = cur.x, .y = cur.y + 1, .z = nz });
        }
    }
    return s;
}

fn rank(inp: []const u8, h: usize, w1: usize, x: usize, y: usize, z: u8) anyerror!usize {
    if (z == '9') {
        return 1;
    }
    var r: usize = 0;
    const nz = z + 1;
    if (x > 0 and inp[x - 1 + y * w1] == nz) {
        r += try rank(inp, h, w1, x - 1, y, nz);
    }
    if (x < w1 - 2 and inp[x + 1 + y * w1] == nz) {
        r += try rank(inp, h, w1, x + 1, y, nz);
    }
    if (y > 0 and inp[x + (y - 1) * w1] == nz) {
        r += try rank(inp, h, w1, x, y - 1, nz);
    }
    if (y < h - 1 and inp[x + (y + 1) * w1] == nz) {
        r += try rank(inp, h, w1, x, y + 1, nz);
    }
    return r;
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
