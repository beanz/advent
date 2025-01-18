const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i16;

fn parts(inp: []const u8) anyerror![2]usize {
    var s: [1536][4]Int = undefined;
    var sl: usize = 0;
    var c: [1536]?usize = .{null} ** 1536;
    var cl: usize = 0;
    var m: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            s[sl][0] = try aoc.chompInt(Int, inp, &i);
            i += 1;
            s[sl][1] = try aoc.chompInt(Int, inp, &i);
            i += 1;
            s[sl][2] = try aoc.chompInt(Int, inp, &i);
            i += 1;
            s[sl][3] = try aoc.chompInt(Int, inp, &i);
            for (0..sl) |j| {
                if (@abs(s[sl][0] - s[j][0]) + @abs(s[sl][1] - s[j][1]) + @abs(s[sl][2] - s[j][2]) + @abs(s[sl][3] - s[j][3]) <= 3) {
                    const con = c[j].?;
                    if (c[sl] != null and c[sl].? != con) {
                        for (0..sl) |k| {
                            if (c[k].? == c[sl].?) {
                                c[k] = con;
                            }
                        }
                        m += 1;
                    }
                    c[sl] = con;
                }
            }
            if (c[sl] == null) {
                c[sl] = cl;
                cl += 1;
            }
            sl += 1;
        }
    }
    return [2]usize{ cl - m, 0 };
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
