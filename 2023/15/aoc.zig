const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const lens = struct { l: usize, v: u8 };

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var i: usize = 0;
    var b: [256 * 8]?lens = std.mem.zeroes([256 * 8]?lens);
    while (i < inp.len) {
        var j = i;
        var bn: usize = 0;
        var lb: usize = 0;
        var tlb: usize = 0;
        var h: u8 = 0;
        while (j < inp.len and inp[j] != ',' and inp[j] != '\n') {
            if (inp[j] == '-' or inp[j] == '=') {
                bn = @as(usize, h);
                lb = tlb;
            }
            h = (h +% inp[j]) *% 17;
            tlb = (tlb << 8) + @as(usize, inp[j]);
            j += 1;
        }
        p1 += @as(usize, h);

        var found: ?usize = null;
        for (0..8) |ii| {
            if (b[bn * 8 + ii]) |be| {
                if (be.l == lb) {
                    found = ii;
                    break;
                }
            }
        }
        if (inp[j - 1] == '-') {
            if (found) |ii| {
                for (ii..8 - 1) |jj| {
                    b[bn * 8 + jj] = b[bn * 8 + jj + 1];
                    b[bn * 8 + jj + 1] = null;
                }
            }
        } else {
            if (found) |ii| {
                b[bn * 8 + ii] = lens{ .l = lb, .v = inp[j - 1] - '0' };
            } else {
                for (0..8) |ii| {
                    if (b[bn * 8 + ii] == null) {
                        b[bn * 8 + ii] = lens{ .l = lb, .v = inp[j - 1] - '0' };
                        break;
                    }
                }
            }
        }

        i = j + 1;
    }
    var p2: usize = 0;
    for (0..256) |bn| {
        for (0..8) |sn| {
            if (b[bn * 8 + sn]) |be| {
                p2 += (bn + 1) * (sn + 1) * @as(usize, be.v);
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
