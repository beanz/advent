const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const WORK_SIZE = 16384;

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    const fav = try aoc.chompUint(usize, inp, &i);
    var back: [WORK_SIZE][3]usize = .{[3]usize{ 0, 0, 0 }} ** WORK_SIZE;
    var todo: aoc.Deque([3]usize) = aoc.Deque([3]usize).init(&back);
    try todo.push([3]usize{ 1, 1, 0 });
    var seen: [16384]bool = .{false} ** 16384;
    var p1: usize = 0;
    var p2: usize = 0;
    while (todo.pop()) |cur| {
        if (cur[0] == 31 and cur[1] == 39) {
            p1 = cur[2];
            break;
        }
        const k = (cur[0] << 7) + cur[1];
        if (seen[k]) {
            continue;
        }
        seen[k] = true;
        if (cur[2] <= 50) {
            p2 += 1;
        }
        if (cur[0] > 0 and !seen[((cur[0] - 1) << 7) + cur[1]] and open(cur[0] - 1, cur[1], fav)) {
            try todo.push([3]usize{ cur[0] - 1, cur[1], cur[2] + 1 });
        }
        if (cur[1] > 0 and !seen[(cur[0] << 7) + cur[1] - 1] and open(cur[0], cur[1] - 1, fav)) {
            try todo.push([3]usize{ cur[0], cur[1] - 1, cur[2] + 1 });
        }
        if (!seen[((cur[0] + 1) << 7) + cur[1]] and open(cur[0] + 1, cur[1], fav)) {
            try todo.push([3]usize{ cur[0] + 1, cur[1], cur[2] + 1 });
        }
        if (!seen[(cur[0] << 7) + cur[1] + 1] and open(cur[0], cur[1] + 1, fav)) {
            try todo.push([3]usize{ cur[0], cur[1] + 1, cur[2] + 1 });
        }
    }
    return [2]usize{ p1, p2 };
}

fn open(x: usize, y: usize, fav: usize) bool {
    const n = x * x + 3 * x + 2 * x * y + y + y * y;
    const ones = @popCount(n + fav);
    return if (ones & 1 == 1) false else true;
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
