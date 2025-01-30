const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var it = std.mem.splitScalar(u8, inp, '\n');
    var backP2: [8]u8 = undefined;
    var sP2 = aoc.Deque(u8).init(backP2[0..]);
    var p2 = PacketIter.init("[[2]]", &sP2);
    var c2: usize = 1;
    var backP6: [8]u8 = undefined;
    var sP6 = aoc.Deque(u8).init(backP6[0..]);
    var p6 = PacketIter.init("[[6]]", &sP6);
    var c6: usize = 2;
    var backA: [8]u8 = undefined;
    var sa = aoc.Deque(u8).init(backA[0..]);
    var backB: [8]u8 = undefined;
    var sb = aoc.Deque(u8).init(backB[0..]);
    var n: usize = 1;
    while (it.next()) |a| {
        const b = it.next().?;
        var pA = PacketIter.init(a, &sa);
        var pB = PacketIter.init(b, &sb);
        if (try less(&pA, &pB)) {
            p1 += n;
        }
        pA.clear();
        if (try less(&pA, &p2)) {
            c2 += 1;
            c6 += 1;
        } else {
            pA.clear();
            if (try less(&pA, &p6)) {
                c6 += 1;
            }
            p6.clear();
        }
        pA.clear();
        p2.clear();
        pB.clear();
        if (try less(&pB, &p2)) {
            c2 += 1;
            c6 += 1;
        } else {
            pB.clear();
            if (try less(&pB, &p6)) {
                c6 += 1;
            }
            p6.clear();
        }
        pB.clear();
        p2.clear();
        if (it.next() == null) {
            break;
        }
        n += 1;
    }
    return [2]usize{ p1, c2 * c6 };
}

fn less(a: *PacketIter, b: *PacketIter) !bool {
    try aoc.assert(a.stack.len() == 0);
    try aoc.assert(b.stack.len() == 0);
    while (true) {
        const va = a.next();
        const vb = b.next();
        if (va == vb) {
            continue;
        }
        if (va == ']') {
            return true;
        }
        if (vb == ']') {
            return false;
        }
        if (va == '[') {
            try b.push(']');
            try b.push(vb);
        } else if (vb == '[') {
            try a.push(']');
            try a.push(va);
        } else {
            return va < vb;
        }
    }
}

const PacketIter = struct {
    s: []const u8,
    i: usize,
    stack: *aoc.Deque(u8),

    fn init(s: []const u8, stack: *aoc.Deque(u8)) PacketIter {
        return .{
            .s = s,
            .i = 0,
            .stack = stack,
        };
    }

    fn clear(self: *@This()) void {
        self.stack.clear();
        self.i = 0;
    }

    fn push(self: *@This(), ch: u8) !void {
        try self.stack.push(ch);
    }

    fn next(self: *@This()) u8 {
        if (self.stack.shift()) |ch| {
            return ch;
        }
        if (self.s[self.i] == '1' and self.s[self.i + 1] == '0') {
            self.i += 2;
            return ':';
        }
        const res = self.s[self.i];
        self.i += 1;
        return res;
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
