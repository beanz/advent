const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var ranges = try std.BoundedArray([2]usize, 1024).init(0);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        if (inp[i] == '\n') {
            break;
        }
        const s = try aoc.chompUint(usize, inp, &i);
        i += 1;
        const e = try aoc.chompUint(usize, inp, &i);
        try ranges.append([2]usize{ s, e + 1 });
    }
    i += 1;
    var p1: usize = 0;
    const rr = ranges.slice();
    std.mem.sort([2]usize, rr, {}, cmp);
    while (i < inp.len) : (i += 1) {
        const n = try aoc.chompUint(usize, inp, &i);
        for (rr) |r| {
            if (r[0] <= n and n < r[1]) {
                p1 += 1;
                break;
            }
            if (n < r[0]) {
                break;
            }
        }
    }
    var p2: usize = 0;
    var end: usize = 0;
    for (rr) |r| {
        const s = @max(r[0], end);
        if (s < r[1]) {
            p2 += r[1] - s;
        }
        end = @max(r[1], end);
    }
    return [2]usize{ p1, p2 };
}

fn cmp(_: void, a: [2]usize, b: [2]usize) bool {
    return std.mem.order(usize, a[0..], b[0..]).compare(std.math.CompareOperator.lt);
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
