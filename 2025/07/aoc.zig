const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const w = 1 + (std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable);
    const h = inp.len / w;
    var p1: usize = 0;
    var first: usize = 0;
    var last: usize = w - 2;
    var b: [150]usize = .{0} ** 150;
    for (0..h) |y| {
        LL: for (first..last + 1) |x| {
            const i = x + y * w;
            switch (inp[i]) {
                'S' => {
                    b[x] += 1;
                    first = x;
                    last = x;
                    break :LL;
                },
                '^' => {
                    if (b[x] > 0) {
                        b[x - 1] += b[x];
                        b[x + 1] += b[x];
                        b[x] = 0;
                        p1 += 1;
                        if (x == first) {
                            first = x - 1;
                        }
                        if (x == last) {
                            last = x + 1;
                        }
                    }
                },
                else => {},
            }
        }
    }
    var p2: usize = 0;
    for (first..last + 1) |i| {
        p2 += b[i];
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
