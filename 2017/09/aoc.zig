const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var l: usize = 1;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            '<' => {
                i += 1;
                while (inp[i] != '>') : (i += 1) {
                    if (inp[i] == '!') {
                        i += 1;
                    } else {
                        p2 += 1;
                    }
                }
            },
            '{' => {
                p1 += l;
                l += 1;
            },
            '}' => {
                l -= 1;
            },
            else => {},
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
