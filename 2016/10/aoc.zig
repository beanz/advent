const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Bot = struct {
    v1: ?usize,
    v2: ?usize,
    done: bool,
    lo: usize,
    hi: usize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    const cmp: [2]usize = if (inp.len < 256) [2]usize{ 2, 5 } else [2]usize{ 17, 61 };
    var bots: [256]Bot = .{Bot{ .v1 = null, .v2 = null, .done = true, .lo = 0, .hi = 0 }} ** 256;
    var i: usize = 0;
    while (i < inp.len) {
        if (inp[i] == 'v') {
            i += 6;
            const v = try aoc.chompUint(usize, inp, &i);
            i += 13;
            const b = try aoc.chompUint(usize, inp, &i);
            i += 1;
            if (bots[b].v1 == null) {
                bots[b].v1 = v;
            } else {
                bots[b].v2 = v;
            }
            bots[b].done = false;
        } else {
            i += 4;
            const b = try aoc.chompUint(usize, inp, &i);
            i += 14;
            var l: usize = undefined;
            if (inp[i] == 'b') {
                i += 4;
                l = try aoc.chompUint(usize, inp, &i);
            } else {
                i += 7;
                l = try aoc.chompUint(usize, inp, &i);
                l += 256;
            }
            i += 13;
            var h: usize = undefined;
            if (inp[i] == 'b') {
                i += 4;
                h = try aoc.chompUint(usize, inp, &i);
            } else {
                i += 7;
                h = try aoc.chompUint(usize, inp, &i);
                h += 256;
            }
            i += 1;
            bots[b].lo = l;
            bots[b].hi = h;
            bots[b].done = false;
        }
    }
    var p1: usize = 9999;
    var output: [256]usize = .{0} ** 256;
    while (true) {
        var done = true;
        for (&bots, 0..) |*b, bi| {
            if (b.done) {
                continue;
            }
            if (b.v1) |v1| {
                if (b.v2) |v2| {
                    const lo = if (v1 > v2) v2 else v1;
                    const hi = if (v1 > v2) v1 else v2;
                    if (lo == cmp[0] and hi == cmp[1]) {
                        p1 = bi;
                    }
                    b.done = true;
                    done = false;
                    if (b.lo > 255) {
                        output[b.lo & 0xff] = lo;
                    } else {
                        if (bots[b.lo].v1 == null) {
                            bots[b.lo].v1 = lo;
                        } else {
                            bots[b.lo].v2 = lo;
                        }
                    }
                    if (b.hi > 255) {
                        output[b.hi & 0xff] = hi;
                    } else {
                        if (bots[b.hi].v1 == null) {
                            bots[b.hi].v1 = hi;
                        } else {
                            bots[b.hi].v2 = hi;
                        }
                    }
                }
            }
        }
        if (done) {
            break;
        }
    }
    return [2]usize{ p1, output[0] * output[1] * output[2] };
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
