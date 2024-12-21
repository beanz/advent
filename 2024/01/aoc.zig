const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var la = try std.BoundedArray(usize, 1024).init(0);
    var lb = try std.BoundedArray(usize, 1024).init(0);
    while (i < inp.len) : (i += 1) {
        const a = try aoc.chompUint(usize, inp, &i);
        i += 3;
        const b = try aoc.chompUint(usize, inp, &i);

        try la.append(a);
        try lb.append(b);
    }
    var p1: usize = 0;
    const as = la.slice();
    std.mem.sort(usize, as, {}, comptime std.sort.asc(usize));
    const bs = lb.slice();
    std.mem.sort(usize, bs, {}, comptime std.sort.asc(usize));

    for (0..as.len) |j| {
        p1 += if (as[j] > bs[j])
            (as[j] - bs[j])
        else
            (bs[j] - as[j]);
    }
    var p2: usize = 0;
    var ai: usize = 0;
    var bi: usize = 0;
    while (ai < as.len and bi < bs.len) {
        if (as[ai] < bs[bi]) {
            ai += 1;
            continue;
        }
        if (as[ai] > bs[bi]) {
            bi += 1;
            continue;
        }
        const v = as[ai];
        var ac: usize = 0;
        while (ai < as.len and as[ai] == v) : (ai += 1) {
            ac += 1;
        }
        var bc: usize = 0;
        while (bi < bs.len and bs[bi] == v) : (bi += 1) {
            bc += 1;
        }
        p2 += v * ac * bc;
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
