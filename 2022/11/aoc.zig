const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Monkey = struct {
    c: usize,
    l: usize,
    i: [32]usize,
    l2: usize,
    i2: [32]usize,
    mod: usize,
    opA: usize,
    opB: usize,
    opC: usize,
    to: [2]usize,

    fn chomp(inp: []const u8, i: *usize) !Monkey {
        i.* += 28;
        var m = Monkey{
            .c = 0,
            .l = 0,
            .i = undefined,
            .l2 = 0,
            .i2 = undefined,
            .mod = 0,
            .opA = 0,
            .opB = 0,
            .opC = 0,
            .to = undefined,
        };
        while (true) : (i.* += 2) {
            const n = try aoc.chompUint(usize, inp, i);
            m.i[m.l] = n;
            m.i2[m.l] = n;
            m.l += 1;
            if (inp[i.*] == '\n') {
                break;
            }
        }
        m.l2 = m.l;
        i.* += 24;
        if (inp[i.*] == '+') {
            i.* += 2;
            m.opC = try aoc.chompUint(usize, inp, i);
            m.opB = 1;
        } else if (inp[i.* + 2] == 'o') {
            m.opA = 1;
            i.* += 5;
        } else {
            i.* += 2;
            m.opB = try aoc.chompUint(usize, inp, i);
        }
        i.* += 22;
        m.mod = try aoc.chompUint(usize, inp, i);
        i.* += 30;
        m.to[1] = try aoc.chompUint(usize, inp, i);
        i.* += 31;
        m.to[0] = try aoc.chompUint(usize, inp, i);
        i.* += 2;
        return m;
    }
};

fn solve(mb: *[8]Monkey, l: usize, rounds: usize, reduce: usize) usize {
    for (0..rounds) |_| {
        for (0..l) |i| {
            for (0..mb[i].l) |j| {
                mb[i].c += 1;
                var w = mb[i].i[j];
                w = mb[i].opA * w * w + mb[i].opB * w + mb[i].opC;
                w = if (reduce == 0)
                    w / 3
                else if (w >= reduce)
                    @rem(w, reduce)
                else
                    w;
                const to = mb[i].to[@intFromBool(w % mb[i].mod == 0)];
                mb[to].i[mb[to].l] = w;
                mb[to].l += 1;
            }
            mb[i].l = 0;
        }
    }
    var m0: usize = 0;
    var m1: usize = 0;
    for (mb[0..l]) |m| {
        var c = m.c;
        if (c > m0) {
            std.mem.swap(usize, &m0, &c);
        }
        if (c > m1) {
            m1 = c;
        }
    }
    return m0 * m1;
}

fn parts(inp: []const u8) anyerror![2]usize {
    var mb: [8]Monkey = undefined;
    var l: usize = 0;
    var lcm: usize = 1;
    {
        var i: usize = 0;
        while (i < inp.len) {
            mb[l] = try Monkey.chomp(inp, &i);
            lcm *= mb[l].mod;
            l += 1;
        }
    }
    const p1 = solve(&mb, l, 20, 0);
    for (0..l) |i| {
        mb[i].c = 0;
        mb[i].l = mb[i].l2;
        std.mem.copyForwards(usize, mb[i].i[0..mb[i].l2], mb[i].i2[0..mb[i].l2]);
    }
    return [2]usize{ p1, solve(&mb, l, 10000, lcm) };
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
