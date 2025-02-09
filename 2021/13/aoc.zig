const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Res = struct {
    p1: usize,
    p2: [8]u8,
};

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Fold = struct {
    n: u16,
    axis: u1,
};

fn parts(inp: []const u8) anyerror!Res {
    var chunks = std.mem.splitSequence(u8, inp, "\n\n");
    const c0 = chunks.next().?;
    const c1 = chunks.next().?;
    const folds = parse: {
        var folds: [12]Fold = undefined;
        var l: usize = 0;
        var i: usize = 0;
        while (i < c1.len) : (i += 1) {
            const axis: u1 = @intCast(c1[i + 11] & 1);
            i += 13;
            const n = try aoc.chompUint(u16, c1, &i);
            folds[l] = Fold{ .n = n, .axis = axis };
            l += 1;
        }
        break :parse folds[0..l];
    };
    var p2: [6]u64 = .{0} ** 6;
    var p1: usize = 0;
    const P1DIM = 656 * 448 * 2;
    var p1m: [P1DIM]bool = .{false} ** P1DIM;
    {
        var it = aoc.uintIter(u16, c0);
        while (it.next()) |ix| {
            var pos = [2]u16{ ix, it.next().? };
            {
                const f = folds[0];
                if (pos[f.axis] > f.n) {
                    pos[f.axis] = f.n - (pos[f.axis] - f.n);
                }
                const i = @as(usize, @intCast(pos[0])) + 655 * @as(usize, @intCast(pos[1]));
                if (!p1m[i]) {
                    p1m[i] = true;
                    p1 += 1;
                }
            }
            for (folds[1..]) |f| {
                if (pos[f.axis] > f.n) {
                    pos[f.axis] = f.n - (pos[f.axis] - f.n);
                }
            }
            p2[pos[1]] |= @as(u64, 1) << @as(u6, @intCast(pos[0]));
        }
    }
    var p2s: [8]u8 = .{32} ** 8;
    for (0..8) |i| {
        var ch: u64 = 0;
        for (0..6) |r| {
            for (0..5) |_| {
                ch = (ch << 1) + (p2[r] & 1);
                p2[r] >>= 1;
            }
        }
        p2s[i] = aoc.ocr(ch);
    }
    return Res{ .p1 = p1, .p2 = p2s };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {s}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
