const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var n = try std.BoundedArray(u32, 16).init(0);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        while (true) : (i += 1) {
            const a = try aoc.chompUint(u32, inp, &i);
            try n.append(a);
            if (inp[i] == '\n') {
                break;
            }
        }
        const s = n.slice();
        try n.resize(0);
        std.mem.sort(u32, s, {}, comptime std.sort.asc(u32));
        p1 += s[s.len - 1] - s[0];
        for (0..s.len) |j| {
            var k = s.len - 1;
            while (k > j) : (k -= 1) {
                if (s[k] % s[j] == 0) {
                    p2 += s[k] / s[j];
                }
            }
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
