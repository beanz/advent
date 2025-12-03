const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn best(line: []const u8, o: *usize, rem: usize) usize {
    var r = line[o.*];
    for (o.* + 1..line.len - rem) |i| {
        if (line[i] > r) {
            r = line[i];
            o.* = i;
            if (r == '9') {
                break;
            }
        }
    }
    o.* += 1;
    return @intCast(r - '0');
}

fn part(line: []const u8, n: usize) usize {
    var r: usize = 0;
    var i: usize = 0;
    var rem: isize = @intCast(n - 1);
    while (rem >= 0) : (rem -= 1) {
        const b = best(line, &i, @intCast(rem));
        r *= 10;
        r += b;
    }
    return r;
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var it = std.mem.splitScalar(u8, inp, '\n');
    while (it.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        p1 += part(line, 2);
        p2 += part(line, 12);
    }
    return [2]usize{ p1, p2 };
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
