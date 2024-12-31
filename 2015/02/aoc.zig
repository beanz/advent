const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const a = try aoc.chompUint(usize, inp, &i);
        i += 1;
        const b = try aoc.chompUint(usize, inp, &i);
        i += 1;
        const c = try aoc.chompUint(usize, inp, &i);
        {
            const ab = a * b;
            const ac = a * c;
            const bc = b * c;
            const s = if (ab < ac and ab < bc) ab else if (ac < bc) ac else bc;
            p1 += 2 * ab + 2 * bc + 2 * ac + s;
        }
        {
            const ab = a + b;
            const ac = a + c;
            const bc = b + c;
            const s = if (ab < ac and ab < bc) ab else if (ac < bc) ac else bc;
            p2 += 2 * s + a * b * c;
        }
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
