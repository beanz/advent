const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    var buf: [16]u8 = .{0} ** 16;
    while (i < inp.len) : (i += 1) {
        const si: usize = i;
        const s = try aoc.chompUint(usize, inp, &i);
        const sl: usize = i - si;
        i += 1;
        const e = try aoc.chompUint(usize, inp, &i);
        std.mem.copyForwards(u8, buf[16 - sl .. 16], inp[si .. si + sl]);
        var ns = Num{
            .n = s,
            .b = &buf,
            .i = 16 - sl,
            .l = sl,
        };
        while (true) {
            const repeats = ns.invalid();
            if (repeats >= 2) {
                p2 += ns.n;
                if (repeats == 2) {
                    p1 += ns.n;
                }
            }
            if (ns.n == e) {
                break;
            }
            ns.inc();
        }
    }
    return [2]usize{ p1, p2 };
}

const Num = struct {
    n: usize,
    b: []u8,
    i: usize,
    l: usize,
    pub fn inc(n: *Num) void {
        n.n += 1;
        var j: usize = n.l - 1;
        while (true) : (j -= 1) {
            n.b[n.i + j] += 1;
            if (n.b[n.i + j] != ':') {
                return;
            }
            n.b[n.i + j] = '0';
            if (j == 0) {
                break;
            }
        }
        n.i -= 1;
        n.b[n.i] = '1';
        n.l += 1;
    }
    pub fn bytes(n: @This()) []u8 {
        return n.b[n.i .. n.i + n.l];
    }
    pub fn matchingHalves(n: @This()) bool {
        if (n.l & 1 == 1) {
            return false;
        }
        const m = n.l / 2;
        for (0..m) |j| {
            if (n.b[n.i + j] != n.b[n.i + m + j]) {
                return false;
            }
        }
        return true;
    }
    pub fn invalid(n: @This()) usize {
        if (n.matchingHalves()) {
            return 2;
        }
        var i: usize = 3;
        OUTER: while (i < n.l) : (i += 2) {
            const m = @divFloor(n.l, i);
            if (m * i != n.l) {
                continue;
            }
            for (0..m) |j| {
                var k = m + j;
                while (k < n.l) : (k += m) {
                    if (n.b[n.i + j] != n.b[n.i + k]) {
                        continue :OUTER;
                    }
                }
            }
            return i;
        }
        for (1..n.l) |j| {
            if (n.b[n.i] != n.b[n.i + j]) {
                return 0;
            }
        }
        return n.l;
    }
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
