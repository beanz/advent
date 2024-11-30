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
    var j: usize = 0;
    while (i < inp.len) {
        if (i + 1 >= inp.len or (inp[i] == '\n' and inp[i + 1] == '\n')) {
            p1 += reflect(inp[j .. i + 1], 0);
            p2 += reflect(inp[j .. i + 1], 1);
            i += 2;
            j = i;
        } else {
            i += 1;
        }
    }
    return [2]usize{ p1, p2 };
}

fn reflect(inp: []const u8, wrong: usize) usize {
    const w = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const h = (1 + inp.len) / (w + 1);
    for (0..w - 1) |r| {
        var cw: usize = 0;
        for (0..w) |o| {
            if (r < o) {
                continue;
            }
            const xl = r - o;
            const xr = r + o + 1;
            if (xr < w) {
                for (0..h) |y| {
                    const yi = (w + 1) * y;
                    if (inp[yi + xl] != inp[yi + xr]) {
                        cw += 1;
                    }
                }
            }
        }
        if (cw == wrong) {
            return r + 1;
        }
    }
    for (0..h - 1) |r| {
        var cw: usize = 0;
        for (0..h) |o| {
            if (r < o) {
                continue;
            }
            const yu = r - o;
            const yd = r + o + 1;
            const yui = (w + 1) * yu;
            const ydi = (w + 1) * yd;
            if (yd < h) {
                for (0..w) |x| {
                    if (inp[yui + x] != inp[ydi + x]) {
                        cw += 1;
                    }
                }
            }
        }
        if (cw == wrong) {
            return 100 * (r + 1);
        }
    }
    return 0;
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
