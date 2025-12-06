const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const w = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const h = inp.len / (w + 1);
    var p2: usize = 0;
    var nums: [5]usize = .{ 0, 0, 0, 0, 0 };
    var numsLen: usize = 0;
    var i: usize = w - 1;
    while (true) : (i -= 1) {
        var n: usize = 0;
        for (0..h - 1) |y| {
            if (inp[i + y * (w + 1)] == ' ') {
                continue;
            }
            n = 10 * n + @as(usize, @intCast(inp[i + y * (w + 1)] - '0'));
        }
        if (n == 0) {
            p2 += apply(inp[i + 1 + (h - 1) * (w + 1)], nums[0..numsLen]);
            numsLen = 0;
        } else {
            nums[numsLen] = n;
            numsLen += 1;
        }
        if (i == 0) {
            break;
        }
    }
    i = (h - 1) * (w + 1);
    p2 += apply(inp[i], nums[0..numsLen]);
    var p1: usize = 0;
    var lines: [5]usize = .{ 0, (w + 1), 2 * (w + 1), 3 * (w + 1), 4 * (w + 1) };
    while (i < inp.len - 1) {
        const op = inp[i];
        i += 1;
        skip(inp, &i);
        numsLen = 0;
        for (0..h - 1) |y| {
            skip(inp, &lines[y]);
            const n: usize = try aoc.chompUint(usize, inp, &lines[y]);
            nums[numsLen] = n;
            numsLen += 1;
            lines[y] += 1;
        }
        p1 += apply(op, nums[0..numsLen]);
    }
    return [2]usize{ p1, p2 };
}

inline fn skip(inp: []const u8, i: *usize) void {
    while (i.* < inp.len and inp[i.*] == ' ') : (i.* += 1) {}
}

inline fn apply(op: u8, nums: []const usize) usize {
    if (op == '+') {
        var s: usize = 0;
        for (nums) |e| {
            s += e;
        }
        return s;
    } else {
        var s: usize = 1;
        for (nums) |e| {
            s *= e;
        }
        return s;
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
